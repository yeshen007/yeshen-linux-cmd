> author -- leaf god  
> data -- 2021.6.26  

# This project is just for recording the common used method for common used linux comands.


## MISC

```c
/* -e识别转义字符 */
echo -e "1 2 3\n4 5 6" > log.txt

/* 配置静态或者dhcp动态ip */
/etc/network/interfaces
auto eth0
iface eth0 inet static
address 192.168.8.123
netmask 255.255.255.0
gateway 192.168.8.1
#iface eth0 inet dhcp //dhcp

/* 网络配置文件 */
/etc/resolv.conf
/etc/dhcp/dhcpd.conf
/etc/dhcp/dhclient.conf
/etc/dhcpcd.conf
/etc/network/interfaces
/etc/hosts

/* 权限文件 */
/etc/passwd
/etc/shadow
/etc/group
/etc/sudoers


/* 启动环境变量设置文件 */
/etc/profile    //设定的变量能用于所有用户    
/etc/profile.d
$HOME/.bashrc   
$HOME/.profile  //和.bashrc实际效果差不多


/* 重定向 */
# <等于0<, >等于1>
cmd 2> file //标准错误重定向到file
cmd &> file //标准输出和标准错误都重定向到file
cmd >&2 //标准输出重定向到文件描述符2即标准输出上

# 永久重定向
exec 

/* x86汇编 */
# call
1.push addr of next instruction
2.make the pc point to the addr of the function being called

# leave
1.mov ebp esp
2.pop ebp

# ret
1.pop the top element of stack to pc

# label
label:
...
mov eax, label    //将label处的地址读到eax
mov eax, [label]  //将label处的内容读到eax
mov $label, %eax  //将label处的地址读到eax
mov label, %eax   //将label处的内容读到eax

# PTR
WORD PTR [ax] //ax的值作为地址存放的一个字
WORD PTR label //label处存放的一个字
WORD PTR label + 2  //label接下来的第二个字节地址处存放的一个字
mov eax, dword ptr [ebx] //intel
movl (%ebx), %eax //at&t

# addressing
mov eax, 8 //intel格式的十进制立即数寻址
mov $8, %eax //at&t格式的十进制立即数寻址
mov eax, ffffh //intel格式的16进制立即数寻址
mov $0xffff, %eax //at&t格式的16进制立即数寻址
base(offset, index, size) //at&t,其中base是立即数或者label，label表示label处的地址
[base + offset + index*size] //intel

```


## A

### adduser

```c
useradd user
useradd -g group user
useradd -d /home/user user

```

### addgroup

```c
//创建一个新的组，组id为id
addgroup -g id group

```

### apt

```c

apt update
apt upgrade [package-name]
apt install packeage-name
apt remove package-name
apt purge package-name
apt autoremove
apt list
apt list --installed
apt list --upgradeable
apt show package-name

```

### awk

`awk options program file`

```c
/* 示例，awk处理awk.txt中的每一行时都打印hello world */
awk '{print "hello world!"}' awk.txt

/* 分隔符默认是任意空白字符，除非用-Fx来将x指定为分隔符 */
awk -F: '{print $1,$2}' awk.txt 

/* 多个分隔符 */
awk -F '[:, ]'  '{print $1,$2,$3}'   awk.txt

/* 多条命令 */
awk '{$0="yeshen"; print $0}' awk.txt

/* 使用文件cmd.awk中的命令
 * cmd.awk : '{print $0}'
*/
awk -f cmd.awk awk.txt

/* 在处理数据前和处理数据后运行脚本 */
awk 'BEGIN{print "begin"} {print $0} END{print "end"}' awk.txt

/* 设置变量 */
awk -va=1 '{$1=4; print $1,$1+a}' awk.txt
awk -vb=s '{print $1,$1b}' awk.txt

/* 过滤 */
awk '$2>2' awk.txt //输出第二列大于2的行
awk '$2>2 {print $1}' awk.txt //输出第二列大于2的行的第1个元素
awk '$1>2 && $2=="li" {print $1}' awk.txt //输出第1列大于2且第2列为li的行的第1个元素

/* 内置变量 */
awk 'BEGIN{FS=":"; OFS="-"} {print $1,$2}' awk.txt 
awk 'BEGIN{FIELDWIDTHS="5 5 4"} {print $1,$2,$3}' awk.txt  
awk 'BEGIN{FS="\n"; RS=""} {print $1,$2}' awk.txt
awk 'BEGIN{OFS="--"} {print $1,$2}' awk.txt

/* 正则表达式 */
echo '1ab2bc3cd4de5' | awk 'BEGIN{RS="[a-z]+"} {print $1,RS,RT}'
awk '$2 ~ /li/ {print $1,$2}' test.awk //输出第2列包含li的行的第1和第2元素
awk '$2 ！~ /li/ {print $1,$2}' test.awk //输出第2列不包含li的行的第1和第2元素

```


