#反汇编(-S 源码,-D 所有)
objdump -S -D xxx.out | less

#提取反汇编
objdump -S xxx.out > xxx.asm

#删除调试信息
objcopy -S -O binary xxx yyy (去掉elf的header等信息)
objcopy -S xxx yyy

#提取调试信息
objcopy --only-keep-debug t t.debuginfo

#添加调试信息
objcopy --add-gnu-debuglink=t.debuginfo t

#gdb 添加符号表信息
gdb inner cmd: add-symbol-file xxx.o

#查看所有header，查看动态库
objdump -x xxx | grep NEED

#查看elf header
readelf -h xxx
readelf -l xxx (program header) (包括装载器)

#查看依赖库ldd xxx
ldd xxx

