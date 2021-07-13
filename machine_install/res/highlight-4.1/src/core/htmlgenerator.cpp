/***************************************************************************
                     htmlgenerator.cpp  -  description
                             -------------------
    begin                : Wed Nov 28 2001
    copyright            : (C) 2001-2021 by Andre Simon
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

#include <fstream>
#include <iostream>
#include <sstream>
#include <algorithm>

#include "htmlgenerator.h"
#include "version.h"

namespace highlight
{

HtmlGenerator::HtmlGenerator () :
    CodeGenerator ( HTML ),
    brTag ( "<br>" ),
    hrTag ( "<hr>" ),
    fileSuffix ( ".html" ),
    cssClassName ( "hl" ),
    orderedList ( false ),
    useInlineCSS ( false ),
    enclosePreTag ( false ),
    attachAnchors ( false ),
    anchorPrefix ( "l" )
{
    spacer = initialSpacer = " ";
    styleCommentOpen="/*";
    styleCommentClose="*/";
}


string HtmlGenerator::getHeaderStart ( const string &title )
{
    ostringstream header;
    header<<  "<!DOCTYPE html>\n<html>\n<head>\n";
    if ( encodingDefined() ) {
        header << "<meta charset=\""
               << encoding
               << "\">\n";
    }
    header << "<title>" << title << "</title>\n";
    return header.str();
}

string HtmlGenerator::getHeader()
{
    ostringstream os;
    os << getHeaderStart ( docTitle );
    if ( !useInlineCSS ) {
        if ( includeStyleDef ) {
            os << "<style type=\"text/css\">\n";
            os << getStyleDefinition();
            os << CodeGenerator::readUserStyleDef();
            os << "</style>\n";
        } else {
            os << "<link rel=\"stylesheet\" type=\"text/css\" href=\""
               << getStyleOutputPath()
               << "\">\n";
        }
        os << "</head>\n<body";
        if (!cssClassName.empty())
            os << " class=\""<<cssClassName<<"\"";
        os << ">\n";
    } else {
        os << "</head>\n<body style=\""
           << "background-color:#"
           << ( docStyle.getBgColour().getRed ( HTML ) )
           << ( docStyle.getBgColour().getGreen ( HTML ) )
           << ( docStyle.getBgColour().getBlue ( HTML ) )
           << "\">\n";
    }

    return os.str();
}

string HtmlGenerator::getFooter()
{
    return getGeneratorComment();
}

void HtmlGenerator::printBody()
{
    if ( (!(showLineNumbers && orderedList) && !fragmentOutput) || enclosePreTag ) {
        if ( !useInlineCSS ) {
            *out << "<pre";
            if (!cssClassName.empty())
                *out<<" class=\"" << cssClassName << "\"";
            *out<< ">";
        } else {
            bool quoteFont=getBaseFont().find_first_of(",'")==string::npos;
            *out << "<pre style=\""
                 << "color:#"
                 << ( docStyle.getDefaultStyle().getColour().getRed ( HTML ) )
                 << ( docStyle.getDefaultStyle().getColour().getGreen ( HTML ) )
                 << ( docStyle.getDefaultStyle().getColour().getBlue ( HTML ) )
                 << "; background-color:#"
                 << ( docStyle.getBgColour().getRed ( HTML ) )
                 << ( docStyle.getBgColour().getGreen ( HTML ) )
                 << ( docStyle.getBgColour().getBlue ( HTML ) )
                 << "; font-size:" << this->getBaseFontSize()
                 << "pt; font-family:"
                 <<((quoteFont)?"'":"")
                 << this->getBaseFont()
                 <<((quoteFont)?"'":"")
                 <<";white-space: pre-wrap;\">";
        }
    }
    if ( showLineNumbers && orderedList ) {
        *out << "<ol";
        if (!cssClassName.empty())
            *out<<" class=\"" << cssClassName << "\"";
        *out<< ">\n";
    }

    processRootState();

    if ( showLineNumbers && orderedList ) *out << "</ol>";

    if ( (!(showLineNumbers && orderedList) && !fragmentOutput)  || enclosePreTag )  *out << "</pre>";
}


