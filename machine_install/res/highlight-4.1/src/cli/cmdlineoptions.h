/***************************************************************************
                          cmdlineoptions.h  -  description
                             -------------------
    begin                : Sun Nov 25 2001
    copyright            : (C) 2001-2021 by Andre Simon
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


#ifndef CMDLINEOPTIONS_H
#define CMDLINEOPTIONS_H

#ifdef _WIN32
#include <windows.h>
#endif

#include <string>
#include <map>
#include <set>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <vector>

#include "stringtools.h"
#include "enums.h"

#define OPT_OUTFORMAT      "out-format"
#define OPT_ANCHORS        "anchors"
#define OPT_ANCHOR_FN      "anchor-filename"
#define OPT_ANCHOR_PFX     "anchor-prefix"
#define OPT_LATEX_BABEL    "babel"
#define OPT_LATEX_BEAMER   "beamer"
#define OPT_BASE_FONT      "font"
#define OPT_BASE_FONT_SIZE "font-size"
#define OPT_BATCHREC       "batch-recursive"
#define OPT_CLASSNAME      "class-name"
#define OPT_DATADIR        "data-dir"
#define OPT_DELTABS        "replace-tabs"
#define OPT_DOC_TITLE      "doc-title"
#define OPT_ENCLOSE_PRE    "enclose-pre"
#define OPT_ENCODING       "encoding"
#define OPT_FILLZEROES     "zeroes"
#define OPT_FORCE_OUTPUT   "force"
#define OPT_FORMAT         "reformat"
#define OPT_FRAGMENT       "fragment"
#define OPT_HELP           "help"
#define OPT_IN             "input"
#define OPT_INC_STYLE      "include-style"
#define OPT_INDEXFILE      "print-index"
#define OPT_INLINE_CSS     "inline-css"
#define OPT_KW_CASE        "kw-case"
#define OPT_LINENO         "line-numbers"
#define OPT_LINE_LEN       "line-length"
#define OPT_LIST_SCRIPTS   "list-scripts"
#define OPT_LNR_LEN        "line-number-length"
#define OPT_LNR_START      "line-number-start"
#define OPT_ORDERED_LIST   "ordered-list"
#define OPT_OUT            "output"
#define OPT_OUTDIR         "outdir"
#define OPT_RTF_PAGE_SIZE  "page-size"
#define OPT_RTF_CHAR_STYLES "char-styles"
#define OPT_RTF_PAGE_COLOR "page-color"
#define OPT_PRINT_CONFIG   "print-config"
#define OPT_PROGRESSBAR    "progress"
#define OPT_QUIET          "quiet"
#define OPT_REPLACE_QUOTES "replace-quotes"
#define OPT_STYLE          "style"
#define OPT_STYLE_IN       "style-infile"
#define OPT_STYLE_OUT      "style-outfile"
#define OPT_SYNTAX         "syntax"
#define OPT_TEST_INPUT     "validate-input"
#define OPT_VERBOSE        "verbose"
#define OPT_VERSION        "version"
#define OPT_WRAP           "wrap"
#define OPT_WRAPSIMPLE     "wrap-simple"
#define OPT_SVG_WIDTH      "width"
#define OPT_SVG_HEIGHT     "height"
#define OPT_SKIP_UNKNOWN   "skip"
#define OPT_PRETTY_SYMBOLS "pretty-symbols"
#define OPT_EOL_DELIM_CR   "delim-cr"
#define OPT_START_NESTED   "start-nested"
#define OPT_PRINT_STYLE    "print-style"
#define OPT_NO_TRAILING_NL "no-trailing-nl"
#define OPT_PLUGIN         "plug-in"
#define OPT_ABS_CFG_PATH   "config-file"
#define OPT_PLUGIN_READFILE  "plug-in-read"
#define OPT_PLUGIN_PARAMETER "plug-in-param"
#define OPT_NO_NUMBER_WL     "wrap-no-numbers"
#define OPT_KEEP_INJECTIONS  "keep-injections"
#define OPT_FORCE_STDOUT     "stdout"
#define OPT_NO_VERSION_INFO  "no-version-info"
#define OPT_CANVAS           "canvas"
#define OPT_REFORMAT_OPT     "reformat-option"
#define OPT_RANGE_OPT        "line-range"
#define OPT_BASE16           "base16"
#define OPT_CATEGORIES       "list-cat"
#define OPT_PIPED_FNAME      "syntax-by-name"
#define OPT_ISOLATE_TAGS     "isolate"
#define OPT_MAX_FILE_SIZE    "max-size"
#define OPT_SYNTAX_SUPPORTED "syntax-supported"

// Improve CLI option compatibility with GNU source-highlight
#define OPT_COMPAT_DOC       "doc"
#define OPT_COMPAT_NODOC     "no-doc"
#define OPT_COMPAT_TAB       "tab"
#define OPT_COMPAT_CSS       "css"
#define OPT_COMPAT_OUTDIR    "output-dir"
#define OPT_COMPAT_FAILSAFE  "failsafe"
#define OPT_COMPAT_SRCLANG   "src-lang"
#define OPT_COMPAT_LINENUM   "line-number"
#define OPT_COMPAT_LINEREF   "line-number-ref"

#define OPT_LS_PROFILE       "ls-profile"
#define OPT_LS_WORKSPACE     "ls-workspace"
#define OPT_LS_EXEC          "ls-exec"
#define OPT_LS_OPTION        "ls-option"
#define OPT_LS_HOVER         "ls-hover"
#define OPT_LS_SEMANTIC      "ls-semantic"
#define OPT_LS_RAINBOW       "ls-rainbow"
#define OPT_LS_SYNTAX        "ls-syntax"
#define OPT_LS_DELAY         "ls-delay"
#define OPT_LS_SYNTAX_ERROR  "ls-syntax-error"

/// handle command line options

class CmdLineOptions
{
public:

    /**Constructor
     \param argc Argument count
     \param argv Argument strings
    */
    CmdLineOptions ( const int argc, const char *argv[] );
    ~CmdLineOptions();

    /** \return Single output file name*/
    const std::string &getSingleOutFilename();

    /** \return Single input file name*/
    const std::string &getSingleInFilename() const;

    /** \return Output directory*/
    const std::string& getOutDirectory() ;

    /** \return Style output file name*/
    const std::string getStyleOutFilename() const;

    /** \return Style input file name*/
    const std::string& getStyleInFilename() const;

    /** \return Char set*/
    const std::string& getEncoding() const;

    /** \return SVG width*/
    const std::string& getSVGWidth() const;

    /** \return SVG height*/
    const std::string& getSVGHeight() const;

    /** \return Number of spaces to replace a tab*/
    int getNumberSpaces() const;

    /** \return True if version information should be printed*/
    bool printVersion() const;

    /** \return True if help information should be printed*/
    bool printHelp() const;

    /** \return verbosity level */
    int verbosityLevel() const;

    /** \return True if configuration information should be printed*/
    bool printConfigInfo() const;

    /** \return True if Style definition should be included in output*/
    bool includeStyleDef() const;

    /** \return True if line numbers should be printed*/
    bool printLineNumbers() const;

    /** \return True if CR is eol delimiter */
    bool useCRDelimiter() const;

    /** \return colour theme name */
    std::string getThemeName() const ;

    /** gibt true zurck, falls deutsche Hilfe ausgegeben werden soll */
    int helpLanguage() const;

    /** \return True if batch mode is active*/
    bool enableBatchMode() const;

    /** \return True if output shluld be fragmented*/
    bool fragmentOutput() const;

    /** \return output file suffix */
    std::string getOutFileSuffix() const;

    /** \return True if anchors should be attached to line numbers*/
    bool attachLineAnchors() const;

    /** \return True if loutput directory is given*/
    bool outDirGiven() const;

    /** \return True if a new data directory is given*/
    bool dataDirGiven() const;

    /** \return True if index file should be printed*/
    bool printIndexFile() const;

    /** \return True if quotes should be replaced by /dq in LaTeX*/
    bool replaceQuotes() const;

    /** \return True if shorthands of LaTeX Babel package should be disabled*/
    bool disableBabelShorthands() const;

    /** \return True if support for the Beamer package should be enabled*/
    bool enableBeamerMode() const;

    /** \return True if input file name should be used as anchor name */
    bool useFNamesAsAnchors() const;

    /** \return Data directory*/
    const std::string &getDataDir() const;

    /** \return True if language syntax is given*/
    bool syntaxGiven() const;

    /** \return True if quiet mode is active*/
    bool quietMode() const;

    /** \return True if progress bar should be printed in batch mode */
    bool printProgress() const;

    /** \return True if line numbers are filled with leading zeroes */
    bool fillLineNrZeroes() const;

    /** \return True if plug-in injections are outputted despite of --fragment */
    bool keepInjections() const;

    /** \return True if files should be sent to stdout in batch mode */
    bool forceStdout() const;

     /** \return True if output should not contain version info comment */
    bool omitVersionInfo() const;

    /** \return programming syntax */
    const std::string &getSyntax() const ;

    /** \return Wrapping style*/
    highlight::WrapMode getWrappingStyle() const;

    /** \return List of input file names*/
    const std::vector <std::string> & getInputFileNames() const;

    /** \return indentation and reformatting scheme*/
    std::string getIndentScheme() const;

    /** \return RTF page size */
    const std::string &getPageSize() const;

    /** \return Output file format */
    highlight::OutputType getOutputType() const;

    /** \return True if chosen output format supports referenced style files */
    bool formatSupportsExtStyle();

    /** \return True if style output path was defined by user*/
    bool styleOutPathDefined() const
    {
        return opt_stylepath_explicit;
    }

    /** \return True if encoding specification should be omitted in output*/
    bool omitEncoding() const;

     /** \return True if encoding was set by user*/
    bool encodingDefined() const
        {
        return opt_encoding_explicit;
    }

    /** \return True if style was defined by user*/
    bool styleDefined() const
    {
        return !styleName.empty();
    }

    /** \return True if output should be generated if language type is unknown*/
    bool forceOutput() const;

    /** \return True if line numbers should be replaced by ordered list (HTML) */
    bool orderedList() const;

    /** \return True if a base font has been given */
    bool hasBaseFont() const ;

    /** \return True if input should be validated */
    bool validateInput() const ;

    /** \return True if wrapped lines should get unique numbers */
    bool numberWrappedLines() const ;

    /** \return True if CSS should be outputted within tag elements */
    bool inlineCSS() const ;

    /** \return True if fragmented html output should be enclosed with pre tags */
    bool enclosePreTag() const ;

    /** \return True if RTF output should include character styles */
    bool includeCharStyles() const ;

    /** \return True if RTF output should include page color */
    bool includePageColor() const ;

    /** \return True if LaTeX output should include fancier symbols */
    bool prettySymbols() const;

    /** \return True if style should be printed */
    bool printOnlyStyle() const;

    /** \return True if Base16 theme should be used */
    bool useBase16Theme() const;

    /** \return True if output token of the same syntax category should be in separate tags */
    bool isolateTags() const;

    /** \return true if file extension should be ignored */
    bool isSkippedExt ( const std::string& ext ) const;

    /** \return true if syntax load result should be reported */
    bool checkSyntaxSupport () const;

    /** \return false  */
    bool isLsRainbow () const;

    /** \return false  */
    bool isLsSemantic () const;

    /** \return false  */
    bool isLsHover () const;

    /** \return false  */
    bool isLsSyntaxError () const;

    /** \return max. input file size (default 256 MB) */
    off_t getMaxFileSize() const;

    /** \return The given base font, empty std::string by default */
    const std::string& getBaseFont() const ;

    /** \return Document title */
    const std::string& getDocumentTitle() const ;

    /** \return anchor prefix */
    const std::string& getAnchorPrefix() const ;

    /** \return class name */
    const std::string& getClassName() const ;

    /** \return list of plugin file paths */
    const std::vector <std::string> &getPluginPaths() const;

    /** \return list of astyle options */
    const std::vector <std::string> &getAStyleOptions() const;

    /** \return list of langiage server options */
    const std::vector <std::string> &getLSOptions() const;

    /** \return 1 if trailing nl should be omitted,
     *          2 if it should only be omitted for empty input */
    int disableTrailingNL() const ;

    /** \return The given base font size, empty string by default */
    const std::string& getBaseFontSize() const ;

    /** \return name of nested syntax which starts the input */
    const std::string& getStartNestedLang() const ;

    /** \return absolute theme definition path name */
    const std::string& getAbsThemePath() const ;

    /** \return absolute language definition path name */
    const std::string& getAbsLangPath() const ;

    /** \return parameter passed to plugin */
    const std::string& getPluginParameter() const ;

    /** \return category to filter scripts of --list-scripts */
    const std::string& getCategories() const ;

    /** \return optional help topic */
    const std::string& getHelpTopic() const;

    /** \return name of the file which will later be redirected to highlight's stdin */
    const std::string& getSyntaxByFilename() const;

    /** \return category of scripts which should be listed */
    const std::string& getListScriptKind() const;

        /** \return fallback syntax if not defined or found by filename or shebang */
    const std::string& getFallbackSyntax() const;

    /** \return language server executable */
    const std::string& getLsExecutable() const;

    /** \return language server workspace directory */
    const std::string& getLsWorkspace() const;

    /** \return language server profile name */
    const std::string& getLsProfile() const;

    /** \return syntax which triggers language server requests */
    const std::string& getLsSyntax() const;

    /** \return server delay time in ms */
    const int getLsDelay() const;

    /** \return line number width */
    int getNumberWidth();

    /** \return line length */
    int getLineLength();

    /** \return Line number start count */
    int getNumberStart();

    /** \return ANSI background color padding width */
    int getCanvasPadding();

    /** \return line range start */
    int getLineRangeStart();

    /** \return line range end (number of lines starting from getLineRangeStart() ) */
    int getLineRangeEnd();

    /** \return Keyword Case (upper, lower, unchanged) */
    StringTools::KeywordCase getKeywordCase() const;

