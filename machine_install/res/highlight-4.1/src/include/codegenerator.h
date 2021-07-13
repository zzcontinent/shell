/***************************************************************************
                          codegenerator.h  -  description
                             -------------------
    begin                : Die Jul 9 2002
    copyright            : (C) 2002-2021 by Andre Simon
    email                : a.simon@mailbox.org
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

#ifndef CODEPARSER_H
#define CODEPARSER_H

#include <iostream>
#include <sstream>
#include <string>
#include <iomanip>
#include <stack>
#include <vector>

#include "regextoken.h"

#include "syntaxreader.h"
#include "themereader.h"

#include "astyle/astyle.h"
#include "astyle/ASStreamIterator.h"

#include "preformatter.h"

#include "stringtools.h"

#include "lspclient.h"

/// The highlight namespace contains all classes and data structures needed for parsing input data.

namespace highlight
{


/** \brief Base class for parsing. Works like a finite state machine.

    The virtual class provides source code parsing functionality, based on
    information stored in language definitions.<br>
    The derived classes have to define the output format.<br>
    The colour information is stored in a ThemeReader instance.<br>
    Codegenerator is a singleton class.<br>
    Use getInstance for a singleton class instance. Then call the init* methods
    and loadLanguage to initialize the parser. Init methods have to be called first.
    Call generate* methods to get results.<br><br>

    Parser workflow (neglecting embedded syntax and other details):

    This flow chart shows the method calls, starting in processRootState:

    -> lineIndex=0
    -> processRootState()
       -> state = getCurrentState()
          -> c = getInputChar()
             -> increase lineIndex
             -> if new line: matchRegex()
                -> cycle through all regexes of Syntaxreader:
                   KEYWORD, COMMENT, IDENTIFIER, NUMBER, STRING, INTERPOLATION,
                   PREPROCESSOR, OPERATOR, NESTEDSECTIONS
                -> save position and length of a match for the current line
          -> is there a match at line[lineIndex]?
             -> YES: - token = match substring of line
                     - lineIndex = lineIndex + length of token
                     - call OnStateChange chunk if available
                     - state = state of the associated regex or OnStateChange return value
             -> NO:  - token=c
                     - state = STANDARD
        -> state is used to determine the next process* method to call. There
           are process methods for each state (ie processKeywordState, processNumberState).
           These methods open and close the delimiter tags in the output format, and most
           importantly decide when the state ends. They also limit the allowed state changes,
           like INTERPOLATION in STRING.

* @author Andre Simon
*/

class CodeGenerator
{

public:

    virtual ~CodeGenerator();

    /**
      Get appropriate Codegenerator instance (should be used with auto_ptr)
      \param type Output file type (HTML, XHTML, RTF, LATEX, TEX, ANSI, XTERM256)
      \return CodeGenerator
    */
    static CodeGenerator* getInstance ( OutputType type );

    /**
      Delete CodeGenerator instance (this is intended for SWIG integration only,
      in normal C++ code the result of getInstance() should be saved in an auto_ptr)
      \param inst CodeGenerator instance
    */
    static void deleteInstance ( CodeGenerator* inst )
    {
        if ( inst ) delete inst;
    }

    /**
     Define colour theme information; needs to be called before using a generate* method.
     Call this method before loadLanguage().
     \param themePath Path of style description file
     \param loadSemanticStyles set true if semantic styles should be read
     \return true if successful
    */
    bool initTheme ( const string& themePath, bool loadSemanticStyles=false );

    LSResult initLanguageServer ( const string& executable, const vector<string> &options, const string& workspace,
                                  const string& syntax, int delay, int logLevel );

    void exitLanguageServer ();


    /**
     \return description of the theme init error
    */
    string getThemeInitError();

    /**
     \return description of the plug-in script error
    */
    string getPluginScriptError();

    /** initialize source code indentation and reformatting scheme;
        needs to be called before using a generate* method
        \param indentScheme Name of indentation scheme
        \return true if successful
     */
    bool initIndentationScheme ( const string& indentScheme );

    /** \param langDefPath Absolute path to language definition, may be used multiple times for a generator instance
     *  \param embedded set True if method is called to load an embedded language
        \return   LOAD_OK, LOAD_FAILED, LOAD_FAILED_REGEX, LOAD_FAILED_LUA
    */
    LoadResult loadLanguage ( const string& langDefPath, bool embedded=false );