void HtmlGenerator::initOutputTags ()
{
    openTags.push_back ( "" );
    if ( useInlineCSS ) {
        openTags.push_back ( getOpenTag ( docStyle.getStringStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getNumberStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getSingleLineCommentStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getCommentStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getEscapeCharStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getPreProcessorStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getPreProcStringStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getLineStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getOperatorStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getInterpolationStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getErrorStyle() ) );
        openTags.push_back ( getOpenTag ( docStyle.getErrorMessageStyle() ) );
    } else {
        openTags.push_back ( getOpenTag ( STY_NAME_STR ) );
        openTags.push_back ( getOpenTag ( STY_NAME_NUM ) );
        openTags.push_back ( getOpenTag ( STY_NAME_SLC ) );
        openTags.push_back ( getOpenTag ( STY_NAME_COM ) );
        openTags.push_back ( getOpenTag ( STY_NAME_ESC ) );
        openTags.push_back ( getOpenTag ( STY_NAME_DIR ) );
        openTags.push_back ( getOpenTag ( STY_NAME_DST ) );
        openTags.push_back ( getOpenTag ( STY_NAME_LIN ) );
        openTags.push_back ( getOpenTag ( STY_NAME_SYM ) );
        openTags.push_back ( getOpenTag ( STY_NAME_IPL ) );
        openTags.push_back ( getOpenTag ( STY_NAME_ERR ) );
        openTags.push_back ( getOpenTag ( STY_NAME_ERM ) );
    }

    closeTags.push_back ( "" );
    for (unsigned int i=1; i<NUMBER_BUILTIN_STATES; i++ ) {
        closeTags.push_back ( "</span>" );
    }

}

string HtmlGenerator::getAttributes ( const string & elemName, const ElementStyle & elem )
{
    ostringstream s;
    if ( !elemName.empty() ) {
        if (!cssClassName.empty())
            s << "."<<cssClassName;
        s <<"."<<elemName<<" { ";
    }

    if (!elem.getCustomOverride()) {
        s << "color:#"
            << ( elem.getColour().getRed ( HTML ) )
            << ( elem.getColour().getGreen ( HTML ) )
            << ( elem.getColour().getBlue ( HTML ) )
            << ( elem.isBold() ?     "; font-weight:bold" :"" )
            << ( elem.isItalic() ?   "; font-style:italic" :"" )
            << ( elem.isUnderline() ? "; text-decoration:underline" :"" );
    }

    string customStyle(elem.getCustomStyle());

    if (!customStyle.empty()) {
        if (!elem.getCustomOverride()) {
            s << "; ";
        }
        s << customStyle;
    }

    if ( !elemName.empty() ) {
        s << "; }\n" ;
    }
    return s.str();
}

string HtmlGenerator::getOpenTag ( const string& styleName )
{
    return "<span class=\"" + (cssClassName.empty() ? "":cssClassName+ " ")  + styleName + "\">";
}

string HtmlGenerator::getOpenTag ( const ElementStyle & elem )
{
    return "<span style=\""+getAttributes ( "", elem ) + "\">";
}

string HtmlGenerator::getGeneratorComment()
{
    ostringstream s;
    s << "\n</body>\n</html>\n";

    if (!omitVersionComment) {
        s << "<!--HTML generated by highlight "
          << highlight::Info::getVersion() << ", " <<  highlight::Info::getWebsite() <<"-->\n";
    }

    return s.str();
}

