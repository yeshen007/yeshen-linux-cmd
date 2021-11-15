# yeshen git study

> author -- god ye  
> company -- hanglory  
> description -- just for studying git, nothing more.

## git log

    git log     //查看本地仓库的提交记录。
    git log --patch-with-stat   //查看的提交记录会展示每个提交记录与前一个提交记录之间的差异补丁。

## git config

    git config --list   //查看配置信息
    git config --global user.name <name>    //配置用户名
    git config --global user.email <email>  //配置邮箱

## git clone

    git clone github.com.XXX <dir>  //克隆仓库到本地dir

## git add 

    git add <files>/.     //(stage)添加工作区的文件到暂存区

## git commit

    git commit -m "comment"     //产生一个本地提交
    git commit --amend -m "comment"     //替换最新的提交

## git push
    /* 本地仓库推送到远程仓库 */
    git push <remoterespo> <localbranch>:<remotebranch>

## git pull
    /* 从远程仓库拉取 */
    git pull <remoterespo> <remotebranch>:<localbranch>
    
## git fetch


## git remote

    git remote -v   //显示远程仓库地址和别名
    git remote show <shortname>     //显示本地仓库和远程仓库的同步情况
    git remote add <shortname> <wholeaddr>      //增加远程仓库别名
    
## git branch

    git branch      //显示本地分支
    git branch -r   //显示远程分支
    git branch -a   //显示本地和远程分支
    git branch <newbranch>  //创建分支
    git branch -d <branch>  //删除分支
    
## git checkout

    git checkout <branch>   //HEAD切换到<branch>分支并刷到暂存区，没有刷到工作区
    git checkout -b <branch>    //创建一个<branch>分支并将HEAD移动到该新分支
    git checkout -- <files>/.   //将暂存区刷到工作区

## git reset

    git reset HEAD <files>/.   //(unstage)将HEAD指向的提交刷回暂存区
    git reset --hard <comid>    //将HEAD移动到<comid>并且commid都刷到暂存区和工作区
    git reset --hard HEAD        //将HEAD指向的当前提交刷到暂存区和工作区    
    git reset --soft HEAD^3     //将HEAD移动到单个版本之前，不刷任何区

## git diff

    git diff    //查看工作区和暂存区的补丁
    git diff --cached   //查看最新提交与暂存区的补丁
    git diff HEAD   //查看HEAD指向的提交与工作区的补丁

## git merge

    git merge <branch>      //在当前分支创建一个合并<branch>的提交，head指向它，但同时当前分支会多出<branch>分支的其他提交，按时间穿插
    /* 如果合并冲突则修改文件保存后执行以下指令 */
    git add <files>/.
    git merge --continue
   
## git rebase
