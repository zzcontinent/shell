
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


#ifndef ENUMS_H
#define ENUMS_H

namespace highlight
{
/** states which may occur during input file parsing */
enum State {
    STANDARD=0,
    STRING,
    NUMBER,
    SL_COMMENT,
    ML_COMMENT,
    ESC_CHAR,
    DIRECTIVE,
    DIRECTIVE_STRING,
    LINENUMBER,
    SYMBOL,
    STRING_INTERPOLATION,
    SYNTAX_ERROR,
    SYNTAX_ERROR_MSG,

    // don't use constants > KEYWORD as array indices!
    KEYWORD,
    STRING_END,
    NUMBER_END,
    SL_COMMENT_END,
    ML_COMMENT_END,
    ESC_CHAR_END,
    DIRECTIVE_END,
    SYMBOL_END,
    STRING_INTERPOLATION_END,
    KEYWORD_END,
    IDENTIFIER_BEGIN,
    IDENTIFIER_END,
    EMBEDDED_CODE_BEGIN,
    EMBEDDED_CODE_END,

    _UNKNOWN=100,
    _REJECT,
    _EOL,
    _EOF,
    _WS,
    _TESTPOS
} ;

/** Parser return values*/
enum ParseError {
    PARSE_OK,
    BAD_INPUT=1,
    BAD_OUTPUT=2,
    BAD_STYLE=4,
    BAD_BINARY=8
};

/** line wrapping modes*/
enum WrapMode {
    WRAP_DISABLED,
    WRAP_SIMPLE,
    WRAP_DEFAULT
};

/** language definition loading results*/
enum LoadResult {
    LOAD_OK,
    LOAD_FAILED,
    LOAD_FAILED_REGEX,
    LOAD_FAILED_LUA
};

/** language server initialization results*/
enum LSResult {
    INIT_OK,
    INIT_BAD_PIPE,
    INIT_BAD_REQUEST,
    CMD_ERROR
};

/** output formats */
enum OutputType {
    HTML,
    XHTML,
    TEX,
    LATEX,
    RTF,
    ESC_ANSI,
    ESC_XTERM256,
    ESC_TRUECOLOR,
    SVG,
    BBCODE,
    PANGO,
    ODTFLAT
};

}

#endif