string HtmlGenerator::getStyleDefinition()
{
    if (disableStyleCache || styleDefinitionCache.empty() ) {
        bool quoteFont=getBaseFont().find_first_of(",'")==string::npos;
        ostringstream os;

        os << "/* highlight theme: "<<docStyle.getDescription()<<" */\n";

        string classNameSuffix;
        if (!cssClassName.empty())
            classNameSuffix="."+cssClassName;

        os  << "body"<<classNameSuffix;

        os  <<"\t{ background-color:#"
            << ( docStyle.getBgColour().getRed ( HTML ) )
            << ( docStyle.getBgColour().getGreen ( HTML ) )
            << ( docStyle.getBgColour().getBlue ( HTML ) )
            << "; }\n";

        os << ( (orderedList) ? "ol" : "pre" ) << classNameSuffix;

        os << "\t{ color:#"
           << ( docStyle.getDefaultStyle().getColour().getRed ( HTML ) )
           << ( docStyle.getDefaultStyle().getColour().getGreen ( HTML ) )
           << ( docStyle.getDefaultStyle().getColour().getBlue ( HTML ) )
           << "; background-color:#"
           << ( docStyle.getBgColour().getRed ( HTML ) )
           << ( docStyle.getBgColour().getGreen ( HTML ) )
           << ( docStyle.getBgColour().getBlue ( HTML ) )
           << "; font-size:" << this->getBaseFontSize();

        os << "pt; font-family:"<<((quoteFont)?"'":"") << getBaseFont() << ((quoteFont)?"'":"")
           << "; white-space: pre-wrap; }\n";

        os  << getAttributes ( STY_NAME_NUM, docStyle.getNumberStyle() )
            << getAttributes ( STY_NAME_ESC, docStyle.getEscapeCharStyle() )
            << getAttributes ( STY_NAME_STR, docStyle.getStringStyle() )
            << getAttributes ( STY_NAME_DST, docStyle.getPreProcStringStyle() )
            << getAttributes ( STY_NAME_SLC, docStyle.getSingleLineCommentStyle() )
            << getAttributes ( STY_NAME_COM, docStyle.getCommentStyle() )
            << getAttributes ( STY_NAME_DIR, docStyle.getPreProcessorStyle() )
            << getAttributes ( STY_NAME_SYM, docStyle.getOperatorStyle() )
            << getAttributes ( STY_NAME_IPL, docStyle.getInterpolationStyle() )
            << getAttributes ( STY_NAME_LIN, docStyle.getLineStyle() )
            << getAttributes ( STY_NAME_HVR, docStyle.getHoverStyle() )
            << getAttributes ( STY_NAME_ERM, docStyle.getErrorMessageStyle() )
            << getAttributes ( STY_NAME_ERR, docStyle.getErrorStyle() );

        KeywordStyles styles = docStyle.getKeywordStyles();
        for ( KSIterator it=styles.begin(); it!=styles.end(); it++ ) {
            os << getAttributes ( it->first, it->second );
        }
        styleDefinitionCache=os.str();
    }
    return styleDefinitionCache;
}

string HtmlGenerator::maskCharacter ( unsigned char c )
{
    switch ( c ) {
    case '<' :
        return "&lt;";
        break;
    case '>' :
        return "&gt;";
        break;
    case '&' :
        return "&amp;";
        break;
    case '\"' :
        return "&quot;";
        break;
    case '\'' :
        return "&#39;"; // &apos; not supported by w3m
        break;

    case '@' :
        return "&#64;";
        break;

    default :
        return string ( 1, c );
    }
}

string HtmlGenerator::getNewLine()
{
    ostringstream ss;

    printSyntaxError(ss);

    if ( showLineNumbers && orderedList ) ss << "</li>";
    if ( printNewLines ) ss << "\n";
    return ss.str();
}

void HtmlGenerator::insertLineNumber ( bool insertNewLine )
{
    if ( insertNewLine ) {

        if (currentSyntax->getDecorateLineEndFct()) {
            Diluculum::LuaValueList res=callDecorateLineFct(false);
            if (res.size()==1) {
                wsBuffer +=res[0].asString();
            }
        }

        wsBuffer += getNewLine();
    }

    if (currentSyntax->getDecorateLineBeginFct()) {
        Diluculum::LuaValueList res=callDecorateLineFct(true);
        if (res.size()==1) {
            wsBuffer +=res[0].asString();
        }
    }

    if ( showLineNumbers ) {
        ostringstream numberPrefix;
        int lineNo = lineNumber+lineNumberOffset;

        string lineID;
        //attach Anchor only if we're in a new line.
        if ( attachAnchors && numberCurrentLine ) {
            ostringstream idStream;
            idStream << " id=\"" << anchorPrefix << "_" << lineNo << "\"";
            lineID = idStream.str();
        }

        if ( orderedList ) {
            if ( useInlineCSS ) {
                bool quoteFont=getBaseFont().find_first_of(",'")==string::npos;
                numberPrefix<< "<li"
                            << lineID
                            << " style=\""
                            << getAttributes ( "", docStyle.getLineStyle() )
                            << "; font-size:" << this->getBaseFontSize()
                            << "pt; font-family:"<<((quoteFont)?"'":"")
                            << getBaseFont() << ((quoteFont)?"'":"")
                            << ";\">";
            } else {
                if (!cssClassName.empty())
                    numberPrefix<<"<li"
                                << lineID
                                << " class=\""<<cssClassName<<"\">";
                else
                    numberPrefix<<"<li"
                                << lineID
                                << ">";
            }
        }

        if ( !orderedList ) {
            //if we're in a wrapped line, don't fill with zeroes.
            ostringstream os;
            if ( lineNumberFillZeroes && numberCurrentLine ) {
                os.fill ( '0' );
            }

            os << setw ( getLineNumberWidth() ) << right;
            //if we're in a wrapped line, don't attach lineNo.
            if ( numberCurrentLine ) {
                os << lineNo;
            } else {
                os << "";
            }

            string tagOpen=openTags[LINENUMBER];
            numberPrefix << tagOpen.insert(tagOpen.size()-1, lineID)
                         << os.str()
                         << spacer
                         << closeTags[LINENUMBER];
        }
        wsBuffer += numberPrefix.str();
    }
}

