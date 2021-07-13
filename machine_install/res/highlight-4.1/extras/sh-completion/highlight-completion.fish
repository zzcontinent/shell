#/usr/bin/env fish

# /usr/share/fish/completions/
# Fish command completion script

complete -c highlight -s B -l batch-recursive -d "convert all matching files, searches subdirs"
complete -c highlight -s D -l data-dir -d " set path to data directory"
complete -c highlight -l  config-file -d "set path to a lang or theme file"
complete -c highlight -s d -l outdir -d "name of output directory"
complete -c highlight -s h -l help -d "print help or a topic description"
complete -c highlight -s i -l input -d "name of single input file"
complete -c highlight -s o -l output -d "name of single output file"
complete -c highlight -s P -l progress -d "print progress bar in batch mode"
complete -c highlight -s q -l quiet -d "suppress progress info in batch mode"
complete -c highlight -s S -l syntax= -d "specify type of source code"
complete -c highlight -l  syntax-by-name -d "specify type of source code by given name"
complete -c highlight -s v -l verbose -d "print debug info"
complete -c highlight -l  force -d "generate output if input syntax is unknown"
complete -c highlight -l  list-scripts -d "list installed scripts"
complete -c highlight -l  list-cat -d "filter the scripts by the given categories"
complete -c highlight -l  plug-in -d "execute Lua plug-in script; repeat option to"
complete -c highlight -l  plug-in-param -d "set plug-in input parameter"
complete -c highlight -l  print-config -d "print path configuration"
complete -c highlight -l  print-style -d "print stylesheet only "
complete -c highlight -l  skip -d "ignore listed unknown file types"
complete -c highlight -l  stdout -d "output to stdout "
complete -c highlight -l  validate-input -d "test if input is text, remove Unicode BOM"
complete -c highlight -l  version -d "print version and copyright information"
complete -c highlight -s O -l out-format -d " output file in given format"
complete -c highlight -s c -l style-outfile -d "name of style file"
complete -c highlight -s f -l fragment -d " omit document header and footer"
complete -c highlight -s F -l reformat -d " reformats and indents output in given style"
complete -c highlight -l  reformat-option -d "apply an astyle cmd line option "
complete -c highlight -s I -l include-style -d "include style definition in output file"
complete -c highlight -s J -l line-length -d "line length before wrapping (-V, -W)"
complete -c highlight -s j -l line-number-length -d "line number width incl. left padding (default: 5)"
complete -c highlight -l  line-range -d "output only lines from number <start> to <end>"
complete -c highlight -s k -l font -d "set font (specific to output format)"
complete -c highlight -s K -l font-size -d "set font size (specific to output format)"
complete -c highlight -s l -l line-numbers -d "print line numbers in output file"
complete -c highlight -s m -l line-number-start -d " start line numbering with cnt"
complete -c highlight -s s -l style -d "set colour theme"
complete -c highlight -s t -l replace-tabs -d "replace tabs by <num> spaces"
complete -c highlight -s T -l doc-title= -d "document title"
complete -c highlight -s u -l encoding -d "set output encoding which matches input file encoding"
complete -c highlight -s V -l wrap-simple -d "wrap lines without indenting"
complete -c highlight -s W -l wrap -d "wrap lines "
complete -c highlight -l  wrap-no-numbers -d "omit line numbers of wrapped lines"
complete -c highlight -s z -l zeroes -d "pad line numbers with zeroes"
complete -c highlight -l  base16 -d "use a theme of the Base16 collection"
complete -c highlight -l  delim-cr -d "set CR as end-of-line delimiter "
complete -c highlight -l  keep-injections -d "output plug-in injections in spite of -f"
complete -c highlight -l  kw-case= -d "change case of case insensitive keywords"
complete -c highlight -l  no-trailing-nl -d "omit trailing newline"
complete -c highlight -l  no-version-info -d "omit version info comment"
complete -c highlight -s a -l anchors -d "attach anchor to line numbers"
complete -c highlight -s y -l anchor-prefix= -d "set anchor name prefix"
complete -c highlight -s N -l anchor-filename -d "use input file name as anchor prefix"
complete -c highlight -s C -l print-index -d "print index with hyperlinks to output files"
complete -c highlight -s n -l ordered-list -d "print lines as ordered list items"
complete -c highlight -l  class-name -d "set CSS class name prefix;"
complete -c highlight -l  inline-css -d "output CSS within each tag (verbose output)"
complete -c highlight -l  enclose-pre -d "enclose fragmented output with pre tag "
complete -c highlight -s b -l babel -d "disable Babel package shorthands"
complete -c highlight -s r -l replace-quotes -d "replace double quotes by \dq{}"
complete -c highlight -l  beamer -d "adapt output for the Beamer package"
complete -c highlight -l  pretty-symbols -d "improve appearance of brackets and other symbols"
complete -c highlight -l  page-color -d " include page color attributes"
complete -c highlight -s x -l page-size -d "set page size "
complete -c highlight -l  char-styles -d "include character stylesheets"
complete -c highlight -l  height -d "set image height"
complete -c highlight -l  width -d "set image width "
complete -c highlight -l  canvas -d "set background colour padding"
