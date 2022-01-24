@REM ==================================================================
@REM Initialization
@REM ==================================================================
  @echo off

  @REM 执行时涉及到中文,cmd 默认按照 GBK/GB2312 解析(VScode强行按UTF-8),所以不开启的话会出现:显示没错但存储时乱码这种问题
  chcp 65001

  @REM !!!!一定要注意等号'='前后不要加空格!!!!
  @REM 不设置的话,备份默认存放在keeper内的 Programming-Configuration, 路径支持含空格
  @REM 例如: BACKUP_DIR=E:\OneDrive - Nima Company\Repo\Weidows-projects\Programming-Configuration
  set BACKUP_DIR=%~dp0Repos\Weidows-projects\Programming-Configuration






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
  echo           ::::'   ':::::'       .::::::::.(7)test / change color
  echo         .::::'    ::::::     .:::::::'::::. (6)dir
  echo        .:::'     :::::::  .:::::::::' ':::::. (5)daily-helper
  echo       .::'       ::::::.:::::::::'      ':::::. (4)devenv-starter
  echo      .::'        :::::::::::::::'         ``::::. (3)boot-starter
  echo  ...:::          :::::::::::::'              ``::. (2)backup
  echo  ````':.          ':::::::::'                  ::::.. (1)exit
  echo 输入选项:           '.:::::'                    ':'```:..
  CHOICE /C 1234567
  echo =============================================================================



  if %errorlevel%==1 exit
  if %errorlevel%==2 call :backup
  if %errorlevel%==3 call :boot-starter
  if %errorlevel%==4 call :devenv-starter
  if %errorlevel%==5 call :daily-helper
  if %errorlevel%==6 call :dir
  if %errorlevel%==7 call :test


  @REM 暂停-查看程序输出-自循环; 视 goto 优先级过高只在 main 中用,其他的 只用 call
    pause & goto :circle
goto :eof






@REM ==================================================================
@REM 开机后设置备份,使用start是在新的终端同时进行的,call是按顺序依次
@REM ==================================================================
:backup
  @REM 判断是否设置值
    if not defined BACKUP_DIR (
      echo 'BACKUP_DIR' not defined, use default path: %~dp0Programming-Configuration
      set BACKUP_DIR=%~dp0Programming-Configuration
    )
    mkdir %BACKUP_DIR% & cd /d %BACKUP_DIR%


  @REM 备份 backup/ , mkdir 不会覆盖已存dir; 第一次cd有可能切换盘符,加上/d
    mkdir backup & cd backup

    @REM 备份ssh 目录后都必须加个'\' (比如.ssh有可能是目录,也可能是文件,而.ssh\只可能是目录)
    xcopy %HOME%\.ssh\ .ssh\ /e/y/d

    cd ..


  @REM 备份lists
    mkdir lists & cd lists

    call xrepo scan > cpp\xrepo-scan.bak

    dir /b "%HOME%\.vscode\extensions" > dir\dir-.vscode.bak
    dir /b "%OneDrive%\Audio\Local" > dir\dir-music.bak
    dir /b "D:\Software" > dir\dir-software.bak

    dir /b "E:\mystream" > game\dir-mystream.bak
    @REM 备份防止重装后,游戏/创意工坊木大
    xcopy "%SCOOP%\apps\steam\current\steamapps\libraryfolders.vdf" game\ /y/d
    xcopy "%SCOOP%\persist\steam\steamapps\workshop\*.acf" game\ /y/d
    xcopy "E:\mystream\steamapps\workshop\*.acf" game\ /y/d

    call gh repo list > github\repolist-Weidows.bak
    call gh repo list Weidows-projects > github\repolist-Weidows-projects.bak

    call nvm list > node\nvm.bak
    call npm list -g --depth=0 > node\npm-global.bak
    call yarn global list > node\yarn-global.bak

    call conda env export -n base > python\conda-env-base.yaml
    call pip freeze > python\pip-list.bak

    call scoop list > scoop\scoop-apps.bak
    call scoop bucket list > scoop\scoop-buckets.bak
    @REM 获取当前文件夹名称
    @REM for /f "delims=" %%i in ("%cd%") do set folder=%%~ni
    @REM 获取每个仓库git地址
    set currentPath=%cd%
    for /d %%i in (%SCOOP%\buckets\*) do (
      cd /d %%i
      call git remote get-url origin >> %currentPath%\scoop\scoop-buckets.bak
    )
    cd /d %currentPath%
    call choco list -l > scoop\choco-list-local.bak

    cd ..


  @REM 备份其他
    mkdir others & cd others

    xcopy %windir%\System32\drivers\etc\hosts hosts\ /e/y/d
    xcopy %SCOOP%\persist\maven\conf\settings.xml maven\conf\ /e/y/d
    xcopy D:\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 .\PowerShell\ /e/y/d

    cd ..


  @REM 备份 ~\
    mkdir user-config & cd user-config

    xcopy %HOME%\.conda\ .conda\ /e/y/d
    xcopy %HOME%\.config\scoop\ .config\scoop\ /e/y/d
    xcopy %HOME%\pip\ pip\ /e/y/d
    xcopy %HOME%\.continuum\ .continuum\ /e/y/d
    xcopy %HOME%\.npmrc . /y/d
    xcopy %HOME%\.yarnrc . /y/d
    xcopy %HOME%\.condarc . /y/d
    xcopy %HOME%\.gitconfig . /y/d

    @REM git-bash 样式
    xcopy %HOME%\.minttyrc . /y/d
    xcopy %HOME%\.vscode\projects.json .vscode\ /y/d

    cd ..

goto :eof






@REM ==================================================================
@REM 开机启动软件
@REM ==================================================================
:boot-starter
  start /b Rainmeter
  start /b MouseInc
  start /b n0vadesktop

  @REM aria2: 直接通过shell启动会被它占用,所以另开
  echo CreateObject("WScript.Shell").Run "aria2c --conf-path=D:\Scoop\persist\aria2\conf",0 > aria2.vbs
  cscript //Nologo aria2.vbs
  del aria2.vbs

  @REM 酷狗
  start /b KuGou.exe
goto :eof






@REM ==================================================================
@REM 启动dev环境
@REM ==================================================================
:devenv-starter
  @REM 文件管理
  start /b xyplorerfree

  @REM IDE
  start /b code
  start /b idea64.exe

  @REM 浏览器
  start /b microsoft-edge:

  @REM 通讯
  start /b %SCOOP%\apps\TIM\current\Bin\TIM.exe
  start /b %SCOOP%\apps\wechat\current\WeChat.exe

  @REM 虚拟机
  start /b vmware
goto :eof






@REM ==================================================================
@REM scoop-update / Bilibili
@REM ==================================================================
:daily-helper
  @REM %~dp0 为脚本所在路径; %cd% 类似 pwd,当前路径
  cd /d %~dp0\local

  @REM log
    for /l %%i in (1 1 5) do echo.>> log\tasks.log
    set date =date /T
    echo =================================%date%===========================>> log\tasks.log

  @REM scoop-update
    call scoop update | tee -a log\tasks.log

  @REM bilibili
    cd BILIBILI-HELPER
    call java -jar BILIBILI-HELPER.jar | tee -a ..\log\tasks.log
    cd ..
    rd /S/Q D:\tmp
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

  @REM dailycheckin (cmd会由于Unicode报错)
    @REM cd /d %~dp0\local
    @REM call conda activate base
    @REM start powershell dailycheckin --include ACFUN CLOUD189 MUSIC163 TIEBA

  @REM 米游社
    @REM call conda activate base
    @REM call python AutoMihoyoBBS/main.py >> tasks.log

goto :eof
