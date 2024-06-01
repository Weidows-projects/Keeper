@REM ==================================================================
@REM 备份,使用start是在新的终端同时进行的,call是按顺序依次
@REM ==================================================================
@echo off
@REM 有的系统环境变量并没有设置 HOME, 无法直接进入只能手动设置了
if not defined HOME set HOME=C:\Users\Weidows
set BACKUP_DIR=%1
  if not defined BACKUP_DIR set BACKUP_DIR=backup

@REM mkdir 不会覆盖已存dir; 第一次cd有可能切换盘符,加上/d
mkdir %BACKUP_DIR% & cd /d %BACKUP_DIR%
@REM ==================================================================

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

  @REM call xrepo scan > cpp\xrepo-scan.bak

  dir /b "D:\mystream" > dir\dir-software.bak
  dir /b "E:\mystream" > dir\dir-mystream.bak
  dir /b "F:\mystream" >> dir\dir-mystream.bak

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
  call pipx list > python\pipx-list.bak

  call scoop export -c > pkgs\scoop-export.bak
  call choco list -l > pkgs\choco-list-local.bak
  call winget export -o pkgs\winget-export.bak --include-versions --accept-source-agreements
  call cygwin apt-cyg list > pkgs\cygwin-apt-cyg-list.bak
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
  xcopy F:\mystream\steamapps\*.acf .\steam\ /y/d

  @REM xcopy "C:\Users\Administrator\AppData\Local\Microsoft\Windows Terminal\settings.json" .\WindowsTerminal\ /e/y/d

  cd ..


@REM 备份 ~\
  mkdir dotfiles & cd dotfiles

  xcopy %HOME%\pip\ pip\ /e/y/d
  xcopy %HOME%\.continuum\ .continuum\ /e/y/d
  xcopy %HOME%\.npmrc . /y/d
  xcopy %HOME%\.wslconfig . /y/d
  @REM xcopy %HOME%\.yrmrc . /y/d
  xcopy %HOME%\.condarc . /y/d
  xcopy %HOME%\.gitconfig . /y/d

  @REM git-bash 样式
  xcopy %HOME%\.minttyrc . /y/d
  echo %PATH% | sed 's/;/\n/g' > .PATH

  cd ..


@REM telegram
  mkdir backup\telegram & cd backup\telegram

  cmd /c telegram.bat

  cd ..
