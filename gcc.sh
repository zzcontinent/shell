#!/bin/bash
#预处理
#gcc -E xx.c
#预处理+编译
#gcc -S hello.c
#预处理,编译,和汇编
#gcc -c xxx.c

#-C
#在预处理的时候,不删除注释信息,一般和-E使用,有时候分析程序，用这个很方便的。

#-M
#生成文件关联的信息。包含目标文件所依赖的所有源代码你可以用gcc -M hello.c来测试一下，很简单。

#-MM
#和上面的那个一样，但是它将忽略由#include<file>造成的依赖关系。

#-MD
#和-M相同，但是输出将导入到.d的文件里面

#-MMD
#和-MM相同，但是输出将导入到.d的文件里面。

#-D macro=defn
#相当于C语言中的#define macro=defn

#-D macro
#相当于C语言中的#define macro

#U macro
#相当于C语言中的#undef macro

#-undef
#取消对任何非标准宏的定义

#取消stdlib
#-nostdlib (Do not use the standard system startup files or libraries when linking)

#static m32
#gcc -m32 -static xxx.c
