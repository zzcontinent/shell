/***************************************************************************
                          lspclient.h  -  description
                             -------------------
    begin                : Wed Jan 20 2021
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


#ifndef LSPCLIENT_H
#define LSPCLIENT_H

#ifdef WIN32
#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#else
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

#if __linux__
#include <sys/prctl.h>
#endif

#endif

#include <vector>
#include <map>
#include <string>

#include "semantictoken.h"

#include "picojson/picojson.h"

namespace highlight
{

class LSPClient
{

private:

    bool initialized;
    bool hoverProvider;
    bool semanticTokensProvider;
    bool logRequests;

    std::string executable, workspace;
    std::string serverName, serverVersion;
    std::string triggerSyntax;

    std::vector<std::string> options;

    std::map<int, std::string> tokenTypes;
    std::map<int, std::string> tokenModifiers;

    std::map< std::tuple<int, int>, highlight::SemanticToken > tokenMap;

    std::map< std::tuple<int, int>, highlight::SemanticToken > errorMap;


    int initDelay;

#ifdef WIN32
    HANDLE g_hChildStd_IN_Rd ;
    HANDLE g_hChildStd_IN_Wr ;
    HANDLE g_hChildStd_OUT_Rd ;
    HANDLE g_hChildStd_OUT_Wr ;

#else
    pid_t pid;
    int inpipefd[2];
    int outpipefd[2];
#endif

    float msgId;

    int lastErrorCode;
    std::string lastErrorMessage;

    bool pipe_write_jsonrpc(const std::string &message);

    std::string pipe_read_jsonrpc();

    void runSimpleAction(const std::string action, int delay = 0);

    bool checkErrorResponse(const picojson::value &json, const std::string& picoError);

    void readNotification(const picojson::value &json);

    void static signal_callback_handler(int signum);

public:
    /** Constructor */
    LSPClient();
    ~LSPClient();

    void setExecutable ( const std::string& exec );

    void setOptions (const std::vector<std::string>& o);

    void setWorkspace ( const std::string& ws );

    void setSyntax ( const std::string& syntax );

    bool connect();

    bool runInitialize();

    void runInitialized();

    bool runDidOpen(const std::string &document, const std::string &syntax);

    bool runDidClose(const std::string &document, const std::string &syntax);

    std::string runHover(const std::string &document, int character, int line);

    bool runSemanticTokensFull(const std::string &document);

    void runShutdown();

    void runExit();

    bool isInitialized() const;

    bool isHoverProvider() const;

    bool isSemanticTokensProvider() const;

    void setLogging(bool flag);

    void setInitializeDelay(int ms);

    std::string getServerName() const;

    std::string getServerVersion() const;

    std::string getErrorMessage() const;

    bool tokenExists(unsigned int line, unsigned int col);

    bool errorExists(unsigned int line, unsigned int col);

    int getSemanticTokenCount() const;

    highlight::SemanticToken getToken(unsigned int line, unsigned int col);

    highlight::SemanticToken getError(unsigned int line, unsigned int col);

    int getErrorCode() const;
};

}

#endif
