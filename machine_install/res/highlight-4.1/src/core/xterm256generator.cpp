/***************************************************************************
                   xterm256generator.cpp  -  description
                             -------------------
    begin                : Oct 13 2006
    copyright            : (C) 2006-2021 by Andre Simon
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


#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sstream>

#include "xterm256generator.h"
#include "charcodes.h"
#include "version.h"


namespace highlight
{
Xterm256Generator::Xterm256Generator() :
    CodeGenerator ( ESC_XTERM256 ),
    use16mColours(false),
    canvasPadding(0)
{
    newLineTag = "\n";
    spacer = initialSpacer = " ";
}

Xterm256Generator::~Xterm256Generator() {}

string Xterm256Generator::getHeader()
{
    return string();
}

void Xterm256Generator::printBody()
{
    processRootState();
}

string Xterm256Generator::getFooter()
{
    return string();
}

string Xterm256Generator::maskCharacter ( unsigned char c )
{
    return string ( 1, c );
}

void Xterm256Generator::initOutputTags ( )
{
    if (canvasPadding > 0 ) {

        ostringstream bgs;
        Colour bg=docStyle.getBgColour();
        unsigned char  bg_rgb[3];
        bg_rgb[0] = ( unsigned char ) strtoll ( bg.getRed ( HTML ).c_str(), NULL, 16 );
        bg_rgb[1] = ( unsigned char ) strtoll ( bg.getGreen ( HTML ).c_str(), NULL, 16 );
        bg_rgb[2] = ( unsigned char ) strtoll ( bg.getBlue ( HTML ).c_str(), NULL, 16 );

        if (use16mColours) {
            //use 24bit true colour ("888" colours (aka 16 million))
            bgs << "\033[48;2;"<< ( int ) bg_rgb[0] << ";" << ( int ) bg_rgb[1] << ";" << ( int ) bg_rgb[2] << "m";
        } else {
            int bgApprox=( int ) rgb2xterm ( bg_rgb );
            if (!bgApprox) bgApprox=16; // workaround transparent 0 value
            bgs << "\033[48;5;"<< bgApprox << "m";
        }
        canvasColSeq = bgs.str();
        maskWsBegin = canvasColSeq;
    }

    openTags.push_back ( getOpenTag ( docStyle.getDefaultStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getStringStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getNumberStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getSingleLineCommentStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getCommentStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getEscapeCharStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getPreProcessorStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getPreProcStringStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getLineStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getOperatorStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getInterpolationStyle()) );

    openTags.push_back ( getOpenTag ( docStyle.getErrorStyle() ) );
    openTags.push_back ( getOpenTag ( docStyle.getErrorMessageStyle()) );

    for (unsigned int i=0; i<NUMBER_BUILTIN_STATES; i++ ) {
        closeTags.push_back ( "\033[m" );
    }
}

string  Xterm256Generator::getOpenTag ( const ElementStyle &col )
{
    Colour c= col.getColour();
    unsigned char  rgb[3];
    rgb[0] = ( unsigned char ) strtoll ( c.getRed ( HTML ).c_str(), NULL, 16 );
    rgb[1] = ( unsigned char ) strtoll ( c.getGreen ( HTML ).c_str(), NULL, 16 );
    rgb[2] = ( unsigned char ) strtoll ( c.getBlue ( HTML ).c_str(), NULL, 16 );

    ostringstream s;

    s << canvasColSeq;

    s  << "\033[";

    if ( col.isBold() ) s << "1;";
    if ( col.isItalic() ) s << "3;";
    if ( col.isUnderline() ) s << "4;";

    if (use16mColours) {
        //use 24bit true colour ("888" colours (aka 16 million))
        s << "38;2;"<< ( int ) rgb[0] << ";" << ( int ) rgb[1] << ";" << ( int ) rgb[2] << "m";
    } else {
        // apply color approximation, 256 colour palette (216 colours + 16 ansi + 24 gray) (colors are 24bit)
        s << "38;5;"<< ( int ) rgb2xterm ( rgb ) << "m";
    }

    return  s.str();
}

string Xterm256Generator::getKeywordOpenTag ( unsigned int styleID )
{
    return getOpenTag ( docStyle.getKeywordStyle ( currentSyntax->getKeywordClasses() [styleID] ) );
}

string Xterm256Generator::getKeywordCloseTag ( unsigned int styleID )
{
    return "\033[m";
}

string Xterm256Generator::getNewLine()
{

    ostringstream ss;

    printSyntaxError(ss);

    if (canvasPadding>0) {
        unsigned int lastLineLength=getLastLineLength();

        //adapt to long lines; avoid lag with very long lines
        if (lastLineLength<512 && lastLineLength > canvasPadding && lastLineLength)
            canvasPadding = lastLineLength;

        ss << canvasColSeq;
        if (canvasPadding > lastLineLength)
            ss << string(canvasPadding - lastLineLength, ' ');
        ss << "\033[m";
    }

    if (printNewLines)
        ss << newLineTag;

    return ss.str();
}

 void Xterm256Generator::setESCTrueColor(bool b) {
    use16mColours = b;
    if (b) setOutputType(ESC_TRUECOLOR);
}

void Xterm256Generator::setESCCanvasPadding(unsigned int p) {
    if (p<512) canvasPadding = p;
}

/* the following functions are based on Wolfgang Frischs xterm256 converter utility:
   https://web.archive.org/web/20060815160015/http://www.frexx.de/xterm-256-notes/
*/

