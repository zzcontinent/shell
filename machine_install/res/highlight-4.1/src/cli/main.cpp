/***************************************************************************
                          main.cpp  -  description
                             -------------------
    begin                : Die Apr 23 22:16:35 CEST 2002
    copyright            : (C) 2002-2021 by Andre Simon
    email                : a.simon@mailbox.org

   Highlight is a universal source code to formatted text converter.
   Syntax highlighting is formatted by Cascading Style Sheets.
   It's possible to easily enhance highlight's parsing database.

 ***************************************************************************/


/*
This file is part of Highlight.

Highlight is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Highlight is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Highlight.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <memory>
#include <algorithm>
#include <Diluculum/LuaState.hpp>

#include "main.h"
#include "datadir.h"
#include "syntaxreader.h"
#include "lspprofile.h"

#define MAX_LINE__WIDTH       80

using namespace std;

void HLCmdLineApp::printVersionInfo(bool quietMode)
{
    if (quietMode) {
        cout << highlight::Info::getVersion() << "\n";
    } else {
        cout << "\n highlight version "
            << highlight::Info::getVersion()
            << "\n Copyright (C) 2002-2021 Andre Simon <a dot simon at mailbox.org>"
            << "\n\n Argparser class"
            << "\n Copyright (C) 2006-2008 Antonio Diaz Diaz <ant_diaz at teleline.es>"
            << "\n\n Artistic Style Classes (3.1 rev. 672)"
            << "\n Copyright (C) 2006-2018 by Jim Pattee <jimp03 at email.com>"
            << "\n Copyright (C) 1998-2002 by Tal Davidson"
            << "\n\n Diluculum Lua wrapper (1.0)"
            << "\n Copyright (C) 2005-2013 by Leandro Motta Barros"
            << "\n\n xterm 256 color matching functions"
            << "\n Copyright (C) 2006 Wolfgang Frisch <wf at frexx.de>"
            << "\n\n PicoJSON library"
            << "\n Copyright (C) 2009-2010 Cybozu Labs, Inc."
            << "\n Copyright (C) 2011-2014 Kazuho Oku"
            << "\n\n This software is released under the terms of the GNU General "
            << "Public License."
            << "\n For more information about these matters, see the file named "
            << "COPYING.\n\n";
    }
}

void HLCmdLineApp::printBadInstallationInfo()
{
    cerr << "highlight: Data directory not found ("<<DataDir::LSB_DATA_DIR<<")."
         " Bad installation or wrong "<< OPT_DATADIR << " parameter."
         << "\n\nCopy the highlight files into one of the directories listed "
         << "in INSTALL.\nYou may also set the data directory with "
         << OPT_DATADIR << ".\n";
}

int HLCmdLineApp::printInstalledFiles(const string& where, const string& wildcard, const string& kind, const string& option, const string& categoryFilterList)
{
    vector <string> filePaths;
    string searchDir = where + wildcard;

    bool directoryOK = Platform::getDirectoryEntries ( filePaths, searchDir, true );
    if ( !directoryOK ) {
        cerr << "highlight: Could not access directory "
             <<  searchDir
             << ", aborted.\n";
        return EXIT_FAILURE;
    }

    sort ( filePaths.begin(), filePaths.end() );
    string suffix, desc;
    Diluculum::LuaValueMap categoryMap;
    cout << "\nInstalled " << kind << "s";

    if (categoryFilterList.size())
        cout << " matching \""<<categoryFilterList<<"\"";

    cout << " (located in " << where << "):\n\n";
    int matchedFileCnt=0;
    std::set<string> categoryNames;
    std::set<string> categoryFilters;

    istringstream valueStream;
    string catFilter;
    valueStream.str ( StringTools::change_case ( categoryFilterList,StringTools::CASE_LOWER ) );
    while ( getline ( valueStream, catFilter, ';' ) ) {
        categoryFilters.insert ( catFilter );
    }

    for (const auto &path : filePaths ) {
        try {
            Diluculum::LuaState ls;
            highlight::SyntaxReader::initLuaState(ls, path,"");
            ls.doFile(path);
            desc = ls["Description"].value().asString();

            suffix = ( path ).substr ( where.length() ) ;
            suffix = suffix.substr ( 0, suffix.length()- wildcard.length()+1 );

            unsigned int filterOKCnt=categoryFilters.size();
            if (ls["Categories"].value() !=Diluculum::Nil){
                filterOKCnt=0;

                categoryMap = ls["Categories"].value().asTable();

                for (Diluculum::LuaValueMap::const_iterator it = categoryMap.begin(); it != categoryMap.end(); ++it)
                {
                    categoryNames.insert(it->second.asString());
                    if (categoryFilters.size() && categoryFilters.count(it->second.asString())) {
                        ++filterOKCnt;
                    }
                }
            }

            if (filterOKCnt!=categoryFilters.size() && categoryFilters.size() ) continue;

            matchedFileCnt++;
            if (kind=="langDef") {
                cout << setw ( 30 ) <<setiosflags ( ios::left ) <<desc<<": "<<suffix;

                int extCnt=0;
                for (StringMap::iterator it=dataDir.assocByExtension.begin(); it!=dataDir.assocByExtension.end(); it++) {
                    if (it->second==suffix ) {
                        cout << ((++extCnt==1)?" ( ":" ")<<it->first;
                    }
                }
                cout << ((extCnt)?" )":"");
            } else {
                cout << setw ( 30 ) <<setiosflags ( ios::left ) <<suffix<<": "<<desc;

            }
            cout << endl;
        } catch (std::runtime_error &error) {
            cout << "Failed to read '" << path<< "': " << error.what() << endl;
        }
    }

    if (!matchedFileCnt) {
        cout <<"No files found." << endl;
    } else {

        if (!categoryFilters.size()){
            cout << "\nFound "<<kind<<" categories:\n\n";
            for (std::set<string>::iterator it=categoryNames.begin(); it!=categoryNames.end(); ++it)
                std::cout << *it<< ' ';
            cout << "\n";
        }

        cout <<"\nUse name of the desired "<<kind
            << " with --" << option << ". Filter categories with --list-cat." << endl;

        if (kind=="theme") {
            cout <<"\nAdd base16/ prefix to apply a Base16 theme." << endl;
        }

        printConfigInfo();
    }

    return EXIT_SUCCESS;
}

void HLCmdLineApp::printDebugInfo ( const highlight::SyntaxReader *lang,
                                    const string & langDefPath, int level )
{
    if (!lang) return;

    map <int, string> HLStateMap;

    cerr << "\nLoading language definition:\n" << langDefPath;
    cerr << "\n\nDescription: " << lang->getDescription();
    if (level>1) {
        Diluculum::LuaState* luaState=lang->getLuaState();
        if (luaState) {
            cerr << "\n\nLUA GLOBALS:\n" ;
            Diluculum::LuaValueMap::iterator it;
            Diluculum::LuaValueMap glob =luaState->globals();
            string elemName;
            for(it = glob.begin(); it != glob.end(); it++) {
                Diluculum::LuaValue first = it->first;
                Diluculum::LuaValue second = it->second;
                elemName = first.asString();
                std::cerr << elemName<<": ";
                switch (second.type()) {
                    case  LUA_TSTRING:
                        cerr << "string [ "<<second.asString()<<" ]";
                        break;
                    case  LUA_TNUMBER:
                        cerr << "number [ "<<second.asNumber()<<" ]";
                        if (elemName.find("HL_")==0 && elemName.find("HL_FORMAT")==string::npos)
                            HLStateMap[second.asNumber()] = elemName;
                        break;
                    case  LUA_TBOOLEAN:
                        cerr << "boolean [ "<<second.asBoolean()<<" ]";
                        break;
                    default:
                        cerr << second.typeName();
                }
                cerr << endl;
            }

        }

        highlight::RegexElement *re=NULL;
        for ( unsigned int i=0; i<lang->getRegexElements().size(); i++ )
        {
            if (i==0)
                cerr << "\nREGEX:\n";

            re = lang->getRegexElements() [i];
            cerr << "State "<<re->open<< " ("<< HLStateMap[re->open]<<  "):\t"<<re->pattern <<"\n";
        }

        highlight::KeywordMap::iterator it;
        highlight::KeywordMap keys=lang->getKeywords();
        for ( it=keys.begin(); it!=keys.end(); it++ ) {
            if (it==keys.begin())
                cerr << "\nKEYWORDS:\n";

            cerr << " "<< it->first << "("<< it->second << ")";
        }
    }
    cerr <<"\n\n";
}

void HLCmdLineApp::printConfigInfo ( )
{
    cout << "\nConfig file search directories:\n";
    dataDir.printConfigPaths();
    cout << "\nFiletype config file:\n"<<dataDir.getFiletypesConfPath ( "filetypes" ) <<"\n";
    cout << endl;
#ifdef HL_DATA_DIR
    cout << "Compiler directive HL_DATA_DIR = " <<HL_DATA_DIR<< "\n";
#endif
#ifdef HL_CONFIG_DIR
    cout << "Compiler directive HL_CONFIG_DIR = " <<HL_CONFIG_DIR<< "\n";
#endif
    cout << endl;
}

int HLCmdLineApp::getNumDigits ( int i )
{
    int res=0;
    while ( i ) {
        i/=10;
        ++res;
    }
    return res;
}

void HLCmdLineApp::printProgressBar ( int total, int count )
{
    if ( !total ) return;
    int p=100*count / total;
    int numProgressItems=p/10;
    cout << "\r[";
    for ( int i=0; i<10; i++ ) {
        cout << ( ( i<numProgressItems ) ?"#":" " );
    }
    cout<< "] " <<setw ( 3 ) <<p<<"%, "<<count << " / " << total << "  " <<flush;
    if ( p==100 ) {
        cout << endl;
    }
}

void HLCmdLineApp::printCurrentAction ( const string&outfilePath,
                                        int total, int count, int countWidth )
{
    cout << "Writing file "
         << setw ( countWidth ) << count
         << " of "
         << total
         << ": "
         << outfilePath
         << "\n";
}

void HLCmdLineApp::printIOErrorReport ( unsigned int numberErrorFiles,
                                        vector<string> & fileList,
                                        const string &action, const string &streamName  )
{
    cerr << "highlight: Could not "
         << action
         << " file"
         << ( ( numberErrorFiles>1 ) ?"s":"" ) <<":\n";

    if (numberErrorFiles==1 && fileList[0].size()==0){
        cerr<<streamName<<"\n";
    }
    else {
        copy ( fileList.begin(), fileList.end(), ostream_iterator<string> ( cerr, "\n" ) );
    }

    if ( fileList.size() < numberErrorFiles ) {
        cerr << "... ["
             << ( numberErrorFiles - fileList.size() )
             << " of "
             << numberErrorFiles
             << " failures not shown, use --"
             << OPT_VERBOSE
             << " switch to print all failures]\n";
    }
}

vector <string> HLCmdLineApp::collectPluginPaths(const vector<string>& plugins)
{
    vector<string> absolutePaths;
    for (unsigned int i=0; i<plugins.size(); i++) {
        if (Platform::fileExists(plugins[i])) {
            absolutePaths.push_back(plugins[i]);
        } else {
            absolutePaths.push_back(dataDir.getPluginPath(plugins[i]+".lua"));
        }
    }
    return absolutePaths;
}

int HLCmdLineApp::run ( const int argc, const char*argv[] )
{
    CmdLineOptions options ( argc, argv );

    // set data directory path, where /langDefs and /themes reside
    string dataDirPath = ( options.getDataDir().empty() ) ?  Platform::getAppPath() :options.getDataDir();

    if ( options.printVersion() ) {
        printVersionInfo(options.quietMode());
        return EXIT_SUCCESS;
    }

    dataDir.initSearchDirectories ( dataDirPath );

    if ( options.printHelp() ) {
        Help::printHelp(options.getHelpTopic());
        return EXIT_SUCCESS;
    }

    if ( options.printConfigInfo() ) {
        printConfigInfo();
        return EXIT_SUCCESS;
    }

    //call before printInstalledLanguages!
    dataDir.loadFileTypeConfig ( "filetypes" );

    // set CLI options; if profle is defined read from lsp.conf
    std::string lsProfile(options.getLsProfile());
    std::string lsExecutable(options.getLsExecutable());         ///< server executable path
    std::string lsSyntax(options.getLsSyntax());                   ///< language definition which can be enhanced using the LS
    int lsDelay=options.getLsDelay();
    std::vector<std::string> lsOptions = options.getLSOptions(); ///< server executable start options

    if (lsProfile.size()) {
        dataDir.loadLSPConfig("lsp");
        if (dataDir.profileExists(lsProfile)) {
            highlight::LSPProfile profile = dataDir.getProfile(lsProfile);
            if (lsExecutable.empty())
                lsExecutable = profile.executable;
            if (lsSyntax.empty())
                lsSyntax = profile.syntax;
            if (lsOptions.empty())
                lsOptions = profile.options;
            if (lsDelay==0)
                lsDelay = profile.delay;
        } else {
            cerr << "highlight: Unknown LSP profile '"<< lsProfile << "'.\n";
            return EXIT_FAILURE;
        }
    }

    string scriptKind=options.getListScriptKind();
    if (scriptKind.length()) {
        if ( scriptKind.find("theme")==0 ) {
            return printInstalledFiles(dataDir.getThemePath(""), "*.theme", "theme", OPT_STYLE, options.getCategories());
        }
        else if ( scriptKind.find("plug")==0 ) {
            return printInstalledFiles(dataDir.getPluginPath(""), "*.lua", "plug-in", OPT_PLUGIN, options.getCategories());
        }
        else if (  scriptKind.find("lang")==0 ) {
            return printInstalledFiles(dataDir.getLangPath(""), "*.lang", "langDef", OPT_SYNTAX, options.getCategories());
        } else {
            cerr << "highlight: Unknown script type '"<< scriptKind << "'. Apply one of 'themes', 'langs' or 'plug-ins'.\n";
            return EXIT_FAILURE;
        }
    }

    const vector <string> inFileList=options.getInputFileNames();

    if ( options.enableBatchMode() && inFileList[0].empty() ) {
        return EXIT_FAILURE;
    }

    string themePath=options.getAbsThemePath().empty() ? dataDir.getThemePath ( options.getThemeName(), options.useBase16Theme() ): options.getAbsThemePath();

    unique_ptr<highlight::CodeGenerator> generator ( highlight::CodeGenerator::getInstance ( options.getOutputType() ) );

    if (options.checkSyntaxSupport()) {

        if (!options.syntaxGiven() ) {
            cerr << "highlight: Define a syntax to use this option\n";
            return EXIT_FAILURE;
        } else {
            string syntaxByFile=options.getSyntaxByFilename();
            string testSuffix = syntaxByFile.empty() ? options.getSyntax() : dataDir.getFileSuffix(syntaxByFile);
            string resolvedSuffix (dataDir.guessFileType (testSuffix, syntaxByFile, syntaxByFile.empty(),false ));
            string langDefPath (options.getAbsLangPath().empty() ? dataDir.getLangPath ( resolvedSuffix +".lang") : options.getAbsLangPath());

            if (generator->loadLanguage( langDefPath ) == highlight::LOAD_OK) {
                cout << "highlight: This syntax is supported\n";
                return EXIT_SUCCESS;
            } else {
                cerr << "highlight: This syntax is not supported\n";
                return EXIT_FAILURE;
            }
        }
    }

    generator->setHTMLAttachAnchors ( options.attachLineAnchors() );
    generator->setHTMLOrderedList ( options.orderedList() );
    generator->setHTMLInlineCSS ( options.inlineCSS() );
    generator->setHTMLEnclosePreTag ( options.enclosePreTag() );
    generator->setHTMLAnchorPrefix ( options.getAnchorPrefix() );
    generator->setHTMLClassName ( options.getClassName() );

    generator->setLATEXReplaceQuotes ( options.replaceQuotes() );
    generator->setLATEXNoShorthands ( options.disableBabelShorthands() );
    generator->setLATEXPrettySymbols ( options.prettySymbols() );
    generator->setLATEXBeamerMode ( options.enableBeamerMode() );

    generator->setRTFPageSize ( options.getPageSize() );
    generator->setRTFCharStyles ( options.includeCharStyles() );
    generator->setRTFPageColor ( options.includePageColor() );

    generator->setSVGSize ( options.getSVGWidth(),  options.getSVGHeight() );

    generator->setESCCanvasPadding ( options.getCanvasPadding() );

    if (options.useCRDelimiter())
        generator->setEOLDelimiter('\r');

    generator->setValidateInput ( options.validateInput() );
    generator->setNumberWrappedLines ( options.numberWrappedLines() );

    generator->setStyleInputPath ( options.getStyleInFilename() );
    generator->setStyleOutputPath ( options.getStyleOutFilename() );
    generator->setIncludeStyle ( options.includeStyleDef() );
    generator->setPrintLineNumbers ( options.printLineNumbers(), options.getNumberStart() );
    generator->setPrintZeroes ( options.fillLineNrZeroes() );
    generator->setFragmentCode ( options.fragmentOutput() );
    generator->setOmitVersionComment ( options.omitVersionInfo() );
    generator->setIsolateTags ( options.isolateTags() );

    generator->setKeepInjections ( options.keepInjections());
    generator->setPreformatting ( options.getWrappingStyle(),
                                  ( generator->getPrintLineNumbers() ) ?
                                  options.getLineLength() - options.getNumberWidth() : options.getLineLength(),
                                  options.getNumberSpaces() );

    generator->setBaseFont ( options.getBaseFont() ) ;
    generator->setBaseFontSize ( options.getBaseFontSize() ) ;
    generator->setLineNumberWidth ( options.getNumberWidth() );
    generator->disableTrailingNL(options.disableTrailingNL());
    generator->setPluginParameter(options.getPluginParameter());

    if (options.getLineRangeStart()>0 && options.getLineRangeEnd()>0){
        generator->setStartingInputLine(options.getLineRangeStart());
        generator->setMaxInputLineCnt(options.getLineRangeEnd());
    }

    bool styleFileWanted = !options.fragmentOutput() || options.styleOutPathDefined();

    const  vector <string> pluginFileList=collectPluginPaths( options.getPluginPaths());
    for (unsigned int i=0; i<pluginFileList.size(); i++) {
        if ( !generator->initPluginScript(pluginFileList[i]) ) {
            cerr << "highlight: "
                 << generator->getPluginScriptError()
                 << " in "
                 << pluginFileList[i]
                 <<"\n";
            return EXIT_FAILURE;
        }
    }

    if ( !generator->initTheme ( themePath, options.isLsSemantic() ) ) {
        cerr << "highlight: "
             << generator->getThemeInitError()
             << "\n";
        return EXIT_FAILURE;
    }

    if ( options.printOnlyStyle() ) {
        if (!options.formatSupportsExtStyle()) {
            cerr << "highlight: output format supports no external styles.\n";
            return EXIT_FAILURE;
        }
        bool useStdout =  options.getStyleOutFilename() =="stdout" || options.forceStdout();
        string cssOutFile=options.getOutDirectory()  + options.getStyleOutFilename();
        bool success=generator->printExternalStyle ( useStdout?"":cssOutFile );
        if ( !success ) {
            cerr << "highlight: Could not write " << cssOutFile <<".\n";
            return EXIT_FAILURE;
        }
        return EXIT_SUCCESS;
    }

    bool formattingEnabled = generator->initIndentationScheme ( options.getIndentScheme() );

    if ( !formattingEnabled && !options.getIndentScheme().empty() ) {
        cerr << "highlight: Undefined indentation scheme "
             << options.getIndentScheme()
             << ".\n";
        return EXIT_FAILURE;
    }

    //generator->setIndentationOptions(options.getAStyleOptions());

    string outDirectory = options.getOutDirectory();
#ifndef WIN32
    ifstream dirTest ( outDirectory.c_str() );
    if ( !outDirectory.empty() && !options.quietMode() && !dirTest ) {
        cerr << "highlight: Output directory \""
             << outDirectory
             << "\" does not exist.\n";
        return EXIT_FAILURE;
    }
    dirTest.close();
#endif

    bool initError=false, IOError=false, twoPassMode=false;
    unsigned int fileCount=inFileList.size(),
                 fileCountWidth=getNumDigits ( fileCount ),
                 i=0,
                 numBadFormatting=0,
                 numBadInput=0,
                 numBadOutput=0;

    vector<string> badFormattedFiles, badInputFiles, badOutputFiles;
    std::set<string> usedFileNames;
    string inFileName, outFilePath;
    string suffix, lastSuffix;
    string twoPassOutFile=Platform::getTempFilePath();
    bool usesLSClient=false;

    if ( options.syntaxGiven() ) { // user defined language definition, valid for all files
        string syntaxByFile=options.getSyntaxByFilename();
        string testSuffix = syntaxByFile.empty() ? options.getSyntax() : dataDir.getFileSuffix(syntaxByFile);
        suffix = dataDir.guessFileType (testSuffix, syntaxByFile, syntaxByFile.empty(), options.getSingleOutFilename().length()==0 );
    }

    generator->setFilesCnt(fileCount);

    while ( i < fileCount && !initError ) {

        if ( Platform::fileSize(inFileList[i]) > options.getMaxFileSize() ) {

            if ( numBadInput++ < IO_ERROR_REPORT_LENGTH || options.verbosityLevel() ) {
                badInputFiles.push_back ( inFileList[i] + " (size)" );
            }
            ++i;
            continue;
        }

        if (i==0 && twoPassMode) {
             if ( !generator->initPluginScript(twoPassOutFile) ) {
                cerr << "highlight: "
                 << generator->getPluginScriptError()
                 << " in "
                 << twoPassOutFile
                 <<"\n";
                initError = true;
                break;
            }
        }

        if ( !options.syntaxGiven() ) { // determine file type for each file
            suffix = dataDir.guessFileType ( dataDir.getFileSuffix ( inFileList[i] ), inFileList[i] );
        }

        if ( suffix.empty()  && options.forceOutput()) suffix=options.getFallbackSyntax(); //avoid segfault

        if ( suffix.empty() ) {
            if ( !options.enableBatchMode() )
                cerr << "highlight: Undefined language definition. Use --"
                     << OPT_SYNTAX << " option.\n";
            if ( !options.forceOutput() ) {
                initError = true;
                break;
            }
        }

        if ( suffix != lastSuffix ) {

            string langDefPath=options.getAbsLangPath().empty() ? dataDir.getLangPath ( suffix+".lang" ) : options.getAbsLangPath();

            if (!Platform::fileExists(langDefPath) && !options.getFallbackSyntax().empty()) {
                langDefPath = dataDir.getLangPath ( options.getFallbackSyntax()+".lang" );
            }

            highlight::LoadResult loadRes= generator->loadLanguage( langDefPath );

            if ( loadRes==highlight::LOAD_FAILED_REGEX ) {
                cerr << "highlight: Regex error ( "
                     << generator->getSyntaxRegexError()
                     << " ) in "<<suffix<<".lang\n";
                initError = true;
                break;
            } else if ( loadRes==highlight::LOAD_FAILED_LUA ) {
                cerr << "highlight: Lua error ( "
                     << generator->getSyntaxLuaError()
                     << " ) in "<<suffix<<".lang\n";
                initError = true;
                break;
            } else if ( loadRes==highlight::LOAD_FAILED ) {
                // do also ignore error msg if --syntax parameter should be skipped
                if ( ! (options.forceOutput() || options.quietMode() || options.isSkippedExt ( suffix )) ) {
                    cerr << "highlight: Unknown source file extension \""
                         << suffix
                         << "\". Consider the "
                         << (options.enableBatchMode() ? "--skip" : "--force or --syntax")
                         << " option.\n";
                }
                if ( !options.forceOutput() ) {
                    initError = true;
                    break;
                }
            }
            if ( options.verbosityLevel() && loadRes==highlight::LOAD_OK ) {
                printDebugInfo ( generator->getSyntaxReader(), langDefPath, options.verbosityLevel() );
            }
            lastSuffix = suffix;

            string encoding= options.getEncoding();
            //user has explicitly defined the encoding:
            if (!options.encodingDefined()) {

                //syntax definition setting:
                string encodingHint= generator->getSyntaxEncodingHint();
                if (encodingHint.size())
                    encoding=encodingHint;

                // filetypes.conf setting has higher priority:
                encodingHint= dataDir.getEncodingHint(suffix);
                if (encodingHint.size())
                    encoding=encodingHint;
            }
            generator->setEncoding (encoding);

            if (lsSyntax==suffix) {

                if (options.getWrappingStyle()!=highlight::WRAP_DISABLED || options.getIndentScheme().size()) {
                    cerr << "highlight: no reformatting allowed with LSP options.\n";
                    initError = true;
                    break;
                }

                //LSP requires absolute paths
                if (inFileList[i].empty()) {
                    cerr << "highlight: no input file path defined.\n";
                    initError = true;
                    break;
                }

                if ( lsExecutable.empty() ) {
                    cerr << "highlight: no LS executable defined. Consider the --ls-exec or --ls-profile options.\n";
                    initError = true;
                    break;
                }

                highlight::LSResult lsInitRes=generator->initLanguageServer ( lsExecutable, lsOptions,
                                                                              options.getLsWorkspace(), lsSyntax,
                                                                              lsDelay,
                                                                              options.verbosityLevel() );
                if ( lsInitRes==highlight::INIT_BAD_PIPE ) {
                    cerr << "highlight: language server connection failed\n";
                    initError = true;
                    break;
                } else if ( lsInitRes==highlight::INIT_BAD_REQUEST ) {
                    cerr << "highlight: language server initialization failed\n";
                    initError = true;
                    break;
                }
                usesLSClient=true;

                generator->lsAddSyntaxErrorInfo( (options.isLsHover() || options.isLsSemantic()) && options.isLsSyntaxError() );

                if (options.isLsHover()) {
                    if (!generator->isHoverProvider()) {
                        cerr << "highlight: language server is no hover provider\n";
                        initError = true;
                        break;
                    }
                    generator->lsAddHoverInfo( true );
                }
            }
        }

        if (usesLSClient && lsSyntax==suffix) {
            generator->lsOpenDocument(inFileList[i], suffix);

            if (options.isLsSemantic()) {
                if (!generator->isSemanticTokensProvider()) {
                    cerr << "highlight: language server is no semantic token provider\n";
                    initError = true;
                    break;
                }
                generator->lsAddSemanticInfo(inFileList[i], suffix);
            }
        }

        if (twoPassMode && !generator->syntaxRequiresTwoPassRun()) {
            ++i;
            continue;
        }

        string::size_type pos= ( inFileList[i] ).find_last_of ( Platform::pathSeparator );
        inFileName = inFileList[i].substr ( pos+1 );

        if ( options.enableBatchMode() ) {
            if (usedFileNames.count(inFileName)) {
                string prefix=inFileList[i].substr (2, pos-1 );
                replace (prefix.begin(), prefix.end(), Platform::pathSeparator, '_');
                inFileName.insert(0, prefix);
            } else {
                usedFileNames.insert(inFileName);
            }
            if (!options.forceStdout()){
                outFilePath = outDirectory;
                outFilePath += inFileName;
                outFilePath += options.getOutFileSuffix();
            }
            if ( !options.quietMode() &&  !options.forceStdout() ) {
                if ( options.printProgress() ) {
                    printProgressBar ( fileCount, i+1 );
                } else {
                    printCurrentAction ( outFilePath, fileCount, i+1, fileCountWidth );
                }
            }
        } else if (!options.forceStdout()) {
            outFilePath = options.getSingleOutFilename();
            if ( outFilePath.size() && outFilePath==options.getSingleInFilename() ) {
                cerr << "highlight: Output path equals input path: \""
                     << outFilePath << "\".\n";
                initError = true;
                break;
            }
        }

        if ( options.useFNamesAsAnchors() ) {
            generator->setHTMLAnchorPrefix ( inFileName );
        }

        generator->setTitle ( options.getDocumentTitle().empty() ?
                              inFileList[i]:options.getDocumentTitle() );

        generator->setKeyWordCase ( options.getKeywordCase() );
        highlight::ParseError error = generator->generateFile ( inFileList[i], outFilePath );

        if ( error==highlight::BAD_INPUT ) {
            if ( numBadInput++ < IO_ERROR_REPORT_LENGTH || options.verbosityLevel() ) {
                badInputFiles.push_back ( inFileList[i] );
            }
        } else if ( error==highlight::BAD_OUTPUT ) {
            if ( numBadOutput++ < IO_ERROR_REPORT_LENGTH || options.verbosityLevel() ) {
                badOutputFiles.push_back ( outFilePath );
            }
        }
        if ( formattingEnabled && !generator->formattingIsPossible() ) {
            if ( numBadFormatting++ < IO_ERROR_REPORT_LENGTH || options.verbosityLevel() ) {
                badFormattedFiles.push_back ( outFilePath );
            }
        }

        if (usesLSClient && lsSyntax==suffix) {
            //pyls hangs
            generator->lsCloseDocument(inFileList[i], suffix);
        }

        ++i;

        if (i==fileCount && outFilePath.size() && generator->requiresTwoPassParsing() && twoPassOutFile.size()
            && !numBadInput && !numBadOutput && !twoPassMode) {

            bool success=generator->printPersistentState(twoPassOutFile);
            if ( !success ) {
                cerr << "highlight: Could not write "<< twoPassOutFile <<".\n";
                IOError = true;
            } else {
                twoPassMode=true;
                if ( !options.quietMode() &&  !options.forceStdout() ) {
                    cout << "Enabling two-pass mode using "<<twoPassOutFile<<"\n";
                }
                //start over, add plug-in to list in next iteration
                usedFileNames.clear();
                generator->resetSyntaxReaders();
                i=0;
                lastSuffix.clear();
                numBadFormatting=0;
                badFormattedFiles.clear();
            }
        }
    }

    if ( i  && !options.includeStyleDef()
            && !options.inlineCSS()
            && styleFileWanted
            && options.formatSupportsExtStyle() ) {
        string cssOutFile=outDirectory  + options.getStyleOutFilename();
        bool success=generator->printExternalStyle ( cssOutFile );
        if ( !success ) {
            cerr << "highlight: Could not write " << cssOutFile <<".\n";
            IOError = true;
        }
    }

    if ( i && options.printIndexFile() ) {
        bool success=generator -> printIndexFile ( inFileList, outDirectory );
        if ( !success ) {
            cerr << "highlight: Could not write index file.\n";
            IOError = true;
        }
    }

    if ( numBadInput ) {
        printIOErrorReport ( numBadInput, badInputFiles, "read input", "<stdin>" );
        IOError = true;
    }
    if ( numBadOutput ) {
        printIOErrorReport ( numBadOutput, badOutputFiles, "write output",  "<stdout>" );
        IOError = true;
    }
    if ( numBadFormatting ) {
        printIOErrorReport ( numBadFormatting, badFormattedFiles, "reformat", "<stdout>" );
    }

    vector<string> posTestErrors = generator->getPosTestErrors();
    if (posTestErrors.size()){
        IOError = true;
        printIOErrorReport ( posTestErrors.size(), posTestErrors, "validate", "<stdin>" );
    }

    if (twoPassMode) {
        unlink(twoPassOutFile.c_str());
    }

    if (usesLSClient) {
        generator->exitLanguageServer();
    }

    return ( initError || IOError ) ? EXIT_FAILURE : EXIT_SUCCESS;
}

int main ( const int argc, const char *argv[] )
{
    HLCmdLineApp app;
    return app.run ( argc, argv );
}
