/***************************************************************************
                          datadir.h  -  description
                             -------------------
    begin                : Sam March 1 2003
    copyright            : (C) 2003-2021 by Andre Simon
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


#ifndef DATADIR_H
#define DATADIR_H

#include <map>
#include <boost/xpressive/xpressive_dynamic.hpp>
#include <Diluculum/LuaState.hpp>

#include "stringtools.h"
#include "lspprofile.h"


typedef std::map<std::string, std::string> StringMap;


/** \brief Manages access to installation directories.

    Apart from the standard installation directory, one can define additional
    search paths. If the additional paths do not exist, the default paths are
    returned.
 **/

class DataDir
{
    std::vector <std::string> possibleDirs;

private:

    const std::string searchFile(const std::string path);

    std::string getFileBaseName(const std::string& fileName);

    std::string analyzeFile ( const std::string& file );

    void readLuaList(const std::string& paramName, const std::string& langName,Diluculum::LuaValue &luaVal, StringMap* extMap);

    // object needs to life until cin is no longer used
    std::stringstream cin_bufcopy;

    std::map<std::string, highlight::LSPProfile> lspProfiles;

public:

    StringMap assocByExtension, assocByFilename, assocByShebang, encodingHint;

    static std::string LSB_DATA_DIR;
    static std::string LSB_CFG_DIR;
    static std::string LSB_DOC_DIR;

    /** search for a valid installation directory
        \param  userDefinedDir Directory defined by user
        \return True if directory was found */
    void initSearchDirectories ( const std::string &userDefinedDir );

    const void printConfigPaths();

    /**  \param file file
         \return Location of given syntax definition */
    const std::string getLangPath ( const std::string & file) ;

    /** \return System themes location */
    const std::string getThemePath () ;

    /** \return System syntax location */
    const std::string getLangPath () ;

    /** \return System syntax location */
    const std::string getSystemDataPath () ;

    /** \return Location of plugins */
    const std::string getPluginPath ();

    /** \param file file
     *  \param base16 set to true if the theme is located in the base16 sub dir
        \return Location of given theme */
    const std::string getThemePath ( const std::string & file, bool base16=false ) ;

    /** \param file file
        \return Location of given configuration file */
    const std::string getFiletypesConfPath (const std::string &path="filetypes.conf");

    /** \param file file
        \return Location of given plugin file */
    const std::string getPluginPath (const std::string &);

    /** \return Location of GUI menu translation files */
    const std::string getI18nDir();

    /** \return Location of GUI file extension filter files */
    const std::string getExtDir();

    /** \return Location of documentation (README) files (GUI) */
    const std::string getDocDir();

    /** \param syntax name
        \return Encoding hint assigned to the syntax */
    const std::string getEncodingHint (const std::string &);

    /**
     * \param fileName input file name
     * \return file extension or the base filename if no file extension exists
    */
    std::string getFileSuffix ( const std::string &fileName );

    /**
     * \param suffix file name suffix
     * \param inputFile name of the input file
     * \param useUserSuffix true if user has defined a syntax suffix
     * \param forceShebangCheckStdin true if stdin should be peeked to look for shebang patterns
     * \return file type deferred from extension or file shebang comment
    */
    std::string guessFileType ( const std::string &suffix, const std::string &inputFile,
                           bool useUserSuffix=false, bool forceShebangCheckStdin=false );

    /**
     * \param name name of filetypes.conf
     * \return true if successful
    */
    bool loadFileTypeConfig ( const std::string& name);

    /**
     * \param name name of lsp.conf
     * \return true if successful
     */
    bool loadLSPConfig ( const std::string& name);

    bool profileExists(const string &profile);

    highlight::LSPProfile &getProfile(const string &profile);
};

#endif
