[ -z $1 ] && echo "input websit!" && exit 1
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent -e robots=off "$1"
