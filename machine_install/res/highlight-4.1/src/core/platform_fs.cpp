
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


#include "platform_fs.h"

// includes for recursive getFileNames() function
#ifdef _WIN32
#include <windows.h>
#include <sys/stat.h>
#else
#include <dirent.h>
#include <errno.h>
#include <sys/stat.h>
#ifdef __VMS
#include <unixlib.h>
#include <rms.h>
#include <ssdef.h>
#include <stsdef.h>
#include <lib$routines.h>
#include <starlet.h>
#endif /* __VMS */
#endif

#include <algorithm>
#include <iostream>
#include <errno.h>

using std::string;
using std::vector;

namespace Platform
{

#ifdef WIN32
#include <windows.h>
const char pathSeparator = '\\';

#ifndef QT
std::string getAppPath()
{
    char pathAndName[MAX_PATH], path[MAX_PATH], drive[3];
    GetModuleFileName(NULL, pathAndName, MAX_PATH);
    _splitpath(pathAndName, drive, path, 0, 0);
    return std::string(drive)+path;
}
#endif

std::string getHomePath()
{
    return "";
}

int isColorEscCapable() {
    return 0;
}

int isDarkTerminal() {
    return 1;
}


std::string getTempFilePath(){

    char tmpPath[MAX_PATH], tmpFile[MAX_PATH];
    if (!GetTempPath(MAX_PATH, tmpPath))
        return "";

    if (!GetTempFileName(tmpPath, "hlt", 0, tmpFile))
        return "";

    return std::string(tmpFile);
}

#else
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <string.h>

const char pathSeparator = '/';

std::string getAppPath()
{
    return "";
}

std::string getHomePath()
{
    struct passwd *pw = getpwuid(getuid());
    return pw != NULL ? string(pw->pw_dir) : "";
}

int isColorEscCapable() {

    if (!isatty(fileno(stdout)) || !isatty(fileno(stdin))){
        return 0;
    }

    char* colorOption=getenv("COLORTERM");

    if (colorOption!=NULL) {
        if (!strncmp(colorOption, "truecolor", 9)){
            return 2;
        }
    }
    colorOption=getenv("TERM");
    if (colorOption!=NULL) {
        if (!strncmp(colorOption, "xterm-256color", 14)){
            return 1;
        }
    }

    return 0;
}

int isDarkTerminal() {

    char* colorOption=getenv("COLORFGBG");
    if (colorOption!=NULL) {
        if (!strncmp(colorOption, "0;15", 4)){
            return 0;
        }
    }
    return 1;
}

std::string getTempFilePath(){
    std::string path("/tmp");

    char* tempOption=getenv("TEMP");
    if (tempOption) path=string(tempOption);
    char tmpPath[100];
    snprintf(tmpPath, sizeof tmpPath-1, "/highlight%d.lua", getpid());
    path += tmpPath;
    return path;
}

#endif

bool getDirectoryEntries ( vector<string> &fileList,
                           string wildcard,
                           bool recursiveSearch )
{
    if ( !wildcard.empty() ) {
        string directory_path;
        string::size_type Pos = wildcard.find_last_of ( pathSeparator );
        if ( Pos == string::npos ) {
            directory_path = ".";
        } else {
            directory_path = wildcard.substr ( 0, Pos );
            wildcard = wildcard.substr ( Pos + 1 );
        }

        getFileNames ( directory_path, wildcard, fileList );
    }
    return ! ( fileList.empty() );
}


#ifdef _WIN32  // Windows specific

/**
 * WINDOWS function to resolve wildcards and recurse into sub directories.
 * The fileName vector is filled with the path and names of files to process.
 *
 * @param directory		The path of the directory to be processed.
 * @param wildcard		The wildcard to be processed (e.g. *.cpp).
 * @param filenam		An empty vector which will be filled with the path and names of files to process.
 */
void getFileNames ( const string &directory,const string &wildcard, vector<string> &fileName )
{
    vector<string> subDirectory;    // sub directories of directory
    WIN32_FIND_DATA FindFileData;   // for FindFirstFile and FindNextFile

    // Find the first file in the directory
    string firstFile = directory + "\\*";
    HANDLE hFind = FindFirstFile ( firstFile.c_str(), &FindFileData );

    if ( hFind == INVALID_HANDLE_VALUE )
        return;

    // save files and sub directories
    do {
        // skip hidden or read only
        if ( FindFileData.cFileName[0] == '.'
                || ( FindFileData.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN )
                || ( FindFileData.dwFileAttributes & FILE_ATTRIBUTE_READONLY ) )
            continue;

        // if a sub directory and recursive, save sub directory
        if ( ( FindFileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY ) && true ) {
            string subDirectoryPath = directory + pathSeparator + FindFileData.cFileName;
            subDirectory.push_back ( subDirectoryPath );
            continue;
        }

        // save the file name
        string filePathName = directory + pathSeparator + FindFileData.cFileName;

        // save file name if wildcard match
        if ( wildcmp ( wildcard.c_str(), FindFileData.cFileName ) ) {
            fileName.push_back ( filePathName );
        }
    } while ( FindNextFile ( hFind, &FindFileData ) != 0 );

    // check for processing error
    FindClose ( hFind );
    DWORD dwError = GetLastError();
    if ( dwError != ERROR_NO_MORE_FILES )
        return;

    // recurse into sub directories
    // if not doing recursive subDirectory is empty
    for ( unsigned i = 0; i < subDirectory.size(); i++ ) {
        getFileNames ( subDirectory[i], wildcard, fileName );
        continue;
    }

    return;
}

#else  // not _WIN32

/**
* LINUX function to resolve wildcards and recurse into sub directories.
* The fileName vector is filled with the path and names of files to process.
*
* @param directory		The path of the directory to be processed.
* @param wildcard		The wildcard to be processed (e.g. *.cpp).
* @param filenam		An empty vector which will be filled with the path and names of files to process.
*/
void getFileNames ( const string &directory,const string &wildcard, vector<string> &fileName )
{
    struct dirent *entry;           // entry from readdir()
    struct stat statbuf;            // entry from stat()
    vector<string> subDirectory;    // sub directories of this directory

    // errno is defined in <errno.h> and is set for errors in opendir, readdir, or stat
    errno = 0;

    DIR *dp = opendir ( directory.c_str() );
    if ( errno ) return;

    // save files and sub directories
    while ( ( entry = readdir ( dp ) ) != NULL ) {
        // get file status
        string entryFilepath = directory + pathSeparator + entry->d_name;

        if ( -1 == stat ( entryFilepath.c_str(), &statbuf ) || errno) {
            closedir ( dp );
            return;
        }

        // skip hidden
        if ( entry->d_name[0] == '.' )
            continue;

        // if a sub directory and recursive, save sub directory
        if ( S_ISDIR ( statbuf.st_mode ) && /*g_isRecursive*/ true ) { ///TODO
            subDirectory.push_back ( entryFilepath );
            continue;
        }

        // if a file, save file name
        if ( S_ISREG ( statbuf.st_mode ) ) {
            // save file name if wildcard match
            if ( wildcmp ( wildcard.c_str(), entry->d_name ) ) {
                fileName.push_back ( entryFilepath );
            }
        }
    }
    closedir ( dp );

    if ( errno ) return;

    // recurse into sub directories
    // if not doing recursive, subDirectory is empty
    if ( subDirectory.size() > 1 )
        sort ( subDirectory.begin(), subDirectory.end() );
    for ( unsigned i = 0; i < subDirectory.size(); i++ ) {
        getFileNames ( subDirectory[i], wildcard, fileName );
        continue;
    }

    return;
}

#endif

// From The Code Project http://www.codeproject.com/string/wildcmp.asp
// Written by Jack Handy - jakkhandy@hotmail.com
// Modified to compare case insensitive for Windows (the LC macro)

int wildcmp ( const char *wild, const char *data )
{
    const char *cp = NULL, *mp = NULL;
    bool cmpval;

    while ( ( *data ) && ( *wild != '*' ) ) {
#ifdef _WIN32
        cmpval = ( tolower ( *wild ) != tolower ( *data ) ) && ( *wild != '?' );
#else
        cmpval = ( *wild != *data ) && ( *wild != '?' );
#endif

        if ( cmpval ) {
            return 0;
        }
        wild++;
        data++;
    }

    while ( *data ) {
        if ( *wild == '*' ) {
            if ( !*++wild ) {
                return 1;
            }
            mp = wild;
            cp = data+1;
        } else {
#ifdef _WIN32
            cmpval = ( tolower ( *wild ) == tolower ( *data ) || ( *wild == '?' ) );
#else
            cmpval = ( *wild == *data ) || ( *wild == '?' );
#endif

            if ( cmpval ) {
                wild++;
                data++;
            } else {
                wild = mp;
                data = cp++;
            }
        }
    }

    while ( *wild == '*' ) {
        wild++;
    }
    return !*wild;
}


bool fileExists(const string &fName)
{
    struct stat fileInfo;
    return !stat(fName.c_str(),&fileInfo);
}

//-D_FILE_OFFSET_BITS=64
//268435456 256 MB

off_t fileSize(const string& fName) {
    struct stat fileInfo;
    if(stat(fName.c_str(), &fileInfo) != 0) {
        return 0;
    }
    return fileInfo.st_size;
}

}
