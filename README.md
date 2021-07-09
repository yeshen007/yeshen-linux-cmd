> author -- leaf god  
> data -- 2021.6.26  

## This project is just for recording the common used method for common used linux comands.

### misc

```c
/* -e识别转义字符 */
echo -e "1 2 3\n4 5 6" > log.txt
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
