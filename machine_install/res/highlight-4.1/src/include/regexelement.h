/***************************************************************************
 *                      RegexElement.h  -  description
 *                           -------------------
 *  begin                : Fr Jan 22 2021
 *  copyright            : (C) 2005-2021 by Andre Simon
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

#ifndef REGEXELEMENT_H
#define REGEXELEMENT_H

#include <boost/xpressive/xpressive_dynamic.hpp>

#include "enums.h"


/**
 * @todo write docs
 */
/**\brief Association of a regex with a state description
 *
 *  A RegexElement associates a regular expression with the state information
 *  (opening and closing state, pattern, keyword class, keyword group id, language name)
 */

namespace highlight
{

class RegexElement
{
public:
    RegexElement()
    :open ( STANDARD ), end ( STANDARD ), kwClass ( 0 ), capturingGroup ( -1 ),
    langName(), instanceId(instanceCnt++),
    priority(0), constraintLineNum (0)
    {
    }

    RegexElement ( State oState, State eState, const std::string&rePattern, unsigned int cID=0, int group=-1, const std::string& name="",
                   unsigned int prio=0, unsigned int cLineNum=0,  const std::string &cFilename=""):
                   open ( oState ), end ( eState ), kwClass ( cID ), capturingGroup ( group ), langName(name),instanceId(instanceCnt++),
                   priority(prio), constraintLineNum (cLineNum), constraintFilename (cFilename)
    {
        pattern=rePattern;
        rex=boost::xpressive::sregex::compile(rePattern);
    }

    ~RegexElement()
    {
        instanceCnt--;
    }

    State open, ///< opening state
    end;  ///< closing state
    boost::xpressive::sregex rex;
    unsigned int kwClass;        ///< keyword class
    int capturingGroup;          ///< capturing group ID
    std::string langName;             ///< language name
    std::string pattern;              ///< RE pattern
    static int instanceCnt;
    int instanceId;
    unsigned int priority;          ///< if set and matched, no other other regular expression will be evaluated
    unsigned int constraintLineNum; ///< restrict this regex to this source line number
    std::string constraintFilename;      ///< restrict this regex to this source filename
};

}
#endif // REGEXELEMENT_H