bool HtmlGenerator::printIndexFile ( const vector<string> &fileList,
                                     const string &outPath )
{
    string suffix = fileSuffix;
    string outFilePath(outPath);
    string fileName = "index" + suffix;
    if (outFilePath.size()==0 || outFilePath[outFilePath.size()-1] == Platform::pathSeparator)
        outFilePath.append(fileName);

    ofstream indexfile ( outFilePath.c_str() );

    if ( !indexfile.fail() ) {
        string inFileName;
        string inFilePath, newInFilePath;
        std::set<string> usedFileNames;
        indexfile << getHeaderStart ( "Source Index" );
        indexfile << "</head>\n<body>\n<h1>Source Index</h1>\n"
                  << hrTag
                  <<  "\n<ul>\n";

        string::size_type pos;
        for ( unsigned int i=0; i < fileList.size();  i++ ) {
            pos= ( fileList[i] ).find_last_of ( Platform::pathSeparator );
            if ( pos!=string::npos ) {
                newInFilePath = ( fileList[i] ).substr ( 0, pos+1 );
            } else {
                newInFilePath=Platform::pathSeparator;
            }
            if ( newInFilePath!=inFilePath ) {
                indexfile << "</ul>\n<h2>";
                indexfile << newInFilePath;
                indexfile << "</h2>\n<ul>\n";
                inFilePath=newInFilePath;
            }
            inFileName = ( fileList[i] ).substr ( pos+1 );

            if (usedFileNames.count(inFileName)) {
                string prefix=fileList[i].substr (0, pos+1 );
                replace (prefix.begin(), prefix.end(), Platform::pathSeparator, '_');
                inFileName.insert(0, prefix);
            } else {
                usedFileNames.insert(inFileName);
            }

            indexfile << "<li><a href=\"" << inFileName << suffix << "\">";
            indexfile << inFileName << suffix <<"</a></li>\n";
        }

        indexfile << "</ul>\n";
        if (!omitVersionComment) {
            indexfile << hrTag << brTag
                    << "<small>Generated by highlight "
                    << highlight::Info::getVersion()
                    << ", <a href=\"" << highlight::Info::getWebsite() << "\" target=\"new\">"
                    << highlight::Info::getWebsite() << "</a></small>";
        }
        indexfile << "</body></html>\n";
    } else {
        return false;
    }
    return true;
}

string HtmlGenerator::getKeywordOpenTag ( unsigned int styleID )
{
    if ( useInlineCSS ) {
        return getOpenTag ( docStyle.getKeywordStyle ( currentSyntax->getKeywordClasses() [styleID] ) );
    }
    return getOpenTag ( currentSyntax->getKeywordClasses() [styleID] );
}

string HtmlGenerator::getKeywordCloseTag ( unsigned int styleID )
{
    return "</span>";
}

void HtmlGenerator::setHTMLOrderedList ( bool b )
{
    orderedList = b;
    if ( b ) spacer = "&nbsp;";
    maskWs = b;

    if (b && !preFormatter.getReplaceTabs()) {
        preFormatter.setReplaceTabs ( true );
        preFormatter.setNumberSpaces ( 4 );
    }
}

string HtmlGenerator::getHoverTagOpen(const string & hoverText)
{
    ostringstream os;
    if ( useInlineCSS ) {
        os << "<span style=\""<<getAttributes ( "", docStyle.getHoverStyle() ) << "\" title=\""<<hoverText<<"\">";
    } else {
        os << "<span class=\""<< (cssClassName.empty() ? "":cssClassName+ " ")  << STY_NAME_HVR << "\" title=\""<<hoverText<<"\">";
    }
    return os.str();
}

string HtmlGenerator::getHoverTagClose()
{
    return "</span>";
}

}
