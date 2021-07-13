/***************************************************************************
                          keystore.cpp  -  description
                             -------------------
    begin                : Sat Aug 05 2020
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

#include "keystore.h"

namespace highlight
{

map<string, string> KeyStore::keyStoreMap;

KeyStore::KeyStore()
{}

KeyStore::~KeyStore()
{
}

int KeyStore::luaStore (lua_State *L)
{
    if (lua_gettop(L)==1) {
        const char* name = lua_tostring(L, 1);
        lua_pushstring(L, KeyStore::keyStoreMap[name].c_str());
    }
    else if (lua_gettop(L)==2) {
        const char* name = lua_tostring(L, 1);
        const char* val = lua_tostring(L, 2);
        KeyStore::keyStoreMap[name] = val;
        lua_pushboolean(L, 1);
    } else {
        lua_pushboolean(L, 0);
    }
    return 1;
}

}
