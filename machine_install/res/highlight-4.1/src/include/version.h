/***************************************************************************
                          version.h  -  description
                             -------------------
    begin                : Mon March 3 2003
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


#ifndef VERSION_H
#define VERSION_H

#include <string>

#define HIGHLIGHT_MAJOR "4"
#define HIGHLIGHT_MINOR "1"

#define HIGHLIGHT_VERSION  HIGHLIGHT_MAJOR "." HIGHLIGHT_MINOR

#define HIGHLIGHT_URL "http://www.andre-simon.de/"
#define HIGHLIGHT_EMAIL "a.simon@mailbox.org"

namespace highlight
{

class Info
{
public:

    static std::string getVersion() {
        return HIGHLIGHT_VERSION;
    }

    static std::string getWebsite() {
        return HIGHLIGHT_URL;
    }

    static std::string getEmail() {
        return HIGHLIGHT_EMAIL;
    }
};

}

#endif
