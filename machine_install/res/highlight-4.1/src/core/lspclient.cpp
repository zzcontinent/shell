/***************************************************************************
 *                          lspclient.cpp  -  description
 *                             -------------------
 *    begin                : Wed Jan 20 2021
 *    copyright            : (C) 2002-2021 by Andre Simon
 *    email                : a.simon@mailbox.org
 ***************************************************************************/


/*
 * This file is part of Highlight.
 *
 * Highlight is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Highlight is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Highlight.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "lspclient.h"
#include "stringtools.h"

#include <sstream>
#include <iostream>
#include <fstream>

#include <chrono>
#include <thread>

namespace highlight
{

    LSPClient::LSPClient():
    initialized(false),
    hoverProvider(false),
    semanticTokensProvider(false),
    logRequests(false),
    initDelay(0),
    msgId(1.0),
    lastErrorCode(0)
    {
        serverName=serverVersion="?";

        #ifdef WIN32
        g_hChildStd_IN_Rd = NULL;
        g_hChildStd_IN_Wr = NULL;
        g_hChildStd_OUT_Rd = NULL;
        g_hChildStd_OUT_Wr = NULL;
        #else
        pid=0;
        #endif
    }

    LSPClient::~LSPClient()
    {
        #ifdef WIN32
        if (initialized) {
            CloseHandle(g_hChildStd_OUT_Wr);
            CloseHandle(g_hChildStd_IN_Rd);
            CloseHandle(g_hChildStd_IN_Wr);
            CloseHandle(g_hChildStd_OUT_Rd);
        }
        #else
        if (initialized) {
            int status=0;
            kill(pid, SIGKILL); //send SIGKILL signal to the child process
            waitpid(pid, &status, 0);
        }
        #endif
    }

    void LSPClient::setExecutable ( const std::string& exec ) {
        executable = exec;
    }

    void LSPClient::setOptions (const std::vector<std::string>& o){
        options = o;
    }

    void LSPClient::setWorkspace ( const std::string& ws ){
        workspace = ws;
    }

    void LSPClient::setSyntax ( const std::string& syntax ){
        triggerSyntax = syntax;
    }

    void LSPClient::signal_callback_handler(int signum){
    }

    bool LSPClient::connect() {

        initialized=true;

        #ifdef WIN32

        // https://docs.microsoft.com/de-de/windows/win32/procthread/creating-a-child-process-with-redirected-input-and-output

        SECURITY_ATTRIBUTES saAttr;

        // Set the bInheritHandle flag so pipe handles are inherited.
        saAttr.nLength = sizeof(SECURITY_ATTRIBUTES);
        saAttr.bInheritHandle = TRUE;
        saAttr.lpSecurityDescriptor = NULL;

        // Create a pipe for the child process's STDOUT
        if (!CreatePipe(&g_hChildStd_OUT_Rd, &g_hChildStd_OUT_Wr, &saAttr, 0))
            return false;

        // Ensure the read handle to the pipe for STDOUT is not inherited
        if (!SetHandleInformation(g_hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0))
            return false;

        // Create a pipe for the child process's STDIN.
        if (!CreatePipe(&g_hChildStd_IN_Rd, &g_hChildStd_IN_Wr, &saAttr, 0))
            return false;

        // Ensure the write handle to the pipe for STDIN is not inherited.
        if (!SetHandleInformation(g_hChildStd_IN_Wr, HANDLE_FLAG_INHERIT, 0))
            return false;

        PROCESS_INFORMATION piProcInfo;
        STARTUPINFO siStartInfo;

        // Set up members of the PROCESS_INFORMATION structure.

        ZeroMemory( &piProcInfo, sizeof(PROCESS_INFORMATION) );

        // Set up members of the STARTUPINFO structure.
        // This structure specifies the STDIN and STDOUT handles for redirection.

        ZeroMemory( &siStartInfo, sizeof(STARTUPINFO) );
        siStartInfo.cb = sizeof(STARTUPINFO);
        siStartInfo.hStdError = g_hChildStd_OUT_Wr;
        siStartInfo.hStdOutput = g_hChildStd_OUT_Wr;
        siStartInfo.hStdInput = g_hChildStd_IN_Rd;
        siStartInfo.dwFlags |= STARTF_USESTDHANDLES;

        // Create the child process.

        std::string cmdLine(executable);
        for (auto& option : options) {
            cmdLine.append(" ");
            cmdLine.append(option);
        }

        if (logRequests) {
            std::cerr << "\nLSP CMD "<<cmdLine<<"\n";
        }

        BOOL bSuccess = CreateProcess(NULL,
                                      const_cast<LPSTR>(cmdLine.c_str()),
                                      NULL,          // process security attributes
                                      NULL,          // primary thread security attributes
                                      TRUE,          // handles are inherited
                                      CREATE_NO_WINDOW, // creation flags
                                      NULL,          // use parent's environment
                                      NULL,          // use parent's current directory
                                      &siStartInfo,  // STARTUPINFO pointer
                                      &piProcInfo);  // receives PROCESS_INFORMATION

        // If an error occurs, exit the application.
        if ( ! bSuccess ) {
            std::cerr <<"highlight: CreateProcess failed\n";
            return false;
        } else {

            // Close handles to the child process and its primary thread.
            // Some applications might keep these handles to monitor the status
            // of the child process, for example.

            CloseHandle(piProcInfo.hProcess);
            CloseHandle(piProcInfo.hThread);
        }

        #else

        pipe(inpipefd);
        pipe(outpipefd);

        pid = fork();

        if (pid == 0)
        {

            // Child
            dup2(outpipefd[0], STDIN_FILENO);
            dup2(inpipefd[1], STDOUT_FILENO);
            dup2(inpipefd[1], STDERR_FILENO);

            #if __linux__
            //ask kernel to deliver SIGTERM in case the parent dies
            prctl(PR_SET_PDEATHSIG, SIGTERM);
            #endif

            //https://stackoverflow.com/questions/5797837/how-to-pass-a-vector-of-strings-to-execv
            std::vector<char*> cmdArgs;

            cmdArgs.push_back(const_cast<char*>(executable.c_str()));

            for (auto& option : options) {
                cmdArgs.push_back(const_cast<char*>(option.c_str()));
            }

            cmdArgs.push_back(NULL);

            // pass the vector's internal array to execvp
            char **command = cmdArgs.data();

            execvp(executable.c_str(), command);

            // Nothing below this line should be executed by child process. If so,
            // it means that the execl function wasn't successful, so lets exit:

            exit(1);
        }
        // The code below will be executed only by parent. You can write and read
        // from the child using pipefd descriptors, and you can send signals to
        // the process using its pid by kill() function. If the child process will
        // exit unexpectedly, the parent process will obtain SIGCHLD signal that
        // can be handled (e.g. you can respawn the child process).

        //close unused pipe ends
        close(outpipefd[0]);
        close(inpipefd[1]);

        signal(SIGPIPE, LSPClient::signal_callback_handler);
        #endif
        return true;
    }

    bool LSPClient::pipe_write_jsonrpc(const std::string &payload){
        std::ostringstream os;

        os << "Content-Length: " << payload.size() << "\r\n\r\n" <<payload;

        std::string msg (os.str());

        if (logRequests) {
            std::cerr << "LSP REQ:\n" << msg << "\n";
        }

        #ifdef WIN32

        DWORD dwWritten;

        BOOL bSuccess = WriteFile(g_hChildStd_IN_Wr, msg.c_str(), msg.length(), &dwWritten, NULL);

        if ( !bSuccess || (long unsigned int)dwWritten!=msg.size()) {
            return false;
        }

        #else

        ssize_t w = write(outpipefd[1], msg.c_str(), msg.size());

        if ((long unsigned int)w!=msg.size()) {
            return false;
        }
        #endif
        return true;
    }

    std::string LSPClient::pipe_read_jsonrpc(){

        std::string resultString;

        resultString.resize(128);
        bool readOK = false;

        #ifdef WIN32

        DWORD headerReadLen = 0;
        readOK = ReadFile(g_hChildStd_OUT_Rd, (void*)resultString.data(), 128, &headerReadLen, NULL);

        #else

        ssize_t headerReadLen=read(inpipefd[0], (char*)resultString.data(), 128);
        readOK = headerReadLen>0;

        #endif

        if (!readOK) {
            return "";
        }

        if (resultString.find("Content-Length:")==0) {

            // we need to read the length of the message first
            std::string payloadLenString = resultString.substr(16, resultString.find("\r\n")-16);
            unsigned int payloadLen = atoi(payloadLenString.c_str());

            // Skip all the headers since they end with two new lines
            size_t start = resultString.find("\r\n\r\n");

            if (start == string::npos) {
                return "";
            }

            start += 4;

            // delete header part
            resultString.erase(0, start);

            // https://github.com/dail8859/NppLSP/blob/master/src/LspClient.cpp
            // it is mandatory to tell ReadFile to read exactly the length of the
            // payload - otherwise no repeated WRITE/READ is possible

            // Probably need to grab more
#ifdef WIN32
            DWORD remainderReadLen = 0;
#else
            size_t remainderReadLen=0;
#endif
            size_t remainderLen=payloadLen - (headerReadLen - start);
            if (resultString.length() < (size_t)payloadLen ) {

                resultString.resize(payloadLen);

                #ifdef WIN32
                ReadFile(g_hChildStd_OUT_Rd, (void*)&resultString[headerReadLen - start],
                         payloadLen - (headerReadLen - start), &remainderReadLen, NULL);
                #else
                remainderReadLen = read(inpipefd[0], &resultString[headerReadLen - start], remainderLen);
                #endif
            }

            if (remainderReadLen != remainderLen) {
                return "";
            }

            if (logRequests) {
                std::cerr << "LSP RES:\nContent-Length:" << payloadLen
                << "\n\n" << resultString << "\n";
            }
            return resultString;
        }

        return "";
    }


    bool LSPClient::runInitialize(){

        picojson::object request;
        picojson::object params;
        picojson::object capabilities;
        picojson::value serverCapabilities;

        picojson::object textDocument, documentSymbol, semanticTokensClientCapabilities, requests;
        picojson::value nullValue;

        request["jsonrpc"] = picojson::value("2.0");
        request["id"] = picojson::value(msgId++);
        request["method"] = picojson::value("initialize");

        params["processId"] =  picojson::value((float)getpid());

        // TODO workspaceFolders
        if (workspace.empty()){
            params["rootUri"] =  picojson::value(nullValue);
        } else {
            params["rootUri"] =  picojson::value("file://" + workspace);
        }

        requests["range"] = picojson::value(false);
        requests["full"] = picojson::value(true);

        vector<std::string> supportedTokenTypes {"keyword","number","regexp","operator","namespace","type","struct","class",
                                                "interface","enum","enumMember","typeParameter","function","method","property",
                                                "macro","variable","parameter", "event", "modifier", "comment", "string"};

        picojson::array myTokenTypes;
        for (auto const &type : supportedTokenTypes)  {
            myTokenTypes.push_back(picojson::value(type));
        }

        vector<std::string> supportedModifiers {"documentation","declaration","definition","static","abstract","deprecated",
                                                "readonly", "async","modification","defaultLibrary"};

        picojson::array myTokenModifiers;
        for (auto const &mod : supportedModifiers) {
            myTokenModifiers.push_back(picojson::value(mod));
        }

        picojson::array formats;
        formats.push_back(picojson::value("relative"));

        semanticTokensClientCapabilities["requests"] = picojson::value(requests);

        semanticTokensClientCapabilities["tokenTypes"] = picojson::value(myTokenTypes);
        semanticTokensClientCapabilities["tokenModifiers"] = picojson::value(myTokenModifiers);
        semanticTokensClientCapabilities["formats"] = picojson::value(formats);

        semanticTokensClientCapabilities["overlappingTokenSupport"] = picojson::value(false);
        semanticTokensClientCapabilities["multilineTokenSupport"] = picojson::value(false);

        textDocument["semanticTokens"] = picojson::value(semanticTokensClientCapabilities);

        capabilities["textDocument"] = picojson::value(textDocument);

        //https://clangd.llvm.org/extensions.html#utf-8-offsets
        picojson::array offsetEncodings;
        offsetEncodings.push_back(picojson::value("utf-8"));
        capabilities["offsetEncoding"] = picojson::value(offsetEncodings);

        params["capabilities"] = picojson::value(capabilities);
        request["params"] =  picojson::value(params);

        std::string serialized = picojson::value(request).serialize();

        pipe_write_jsonrpc(serialized);

        std::string response = pipe_read_jsonrpc();

        picojson::value jsonResponse;
        std::string err = picojson::parse(jsonResponse, response);

        if (!checkErrorResponse(jsonResponse, err)) {
            return false;
        }

        if (   !jsonResponse.get("result").is<picojson::object>()
            && !jsonResponse.get("result").get("capabilities").is<picojson::object>()) {

            return false;
        }

        if (jsonResponse.get("result").get("serverInfo").is<picojson::object>()) {
            serverName= jsonResponse.get("result").get("serverInfo").get("name").get<std::string>();
            serverVersion= jsonResponse.get("result").get("serverInfo").get("version").get<std::string>();
        }

        serverCapabilities = jsonResponse.get("result").get("capabilities");
        hoverProvider = serverCapabilities.get("hoverProvider").get<bool>();

        semanticTokensProvider = serverCapabilities.contains("semanticTokensProvider");

        if (semanticTokensProvider) {
            picojson::array list = serverCapabilities.get("semanticTokensProvider").get("legend").get("tokenTypes").get<picojson::array>();
            int cnt=0;
            for (picojson::array::iterator iter = list.begin(); iter != list.end(); ++iter) {
                tokenTypes.insert( make_pair( cnt++, iter->get<std::string>()));
            }

            picojson::array modifiersList = serverCapabilities.get("semanticTokensProvider").get("legend").get("tokenModifiers").get<picojson::array>();
            cnt=0;
            for (picojson::array::iterator iter = modifiersList.begin(); iter != modifiersList.end(); ++iter) {
                tokenModifiers.insert( make_pair( cnt++, iter->get<std::string>()));
            }
        }

        return true;
    }

    void LSPClient::readNotification(const picojson::value &json) {

        if (json.contains("method") && json.get("method").get<std::string>()=="textDocument/publishDiagnostics") {
            picojson::array diagnostics = json.get("params").get("diagnostics").get<picojson::array>();

            for (picojson::array::iterator iter = diagnostics.begin(); iter != diagnostics.end(); ++iter) {

                if ((int)iter->get("severity").get<double>() != 1){
                    continue;
                }

                picojson::value range = iter->get("range");
                int startLine = (int) range.get("start").get("line").get<double>();
                int startCharacter = (int) range.get("start").get("character").get<double>();
                int endLine = (int) range.get("end").get("line").get<double>();
                int endCharacter = (int) range.get("end").get("character").get<double>();

                if (startLine == endLine && startCharacter<endCharacter) {
            //        std::cerr<<"diag "<< startLine << " : "<<startCharacter << " - " << endCharacter<<"\n";
                    std::string msg=iter->get("message").get<std::string>();
                    std::replace(msg.begin(), msg.end(), '\n', ' ');
                    errorMap[{ startLine+1, startCharacter+1 }] = highlight::SemanticToken(endCharacter-startCharacter, 1, msg);
                }
            }
        }
    }

    std::string LSPClient::runHover(const std::string &document, int character, int line){

        if (document.empty())
            return "";

        picojson::object request;
        picojson::object params;
        picojson::object position;
        picojson::object textDocument;

        float myId = ++msgId;

        request["jsonrpc"] = picojson::value("2.0");
        request["id"] = picojson::value(myId);
        request["method"] = picojson::value("textDocument/hover");

        std::string uri("file://");
        uri.append(document);
        textDocument["uri"] = picojson::value(uri);

        position["character"] = picojson::value((double)character);
        position["line"] = picojson::value((double)line);

        params["textDocument"] = picojson::value(textDocument);
        params["position"] = picojson::value(position);

        request["params"] =  picojson::value(params);

        std::string serialized = picojson::value(request).serialize();

        bool writeRes=pipe_write_jsonrpc(serialized);

        if (!writeRes) {
            return "";
        }

        while (true) {

            std::string response = pipe_read_jsonrpc();

            picojson::value jsonResponse;
            std::string err = picojson::parse(jsonResponse, response);

            if (!checkErrorResponse(jsonResponse, err)) {
                return "";
            }

            if ( !jsonResponse.contains("id") ) {

                readNotification(jsonResponse);
                continue;
            }

            if ( myId != jsonResponse.get("id").get<double>()) {
                continue;
            }

            if ( !jsonResponse.get("result").is<picojson::object>() ) {
                return "";
            }

            // Apparently each server sends the Hover data slightly different:
            // maybe configure this in the lsp.conf

            std::string hoverList;

            if (jsonResponse.get("result").get("contents").is<std::string>()){
                //rls
                hoverList = jsonResponse.get("result").get("contents").get<std::string>();
            }
            else if (jsonResponse.get("result").get("contents").is<picojson::array>()){

                picojson::array list = jsonResponse.get("result").get("contents").get<picojson::array>();
                for (picojson::array::iterator iter = list.begin(); iter != list.end(); ++iter) {
                    if ((*iter).is<std::string>()){
                        // pyls
                        hoverList.append( (*iter).get<std::string>());
                    }
                    else if ((*iter).is<picojson::object>()){
                        //ccls
                        if ((*iter).get("value").is<std::string>())
                            hoverList = (*iter).get("value").get<std::string>();
                    }
                }
            }
            else if (jsonResponse.get("result").get("contents").is<picojson::object>()){
                //clangd
                hoverList = jsonResponse.get("result").get("contents").get("value").get<std::string>();
            }

            return hoverList;
        }

        return "";
    }


    bool LSPClient::runSemanticTokensFull(const std::string &document) {

        if (document.empty() || !semanticTokensProvider)
            return false;

        picojson::object request;
        picojson::object params;
        picojson::object textDocument;

        float myId = ++msgId;
        request["jsonrpc"] = picojson::value("2.0");
        request["id"] = picojson::value(myId);
        request["method"] = picojson::value("textDocument/semanticTokens/full");

        std::string uri("file://");
        uri.append(document);
        textDocument["uri"] = picojson::value(uri);

        params["textDocument"] = picojson::value(textDocument);

        request["params"] =  picojson::value(params);

        std::string serialized = picojson::value(request).serialize();

        bool writeRes = pipe_write_jsonrpc(serialized);

        if (!writeRes) {

            return false;
        }

        std::string response;
        picojson::value jsonResponse;

        while (true) {
            response = pipe_read_jsonrpc();

            std::string err = picojson::parse(jsonResponse, response);

            if (!checkErrorResponse(jsonResponse, err)) {
                return false;
            }

            if ( !jsonResponse.contains("id") ) {

                readNotification(jsonResponse);
                continue;
            }

            if ( myId != jsonResponse.get("id").get<double>()) {
                continue;
            }

            if ( jsonResponse.get("result").is<picojson::object>() ) {
                break;
            }
        }

        vector<unsigned int> semAttributes;
        picojson::array list = jsonResponse.get("result").get("data").get<picojson::array>();
        for (picojson::array::iterator iter = list.begin(); iter != list.end(); ++iter) {
            semAttributes.push_back((unsigned int)iter->get<double>());
        }

        int semCnt = semAttributes.size();

        if (semCnt%5) {
            return false;
        }

        unsigned int line=0;
        unsigned int col=0;
        std::string id;
        for (int i=0; i<semCnt; i+=5){

            if (semAttributes[i]) col=0;
            line +=semAttributes[i];

            col +=semAttributes[i+1];
            id = tokenTypes[semAttributes[i+3]];

            //if (semAttributes[i+4]) {
            //    std::cerr << "Mod! line "<<line<<" col "<< col << " id  "<< id << " val "<<semAttributes[i+4]<<"\n";
            //}
            //std::cerr << "ST! line "<<line<<" col "<< col << " id  "<< id << " val "<<semAttributes[i+3]  <<"\n";

            // for now disable multiline elements
            if (id != "comment" && id != "string" && id != "macro") {
                tokenMap[{ line+1, col+1 }] = highlight::SemanticToken(semAttributes[i+2], semAttributes[i+3], id);
            }
        }

        return true;
    }

    bool LSPClient::tokenExists(unsigned int line, unsigned int col) {
        return semanticTokensProvider && tokenMap.count(make_tuple(line,col));
    }

    highlight::SemanticToken LSPClient::getToken(unsigned int line, unsigned int col) {
        return tokenMap.find(make_tuple(line,col))->second;
    }

    bool LSPClient::errorExists(unsigned int line, unsigned int col) {
        return  errorMap.count(make_tuple(line,col));
    }

    highlight::SemanticToken LSPClient::getError(unsigned int line, unsigned int col) {
        return errorMap.find(make_tuple(line,col))->second;
    }

    bool LSPClient::runDidOpen(const std::string &document, const string& syntax){

        if (document.empty() || syntax != triggerSyntax)
            return false;

        std::ifstream t(document.c_str());
        std::stringstream buffer;
        buffer << t.rdbuf();

        picojson::object request;
        picojson::object params;
        picojson::object textDocument;

        request["jsonrpc"] = picojson::value("2.0");
        request["method"] = picojson::value("textDocument/didOpen");

        std::string uri("file://");
        uri.append(document);
        textDocument["uri"] = picojson::value(uri);
        textDocument["languageId"] =  picojson::value(triggerSyntax);
        textDocument["text"] = picojson::value(buffer.str());
        textDocument["version"] =  picojson::value(0.0);

        params["textDocument"] = picojson::value(textDocument);

        request["params"] =  picojson::value(params);

        std::string serialized = picojson::value(request).serialize();

        pipe_write_jsonrpc(serialized);

        return true;
    }

    bool LSPClient::runDidClose(const std::string &document, const string& syntax){

        tokenMap.clear();
        errorMap.clear();

        if (document.empty() || syntax !=triggerSyntax)
            return false;

        picojson::object request;
        picojson::object params;
        picojson::object textDocument;

        request["jsonrpc"] = picojson::value("2.0");
        request["method"] = picojson::value("textDocument/didClose");

        std::string uri("file://");
        uri.append(document);
        textDocument["uri"] = picojson::value(uri);

        params["textDocument"] = picojson::value(textDocument);

        request["params"] =  picojson::value(params);

        std::string serialized = picojson::value(request).serialize();

        pipe_write_jsonrpc(serialized);

        return true;
    }

    bool LSPClient::checkErrorResponse(const picojson::value &json, const string& picoError){
        lastErrorCode = 0;
        lastErrorMessage.clear();
        if (! picoError.empty()) {
            lastErrorCode = 1;
            lastErrorMessage = picoError;
            return false;
        }

        if (! json.is<picojson::object>()) {
            lastErrorCode = 2;
            lastErrorMessage = "could not initialize PicoJSON";
            return false;
        }

        if (json.get("error").is<picojson::object>()) {
            lastErrorCode = (int)json.get("error").get("code").get<double>();
            lastErrorMessage = json.get("error").get("message").get<std::string>();
            return false;
        }
        return true;
    }

    void LSPClient::runSimpleAction(const std::string action, int delay) {
        picojson::object request;
        //picojson::value nullValue;
        picojson::object emptyObject;

        request["jsonrpc"] = picojson::value("2.0");
        request["method"] = picojson::value(action);

        request["params"] =  picojson::value(emptyObject);

        std::string serialized = picojson::value(request).serialize();

        pipe_write_jsonrpc(serialized);

        if (delay>0) {
            if (logRequests) {
                std::cerr << "waiting " << delay <<"ms for language server\n";
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(delay));
        }
    }

    void LSPClient::runInitialized(){
         runSimpleAction("initialized", initDelay);
    }

    void LSPClient::runShutdown() {
        runSimpleAction("shutdown");
    }

    void LSPClient::runExit()  {
        runSimpleAction("exit");
    }

    bool LSPClient::isInitialized() const {
        return initialized;
    }

    bool LSPClient::isHoverProvider() const {
        return hoverProvider;
    }

    bool LSPClient::isSemanticTokensProvider() const {
        return semanticTokensProvider;
    }

    void LSPClient::setLogging(bool flag){
        logRequests = flag;
    }

    void LSPClient::setInitializeDelay(int ms) {
        initDelay = ms;
    }

    std::string LSPClient::getServerName() const {
        return serverName;
    }
    std::string LSPClient::getServerVersion() const {
        return serverVersion;
    }

    std::string LSPClient::getErrorMessage() const {
        return lastErrorMessage;
    }

    int LSPClient::getErrorCode() const {
        return lastErrorCode;
    }

    int LSPClient::getSemanticTokenCount() const {
        return tokenTypes.size();
    }

}

/*
 *
 * //documentHighlightProvider, see https://github.com/microsoft/python-language-server/pull/1767
 * //referencesProvider,
 * //foldingRangeProvider
 *
 * //ccls and cquery -> semantic highlighting
 *
 * https://code.visualstudio.com/api/language-extensions/programmatic-language-features
 * https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide
 * https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide
 *
 * https://clangd.llvm.org/extensions.html#utf-8-offsets
 *
 * publishDiagnostics:
 * Your language server sends the textDocument/publishDiagnostics message to the language client. The message carries an array of diagnostic items for a resource URI.
 *
 * Note: The client does not ask the server for diagnostics. The server pushes the diagnostic information to the client.
 */

