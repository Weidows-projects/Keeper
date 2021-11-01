@REM ==================================================================
@REM Initialization
@REM ==================================================================
  @echo off

  @REM 执行时涉及到中文,cmd 默认按照 GBK/GB2312 解析(VScode强行按UTF-8),所以不开启的话会出现:显示没错但存储时乱码这种问题
  chcp 65001

  @REM !!!!一定要注意等号'='前后不要加空格!!!!
  set BACKUP_DIR=D:\Game\Github\Programming-Configuration






@REM ==================================================================
@REM main入口
@REM ==================================================================
:circle
  @REM 清屏
    cls


  @REM 改色
    set /a a=%random%%%10
    color 0%a%

  @REM 初始化 choice
    set choice=-1


  echo                    .::::.
  echo                  .::::::::.
  echo                 :::::::::::
  echo              ..:::::::::::'
  echo           '::::::::::::'
  echo             .::::::::::
  echo        '::::::::::::::..
  echo             ..::::::::::::.
  echo           ``::::::::::::::::
  echo            ::::``:::::::::'        .:::.
  echo           ::::'   ':::::'       .::::::::.(6)test
  echo         .::::'    ::::::     .:::::::'::::. (5)dir
  echo        .:::'     :::::::  .:::::::::' ':::::. (4)bilibili/miHoYo-helper
  echo       .::'       ::::::.:::::::::'      ':::::. (3)devenv-starter
  echo      .::'        :::::::::::::::'         ``::::. (2)boot-starter
  echo  ...:::          :::::::::::::'              ``::. (1)backup
  echo  ````':.          ':::::::::'                  ::::.. (0)exit
  set /p choice=输入选项:           '.:::::'                    ':'```:..
  echo =============================================================================



  if %choice%==0 exit
  if %choice%==1 call :backup
  if %choice%==2 call :boot-starter
  if %choice%==3 call :devenv-starter
  if %choice%==4 call :bilibili-helper
  if %choice%==5 call :dir
  if %choice%==6 call :test


  @REM 暂停-查看程序输出-自循环
    pause & goto :circle
goto :eof






@REM ==================================================================
@REM 开机后设置备份,使用start是在新的终端同时进行的,call是按顺序依次
@REM ==================================================================
:backup
  @REM 备份 backup/ , mkdir 不会覆盖已存dir; 第一次cd有可能切换盘符,加上/d
    mkdir %BACKUP_DIR%\backup & cd /d %BACKUP_DIR%\backup

    @REM 备份ssh 目录后都必须加个'\' (比如.ssh有可能是目录,也可能是文件,而.ssh\只可能是目录)
    xcopy %HOME%\.ssh\ .ssh\ /e/y/d


  @REM 备份lists
    mkdir %BACKUP_DIR%\lists & cd %BACKUP_DIR%\lists

    call xrepo scan > cpp\xrepo-scan.bak

    dir /b D:\Musics\Local > dir\dir-music.bak
    dir /b D:\Software > dir\dir-software.bak
    dir /b E:\mystream > dir\dir-mystream.bak

    call gh repo list > github\repo-list-Weidows.bak
    call gh repo list weidows-projects > github\repo-list-weidows-projects.bak

    call npm -g list > node\npm-global.bak
    call yarn global list > node\yarn-global.bak

    call conda env export -n base > python\conda-env-base.yaml
    call pip freeze > python\pip-list.bak

    call scoop list > scoop\scoop-apps.bak
    call scoop bucket list > scoop\scoop-buckets.bak
    call choco list -l > scoop\choco-list-local.bak

    @REM 重装系统/重装wallpaper engine,所有壁纸会木大,所以备份
    xcopy %SCOOP%\persist\steam\steamapps\common\wallpaper_engine\config.json .\wallpaper_engine\ /y/d


  @REM 备份其他
    mkdir %BACKUP_DIR%\others & cd %BACKUP_DIR%\others
    xcopy %windir%\System32\drivers\etc\hosts hosts\ /e/y/d
    xcopy %SCOOP%\persist\maven\conf\settings.xml maven\conf\ /e/y/d
    xcopy D:\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 .\PowerShell\ /e/y/d


  @REM 备份 ~\
    mkdir %BACKUP_DIR%\user-config & cd %BACKUP_DIR%\user-config
    xcopy %HOME%\.conda\ .conda\ /e/y/d
    xcopy %HOME%\.config\ .config\ /e/y/d
    xcopy %HOME%\pip\ pip\ /e/y/d
    xcopy %HOME%\.continuum\ .continuum\ /e/y/d
    xcopy %HOME%\.npmrc . /y/d
    xcopy %HOME%\.yarnrc . /y/d
    xcopy %HOME%\.condarc . /y/d
    xcopy %HOME%\.gitconfig . /y/d
    @REM git-bash 样式
      xcopy %HOME%\.minttyrc . /y/d
goto :eof






@REM ==================================================================
@REM 开机启动软件
@REM ==================================================================
:boot-starter
  start Rainmeter
  start MouseInc
  start %SCOOP%\apps\N0vaDesktop\current\N0vaDesktop.exe

  @REM aria2: 直接通过shell启动会被它占用,所以另开
  echo CreateObject("WScript.Shell").Run "aria2c --conf-path=D:\Game\Scoop\persist\aria2\conf",0 > aria2.vbs
  cscript //Nologo aria2.vbs
  del aria2.vbs

  @REM 酷狗
  start D:\Software\KGMusic\KuGou.exe
goto :eof






@REM ==================================================================
@REM 启动dev环境
@REM ==================================================================
:devenv-starter
  @REM 文件管理
  start xyplorerfree

  @REM IDE
  start code
  start idea64.exe

  @REM 浏览器
  start microsoft-edge:

  @REM 通讯
  start %SCOOP%\apps\TIM\current\Bin\TIM.exe
  start %SCOOP%\apps\wechat\current\WeChat.exe

  @REM 虚拟机
  start vmware
goto :eof






@REM ==================================================================
@REM Bilibili/miHoYo-helper
@REM ==================================================================
:bilibili-helper
  @REM %~dp0 为脚本所在路径; %cd% 类似 pwd,当前路径
  cd /d %~dp0\local

  call conda activate base
  start /b python AutoMihoyoBBS/main.py

  cd BILIBILI-HELPER
  start /b java -jar BILIBILI-HELPER.jar
  cd ..

goto :eof






@REM ==================================================================
@REM 批量获取文件名
@REM ==================================================================
:dir
  set /p specifiedPath=输入路径 (留空取当前路径):
  DIR /B %specifiedPath%
goto :eof






@REM ==================================================================
@REM 测试
@REM ==================================================================
:test
  echo Testing...

goto :eof
