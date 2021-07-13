/***************************************************************************
                          syntaxreader.h  -  description
                             -------------------
    begin                : Wed Nov 28 2001
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


#ifndef SYNTAXREADER_H
#define SYNTAXREADER_H

#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <fstream>
#include <iterator>
#include <sstream>

#include <Diluculum/LuaState.hpp>
#include <Diluculum/LuaVariable.hpp>
#include <Diluculum/LuaFunction.hpp>

#include "regexelement.h"
#include "platform_fs.h"
#include "enums.h"

#define GLOBAL_SR_INSTANCE_NAME "HL_SRInstance"

using namespace std;


namespace highlight
{
class RegexElement;

/** maps keywords and the corresponding class IDs*/
typedef map <string, int> KeywordMap;

/** maps embedded language names to exit delimiter regexes*/
typedef map <string, string> DelimiterMap;

typedef map <string, bool> AllowInnerSectionsMap;


/**\brief Contains specific data of the programming language being processed.

* @author Andre  Simon
*/
class SyntaxReader
{

public:

    SyntaxReader();

    ~SyntaxReader();


    /** Load new language definition
        Will only read a new language definition if the given
          file path is not equal to the path of the current language definition.
        \param langDefPath Path of language definition
        \param pluginReadFilePath path to file which is read by plugin
        \param outputType output format
        \return LoadResult  */
    LoadResult load( const string& langDefPath, const string& pluginReadFilePath,  OutputType outputType );

    /** \return True if the next load() call would load a new language definition
        \param  langDefPath Path to language definition  */
    bool needsReload ( const string &langDefPath ) const
    {
        return currentPath!=langDefPath;
    }

    /** \return Failed regular expression */
    string getFailedRegex() const
    {
        return regexErrorMsg;
    }

    /** \return Failed Lua exception description */
    string getLuaErrorText() const
    {
        return luaErrorMsg;
    }

    /** \return Prefix of raw strings */
    unsigned char getRawStringPrefix() const
    {
        return rawStringPrefix;
    }

    /** \return Continuation Character */
    unsigned char getContinuationChar() const
    {
        return continuationChar;
    }

    /** \return true if syntax highlighting is enabled*/
    bool highlightingEnabled() const
    {
        return !disableHighlighting;
    }

    /** \return True if language is case sensitive */
    bool isIgnoreCase() const
    {
        return ignoreCase;
    }

    /** \param s String
         \return true if s is not a known keyword */
    bool isKeyword ( const string &s ) ;

    /** \param s String
         \return keyword list group id */
    int getKeywordListGroup ( const string &s );

    /** \return True if multi line comments may be nested */
    bool allowNestedMLComments() const
    {
        return allowNestedComments;
    }

    /** \return True if highlighting is disabled
                            TODO remove method */
    bool highlightingDisabled() const
    {
        return disableHighlighting;
    }

    /** \return True if current language may be reformatted (c, c++, c#, java) */
    bool enableReformatting() const
    {
        return reformatCode;
    }

    bool assertDelimEqualLength() const
    {
      return assertEqualLength;
    }

    /** \return keywords*/
    const KeywordMap& getKeywords() const
    {
        return keywords;
    }

    /** \return keyword classes*/
    const vector<string>& getKeywordClasses() const
    {
        return keywordClasses;
    }

    /** \return regular expressions */
    const vector<RegexElement*>& getRegexElements() const
    {
        return regex;
    }

    /** \return list of Lua code snippets to be stored on disk */
    const vector<string>& getPersistentSnippets() const
    {
        return persistentSnippets;
    }

    /** \return number of Lua code snippets to be stored on disk */
    int getPersistentSnippetsNum() const
    {
        return persistentSnippets.size();
    }

    /** \return list of format override flags defined in syntax definitions */
    vector<int>& getOverrideStyleAttributes()
    {
        return overrideStyles;
    }

    /** \return description of the programming language */
    const string & getDescription () const
    {
        return langDesc;
    }

    const string & getCategoryDescription() const
    {
        return categories;
    }


    /** \return header string defined by a plug-in */
    const string & getHeaderInjection () const
    {
        return headerInjection;
    }

    /** \return footer string defined by a plug-in */
    const string & getFooterInjection () const
    {
        return footerInjection;
    }

    /**  \param delimID delimiter id
         \return true,  if no closing delimiter exists (open and close delimiters are equal)
     */
    bool delimiterIsDistinct ( int delimID )
    {
        return delimiterDistinct[delimID];
    }

    /**  \param delimID delimiter id
         \return true,  if delimiter indicates a raw string
     */
    bool delimiterIsRawString ( int delimID )
    {
        return rawStringOpenDelims[delimID];
    }

    /**  Pairs of open/close delimiters have a unique ID to test if two tokens act as delimiters
         \param token delimiter token
                     \param s State of delimiter
         \return delimiter ID
     */
    int getOpenDelimiterID ( const string& token, State s);

    /**  Pairs of open/close delimiters have a unique ID to test if two tokens act as delimiters
         \param token delimiter token
                     \param s State of delimiter
                     \param openDelimId opening delimiter retrieved with getOpenDelimiterID
         \return true if delimiter id of token matches openDelimID
     */
    bool matchesOpenDelimiter ( const string& token, State s, int openDelimId);

    /** initializes end delimiter regex to switch back to host language
    	\param langPath path of embedded language definition
    */
    void restoreLangEndDelim(const string&langPath);

    bool allowsInnerSection(const string& langPath);