## C

### cat

```c
cat -n file
cat -b file
```

### chown

```c
chown newuser file
chown newuser.newgroup file

```
### chgrp

```c
chgrp newgroup file

```

### cut

```c
cut -b/-c 3 file
cut -b/-c 2-4,8 file
cut -d: -f 3 file
```


## D

### deluser

```c
/* 删除用户 */
deluser <user>

/* 从组中删除用户 */
deluser <user> <group>
 
/* 删除用户的同时删除目录等 */
deluser --remove-all-files <user>
deluser --remove-home <user>

```

### delgroup

```c
delgroup group //先删除组中的用户
```

### diff and patch

```c
/* 两个单独文件生成补丁 */
diff -u a.txt a_fix.txt > a-patch 

/* 两个目录生成补丁 */
diff -urN a/ a_fix/ > a-patch

/* 正向打补丁(a->a_fix) */
patch -p0 < a-patch   //补丁在a同级目录，patch命令也在同级目录
patch -p1 < ../a-patch  //补丁在a同级目录，patch命令在a目录中

/* 反向打补丁(a_fix->a) */
patch -R -p0 < a-patch  //补丁在a同级目录，patch命令也在同级目录
patch -R -p1 < ../a-patch  //补丁在a同级目录，patch命令在a目录中

```

### dtc

### du

### df

### docker

### dd


## F

### fdisk

### file

`查看文件格式，如elf，acill等`


## G

### gcc

```c
/* 预处理 */
gcc -E HelloWorld.c -o HelloWorld.i
/* 编译 */
gcc -S HelloWorld.i -o HelloWorld.S
/* 汇编 */
gcc -c HelloWorld.S -o HelloWorld.o 或者 as hello.S -o hello.o
/* 链接 */
gcc -static -o myproc main.o test.o 或者 ld -static -o myproc main.o test.o
/* 默认动态链接，如果没有动态库则静态链接 */
gcc -o myproc main.o test.o 或者 ld -o myproc main.o test.o
/* 一步处理预处理，编译，汇编，链接 */
gcc -o myproc main.c test.c
/* 生成静态库 */
ar rcs -o mylib.a proc1.o proc2.o
/* 生成动态库 */
gcc -shared -fPIC -o mylib.so proc1.o proc2.o
/* 生成32位的程序 */
gcc -m32 ...

```

### grep 

### gzip/gunzip


## H

### head/tail

```c
head -n 5 file
head -c 5 file //显示文件file开头5个字节
```

### hd/hexdump

```c
hexdump file
```


## L

### ldd

### losetup

### less

### ltrace


## M

### more

### mkfs

### mount


## N

### nasm

```c
nasm -f bin/elf test.asm -o test
```

### nm


## O

### objdump

```c
/* 显示执行节如.text */
objdump -d elf-file
/* 显示所有节如.text .data */
objdump -D elf-file
/* 显示原码，但首席需要-g编译 */
objdump -S elf-file
/* 用intel的i386或者x86-64格式输出 */
objdump -M i386,intel/x86-64,intel -D/-d elf-file
/* 显示特定节如.data,-z表示显示0 */
objdump -z -d test -j .data

```

### objcopy

### od

```c
/*
 * -AX:显示地址用16进制来显示地址
 * -t -x1:显示字节码内容使用16进制，每次显示一个字节
 * -N 52:只需读取52个字节
 * -j 500:表示跳过前面500个字节开始读取
 */
od -Ax -t x1 -N 52 file
od -AX -t x1 -j 500 -N 40 file

```


## P

### ps

### parted


## Q

### qemu


## R

### readelf

```c
/* 文件头 */
readelf -h elffile
/* 程序头表/段头表 */
readelf -l elffile
/* 节头表 */
readelf -S elffile
/* 符号表 */
readelf -s elffile
/* 重定位条目 */
readelf -r elffile
/* 特定节 */
readelf -x .data elffie
readelf -x 2 elffile

```


## S

### sed

### sort

### strace


## T

### tar

### top

### tee


## W

### wc

