@REM ==================================================================
@REM Initialization
@REM ==================================================================
  @echo off

  @REM 执行时涉及到中文,cmd 默认按照 GBK/GB2312 解析(VScode强行按UTF-8),所以不开启的话会出现:显示没错但存储时乱码这种问题
  chcp 65001

  @REM 设置代理, 不然 hello 图床无法访问报错.
  @REM set http_proxy=http://127.0.0.1:7890 & set https_proxy=http://127.0.0.1:7890

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
  echo           ::::'   ':::::'       .::::::::.(7)
  echo         .::::'    ::::::     .:::::::'::::. (6)dir
  echo        .:::'     :::::::  .:::::::::' ':::::. (5)backup
  echo       .::'       ::::::.:::::::::'      ':::::. (4)new-bing
  echo      .::'        :::::::::::::::'         ``::::. (3)boot-starter
  echo  ...:::          :::::::::::::'              ``::. (2)test / change color
  echo  ````':.          ':::::::::'                  ::::.. (1)exit
  echo 输入选项:           '.:::::'                    ':'```:..
  CHOICE /C 12345678
  echo =============================================================================


  if %errorlevel%==1 exit
  if %errorlevel%==2 call :test
  if %errorlevel%==3 cmd /c %~dp0scripts\booter.bat %BACKUP_DIR%
  if %errorlevel%==4 call :new-bing
  if %errorlevel%==5 call :backup
  if %errorlevel%==6 call :dir


  @REM 暂停-查看程序输出-自循环; 视 goto 优先级过高只在 main 中用,其他的 只用 call
    pause & goto :circle
goto :eof






@REM ==================================================================
@REM 测试
@REM ==================================================================
:test
  echo Testing...
  @REM call nvm list


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
    xcopy %HOME%\_netrc . /y/d

    @REM 备份 bw; 文档: https://help.bitwarden.ltd/getting-started/bitwarden-cli
    set /p BW_SESSION=<bitwarden\session
    bw list items --session %BW_SESSION% >bitwarden\items.json

    @REM 备份图床
    @REM ImageHub 备份
    @REM wget -nc -i images.txt -P ./ImageHub
    @REM # 增量备份 https://cloud.tencent.com/developer/ask/sof/34010
    @REM %~dp0.venv\Scripts\python.exe %~dp0scripts\hello.py "Weidows" %BACKUP_DIR%\backup\

    cd ..


  @REM 备份lists
    mkdir lists & cd lists

    call xrepo scan > cpp\xrepo-scan.bak

    dir /b "D:\mystream" > dir\dir-software.bak
    dir /b "E:\mystream" > dir\dir-mystream.bak
    dir /b "G:\mystream" >> dir\dir-mystream.bak

    call gh repo list > github\repolist-Weidows.bak
    call gh repo list Weidows-projects > github\repolist-Weidows-projects.bak

    dir /b "%GOPATH%\bin" > golang\go-install.bak
    call go env > golang\go-env.bak
    call gvm ls > golang\gvm-ls.bak

    call pnpm list -g > node\pnpm-global.bak
    call yarn global list > node\yarn-global.bak

    call conda env list > python\conda-env-list.bak
    call conda env export -n base > python\conda-env-base.yaml
    @REM call pip freeze > python\pip-list.bak
    call pip list --format=freeze > python\pip-list.bak

    call scoop export -c > scoop\scoop-export.bak
    call choco list -l > scoop\choco-list-local.bak
    call winget export -o scoop\winget-export.bak --include-versions --accept-source-agreements
    @REM call scoop bucket list > scoop\scoop-buckets.bak
    @REM 获取当前文件夹名称
    @REM for /f "delims=" %%i in ("%cd%") do set folder=%%~ni
    @REM 获取每个仓库git地址
    @REM set currentPath=%cd%

    @REM   cd /d %%i
    @REM   call git remote get-url origin >> %currentPath%\scoop\scoop-buckets.bak
    @REM )
    @REM cd /d %currentPath%

    cd ..


  @REM 备份其他
    mkdir others & cd others

    xcopy %SCOOP%\persist\Clash-for-Windows_Chinese\data\cfw-settings.yaml clash\ /e/y/d
    xcopy %windir%\System32\drivers\etc\ hosts\ /y/d
    xcopy %SCOOP%\persist\maven\conf\settings.xml maven\conf\ /e/y/d
    xcopy %SCOOP%\persist\pwsh\profile.ps1 .\pwsh\ /e/y/d

    @REM steam 经常遇到游戏本体存在但是不认亲的情况, so backup.
    xcopy %SCOOP%\persist\steam\steamapps\*.acf .\steam\ /y/d
    xcopy E:\mystream\steamapps\*.acf .\steam\ /y/d
    xcopy G:\mystream\steamapps\*.acf .\steam\ /y/d

    xcopy "C:\Users\Administrator\AppData\Local\Microsoft\Windows Terminal\settings.json" .\WindowsTerminal\ /e/y/d

    cd ..


  @REM 备份 ~\
    mkdir user-config & cd user-config

    xcopy %HOME%\pip\ pip\ /e/y/d
    xcopy %HOME%\.continuum\ .continuum\ /e/y/d
    xcopy %HOME%\.npmrc . /y/d
    xcopy %HOME%\.wslconfig . /y/d
    xcopy %HOME%\.yrmrc . /y/d
    xcopy %HOME%\.condarc . /y/d
    xcopy %HOME%\.gitconfig . /y/d

    @REM git-bash 样式
    xcopy %HOME%\.minttyrc . /y/d
    echo %PATH%> .PATH

    cd ..

goto :eof









@REM ==================================================================
@REM NewBiing AI
@REM ==================================================================
:new-bing
  @REM set /p specifiedPath=输入路径 (留空取当前路径):
  @REM echo.
  @REM DIR /B %specifiedPath%

  cd /d D:\Repos\tools\BingAI-Client
  venv\Scripts\python.exe .\BingServer.py
goto :eof






@REM ==================================================================
@REM killer
@REM ==================================================================
:killer
  taskkill /F /IM sharemouse.exe
  @REM net stop "ShareMouse Service"
  @REM net start "ShareMouse Service"
  start /b cmd /c "C:\Program Files (x86)\ShareMouse\ShareMouse.exe"

  taskkill /f /im kassistant.exe
goto :eof
