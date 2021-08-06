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

/* 自动挂载文件系统文件  */
/etc/fstab


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

# pc指针
指向下一条指令，而arm32位的指向下下条

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
base(offset, index, size) //at&t,其中base是立即数或者label，label表示label处的地址,base和size中的常数不带$,
                          //但是base中的label我见过带$也见过不带$的，应该都表示label处的地址。
[base + offset + index*size] //intel

/* 内联汇编 */

asm [volatile] ("汇编指令" : "输出操作数列表" : "输入操作数列表" : "改动列表")
输出操作数列表：汇编代码如何把处理结果传递到 C 代码中，向哪些寄存器或内存输出结果，然后再复制给c代码变量位置(栈)。
输入操作数列表：C 代码如何把数据传递给内联汇编代码，先从c代码变量（栈）复制到寄存器或者内存，然后从这些寄存器或内存地址读取输入数据。
注：如果使用内存是不用复制的。

改动列表中的memory表示内联代码要修改内存，因此在这段代码前将其他缓存了内存内容的寄存器刷回内存，执行完asm后再加载回来。
如果是寄存器比如eax，网上和arm手册的说法不太一致，我觉得是寄存器充足的时候网上说的是对的，
即告诉 GCC %eax 的值将会在 "asm" 内部被修改，所以 GCC 将不会使用此寄存器存储任何其他值。
如果寄存器不足的情况我觉得arm手册是对的，即在内联代码前将eax保存起来，之后恢复。不能和输入
输出操作数的寄存器重叠。

"[输出修饰符]约束"(寄存器或内存地址)
输出修饰符：对输出寄存器或者输出内存提供额外的说明。
1.+表示被修饰的内存或寄存器可以读取可以写入。
2.=表示被修饰的内存或寄存器只能写入不能读取。
3.&告诉编译器不要选择任何一个被用作输入的寄存器用作输出寄存器。因此&和r搭配。
约束：就是通过不同的字符，来告诉编译器使用哪些寄存器，或者内存地址。
1.a,b,c,d代表eax,ebx,ecx,edx.
2.r表示使用任何可用的通用寄存器
3.m表示使用变量的内存位置，此时就不用进行数据复制

示例：
#include <stdio.h>

int main()
{
    int data1 = 1;
    int data2 = 2;
    int data3;

    asm("movl %%ebx, %%eax\n\t"
        "addl %%ecx, %%eax"
        : "=a"(data3)
        : "b"(data1),"c"(data2));

    printf("data3 = %d \n", data3);
    return 0;
}

以上代码解释：
1."b"(data1),"c"(data2) ==> 把变量 data1 复制到寄存器 %ebx，变量 data2 复制到寄存器 %ecx。这样，内联汇编代码中，
  就可以通过这两个寄存器来操作这两个数了；
2."=a"(data3) ==> 把处理结果放在寄存器 %eax 中，然后复制给变量data3。前面的修饰符等号意思是：会往 %eax 中写入数据，
  不会从中读取数据;

别名：
    asm("addl %[v1], %[v2]\n\t"
        "movl %[v2], %[v3]"
        : [v3]"=r"(data3)
        : [v1]"r"(data1),[v2]"r"(data2));
        

