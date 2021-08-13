
##没有递归的模板
##来自彭东

#执行make时,默认第一个目标all,此时all按次序依次依赖clean build link bin,
#分别代表先清洗残留污垢，编译，连接，二进制转换。

#定义一些辅助操作的命令，比如clean的rm
MAKEFLAGS = -sR
MKDIR = mkdir
RMDIR = rmdir
CP = cp
CD = cd
DD = dd
RM = rm

#定义汇编器，编译器，连接器，二进制转换器
ASM             = nasm
CC              = gcc
LD              = ld
OBJCOPY = objcopy

#定义汇编器，编译器，连接器，二进制转换器的参数
ASMBFLAGS       = -f elf -w-orphan-labels
CFLAGS          = -c -Os -std=c99 -m32 -Wall -Wshadow -W -Wconversion -Wno-sign-conversion  -fno-stack-protector -fomit-frame-pointer -fno-builtin -fno-common  -ffreestanding  -Wno-unused-parameter -Wunused-variable
LDFLAGS         = -s -static -T hello.lds -n -Map HelloOS.map
OJCYFLAGS       = -S -O binary

#定义汇编，编译，连接，二进制转换的目标文件
HELLOOS_OBJS :=
HELLOOS_OBJS += entry.o main.o vgastr.o
HELLOOS_ELF = HelloOS.elf
HELLOOS_BIN = HelloOS.bin

#声明伪目标，make 伪目标总是被执行，无论该伪目标依赖其他伪目标还是不依赖东西
.PHONY : build clean all link bin

all: clean build link bin

#清除上次编译生成的目标文件，连接和转换后的elf和bin
clean:
        $(RM) -f *.o *.bin *.elf

#编译HELLOOS_OBJS中定义的目标文件，它使用下面的两条规则
build: $(HELLOOS_OBJS)

#连接HELLOOS_OBJS得到HELLOOS_ELF
link: $(HELLOOS_ELF)
$(HELLOOS_ELF): $(HELLOOS_OBJS)
        $(LD) $(LDFLAGS) -o $@ $(HELLOOS_OBJS)

#二进制转换HELLOOS_ELF得到HELLOOS_BIN
bin: $(HELLOOS_BIN)
$(HELLOOS_BIN): $(HELLOOS_ELF)
        $(OBJCOPY) $(OJCYFLAGS) $< $@

#$@:目标
#$<:第一个依赖
#$^:所有依赖
%.o : %.asm
        $(ASM) $(ASMBFLAGS) -o $@ $<
%.o : %.c
        $(CC) $(CFLAGS) -o $@ $<



##有递归的模板
##来自韦东山





##内核模块makefile模板
##来自altera

#Name of the module
obj-m := rd_f2sm_rand.o

#Files composing the module
rd_f2sm_rand-objs :=  f2sm_rdev_ko.o

#guest architecture
ARCH := arm

#compiler
CROSS_COMPILE := /home/hanglory/tongdj/V3.0/buildroot/toolchain/bin/arm-linux-gnueabihf-

#path to the compiled kernel
ROOTDIR := /home/hanglory/yezheng/linux-socfpga

#path to install the modules
MODDIR := /home/hanglory/nfs_share/yz

#cross compile
MAKEARCH := $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)

KDIR ?= $(ROOTDIR)

default:
    $(MAKEARCH) -C $(KDIR) M=${shell pwd}

clean:
    $(MAKEARCH) -C $(KDIR) M=${shell pwd} clean

help:
    $(MAKEARCH) -C $(KDIR) M=${shell pwd} help

modules:
    $(MAKEARCH) -C $(KDIR) M=${shell pwd} modules

modules_install:
    $(MAKEARCH) -C $(KDIR) M=${shell pwd} INSTALL_MOD_PATH=$(MODDIR) modules_install




