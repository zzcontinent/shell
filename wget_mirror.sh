[ -z $1 ] && echo "input websit!" && exit 1
wget -c --mirror --convert-links --adjust-extension --page-requisites --no-parent -e robots=off "$1"