    /**
     Generate output file from input file
     \param inFileName Path of input file (if empty use stdin)
     \param outFileName Path of output file (if empty use stdout)
     \return ParseError
    */
    ParseError generateFile ( const string &inFileName, const string &outFileName );

    /**
     Generate output string from input string
     \param input input code string
     \return formatted output code
    */
    string generateString ( const string &input );

    /**
     Generate output string from input file
     \param inFileName file path
     \return formatted output code
    */
    string generateStringFromFile ( const string &inFileName );

    /** Print style definitions to external file or stdout
      \param outFile Path of external style definition; print to stdout if empty
       \return true if successful
      */
    bool printExternalStyle ( const string &outFile );

    /** Print persistent state snippets to external file
      \param outFile Path of plugin file to generate
       \return true if successful
      */
    bool printPersistentState ( const string &outFile );

    /** Print index file with all input file names
       \param fileList List of output file names
       \param outPath Output path
        \return true if successful
     */
    virtual bool printIndexFile ( const vector<string> & fileList,
                                  const string &outPath );

    /** define the preformatting parameters. Preformatting takes place before
        the optional astyle reformatting and indenting is performed (defined by initIndentationScheme)
       \param lineWrappingStyle wrapping style (WRAP_DISABLED, WRAP_SIMPLE, WRAP_DEFAULT)
       \param lineLength max line length
       \param numberSpaces number of spaces which replace a tab
    */
    void setPreformatting ( WrapMode lineWrappingStyle, unsigned int lineLength,int numberSpaces );

    /** \return True if document style was found */
    bool styleFound();

    /** \return True if reformatting of current input is disabled */
    bool formattingDisabled();

    /** \return True if reformatting of current input is possible */
    bool formattingIsPossible();

    /** output line numbers
       \param flag true if line numbers should be printed
       \param startCnt line number starting count
    */
    void setPrintLineNumbers ( bool flag, unsigned int startCnt=1 );

    /** \return line number flag */
    bool getPrintLineNumbers();

    /** output line numbers filled with zeroes
        \param  flag true if zeroes should be printed
    */
    void setPrintZeroes ( bool flag );

    /** \return print zeroes flag */
    bool getPrintZeroes();

    /** omit document header and footer
       \param  flag true if output should be fragmented
    */
    void setFragmentCode ( bool flag );

    /** \return fragment flag */
    bool getFragmentCode();

    /** define line number width
       \param  w width
    */
    void setLineNumberWidth ( int w );

    /** \return line number width */
    int getLineNumberWidth();

    /** check if input is binary or text
       \param  flag true if input should be checked
    */
    void setValidateInput ( bool flag );

    /** \return input validation flag */
    bool getValidateInput();

    /** set keep injections flag
     * \param  flag true if plug-in injections should be outputted if header
     * and footer are omitted (fragmentCode is true)
     */
    void setKeepInjections( bool flag );;

    /** \return keep injection flag */
    bool getKeepInjections();

    bool requiresTwoPassParsing() const;

    /** \param  flag true if wrapped lines receive unique line numbers.
     *  otherwise wrapped lines don't have line numbers at all. */
    void setNumberWrappedLines ( bool flag );

    /** return number wrapped lines flag */
    bool getNumberWrappedLines ();

    /** \param flag true if version info comment should be omitted */
    void setOmitVersionComment ( bool flag );

    /** return version info comment flag */
    bool getOmitVersionComment ();

    /** \param flag true if token of the same syntax category should be outputted in separate tags */
    void setIsolateTags ( bool flag );

    /** return version info comment flag */
    bool getIsolateTags ();

    /** \return style path */
    const string& getStyleName();

    /** use this font as base font
      * \param fontName the font name, e.g. "Courier New"
     */
    void setBaseFont ( const string& fontName);

    /** \return base font */
    const string getBaseFont() const ;

    /** use this size as base font size
      * \param fontSize the font size, e.g. "12"
     */
    void setBaseFontSize ( const string& fontSize );

    /** \return base font size*/
    const string getBaseFontSize();

    /** tell parser the include style definition in output
        \param flag true if style should be included
     */
    void setIncludeStyle ( bool flag );

