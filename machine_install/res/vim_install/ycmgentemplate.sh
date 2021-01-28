cat > .ycm_extra_conf.py<<EOF
import os
import ycm_core

flags = [
        '-Wall',
        '-Wno-implicit-function-declaration',
        '-Wextra',
        '-Werror',
        '-I',
        './kern/',
        '-I',
        './kern/debug',
        '-I',
        './kern/driver',
        '-I',
        './kern/mm',
        '-I',
        './kern/trap',
        '-I',
        './libs/',
        '-I',
        './boot/',
        ]

def Settings( **kwargs ):
    return {
            'flags': flags,
            'include_paths_relative_to_dir': os.path.dirname( os.path.abspath( __file__ ) )
            }
EOF
