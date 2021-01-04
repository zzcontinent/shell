#!/bin/bash
# common env ----------------------------------
TOPDIR="$(dirname $0)"
cd $TOPDIR

RUN_FILE=run.sh
RES_DIR=res
OUT_PACK=out_run

func_gen_run_template()
{
	echo "+++ func_gen_run_template +++"
	[ -f $RUN_FILE ] && echo "no need gen_template, $RUN_FILE exists!" && return 0
	echo -n '#!/bin/bash
FILE_LEN=33

# common env ----------------------------------
TOPDIR="$(dirname $0)"
cd $TOPDIR

RUN_FILE=run.sh
RES_DIR=res
OUT_PACK=out_run

func_unpack()
{
	echo "+++ func_unpack +++"
	tail -n +`expr $FILE_LEN + 1` $OUT_PACK > $RES_DIR.tgz
	rm -r $RES_DIR
	tar -zxvf $RES_DIR.tgz
	rm $RES_DIR.tgz 2>/dev/null
}

func_run()
{
	echo "+++ func_run +++"
}

func_unpack
func_run

exit 0
' > $RUN_FILE
	chmod +x $RUN_FILE
}

func_update_run_file(){
	echo "+++ func_update_run_file +++"
	sed -i '/^FILE_LEN=/d' $RUN_FILE
	sed -i '/^exit 0$/d' $RUN_FILE
	echo "exit 0" >> $RUN_FILE
	RUN_FILE_LEN="`wc -l $RUN_FILE |awk '{print $1}'`"
	SED_CMD='1a\FILE_LEN='`expr $RUN_FILE_LEN + 1`
	sed -i $SED_CMD $RUN_FILE
}

func_pack(){
	echo "+++ func_pack +++"
	rm $RES_DIR.tgz 2>/dev/null
	tar -zcf $RES_DIR.tgz $RES_DIR
	[ -e $RES_DIR.tgz ] || (echo 'tar error!' && exit 1)

	cat $RUN_FILE $RES_DIR.tgz > $OUT_PACK
	chmod +x $OUT_PACK
	rm $RES_DIR.tgz 2>/dev/null
}
func_cleanup()
{
	rm $OUT_PACK
	return 0
}

func_gen_run_template
func_update_run_file
func_pack