    bool requiresTwoPassRun();

    bool requiresParamUpdate();


    string getPersistentHookConditions();

    void clearPersistentSnippets();

    /**
    	\param lang language definition name  (no path, no ".lang" extension)
    	\return absolute path based on the previously loaded definition
    */
    string getNewPath(const string& lang);

    /**
    	\return absolute path of currently loaded definition
    */
    string getCurrentPath() const
    {
        return currentPath;
    }

    /**
    	\return encoding which is normally used for input files of this syntax
    */
    string getEncodingHint() const
    {
        return encodingHint;
    }

     /**
    	\return test function
    */
    string getOverrideConfigVal(const string& name) const
    {
        return pluginConfigOverride.count(name) ? pluginConfigOverride[name] : "";
    }

    /**
    	\return pointer to state validation function
    */
    Diluculum::LuaFunction* getValidateStateChangeFct() const
    {
        return validateStateChangeFct;
    }
    /**
    	\return pointer to state decorate function
    */
    Diluculum::LuaFunction* getDecorateFct() const
    {
        return decorateFct;
    }

    /**
    	\return pointer to line begin decorate function
    */
    Diluculum::LuaFunction* getDecorateLineBeginFct() const
    {
        return decorateLineBeginFct;
    }

    /**
    	\return pointer to line end decorate function
    */
    Diluculum::LuaFunction* getDecorateLineEndFct() const
    {
        return decorateLineEndFct;
    }

    /**
    	\return pointer to Lua state
    */
    Diluculum::LuaState* getLuaState() const
    {
        return luaState;
    }

    /**
    	\param chunk Lua function to be added to the function list
    */
    void addUserChunk(const Diluculum::LuaFunction& chunk)
    {
        pluginChunks.push_back(new Diluculum::LuaFunction(chunk));
    }

    /**
    	\param fn name of the processed input file
    */
    void setInputFileName(const string& fn) { currentInputFile=fn; }

    /**
    	\return name of the processed input file
    */

    string getInputFileName() const { return currentInputFile; }

    /**
    	\param groupID keyword group to be stored on disk
    	\param kw keyword token to be stored on disk
    */

    void addPersistentKeyword(unsigned int groupID, const string& kw);

    /**
    	\param groupID keyword group to be stored on disk
    	\param column start of range within line
    	\param length length of range
    	\param lineNumber line number
    	\param fileName file name of processed file containing the line
    	*/
    void addPersistentStateRange(unsigned int groupID, unsigned int column,unsigned int length, unsigned int lineNumber, const string& fileName);

    /**
        \param ls Lua state to be initialized with constants
        \param langDefPath absolute path of language definition
        \param pluginReadFilePath absolute path of plugin input file
    */
    static void initLuaState(Diluculum::LuaState& ls, const string& langDefPath, const string& pluginReadFilePath, OutputType outputType=HTML );

    // generate a keyword class
    unsigned int generateNewKWClass ( int classID, const char *prefix="kw" );

    int getKeywordCount() const;

private:

    static const string REGEX_IDENTIFIER;
    static const string REGEX_NUMBER;
    static const string REGEX_ESCSEQ;

    // path to loaded language definition
    string currentPath;

    // name of file being processed
    string currentInputFile;

    // Language description
    string langDesc, categories, encodingHint;

    string headerInjection, footerInjection;

    string regexErrorMsg, luaErrorMsg;

    KeywordMap keywords;

    vector <string> keywordClasses;
    static vector <string> persistentSnippets;
    static set <string> persistentSyntaxDescriptions;

    vector <RegexElement*> regex;

    vector <int>overrideStyles;

    // collect delimiters or get current delimiter in CodeGenerator::loadEmbeddedLang
    static DelimiterMap nestedStateEndDelimiters;

    static DelimiterMap pluginConfigOverride;

    static AllowInnerSectionsMap allowInnerSections;

    // saves if delimiter pair consists of the same delimiter symbol
    map <int, bool> delimiterDistinct;

    map <int, bool> rawStringOpenDelims;

    map <int, int> matchingDelimiters;

    // keywords are not case sensitive if set
    bool ignoreCase,

         // highlighting is disabled
         disableHighlighting,

         // allow nested multi line comment blocks
         allowNestedComments,

         // code formatting is enabled if set
         reformatCode,

         // string open and close delimiters must have the same length
         assertEqualLength,

         paramsNeedUpdate;

    // character which is prefix of raw string (c#)
    unsigned char rawStringPrefix;

    //character which continues current style on next line
    unsigned char continuationChar;

    int keywordCount;

    bool readFlag(const Diluculum::LuaVariable& var) ;

    // interface for plug-ins: add keywords dynamically
    static int luaAddKeyword (lua_State *L);

    // interface for plug-ins: remove keywords dynamically
    static int luaRemoveKeyword (lua_State *L);

    static int luaAddPersistentState (lua_State *L);

    static int luaOverrideParam (lua_State *L);



    void addKeyword(unsigned int groupID, const string& kw);

    void removeKeyword(const string& kw);

    void overrideParam(const string& name, const string& val);


    // Functions accessible in Lua State
    Diluculum::LuaFunction* validateStateChangeFct;
    Diluculum::LuaFunction* decorateFct, *decorateLineBeginFct, *decorateLineEndFct;

    Diluculum::LuaState* luaState; // make member to allow interaction with codeparser instance

    static vector<Diluculum::LuaFunction*> pluginChunks;
};

}
#endif