    /** tell parser to omit trailing newline character
        \param flag 1 if no trailing newline should be printed,
                    2 omit newline only for empty input
     */
    void disableTrailingNL ( int flag );

    /** Set style input path
        \param path path to style input file
      */
    void setStyleInputPath ( const string& path );

    /** Set style output path
      \param path path to style output file
    */
    void setStyleOutputPath ( const string& path );

    /** Set encoding (output encoding must match input file)
      \param encodingName encoding name
    */
    void setEncoding ( const string& encodingName );

    /** \return style input file path */
    const string&  getStyleInputPath();

    /** \return style output file path */
    const string&  getStyleOutputPath();

    /** \param title Document title */
    void setTitle ( const string & title );

    /** \return Document title */
    string getTitle();

    /** \param begin number of the first input line to be processed */
    void setStartingInputLine ( unsigned int begin );

    /** \param cnt upper limit of input lines to be processed */
    void setMaxInputLineCnt ( unsigned int cnt );

    /** \param cnt number of input files */
    void setFilesCnt ( unsigned int cnt );

    /** \param keyCase Keyword case */
    void setKeyWordCase ( StringTools::KeywordCase keyCase );

    /** \param delim End of line delimiter (default: NL)
    */
    void setEOLDelimiter(char delim);

    /** \param param path of plugin input file
    */
    void setPluginParameter ( const string& param );

    void resetSyntaxReaders();

    /** Load the Lua functions og the plug-in script
    	\param script path of the plug-in script
    */
    bool initPluginScript(const string& script);

    bool syntaxRequiresTwoPassRun();

    void clearPersistentSnippets();

    /** \param flag true if styles should be cached for repeated file output calls */
    void setStyleCaching ( bool flag );

    /** \return Syntaxreader Regex error message */
    string getSyntaxRegexError();

    /** \return Syntaxreader Lua error message */
    string getSyntaxLuaError();

    /** \return Syntaxreader description */
    string getSyntaxDescription();

    /** \return Encoding hint */
    string getSyntaxEncodingHint();

    /** \return Theme description */
    string getThemeDescription();

    /** \return Syntaxreader category description */
    string getSyntaxCatDescription();

    /** \return Encoding contrast of Canvas and Default colours */
    float getThemeContrast();

    /** \return Theme category description */
    string getThemeCatDescription();

    vector<string> getPosTestErrors() { return failedPosTests; }

    /** \return Pointer Syntaxreader, intended for debug output  */
    SyntaxReader* getSyntaxReader()
    {
        return currentSyntax;
    }

    /** \return Content of user defined input style */
    string readUserStyleDef();

    /** \return Style definition of the chosen output format */
    virtual string getStyleDefinition()
    {
        return "";
    }

    virtual string getHoverTagOpen(const string & hoverText)
    {
        return "";
    }

    virtual string getHoverTagClose()
    {
        return "";
    }

    bool lsOpenDocument(const string& fileName, const string & suffix);

    bool lsCloseDocument(const string& fileName, const string & suffix);

    bool lsAddSemanticInfo(const string& fileName, const string & suffix);

    void lsAddHoverInfo(bool hover);

    void lsAddSyntaxErrorInfo(bool error);

    bool isHoverProvider();

    bool isSemanticTokensProvider();

    /** set HTML output anchor flag
     */
    virtual void setHTMLAttachAnchors ( bool )  {};

    /** set HTML output ordered list flag
     */
    virtual void setHTMLOrderedList ( bool )  {};

    /** set HTML output inline CSS flag
     */
    virtual void setHTMLInlineCSS ( bool )  {};

    /** set HTML output enclose pre tag flag
     */
    virtual void setHTMLEnclosePreTag ( bool )  {};

    /** set HTML output replace space by &nbsp; flag
     */
    virtual void setHTMLUseNonBreakingSpace ( bool )  {};

    /** set HTML output anchor prefix
     */
    virtual void setHTMLAnchorPrefix ( const string& )  {};

    /** set HTML output class name
     */
    virtual void setHTMLClassName ( const string& )  {};

    /** set LaTeX replace quotes flag
     */
    virtual void setLATEXReplaceQuotes ( bool )  {};

    /** set LaTeX no Babel shorthands flag
     */
    virtual void setLATEXNoShorthands ( bool )  {};

