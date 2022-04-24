@REM  * @?: **********************************************************
@REM  * @Author: Weidows
@REM  * @Date: 2022-04-24 11:38:38
@REM  * @LastEditors: Weidows
@REM  * @LastEditTime: 2022-04-24 11:53:18
@REM  * @FilePath: \Keeper\scripts\GitHub-520.bat
@REM  * @Description: 手动刷新 GitHub520 hosts + 原版备份
@REM  * 报错了的话检查一下是不是 hosts 里面 GitHub520 重复了
@REM  * @!: **********************************************************
@echo off

@REM set filename=%windir%\System32\drivers\etc\hosts
set filename=C:\Windows\System32\drivers\etc\hosts
set temp_file=%filename%.bak

@REM 获取指定字符串的行号
sed -n "/GitHub520 Host Start/=" %filename% > %temp_file%
set /p startLine=<%temp_file%
sed -n "/GitHub520 Host End/=" %filename% > %temp_file%
set /p endLine=<%temp_file%

if "%startLine%,%endLine%d"==",d" (
  echo GitHub520 not exists, will append
  copy %filename% %temp_file% /Y
) else (
  echo GitHub520 exists, will refresh
  sed %startLine%,%endLine%d %filename% > %temp_file%
  copy %temp_file% %filename% /Y
)
curl https://raw.hellogithub.com/hosts >> %filename%

echo.
echo Finished.
