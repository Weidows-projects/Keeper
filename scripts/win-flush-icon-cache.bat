@REM https://www.bilibili.com/video/BV1JK411x7YN/
::打开图标缓存文件夹
::cd %localappdata%
cd /d %userprofile%\AppData\Local

::删除图标缓存文件
del IconCache.db /a

::终止进程资源管理器
taskkill /f /im explorer.exe

::启动资源管理器
start explorer.exe
