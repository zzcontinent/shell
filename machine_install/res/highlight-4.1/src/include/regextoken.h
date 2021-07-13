/***************************************************************************
 *                          regextoken.h  -  description
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


#ifndef REGEX_TOKEN_H
#define REGEX_TOKEN_H

#include <string>

#include "enums.h"

namespace highlight
{
/** \brief Regular Expression Information

    This class associates a processing state with a keyword class and the length of the matched token.

* @author Andre Simon
*/
class RegexToken
{
public:

    /// Constructor
    RegexToken() : length ( 0 ), state ( STANDARD ), kwClass ( 0 ), name()
    {
    }

    /// Constructor
    RegexToken ( State s, unsigned int l , unsigned int c, const std::string&n ) :
        length ( l ), state ( s ), kwClass ( c ), name(n)
    {
    }

    /// Copy Constructor
    RegexToken ( const RegexToken& other )
    {
        length = other.length;
        state = other.state;
        kwClass = other.kwClass;
        name=other.name;
    }

    /// Operator overloading
    RegexToken& operator= ( const RegexToken & other )
    {
        length = other.length;
        state = other.state;
        kwClass = other.kwClass;
        name=other.name;
        return *this;
    }

    ~RegexToken()
    {
    }

    unsigned int length;    ///< length of the token
    State state;            ///< state of the matched token (keyword, string, etc)
    unsigned int kwClass;   ///< keyword class if state is keyword
    std::string name;           ///< language name needed to handle embedded languages
};

}

#endif