/* vim */
1.misc
  <ctrl r><ctrl w>  //在命令或查找模式下插入光标下的单词
  <ctrl r><ctrl a>  //在命令或查找模式下插入光标下的广义单词
  :write !sudo tee % > /dev/null  //用root用户权限将vim缓冲区写回文件
  :pwd //显示当前窗口的工作目录
  :lcd //改变当前窗口的工作目录，不影响其他窗口
  :h <插件名字>   //查看插件的用法
  <ctrl o><cmd>   //在插入模式中输入普通模式的cmd命令然后继续插入模式
  :vimgrep "text" **/*    //在当前vim的工作目录查找text
  手工插件安装方法：
    1) 创建一个存储插件的目录 mkdir -p ~/.vim/pack/plugins/start
    2) 配置好vimrc中的packloadall和silent! helptags ALL实现启动vim时加载插件和插件帮助文档
    3) 将插件下载到插件目录后重启vim即可，如
        git clone https://github.com/yeshen007/yeshen-linux-cmd.git ~/.vim/pack/plugins/start/yeshen-linux-cmd
  管理器插件安装方法：
    1) 在https://github.com/junegunn/vim-plug下载vim.plug到~/.vim/autoload下。
    2) 修改vimrc加入call plug#begin()和call plug#end()，在里面加入插件。
    3) 重启vim或者source $MYVIMRC后执行:PlugInstall来安装插件，:PlugUpdate更新已安装插件，:PlugClean删除vimrc中移除的插件。
  map和noremap：
    1) map--递归映射，cmd1会映射到cmd3
     map cmd1 cmd2
     map/noremap cmd2 cmd3
    2) noremap--非递归映射,cmd1映射到cmd2就停了，无论cmd2后来是否有映射和是否递归映射
     noremap cmd1 cmd2
     map/noremap cmd2 cmd3     
  
2.插件ctags
  ctags -R .   //递归扫描当前目录和所有子目录生成索引文件
     注：我的vimrc配置了修改文件会自动更新索引，因此只要第一次ctags -R .
  ctrl + ]    //跳转到函数或变量定义的地方
  ctrl + T    //返回跳转之前的地方
   
3.插件cscope
  cscope -Rbq   //递归扫描当前目录和所有子目录生成索引文件
     注：和ctags一样，我的vimrc配置了修改文件会自动更新索引，因此只要第一次cscope -Rbq
  :cs find s <symbol>   //f5  查找c语言符号<symbol>出现的地方  
  :cs find t <text>    //f6   查找任何形式的字符串<text>出现的地方
  :cs find c <function>  //f7   查找调佣function的函数
  :cs find d <function> //查找function调用的函数
  :cs find g <symbol>  //和ctags中的 ctrl + ]一样，查找符号定义的地方
  
4.插件nerdtree
  B  //切换书签显示兰
  :Bookmark //将光标当前位置生成书签
  D //删除光标位置书签
  p //小写，跳到当前位置的上一级节点
  P //大写，跳到根节点
  J //跳到当前同级最后一个
  K //跳到当前同级第一个
  o //小写，和回车一样，打开文件，旧文件的缓冲区被覆盖，光标跳转到新打开文件的缓冲区
  i //在新窗口打开文件，不覆盖旧文件缓冲区，光标跳转到打开文件的缓冲区
  go和gi //光标不跳转到打开的文件缓冲区的o和i版
  
5.插件unimpaired
  ]a/[a   //下一个参数，上一个参数
  ]b/[b   //下一个缓冲区，上一个缓冲区
  ]t/[t   //下一个标签，上一个标签
  ]f/[f   //下一个文件，上一个文件
  ]q/[q   //下一个修复列表项，上一个修复列表项
  ]l/[l   //下一个位置列表项，上一个位置列表项

6.插件fzf fzf.vim ctrlp
  fzf和fzf.vim傻傻分不清，当成一个，不建议用ctrlp
  <space><f>    //开启模糊搜索文件功能
  
7.插件easymotion
  <space><h/j/k/l/w/b/e>
  
8.标签tab
  :tabnew                 //创建新tab
  :tabnext/:tab        //切换到下一个标签
  gt              //切换到下一个标签
  :tabprevious/:tabp        //切换到上一个标签
  gT            //切换到上一个标签
  :tabmove n/:tabm n  //将当前标签移动到第n个标签之后
  :tabclose/:tabc   //关闭当前标签和它的窗口，如果是最后一个标签页则不行
  
9.窗口window
  :sp       //在当前活动窗口的上方创建一个窗口，导入当前活动窗口的文件缓冲区
  :sp file  //在当前活动窗口的上方创建一个窗口，导入文件file的缓冲区
  :vsp      //在左边
  :q/<ctrl w><q>        //关闭当前窗口
  <ctrl w><H>/<J>/<K>/<L>      //将当前窗口移动到最左，最下，最上，最右
  <ctrl w><r>/<x>       //调换窗口的内容
  <ctrl w><=>       //所有常规窗口调整为同样高度和宽度
  <ctrl w><_>       //当前窗口拉到最高
  <ctrl w><|>       //当前窗口拉到最宽
  <ctrl w><+>/<->   //调整当前窗口的高度
  <ctrl w><<>/<>>   //调整当前窗口的宽度
  :res +n   //当前窗口高度增加n行
  :res -n   //当前窗口高度减少n行
  :res n    //当前窗口高度就设为n行
  :vert res .. //宽度

10.缓冲区buffer
  :b n    
  :b file-name 
  :bd n
  :bd file-name
  :bd       //和以上两条不同，不会退出当前窗口
  
11.参数列表args
  :args  //显示参数列表
  :arg <files>  //重新定义参数列表
  :argadd <file>  //在原来的参数列表中添加file
  :argdo <cmd> | write   //对参数列表每个文件缓冲区执行指令cmd和write

12.位置列表list
  /* 对于每个会产生quickfix条目的命令都会有加上一个l前缀的局部命令。
   * 每个窗口一个位置列表，以下命令都只操作当前窗口的位置列表。
   * 命令和quickfix的操作一样，把c换成l
   */

