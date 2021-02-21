
include funcs.mk

var := $(abspath ./)

define test_fun1
echo func name = $(0)
echo arg1 = $(1)
echo arg2 = $(2)
endef

define dirs1
$(addprefix -I,$(basename $(1)))
endef

var1 := $(call test_fun1,in1,in2)
var2 := $(call dirs1,/home/cliff/tmp)
dirs_s :=$(shell find * -type d)
match = $(shell echo $(2) | awk '{for(i=1;i<NF;i++){if(match("$(1)","^"$$(i)"$$")){exit 1;}}}'; echo $$?)
$(call cc_compile,/home/cliff/tmp/1.c,gcc)

test:
	@echo $(dir /home/cliff/tmp)
	@echo =============
	@echo $(var)
	@echo =============
	@echo $(var1)
	@echo =============
	@$(call var1)
	@echo =============
	@echo $(var2)
	@echo =============
	@echo $(dirs_s)
	@echo =============
	@echo $(addprefix -I,$(dirs_s))