private:

    int numberSpaces;   // number of spaces which replace a tab
    int lineNrWidth;    // width of line number (left padding)
    int lineLength;    // length of line before wrapping
    int lineNrStart;    // line number start count
    int lineRangeStart;    // line range start
    int lineRangeEnd;    // line range end
    int opt_no_trailing_nl;
    int verbosity;
    int lsDelay;

    unsigned int canvasPaddingWidth;    // line number start count

    highlight::WrapMode wrappingStyle; // line wrapping mode
    highlight::OutputType outputType;
    StringTools::KeywordCase keywordCase;

    // name of single output file
    std::string outFilename,
           // output directory
           outDirectory,
           // programming syntax which will be loaded
           syntax,
           // name of colour theme
           styleName,
           // name of external style file
           styleOutFilename,
           // name of file to be included in external style file
           styleInFilename,
           // used to define data directories at runtime
           dataDir;

    // name of indenation scheme
    std::string indentScheme,
           pageSize,
           startNestedLang;

    std::string baseFont, baseFontSize;
    std::string docTitle, className;
    std::string skipArg;
    std::string svg_height, svg_width;
    std::string absThemePath, absLangPath/*, twoPassFile*/;

    bool opt_syntax;
    bool opt_include_style;
    bool opt_help;
    bool opt_version ;
    bool opt_print_config;
    bool opt_linenumbers;
    bool opt_batch_mode;
    bool opt_fragment;
    bool opt_attach_line_anchors;
    bool opt_printindex;
    bool opt_quiet;
    bool opt_replacequotes;
    bool opt_babel;
    bool opt_beamer;
    bool opt_print_progress;
    bool opt_fill_zeroes;
    bool opt_stylepath_explicit;
    bool opt_force_output;
    bool opt_ordered_list;
    bool opt_fnames_as_anchors;
    bool opt_validate;
    bool opt_number_wrapped_lines;
    bool opt_inline_css;
    bool opt_enclose_pre;
    bool opt_char_styles;
    bool opt_page_color;
    bool opt_pretty_symbols;
    bool opt_delim_CR;
    bool opt_print_style;
    bool opt_base16_theme;
    bool opt_keep_injections;
    bool opt_force_stdout;
    bool opt_no_version_info;
    bool explicit_output_format;
    bool opt_isolate;
    bool opt_encoding_explicit;
    bool opt_syntax_supported_check;

    bool opt_ls_hover;
    bool opt_ls_semantic;
    bool opt_ls_rainbow;
    bool opt_ls_syntax_error;

    off_t maxFileSize;

    std::string fallbackSyntax, anchorPrefix;
    std::string helpLang, encodingName;

    std::string pluginPath, pluginParameter,
           listScriptCategory, helpTopic, redirectedFilename, listScriptType;

    std::string lsProfile, lsExecutable, lsWorkspace, lsSyntax;

    /** list of all input file names */
    std::vector <std::string> inputFileNames;

    /** list of plugin file names */
    std::vector <std::string> userPlugins;

    /** list of additional Artistic Style options */
    std::vector <std::string> astyleOptions;

    /** list of Language Server options */
    std::vector <std::string> lsOptions;

    /** list of file types which should be ignored */
    set <std::string> ignoredFileTypes;

    /** \return file suffix */
    std::string getFileSuffix ( const std::string & fileName ) const;

    /** \return directory name of path */
    std::string getDirName ( const std::string & path );

    /** get all entries in the directory defined by wildcard */
    void readDirectory ( const std::string & wildcard );

    /** \return Valid path name */
    std::string validateDirPath ( const std::string & path );

    void parseRuntimeOptions( const int argc, const char *argv[], bool readInputFilenames=true);

    void showDeprecationHint ( const std::string & option, const std::string & alt ) const;
};

#endif