    /** set LaTeX pretty Symbols flag
     */
    virtual void setLATEXPrettySymbols ( bool )  {};

    virtual void setLATEXBeamerMode ( bool )  {};

    /** set RTF page size
     */
    virtual void setRTFPageSize ( const string& )  {};

    /** set RTF output character styles flag
     */
    virtual void setRTFCharStyles ( bool )  {};

    /** set RTF page color flag
     */
    virtual void setRTFPageColor ( bool )  {};

    /** set SVG page size
     */
    virtual void setSVGSize ( const string&, const string& )  {};

    /** set True Color flag
     */
    virtual void setESCTrueColor ( bool )  {};

     /** set background padding width (<=0 to disable)
     */
    virtual void setESCCanvasPadding ( unsigned int )  {};

protected:

    static const unsigned int NUMBER_BUILTIN_STATES;  ///< number of token states (without keyword group IDs)

    static const string STY_NAME_STD;
    static const string STY_NAME_STR;
    static const string STY_NAME_NUM;
    static const string STY_NAME_SLC;
    static const string STY_NAME_COM;
    static const string STY_NAME_ESC;
    static const string STY_NAME_DIR;
    static const string STY_NAME_DST;
    static const string STY_NAME_LIN;
    static const string STY_NAME_SYM;
    static const string STY_NAME_IPL;

    static const string STY_NAME_HVR;
    static const string STY_NAME_ERR;
    static const string STY_NAME_ERM;

    /** \param type Output type */
    CodeGenerator ( highlight::OutputType type );
    CodeGenerator() {};

    /** \param c Character to be masked
        \return Escape sequence of output format */
    virtual string maskCharacter ( unsigned char c ) = 0;

    /** \param ss destination stream
        \param s string */
    void maskString ( ostream& ss, const string &s ) ;

    void printSyntaxError ( ostream& ss ) ;

    /** Get current line number
      \return line number  */
    unsigned int getLineNumber();

    vector <string> openTags,   ///< list of format delimiters (open new format descriptions)
           closeTags;   ///< list of format delimiters (close format descriptions)

    /** Description of document colour style*/
    ThemeReader docStyle;

    /** Language definition*/
    SyntaxReader* currentSyntax;

    /** Tag for inserting line feeds*/
    string newLineTag;

    /** String that represents a white space in output */
    string spacer, initialSpacer;

    /** file input*/
    istream *in;

    /** file output*/
    ostream *out;

    string maskWsBegin,  ///< open whitespace mask
           maskWsEnd;    ///< close whitespace mask

    string styleCommentOpen,  ///< open comment delimiter
           styleCommentClose; ///< close comment delimiter

    string embedBlockOpen,  ///< open block delimiter to highlight embedded code
           embedBlockClose; ///< close block delimiter

    /** Encoding name */
    string encoding;

    /** document title */
    string docTitle;

    string inFile,   ///< input file name
           outFile;  ///< output file name

    /// LSP syntax error description
    string lsSyntaxErrorDesc;

    /** Test if maskWsBegin and maskWsEnd should be applied */
    bool maskWs;

    /** Test if whitespace should always be separated from enclosing tokens */
    bool excludeWs;

    /** Test if header and footer should be omitted */
    bool fragmentOutput;

    /** Test if plugin injections should be printed if fragmentOutput is true */
    bool keepInjections;

    /** Test if line numbers should be printed */
    bool showLineNumbers;

    /** Test if leading spyce of line number should be filled with zeroes*/
    bool lineNumberFillZeroes;

    /** Flag to test if newlines should be printed */
    bool printNewLines;

    /** Test if version info comment printed */
    bool omitVersionComment;

    /** Flag to output token of the same syntax category in separate tags */
    bool isolateTags;

    bool disableStyleCache;

    /** The base font to use */
    string baseFont ;

    /** The base font size to use */
    string baseFontSize ;

    /** Current line of input file*/
    string line;

    /** Current line number */
    unsigned int lineNumber;

    /**output line number count start */
    int lineNumberOffset;

    /** Current state*/
    State currentState;

    /** keyword class id, used to apply the corresponding keyword style*/
    unsigned int currentKeywordClass;

    /** Processes origin state */
    void processRootState();

    /** \return line break sequence */
    virtual string getNewLine();

