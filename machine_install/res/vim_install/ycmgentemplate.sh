cat > .ycm_extra_conf.py<<EOF
import os
import ycm_core

flags = [
        '-Wall',
        '-Wextra',
        '-Werror',
        ]

def Settings( **kwargs ):
    return {
            'flags': flags,
            'include_paths_relative_to_dir': os.path.dirname( os.path.abspath( __file__ ) )
            }
EOF

dirs=$(find * -type d)
template_flags=''
for dir_one in $dirs
do
	template_flags+="\'-I\',\n\'${dir_one}\',\n"
done
eval sed -i "/-Werror/a\${template_flags}" .ycm_extra_conf.py
