@REM ==================================================================
@REM 开机启动软件
@REM 很多程序通过 start /b 会占用当前shell, 可以改用 powershell
@REM ==================================================================
@echo off

@REM 配置和启动脚本目录 (空的就行)
set BACKUP_DIR=%1
  if not defined BACKUP_DIR set BACKUP_DIR=%~dp0..\Programming-Configuration

@REM 服务
@REM sudo net start "Winmgmt"

cd /d %appdata%\Microsoft\Windows\Start Menu\Programs\Scoop Apps

@REM CPU 密集型
  @REM tasklist | find /i "GHelper" || powershell Start-Process "GHelper"
  tasklist | find /i "MouseInc" || powershell Start-Process "MouseInc"
  @REM tasklist | find /i "Steam++.exe" || powershell Start-Process "Steam++"
  @REM tasklist | find /i "RunCat.exe" || powershell Start-Process -WindowStyle hidden "RunCat"
  @REM tasklist | find /i "windhawk.exe" || powershell Start-Process -WindowStyle hidden "Windhawk"
  @REM tasklist | find /i "ShareX" || start steam://run/400040
  @REM tasklist | find /i "steam" || start /b steam -silent -noverifyfiles
  @REM tasklist | find /i "memreduct.exe" || powershell Start-Process -WindowStyle hidden "memreduct.exe"
  @REM tasklist | find /i "keysound3.0.exe" || powershell Start-Process "KeySound"
  @REM tasklist | find /i "KuGou" || powershell Start-Process -WindowStyle hidden "kugou.exe"
  tasklist | find /i "keep-runner" || powershell Start-Process -WorkingDirectory %BACKUP_DIR%\others\keep-runner -WindowStyle hidden keep-runner parallel
  @REM tasklist | find /i "WeChat" || powershell Start-Process -WindowStyle hidden "WeChat"

  @REM 磁盘唤醒 (deprecated) -> clash 子进程
  @REM cmd /c %~dp0disk-sleep-guard.bat D:\
  @REM 这里不要用 start, 虽然能跑起来, 但可能会出现某些未知异常
  @REM cmd /c %~dp0aria2.bat %BACKUP_DIR% E:\Download
  @REM tasklist | find /i "AudioRelay.exe" || powershell Start-Process -WindowStyle hidden "D:\mystream\AudioRelay\AudioRelay.exe"

echo "Next to open other softs, or just close the window."
@REM https://blog.miniasp.com/post/2009/06/24/Sleep-command-in-Batch
timeout /t 10
  tasklist | find /i "Dock_64" || start steam://run/1787090
  @REM tasklist | find /i "VPet" || start steam://run/1920960
  @REM tasklist | find /i "msedge.exe" || start /b microsoft-edge:
  @REM tasklist | find /i "rainmeter.exe" || powershell Start-Process -WindowStyle hidden "rainmeter.exe"
  tasklist | find /i "xyplorer" || powershell Start-Process -WindowStyle hidden "xyplorer.exe"
  @REM tasklist | find /i "bLend" || powershell Start-Process "盘姬工具箱\bLend"
  @REM tasklist | find /i "n0vadesktop.exe" || powershell Start-Process -WindowStyle hidden "n0vadesktop"
  @REM tasklist | find /i "Foxmail.exe" || powershell Start-Process -WindowStyle hidden "Foxmail"
  @REM tasklist | find /i "WXWork.exe" || powershell Start-Process -WindowStyle hidden '企业微信'
  @REM tasklist | find /i "Lark.exe" || powershell Start-Process -WindowStyle hidden "Lark"
  @REM tasklist | find /i "qq.exe" || powershell Start-Process -WindowStyle hidden "QQ-NT"

@REM timeout /t 10
@REM pause
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
  @REM sudo cmd /c %~dp0GitHub520\GitHub520.bat | tee -a %logFile%

@REM scoop-update
  @REM call scoop update | tee -a %logFile%

@REM dailycheckin (cmd会由于Unicode报错)
  @REM call conda activate base
  @REM start powershell dailycheckin --include ACFUN CLOUD189 MUSIC163 TIEBA

@REM 米游社
  @REM call python AutoMihoyoBBS/main.py

@REM bilibili
  @REM cd BILIBILI-HELPER
  @REM call java -jar BILIBILI-HELPER.jar | tee -a %logFile%
  @REM cd ..
  @REM rd /S/Q D:\tmp

@REM biliup
  @REM cd /d G:\Videos\录播\biliup
  @REM biliup --config ./config.toml --http start
