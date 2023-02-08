@REM ==================================================================
@REM
@REM ==================================================================
@echo off
set FILE_PATH=%1
  if not defined FILE_PATH set FILE_PATH=F:\

set DELAY=%2
  @REM 延时 30 秒
  if not defined DELAY set DELAY=30
@REM ==================================================================

:start
  choice /t %DELAY% /d y /n > %FILE_PATH%.dsg
  goto :start
goto :eof
