
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



