@REM ==================================================================
@REM Initialization
@REM ==================================================================
  @echo off

  @REM 执行时涉及到中文,cmd 默认按照 GBK/GB2312 解析(VScode强行按UTF-8),所以不开启的话会出现:显示没错但存储时乱码这种问题
  chcp 65001

  @REM 设置代理, 不然 hello 图床无法访问报错.
  set http_proxy=http://127.0.0.1:7890 & set https_proxy=http://127.0.0.1:7890

  @REM !!!!一定要注意等号'='前后不要加空格!!!!
  @REM 备份默认存放在keeper内的 Programming-Configuration, 路径支持含空格
  set BACKUP_DIR=
    if not defined BACKUP_DIR set BACKUP_DIR=%~dp0Programming-Configuration

  @REM 有的系统环境变量并没有设置 HOME, 无法直接进入只能手动设置了
  if not defined HOME set HOME=C:\Users\Administrator






@REM ==================================================================
@REM main入口
@REM ==================================================================
:circle
  @REM 清屏
    cls

  @REM 改色
    set /a COLOR=%random%%%10
    color 0%COLOR%

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
  echo           ::::'   ':::::'       .::::::::.
  echo         .::::'    ::::::     .:::::::'::::. (6)test / change color
  echo        .:::'     :::::::  .:::::::::' ':::::. (5)dir
  echo       .::'       ::::::.:::::::::'      ':::::. (4)daily-helper
  echo      .::'        :::::::::::::::'         ``::::. (3)boot-starter
  echo  ...:::          :::::::::::::'              ``::. (2)backup
  echo  ````':.          ':::::::::'                  ::::.. (1)exit
  echo 输入选项:           '.:::::'                    ':'```:..
  CHOICE /C 123456
  echo =============================================================================


  if %errorlevel%==1 exit
  if %errorlevel%==2 call :backup
  if %errorlevel%==3 call :boot-starter
  if %errorlevel%==4 call :daily-helper
  if %errorlevel%==5 call :dir
  if %errorlevel%==6 call :test


  @REM 暂停-查看程序输出-自循环; 视 goto 优先级过高只在 main 中用,其他的 只用 call
    pause & goto :circle
goto :eof






@REM ==================================================================
@REM 备份,使用start是在新的终端同时进行的,call是按顺序依次
@REM ==================================================================
:backup
  @REM mkdir 不会覆盖已存dir; 第一次cd有可能切换盘符,加上/d
  mkdir %BACKUP_DIR% & cd /d %BACKUP_DIR%


  @REM 备份到 backup/  !!!!!!!!!!!!! 务必把 backup 添加到 .gitignore !!!!!!!!!!!!!
    touch %BACKUP_DIR%\.gitignore
    cat %BACKUP_DIR%\.gitignore | findstr backup >nul || (
        echo backup>> %BACKUP_DIR%\.gitignore
    )
    mkdir backup & cd backup

    @REM 备份ssh 目录后都必须加个'\' (比如.ssh有可能是目录,也可能是文件,而.ssh\只可能是目录)
    xcopy %HOME%\.ssh\ .ssh\ /e/y/d

    @REM 备份 bw; 文档: https://help.bitwarden.ltd/getting-started/bitwarden-cli
    set /p session=<bitwarden\session
    bw list items --session %session% >bitwarden\items.json

    @REM 备份图床
    python %~dp0scripts\hello.py "Weidows" %BACKUP_DIR%\backup\

    cd ..


  @REM 备份lists
    mkdir lists & cd lists

    call xrepo scan > cpp\xrepo-scan.bak

    dir /b "%SCOOP%\persist\vscode-portable-association\data\extensions" > dir\dir-.vscode.bak
    dir /b "%OneDrive%\Audio\Local" > dir\dir-music.bak
    dir /b "D:\Game" > dir\dir-software.bak

    dir /b "E:\mystream" > game\dir-mystream.bak
    dir /b "E:\mystream\0x" > game\dir-mystream-0x.bak
    @REM 备份防止重装后,游戏/创意工坊木大
    xcopy "%SCOOP%\persist\steam\steamapps\libraryfolders.vdf" game\ /y/d
    xcopy "%SCOOP%\persist\steam\steamapps\workshop\*.acf" game\ /y/d
    xcopy "E:\mystream\steamapps\workshop\*.acf" game\ /y/d

    call gh repo list > github\repolist-Weidows.bak
    call gh repo list Weidows-projects > github\repolist-Weidows-projects.bak

    call nvm list > node\nvm.bak
    call npm list -g --depth=0 > node\npm-global.bak
    @REM call yarn global list > node\yarn-global.bak

    call conda env export -n base > python\conda-env-base.yaml
    @REM call pip freeze > python\pip-list.bak
    call pip list --format=freeze > python\pip-list.bak

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

    xcopy %windir%\System32\drivers\etc\ hosts\ /e/y/d
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
    xcopy %HOME%\.yrmrc . /y/d
    xcopy %HOME%\.condarc . /y/d
    xcopy %HOME%\.gitconfig . /y/d

    @REM git-bash 样式
    xcopy %HOME%\.minttyrc . /y/d

    cd ..

goto :eof






@REM ==================================================================
@REM 开机启动软件
@REM ==================================================================
:boot-starter
  @REM 软件
  @REM start /b Rainmeter
  @REM start /b n0vadesktop
  start /b steam

  @REM 浏览器
  start /b microsoft-edge:

  @REM 酷狗
  start /b KuGou.exe

  @REM 通讯
  start /b qq.exe
  @REM start /b wechat-mod.exe

  @REM 工具
  start /b xyplorer.exe
  start /b MouseInc

  @REM 这里不要用 start, 虽然能跑起来, 但可能会出现某些未知异常
  cmd /c %~dp0scripts\aria2.bat %BACKUP_DIR%

goto :eof






@REM ==================================================================
@REM Daily: scoop-update / Bilibili
@REM ==================================================================
:daily-helper
  @REM %~dp0 为脚本所在路径; %cd% 类似 pwd,当前路径
  cd /d %BACKUP_DIR%\backup

  @REM logger
    @REM 2022-04-24
    echo %date:~3,14%| sed -e 's/\//-/g' > log\last-run.txt
    set /p logFile=<log\last-run.txt
    time /T >> log\last-run.txt

    @REM 2022-04-24.log
    set logFile=%BACKUP_DIR%\backup\log\tasks\%logFile%.log

    for /l %%i in (1 1 5) do echo.>> %logFile%
    time /T >> %logFile%
    echo =====================================================================>> %logFile%

  @REM https://github.com/521xueweihan/GitHub520
    cmd /c %~dp0scripts\GitHub520\GitHub520.bat | tee -a %logFile%

  @REM scoop-update
    call scoop update | tee -a %logFile%

  @REM dailycheckin (cmd会由于Unicode报错)
    @REM call conda activate base
    @REM start powershell dailycheckin --include ACFUN CLOUD189 MUSIC163 TIEBA

  @REM 米游社
    @REM call python AutoMihoyoBBS/main.py

  @REM bilibili
    cd BILIBILI-HELPER
    call java -jar BILIBILI-HELPER.jar | tee -a %logFile%
    cd ..
    rd /S/Q D:\tmp
goto :eof






@REM ==================================================================
@REM 批量获取文件名
@REM ==================================================================
:dir
  set /p specifiedPath=输入路径 (留空取当前路径):
  echo.
  DIR /B %specifiedPath%
  echo.
goto :eof






@REM ==================================================================
@REM 测试
@REM ==================================================================
:test
  echo Testing...

  @REM python %~dp0scripts\hello.py "Weidows" %BACKUP_DIR%\backup\

  @REM cmd /c %~dp0scripts\aria2.bat %BACKUP_DIR%

goto :eof