    /**
       \param s current state
       \param kwClassID keyword class (has to be set when s=KEYWORD)
       \return Index of style tag corresponding to the states
    */
    unsigned int getStyleID ( State s, unsigned int kwClassID = 0 );

    /** \return current line index */
    unsigned int getLineIndex();

    /** \return last line index */
    unsigned int getLastLineLength();

    /** print all remaining white space*/
    void flushWs(int );

    /** \return true id encoding is defined */
    bool encodingDefined()
    {
        return StringTools::change_case ( encoding ) !="none";
    }

    /** Invoke plugin decorate user function */
    Diluculum::LuaValueList callDecorateFct(const string& token);

    /** Invoke plugin decorate line user function
     @param isLineStart set true if line start function should be called,
            otherwise line end function is invoked */
    Diluculum::LuaValueList callDecorateLineFct(bool isLineStart);

    /** contains white space, which will be printed after a closing tag */
    string wsBuffer;

    /** Flag to test if style definition should be included in output document */
    bool includeStyleDef;

    /** Class for line wrapping and tab replacement*/
    PreFormatter preFormatter;

    /** Stores if the current line should receive a line number.
     *  If the line is just the continuation of a wrapped line,
     *  and numberWrappedLines is false, this is set true. */
    bool numberCurrentLine;

    /** method to fix output type in Lua state for XHTML and Truecolor
        @param output type */
    void setOutputType(OutputType t) { outputType = t; }

private:

    void printTrace(const string &s);

    CodeGenerator ( const CodeGenerator& ) {}

    CodeGenerator& operator= ( CodeGenerator& )
    {
        return *this;
    }

    /** Insert line number at the beginning of current output line
        @param insertNewLine set true if newline should be outputted
     */
    virtual void insertLineNumber ( bool insertNewLine=true);

    /** returns output specific document footer
        @return footer */
    virtual string getFooter() = 0;

    /** returns output specific document header
      * @return header */
    virtual string getHeader() = 0;

    /** Prints document header*/
    void printHeader();

    /** Prints document body*/
    virtual void printBody() = 0;

    /** Prints document footer*/
    void printFooter();

    /** initialize tags in specific format according to colouring information
     *  provided in DucumentStyle */
    virtual void initOutputTags() = 0;

    /** \param styleID keyword style id
    	\return  open tag  */
    virtual string getKeywordOpenTag ( unsigned int styleID) = 0;

    /** \param styleID keyword style id
    	\return  close tag  */
    virtual string getKeywordCloseTag ( unsigned int styleID) = 0;

    /** open a new tag, set current state to s*/
    void openTag ( State s );

    /** close opened tag, clear current state */
    void closeTag ( State s );

    /** close Keyword tag of corresponding style ID */
    void closeKWTag ( unsigned int styleID );

    /** open Keyword tag of corresponding style ID */
    void openKWTag ( unsigned int styleID );

    /// path to style definition file
    string themePath;

    /// path to host language definition
    string hostLangDefPath;

    /// path to embedded language definition
    string embedLangDefPath;

    /// path to plugin input file
    string pluginParameter;

    /// contains current position in line
    unsigned int lineIndex;

    /// contains length of last line
    unsigned int lastLineLength;

    /// line index where syntax change takes place
    unsigned int syntaxChangeIndex;

    /// line number where syntax change takes place
    unsigned int syntaxChangeLineNo;

    /// width of line numbering column
    unsigned int lineNumberWidth;

    /**first input line to be processed*/
    unsigned int startLineCnt;
    unsigned int startLineCntCurFile;

    /**maximum count of input lines to be processed*/
    unsigned int maxLineCnt;


    /**number of files to be processed and counter*/
    unsigned int inputFilesCnt;
    unsigned int processedFilesCnt;

    int kwOffset;

    /** Flag to test if trailing newline should be printed */
    int noTrailingNewLine;

    /**last character of the last line*/
    unsigned char terminatingChar;

    /** Class for reformatting */
    astyle::ASFormatter *formatter;
    astyle::ASStreamIterator *streamIterator;

    /** Flag to test if formatting is enabled with current input document*/
    bool formattingEnabled;

    /** Flag to test if formatting is possible with current input document*/
    bool formattingPossible;

    /** Flag to test if input should be validated (binary or text) */
    bool validateInput;

