/***************************************************************************
 *                      LSPProfile.h  -  description
 *                           -------------------
 *  begin                : Fr Jan 22 2021
 *  copyright            : (C) 2021 by Andre Simon
 *  email                : a.simon@mailbox.org
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

#ifndef LSPPROFILE_H
#define LSPPROFILE_H

#include <vector>
#include <string>

/**\brief LSP Profile Information
 *
 * A LSPProfile contains information of several LSP servers
 *
 * Configuration is stored in lsp.conf like:
 *  { Server="clangd", Exec="clangd", Syntax="c", Options={"--log=error"} },
 */

namespace highlight
{

class LSPProfile
{
public:
    LSPProfile()
    {
    }

    ~LSPProfile()
    {
    }

    std::string serverName;              ///< server name
    std::string executable;              ///< server executable path
    std::string syntax;                  ///< language definition which can be enhanced using the LS
    int delay;                           ///< server delay in milliseconds after initialization request
    std::vector<std::string> options;    ///< server executable start options
};

}
#endif // REGEXELEMENT_H