void Xterm256Generator::xterm2rgb ( unsigned char color, unsigned char* rgb )
{
    // 16 basic colors
    if ( color<16 ) {
        rgb[0] = basic16[color][0];
        rgb[1] = basic16[color][1];
        rgb[2] = basic16[color][2];
    }

    // color cube color
    if ( color>=16 && color<=232 ) {
        color-=16;
        rgb[0] = valuerange[ ( color/36 ) %6];
        rgb[1] = valuerange[ ( color/6 ) %6];
        rgb[2] = valuerange[color%6];
    }

    // gray tone
    if ( color>=233 && color<=253 ) {
        rgb[0]=rgb[1]=rgb[2] = 8+ ( color-232 ) *0x0a;
    }
}

void Xterm256Generator::maketable()
{
    unsigned char c, rgb[3] = {0};
    for ( c=0; c<=253; c++ ) {
        xterm2rgb ( c,rgb );
        colortable[c][0] = rgb[0];
        colortable[c][1] = rgb[1];
        colortable[c][2] = rgb[2];
    }
}

unsigned char Xterm256Generator::rgb2xterm ( unsigned char* rgb )
{
    unsigned char c, best_match=0;
    double d, smallest_distance;

    if ( !initialized ) {
        maketable();
        initialized = true;
    }

    smallest_distance = 10000000000.0;

    for ( c=0; c<=253; c++ ) {
        d = pow ( colortable[c][0]-rgb[0],2.0 ) +
            pow ( colortable[c][1]-rgb[1],2.0 ) +
            pow ( colortable[c][2]-rgb[2],2.0 );
        if ( d<smallest_distance ) {
            smallest_distance = d;
            best_match=c;
        }
    }
    return best_match;
}

bool Xterm256Generator::initialized=false;

unsigned char Xterm256Generator::colortable[254][3] = { {0} };

const unsigned char Xterm256Generator::valuerange[] = { 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF };

const unsigned char Xterm256Generator::basic16[16][3] = {
    { 0x00, 0x00, 0x00 }, // 0
    { 0xCD, 0x00, 0x00 }, // 1
    { 0x00, 0xCD, 0x00 }, // 2
    { 0xCD, 0xCD, 0x00 }, // 3
    { 0x00, 0x00, 0xEE }, // 4
    { 0xCD, 0x00, 0xCD }, // 5
    { 0x00, 0xCD, 0xCD }, // 6
    { 0xE5, 0xE5, 0xE5 }, // 7
    { 0x7F, 0x7F, 0x7F }, // 8
    { 0xFF, 0x00, 0x00 }, // 9
    { 0x00, 0xFF, 0x00 }, // 10
    { 0xFF, 0xFF, 0x00 }, // 11
    { 0x5C, 0x5C, 0xFF }, // 12
    { 0xFF, 0x00, 0xFF }, // 13
    { 0x00, 0xFF, 0xFF }, // 14
    { 0xFF, 0xFF, 0xFF }  // 15
};
}
