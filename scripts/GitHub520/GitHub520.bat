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

@REM set file=%windir%\System32\drivers\etc\hosts
set file=C:\Windows\System32\drivers\etc\hosts
set bak_file=%file%.bak
set curl_file=%file%.github

@REM 获取指定字符串的行号
sed -n "/GitHub520 Host Start/=" %file% > %bak_file%
set /p startLine=<%bak_file%
sed -n "/GitHub520 Host End/=" %file% > %bak_file%
set /p endLine=<%bak_file%

if "%startLine%,%endLine%d"==",d" (
  echo GitHub520 not exists, will append
  copy %file% %bak_file% /Y
) else (
  echo GitHub520 exists, will refresh
  sed %startLine%,%endLine%d %file% > %bak_file%
  copy %bak_file% %file% /Y
)

@REM https://github.com/521xueweihan/GitHub520
curl https://raw.hellogithub.com/hosts > %curl_file%
@REM 去除错误信息, 如下
@REM <html>
@REM <head><title>502 Bad Gateway</title></head>
@REM <body bgcolor="white">
@REM <center><h1>502 Bad Gateway</h1></center>
@REM <hr><center>nginx/1.14.0 (Ubuntu)</center>
@REM </body>
@REM </html>
sed "/</d" %curl_file% >> %file%

echo Finished.
