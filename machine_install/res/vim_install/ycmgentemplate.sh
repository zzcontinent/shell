cat > .ycm_extra_conf.py<<EOF
import os
import ycm_core
import os.path as p

DIR_OF_THIS_SCRIPT = p.abspath( p.dirname( __file__ ) )
DIR_OF_THIRD_PARTY = p.join( DIR_OF_THIS_SCRIPT, 'third_party' )
DIR_OF_WATCHDOG_DEPS = p.join( DIR_OF_THIRD_PARTY, 'watchdog_deps' )


flags = [
        '-Wall',
        '-Wextra',
        '-Werror',
        ]

def Settings( **kwargs ):
    language = kwargs[ 'language' ]
    if language == 'python':
      client_data = kwargs[ 'client_data' ]
      return {
            'flags': flags,
            'interpreter_path': client_data[ 'g:ycm_python_interpreter_path' ],
            'sys_path': client_data[ 'g:ycm_python_sys_path' ]
            }
    return {
            'flags': flags,
            'include_paths_relative_to_dir': p.dirname( p.abspath( __file__ ) )
            }


def PythonSysPath( **kwargs ):
  sys_path = kwargs[ 'sys_path' ]

  interpreter_path = kwargs[ 'interpreter_path' ]

  sys_path[ 0:0 ] = [ p.join( DIR_OF_THIS_SCRIPT ),
  ]

  sys_path.append( p.join( DIR_OF_THIRD_PARTY, 'jedi_deps', 'numpydoc' ) )
  return sys_path

EOF

dirs=$(find * -type d -exec echo `pwd`/{} \;)
cnt=`echo $dirs | wc -w`
cnt_cur=1
for dir_one in $dirs
do
	printf "\r [$cnt_cur/$cnt] $dir_one"
	sed -i "36a\p\.join\(\'${dir_one}\'\)," .ycm_extra_conf.py
	cnt_cur=`expr $cnt_cur + 1`
done
echo

cnt_cur=1
for dir_one in $dirs
do
	printf "\r [$cnt_cur/$cnt] $dir_one"
	sed -i "13a\\'-I\',\n\'${dir_one}\'," .ycm_extra_conf.py
	cnt_cur=`expr $cnt_cur + 1`
done
echo

