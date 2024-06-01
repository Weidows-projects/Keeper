@REM ==================================================================
@REM 速查表: 一些现在没用到但可能会用到的命令
@REM ==================================================================
@REM taskkill /F /IM sharemouse.exe
@REM net stop "ShareMouse Service"
@REM net start "ShareMouse Service"
@REM start /b cmd /c "C:\Program Files (x86)\ShareMouse\ShareMouse.exe"

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
  echo         .::::'    ::::::     .:::::::'::::. (6)
  echo        .:::'     :::::::  .:::::::::' ':::::. (5)
  echo       .::'       ::::::.:::::::::'      ':::::. (4)backup
  echo      .::'        :::::::::::::::'         ``::::. (3)boot-starter
  echo  ...:::          :::::::::::::'              ``::. (2)test / change color
  echo  ````':.          ':::::::::'                  ::::.. (1)exit
  echo 输入选项:           '.:::::'                    ':'```:..
  CHOICE /C 12345678
  echo =============================================================================


  if %errorlevel%==1 exit
  if %errorlevel%==2 call :test
  if %errorlevel%==3 cmd /c %~dp0scripts\booter.bat %BACKUP_DIR%
  if %errorlevel%==4 cmd /c %~dp0scripts\backup.bat %BACKUP_DIR%


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
