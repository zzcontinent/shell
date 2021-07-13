/***************************************************************************
 *                          regextoken.h  -  description
 *                             -------------------
 *    begin                : Wed Jan 20 2021
 *    copyright            : (C) 2021 by Andre Simon
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


#ifndef SEMANTIC_TOKEN_H
#define SEMANTIC_TOKEN_H

#include <string>


namespace highlight
{
/** \brief Semantic Token Information

    This class contains the name, id and length of a semantic token.

* @author Andre Simon
*/
class SemanticToken
{
public:

    /// Constructor
    SemanticToken() : length ( 0 ), idx ( 0 ), id()
    {
    }

    /// Constructor
    SemanticToken ( unsigned int l, unsigned int idx, const std::string&n ) :
    length ( l ), idx ( idx ), id(n)
    {
    }

    /// Copy Constructor
    SemanticToken ( const SemanticToken& other )
    {
        length = other.length;
        idx = other.idx;

        id=other.id;
    }

    /// Operator overloading
    SemanticToken& operator= ( const SemanticToken & other )
    {
        length = other.length;
        idx = other.idx;

        id=other.id;
        return *this;
    }

    ~SemanticToken()
    {
    }

    unsigned int length;  ///< length of the token
    unsigned int idx;     ///< token type index

    std::string id;     ///< token type name
};

}

#endif
