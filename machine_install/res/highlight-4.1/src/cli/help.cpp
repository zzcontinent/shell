/***************************************************************************
                          help.cpp  -  description
                             -------------------
    begin                : Die Apr 23 2002
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

#include <iostream>
#include "help.h"

using namespace std;

namespace Help
{
void printHelp(const std::string &topic)
{
    if (topic=="syntax" || topic=="lang")  {
        cout <<"SYNTAX HELP:\n\n";
        cout <<"A language definition describes syntax elements of a programming language which\n";
        cout <<"will be highlighted by different colours and font types.\n";
        cout <<"\n";
        cout <<"These definitions are saved as Lua scripts in HL_DATA_DIR/langDefs.\n";
        cout <<"File extensions and shebangs are mapped to language definitions in \n";
        cout <<"filetypes.conf (see --print-config for the configuration search paths).\n";
        cout <<"\n";
        cout <<"Apply custom language definitions with --config-file or as absolute path to -S.\n";
        cout <<"\n";
        cout <<"Use plug-in scripts (--plug-in) to modify syntax parsing and output.\n";
        cout <<"\n";
        cout <<"Print all installed language definitions with --list-scripts=langs.\n";
        cout <<"\n";
        cout <<"Exemplary config files:\n";
        cout <<"c.lang:      C and C++ syntax file (compiled sources) \n";
        cout <<"python.lang: Python syntax file    (script sources)\n";
        cout <<"ini.lang:    INI syntax file       (configuration)\n";
        cout <<"xml.lang:    XML syntax file       (markup)\n";
        cout <<"\n";
        cout <<"Refer to README files for configuration syntax and examples.\n";

    } else if (topic=="theme") {
        cout <<"THEME HELP:\n\n";
        cout <<"A colour theme defines the formatting of recognized syntax elements.\n";
        cout <<"\n";
        cout <<"These descriptions are saved as Lua scripts in HL_DATA_DIR/themes.\n";
        cout <<"\n";
        cout <<"Apply custom themes with --config-file or as absolute path to --theme.\n";
        cout <<"\n";
        cout <<"Use plug-in scripts (--plug-in) to modify the formatting output.\n";
        cout <<"\n";
        cout <<"Print all installed themes with --list-scripts=themes.\n";
        cout <<"\n";
        cout <<"Add 'base16/' as prefix to read a theme of the Base16 set.\n";
        cout <<"\n";
        cout <<"Exemplary config files:\n";
        cout <<"darkspectrum.theme: dark canvas (vim) \n";
        cout <<"edit-eclipse:       light canvas (IDE)\n";
        cout <<"bespin.lang:        dark canvas  (Base16)\n";
        cout <<"\n";
        cout <<"Refer to README files for configuration syntax and examples.\n";

    } else if (topic=="config") {
        cout <<"CONFIG HELP:\n\n";
        cout <<"Highlight is configured by a set of Lua scripts and environment variables.\n";
        cout <<"See --print-config for the configuration file search paths.\n\n";
        cout <<"List of environment variables:\n";
        cout <<"HIGHLIGHT_DATADIR: sets the path to highlight's configuration scripts\n";
        cout <<"HIGHLIGHT_OPTIONS: may contain command line options, but no input file paths\n\n";
        cout <<"Highlight reads TERM and COLORTERM to determine the appropriate default output.\n";
    } else if (topic=="plugin" || topic=="plug-in") {
        cout <<"PLUG-IN HELP:\n\n";
        cout <<"The plug-in interface allows modifications of syntax parsing, colouring and\n";
        cout <<"the document's header and footer.\n";
        cout <<"\n";
        cout <<"The --plug-in option reads the path of a Lua script which overrides or\n";
        cout <<"enhances the settings of theme and language definition files. Plug-ins make\n";
        cout <<"it possible to apply custom settings without the need to edit installed\n";
        cout <<"configuration files.\n";
        cout <<"You can apply multiple plugins by using the --plug-in option more than once.\n";
        cout <<"\n";
        cout <<"Pass arguments to a plug-in with --plug-in-param.\n";
        cout <<"\n";
        cout <<"Print all installed themes with --list-scripts=plugins.\n";
        cout <<"\n";
        cout <<"Exemplary config files:\n";
        cout <<"cpp_qt.lua:             Add Qt keywords to C and C++ (simple structure)\n";
        cout <<"outhtml_codefold.lua:   Adds code folding for C style languages, and more (advanced)\n";
        cout <<"bash_ref_man7_org.lua:  Add man7.org reference links to Bash output (advanced)\n";
        cout <<"\n";
        cout <<"See README_PLUGINS.adoc for a detailed description and examples of packaged plugins.\n";

    } else if (topic=="test") {
        cout <<"SYNTAX TEST HELP:\n\n";
        cout <<"The syntax parsing can be validated with test state indicators embedded in comments.\n";
        cout <<"These are recognized in files saved as syntax_test_*.\n\n";
        cout <<"A test case is defined by two entities: column and expected state.\n";
        cout <<"The column is defined by ^ (here) or < (comment start / first column).\n";
        cout <<"This indicator points at the tested syntax element of the previous line.\n";
        cout <<"The state identifiers match the corresponding HTML output CSS class names.\n\n";
        cout <<"See README_TESTCASES.adoc for a detailed description and examples.\n";
    } else if (topic=="lsp") {
        cout <<"LANGUAGE SERVER PROTOCOL HELP:\n\n";
        cout <<"Highlight can invoke LSP servers to enhance its output. Warning: These features are WIP.\n";
        cout <<"Language servers are be configured in the lsp.conf file. Each parameter of this file\n";
        cout <<"can also be set using --ls-exec, --ls-option, --ls-delay and --ls-syntax.\n";
        cout <<"Important: LSP features require absolute input paths and disable reformatting (-F).\n";
    } else {
        cout<<"USAGE: highlight [OPTIONS]... [FILES]...\n";
        cout<<"\n";
        cout<<"General options:\n";
        cout<<"\n";
        cout<<" -B, --batch-recursive=<wc>     convert all matching files, searches subdirs\n";
        cout<<"                                  (Example: -B '*.cpp')\n";
        cout<<" -D, --data-dir=<directory>     set path to data directory\n";
        cout<<"     --config-file=<file>       set path to a lang or theme file\n";
        cout<<" -d, --outdir=<directory>       name of output directory\n";
        cout<<" -h, --help[=topic]             print this help or a topic description\n";
        cout<<"                                  <topic> = [syntax, theme, plugin, config, test, lsp]\n";
        cout<<" -i, --input=<file>             name of single input file\n";
        cout<<" -o, --output=<file>            name of single output file\n";
        cout<<" -P, --progress                 print progress bar in batch mode\n";
        cout<<" -q, --quiet                    suppress progress info in batch mode\n";
        cout<<" -S, --syntax=<type|path>       specify type of source code or syntax file path\n";
        cout<<"     --syntax-by-name=<name>    specify type of source code by given name\n";
        cout<<"                                  will not read a file of this name, useful for stdin\n";
        cout<<"     --syntax-supported         test if the given syntax can be loaded\n";
        cout<<" -v, --verbose                  print debug info; repeat to show more information\n";
        cout<<"     --force[=syntax]           generate output if input syntax is unknown\n";
        cout<<"     --list-scripts=<type>      list installed scripts\n";
        cout<<"                                  <type> = [langs, themes, plugins]\n";
        cout<<"     --list-cat=<categories>    filter the scripts by the given categories\n";
        cout<<"                                  (example: --list-cat='source;script')\n";
        cout<<"     --max-size=<size>          set maximum input file size\n";
        cout<<"                                  (examples: 512M, 1G; default: 256M)\n";
        cout<<"     --plug-in=<script>         execute Lua plug-in script; repeat option to\n";
        cout<<"                                  execute multiple plug-ins\n";
        cout<<"     --plug-in-param=<value>    set plug-in input parameter\n";
        cout<<"     --print-config             print path configuration\n";
        cout<<"     --print-style              print stylesheet only (see --style-outfile)\n";
        cout<<"     --skip=<list>              ignore listed unknown file types\n";
        cout<<"                                  (Example: --skip='bak;c~;h~')\n";

        cout<<"     --stdout                   output to stdout (batch mode, --print-style)\n";
        cout<<"     --validate-input           test if input is text, remove Unicode BOM\n";
        cout<<"     --version                  print version and copyright information\n";
        cout<<"\n\n";
        cout<<"Output formatting options:\n";
        cout<<"\n";
        cout<<" -O, --out-format=<format>      output file in given format\n";
        cout<<"                                  <format>=[html, xhtml, latex, tex, odt, rtf,\n";
        cout<<"                                  ansi, xterm256, truecolor, bbcode, pango, svg]\n";
        cout<<" -c, --style-outfile=<file>     name of style file or print to stdout, if\n";
        cout<<"                                  'stdout' is given as file argument\n";

        cout<<" -e, --style-infile=<file>      to be included in style-outfile (deprecated)\n";
        cout<<"                                  use a plug-in file instead\n";

        cout<<" -f, --fragment                 omit document header and footer\n";
        cout<<" -F, --reformat=<style>         reformats and indents output in given style\n";
        cout<<"                                  <style> = [allman, gnu, google, horstmann,\n";
        cout<<"                                  java, kr, linux, lisp, mozilla, otbs, pico,\n";
        cout<<"                                  vtk, ratliff, stroustrup, webkit, whitesmith]\n";

        cout<<" -I, --include-style            include style definition in output file\n";
        cout<<" -J, --line-length=<num>        line length before wrapping (see -V, -W)\n";
        cout<<" -j, --line-number-length=<num> line number width incl. left padding (default: 5)\n";
        cout<<"     --line-range=<start-end>   output only lines from number <start> to <end>\n";

        cout<<" -k, --font=<font>              set font (specific to output format)\n";
        cout<<" -K, --font-size=<num?>         set font size (specific to output format)\n";
        cout<<" -l, --line-numbers             print line numbers in output file\n";
        cout<<" -m, --line-number-start=<cnt>  start line numbering with cnt (assumes -l)\n";
        cout<<" -s, --style=<style|path>       set colour style (theme) or theme file path\n";
        cout<<" -t, --replace-tabs=<num>       replace tabs by <num> spaces\n";
        cout<<" -T, --doc-title=<title>        document title\n";
        cout<<" -u, --encoding=<enc>           set output encoding which matches input file\n";
        cout<<"                                  encoding; omit encoding info if set to NONE\n";
        cout<<" -V, --wrap-simple              wrap lines after 80 (default) characters w/o\n";
        cout<<"                                  indenting function parameters and statements\n";
        cout<<" -W, --wrap                     wrap lines after 80 (default) characters\n";
        cout<<"     --wrap-no-numbers          omit line numbers of wrapped lines\n";
        cout<<"                                  (assumes -l)\n";
        cout<<" -z, --zeroes                   pad line numbers with 0's\n";
        cout<<"     --isolate                  output each syntax token separately (verbose output)\n";
        cout<<"     --keep-injections          output plug-in injections in spite of -f\n";
        cout<<"     --kw-case=<case>           change case of case insensitive keywords\n";
        cout<<"                                  <case> =  [upper, lower, capitalize]\n";
        cout<<"     --no-trailing-nl[=mode]    omit trailing newline. If mode is empty-file, omit\n";
        cout<<"                                  only for empty input\n";
        cout<<"     --no-version-info          omit version info comment\n";

        cout<<"\n\n";
        cout<<"(X)HTML output options:\n";
        cout<<"\n";
        cout<<" -a, --anchors                  attach anchor to line numbers\n";
        cout<<" -y, --anchor-prefix=<str>      set anchor name prefix\n";
        cout<<" -N, --anchor-filename          use input file name as anchor prefix\n";
        cout<<" -C, --print-index              print index with hyperlinks to output files\n";
        cout<<" -n, --ordered-list             print lines as ordered list items\n";
        cout<<"     --class-name=<name>        set CSS class name prefix;\n";
        cout<<"                                  omit class name if set to NONE\n";
        cout<<"     --inline-css               output CSS within each tag (verbose output)\n";
        cout<<"     --enclose-pre              enclose fragmented output with pre tag \n";
        cout<<"                                  (assumes -f)\n";
        cout<<"\n\n";
        cout<<"LaTeX output options:\n";
        cout<<"\n";
        cout<<" -b, --babel                    disable Babel package shorthands\n";
        cout<<" -r, --replace-quotes           replace double quotes by \\dq{}\n";
        cout<<"     --beamer                   adapt output for the Beamer package\n";
        cout<<"     --pretty-symbols           improve appearance of brackets and other symbols\n";
        cout<<"\n\n";
        cout<<"RTF output options:\n";
        cout<<"\n";
        cout<<"     --page-color               include page color attributes\n";
        cout<<" -x, --page-size=<ps>           set page size \n";
        cout<<"                                  <ps> = [a3, a4, a5, b4, b5, b6, letter]\n";
        cout<<"     --char-styles              include character stylesheets\n";
        cout<<"\n\n";
        cout<<"SVG output options:\n";
        cout<<"\n";
        cout<<"     --height                   set image height (units allowed)\n";
        cout<<"     --width                    set image width (see --height)\n";
        cout<<"\n\n";
        cout<<"Terminal escape output options (xterm256 or truecolor):\n";
        cout<<"\n";
        cout<<"     --canvas[=width]           set background colour padding (default: 80)\n";
        cout<<"\n\n";

        cout<<"Language Server options:\n\n";
        cout<<"     --ls-profile=<server>      read LSP configuration from lsp.conf\n";
        cout<<"     --ls-delay=<ms>            set server initialization delay\n";
        cout<<"     --ls-exec=<bin>            set server executable name\n";
        cout<<"     --ls-option=<option>       set server CLI option (can be repeated)\n";
        cout<<"     --ls-hover                 execute hover requests (HTML output only)\n";
        cout<<"     --ls-semantic              retrieve semantic token types (requires LSP 3.16)\n";
        cout<<"     --ls-syntax=<lang>         set syntax which is understood by the server\n";
        cout<<"     --ls-syntax-error          retrieve syntax error information\n";
        cout<<"                                  (assumes --ls-hover or --ls-semantic)\n";
        cout<<"     --ls-workspace=<dir>       set workspace directory to init. the server\n";
        cout<<"\n\n";

        cout<<"If no in- or output files are specified, stdin and stdout will be used.\n";
        cout<<"Reading from stdin can also be triggered using the '-' option.\n";
        cout<<"Default output format: xterm256 or truecolor if appropriate, HTML otherwise.\n";
        cout<<"Style definitions are stored in highlight.css (HTML, XHTML, SVG) or\n";
        cout<<"highlight.sty (LaTeX, TeX) if neither -c nor -I is given.\n";
        cout<<"Reformatting code (-F) will only work with C, C++, C# and Java input files.\n";
        cout<<"LSP features require absolute input paths and disable reformatting (-F).\n";
        cout<<"Wrapping lines with -V or -W will cause faulty highlighting of long single\n";
        cout<<"line comments and directives. Using line-range might interfere with multi\n";
        cout<<"line syntax elements. Use with caution.\n\n";

        cout<<"Run highlight --list-scripts=langs to see all supported syntax types.\n\n";
        cout<<"Refer to README files how to apply plug-ins to customize the output.\n\n";
        cout<<"Updates and information: http://www.andre-simon.de/\n";
    }
}

}