    /** Flag if wrapped lines should receive unique line numbers as well */
    bool numberWrappedLines;

    /** indicator if current state was set by Lua hook function */
    bool resultOfHook;

    bool lineContainedTestCase;

    bool lineContainedStmt;

    bool applySyntaxTestCase;

    bool toggleDynRawString;

    bool lsEnableHoverRequests;

    bool lsCheckSemanticTokens;

    bool lsCheckSyntaxErrors;

    /** flag which determines keyword output (unchangeed, uppercase, lowercase)*/
    StringTools::KeywordCase keywordCase;

    /** contains the current token*/
    string token;

    string styleInputPath,   ///< style input file path
           styleOutputPath;  ///< style output file path

    string userScriptError;  ///< Plug-In script error message

    string lsDocumentPath;   ///< Language Server input file name

    /** end-of-line delimiter*/
    char eolDelimiter;

    /** Resets parser to origin state, call this after every file conversion */
    void reset();

    /** read new line from in stream */
    bool readNewLine ( string &newLine );

    /** return next character from in stream */
    unsigned char getInputChar();

    /** output file type */
    OutputType outputType;

    /** return new state */
    State getCurrentState (State oldState);

    std::stack<std::string> nestedLangs;

    /* Methods that represent a parsing state */
    bool processKeywordState ( State myState );  ///< process keywords
    bool processNumberState() ;               ///< process numbers
    bool processMultiLineCommentState();      ///< process multi line comments
    bool processSingleLineCommentState();     ///< process single line comments
    bool processStringState ( State oldState ); ///< process strings
    bool processEscapeCharState();            ///< process escape characters
    bool processInterpolationState();         ///< process string interpolation sequences
    bool processDirectiveState();             ///< process directives
    bool processTagState();                   ///< process tags
    bool processSymbolState();                ///< process symbols
    void processWsState();                    ///< process whitespace
    bool processSyntaxChangeState(State myState ); ///< process syntax change of embedded languages
    bool processSyntaxErrorState();           ///< process syntax errors

    /* checks whether the given state was defined in the same column of the last parsed input line */
    void runSyntaxTestcases(unsigned int column);

    /* returns name of testcase state */
    string getTestcaseName(State s, unsigned int kwClass);

    /** print escaped token and clears it
       \param flushWhiteSpace set true if white space should be flushed
       \param tcase keyword case
    */
    void printMaskedToken ( bool flushWhiteSpace = true,
            StringTools::KeywordCase tcase = StringTools::CASE_UNCHANGED );

    void updateKeywordClasses();

    /** association of matched regexes and the corresponding keyword class ids*/
    map <int, RegexToken> regexGroups;

    /** history of states per line position in the current line of input code (max 200 entries) */

    struct PositionState {
        State state;
        unsigned int kwClass;
        bool isWhiteSpace;
        PositionState(const State s, const unsigned int kwc, bool ws)
        : state(s), kwClass(kwc), isWhiteSpace(ws) {
            if (s!=KEYWORD) kwClass=0;
        }
    };
    vector<PositionState> stateTraceCurrent, stateTraceTest;

    vector<string> failedPosTests;

    /** association of syntax definitions and their paths*/
    map <string, SyntaxReader*> syntaxReaders;

    /** test for regular expressions
        \param line current input line
        \param skipState state which should be ignored*/
    void matchRegex ( const string &line, State skipState=_UNKNOWN );

    /** \return true if input is no binary stream */
    bool validateInputStream();

    /** load syntax description of embedded snippet's language
     \param embedLangDefPath path to language definition
      \return true if successful */
    bool loadEmbeddedLang(const string&embedLangDefPath);

    /** call user script OnStateChange function if defined to confirm state change
     \param newState new state
     \param oldState old state
     */
    State validateState(State newState, State oldState);

    unsigned int getCurrentKeywordClassId();

    /**
    	\param chunk Lua function to be added to the function list
    */
    void addUserChunk(const Diluculum::LuaFunction& chunk)
    {
        pluginChunks.push_back(new Diluculum::LuaFunction(chunk));
    }

    void applyPluginChunk(const string& fctName, string *result, bool *keepDefault);

    void initASStream();

    void setOverrideParams();

    static vector<Diluculum::LuaFunction*> pluginChunks;

    highlight::LSPClient LSPClient;
};

}

#endif
