
> author yeshen  
> date 2021.7.23

# common use of gdb

## prepare

compile a program with -g, then start it with gdb:

```c
/* hello.c */
#include <stdio.h>
int main(int argc, char *argv[])
{
  printf("hello world\n");
  return 0;
}
```
`gcc -m32 -g hello.c -o hello`  
`gdb ./hello`

## info

```c
/* 显示所有寄存器的值 */
info all
/* 显示常用寄存器 */
info register

/* 可执行文件的简单信息 */
info target

/* 显示断点信息 */
info break

/* 比info target更详细的信息 */
maint info sections
maint info sections .data .bss
maint info sections ALLOC

/* 查看函数地址 */
info functions

/* 查看变量 */
info variables

```

## disassemble

```c

/* 反汇编函数 */
disassemble main
disassemble /s main   //显示源代码
disassemble /rs main   //显示源代码和16进制代码
disassemble /rs 'hello.c'::main   //显示特定源文件中的特定函数

```

## x

`显示指定内存地址的内容`

```c
注：addr-label是addr或者label，&label和label一样
x addr-label  //按上次的模式显示一个
x/10b addr-label  //byte
x/10w addr-label  //word
x/10c addr-label  //char
x/10x addr-label  //hex
x/10d addr-label  //decimal
x/10o addr-label  //octal
x/10i addr-label  //显示addr处的10个指令
x/s addr-label  //string
x/i $eip  //显示寄存器的值作为地址的内容
```

## print/p

`显示指定寄存器或变量的内容或者获取label处的地址`

```c
print/x $eax
print/t $eax  //二进制
print/d $eax
print label //显示label处的地址
print variable //显示变量的值

```

## break/b

```c
b number  //源代码行号
b *addr
b label
b file:number
b file:label

```

## next/n

`跳过函数的单步执行`

## step/s

`陷入函数的单步执行`

## bt

`显示当前栈帧`