13.快速修复列表quickfix
  /* 参考vim使用技巧248页技巧106 */
  

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

### curl

```c
/* 下载文件 */
curl -O http://man.linuxde.net/text.iso                    //O大写，不用O只是打印内容不会下载

/* 下载文件并重命名 */
curl -o rename.iso http://man.linuxde.net/text.iso         //o小写

/* 断点续传 */
curl -O -C - http://man.linuxde.net/text.iso               //O大写，C大写

/* 限速下载 */
curl --limit-rate 50k -O http://man.linuxde.net/text.iso

/* 显示响应头部信息 */
curl -I http://man.linuxde.net/text.iso

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
/* 普通用法 */
hexdump file
/* 好用，16进制和ascii一起显示 */
hexdump -C file
```


## L

### ldd

### losetup

`将镜像文件虚拟成块设备，进而可以模拟文件系统`

```c
/* step1 创建镜像文件 */
dd if=/dev/zero of=floppy.img bs=512 count=1000

/* step2 格式化镜像文件 */
mkfs.ext4 floppy.img

/* step3 查找第一个没有使用的回环设备，比如就是/dev/loop21 */
losetup -f

/* step4 使用losetup将镜像文件虚拟成块设备 */
losetup /dev/loop21 floppy.img

/* step5 挂载块设备到某个目录 */
mount /dev/loop21 /mnt/mydir

/* step6 访问完设备后解除联系 */
umount /mnt/mydir
losetup -d /dev/loop21

注1：step2可以在step3和step4后做，不过此时是 mkfs.ext4 /dev/loop21

注2：step3.step4可以用一步 losetup --find --show floppy.img 替代

注3：step4.step5可以用一步 mount -o loop loopfile.img /mnt/mydir 替代

```

### less

### ltrace


## M

### more

### mkfs

### mount

```c
mount //和df类似，显示挂载的文件系统，但是可读性没有df好
mount /dev/xxx mount-dir //将设备xxx挂载到mount-dir
mount -o loop xxx.img mount-dir //用回环设备将xxx.img虚拟为块设备再挂载
```


## N

### nasm

```c
nasm -f bin/elf test.asm -o test
```

### nm

```c
nm elf-file
```

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
objdump -z -d elf-file -j .data
/* 加上-x把elf文件的程序头表，节头表符号表等详细内容显示出来 */
objdump -x elf-file
objdump -x -d elf-file

```

### objcopy

`objcopy [选项]... 输入文件 [输出文件]`  
`将目标文件的一部分或者全部内容拷贝到另外一个目标文件中，或者实现目标文件的格式转换`  
`如果不指定目标文件那么 objcopy 将会创建一个临时文件，并且将其命名为源文件`

```c
/*
 * -I format -- 指定输入文件的格式
 * -O format -- 指定输出文件的格式
 */
objcopy -I elf32-little -O binary inputfile outputfile

```

### od

```c
/*
 * -AX:显示地址用16进制来显示地址
 * -t -x1:显示字节码内容使用16进制，每次显示一个字节
 * -t c:显示字节码内容使用字符，每次显示一个字节
 * -N 52:只需读取52个字节
 * -j 500:表示跳过前面500个字节开始读取
 */
od -Ax -t x1 -N 52 file
od -AX -t x1 -j 500 -N 40 file
od -Ad -t c -j 5228 -N 499 main

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

### wget

```c
/* 下载文件 */
wget http://www.linuxde.net/text.iso

/* 下载文件并重命名 */
wget -O rename.zip http://www.linuxde.net/text.iso         //O大写

/* 断点续传 */
wget -c http://www.linuxde.net/text.iso                    //c小写

/* 限速下载 */
wget --limit-rate=50k http://www.linuxde.net/text.iso

/* 显示响应头部信息 */
wget --server-response http://www.linuxde.net/test.iso

/* 打包下载网站 */
wget --mirror -p --convert-links -P /var/www/html http://man.linuxde.net/

```
