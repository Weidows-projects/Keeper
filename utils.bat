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

  @REM 下载目录, 默认为 D:\Download
  set DOWNLOAD_DIR=
    if not defined DOWNLOAD_DIR set DOWNLOAD_DIR=D:\Download





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
    xcopy %HOME%\.yarnrc . /y/d
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
  start /b TIM.exe
  @REM start /b wechat-mod.exe

  @REM 工具
  call :aria2
  start /b xyplorer.exe
  start /b MouseInc
goto :eof






@REM ==================================================================
@REM Daily: scoop-update / Bilibili
@REM ==================================================================
:daily-helper
  @REM %~dp0 为脚本所在路径; %cd% 类似 pwd,当前路径
  cd /d %BACKUP_DIR%\backup

  @REM log
    for /l %%i in (1 1 5) do echo.>> log\tasks.log
    set date =date /T
    echo =================================%date%===========================>> log\tasks.log

  @REM scoop-update
    call scoop update | tee -a log\tasks.log

  @REM 521xueweihan/GitHub520
    set filename=%windir%\System32\drivers\etc\hosts
    set temp_file=%filename%.bak

    @REM 获取指定字符串的行号
    sed -n "/GitHub520 Host Start/=" %filename% > %temp_file%
    set /p startLine=<%temp_file%
    sed -n "/GitHub520 Host End/=" %filename% > %temp_file%
    set /p endLine=<%temp_file%

    sed %startLine%,%endLine%d %filename% > %temp_file%
    xcopy %temp_file% %filename% /y/d

    curl https://raw.hellogithub.com/hosts >> %filename%

  @REM dailycheckin (cmd会由于Unicode报错)
    @REM call conda activate base
    @REM start powershell dailycheckin --include ACFUN CLOUD189 MUSIC163 TIEBA

  @REM 米游社
    @REM call python AutoMihoyoBBS/main.py

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
  echo.
  DIR /B %specifiedPath%
  echo.
goto :eof






@REM ==================================================================
@REM 测试
@REM ==================================================================
:test
  echo Testing...


goto :eof






@REM ==================================================================
@REM 子函数 (需要多处调用/调试的抽离出来; 不录入Menu)
@REM ==================================================================
:aria2
  @REM aria2: 直接通过shell启动会被它占用,所以另开
  @REM 调用链: utils.bat -> aria2.vbs -> aria2.exe -> aria2.conf -> aria2.session

  @REM aria2.session
  touch %BACKUP_DIR%\others\aria2\aria2.session

  @REM 括号内命令的标准输出会重定向到 aria2.conf
  (
    echo ## # 开头为注释内容, 选项都有相应的注释说明, 根据需要修改 ##
    echo ## 被注释的选项填写的是默认值, 建议在需要修改时再取消注释  ##
    echo.
    echo ## 文件保存相关 ##
    echo.
    echo # 文件的保存路径 （可使用绝对路径或相对路径）, 默认: 当前启动位置
    echo dir=%DOWNLOAD_DIR%
    echo # 启用磁盘缓存, 0 为禁用缓存, 需 1.16 以上版本, 默认:16M
    echo #disk-cache=
    echo # 文件预分配方式, 能有效降低磁盘碎片, 默认:prealloc
    echo # 预分配所需时间: none 《 falloc ? trunc 《 prealloc
    echo # falloc 和 trunc 则需要文件系统和内核支持
    echo # NTFS 建议使用 falloc, EXT3/4 建议 trunc, MAC 下需要注释此项
    echo file-allocation=none
    echo # 断点续传
    echo continue=true
    echo.
    echo ## 下载连接相关 ##
    echo.
    echo # 最大同时下载任务数, 运行时可修改, 默认:5
    echo max-concurrent-downloads=5
    echo # 同一服务器连接数, 添加时可指定, 默认:1
    echo max-connection-per-server=16
    echo # 最小文件分片大小, 添加时可指定, 取值范围 1M -1024M, 默认:20M
    echo # 假定 size=10M, 文件为 20MiB 则使用两个来源下载; 文件为 15MiB 则使用一个来源下载
    echo # min-split-size=1M
    echo # 单个任务最大线程数, 添加时可指定, 默认:5
    echo # split=32
    echo # 整体下载速度限制, 运行时可修改, 默认:0
    echo #max-overall-download-limit=0
    echo # 单个任务下载速度限制, 默认:0
    echo #max-download-limit=0
    echo # 整体上传速度限制, 运行时可修改, 默认:0
    echo #max-overall-upload-limit=0
    echo # 单个任务上传速度限制, 默认:0
    echo #max-upload-limit=0
    echo # 禁用 IPv6, 默认:false
    echo # disable-ipv6=true
    echo.
    echo ## 进度保存相关 ##
    echo.
    echo # 从会话文件中读取下载任务
    echo input-file=%BACKUP_DIR%\others\aria2\aria2.session
    echo # 在 Aria2 退出时保存 ` 错误 / 未完成 ` 的下载任务到会话文件
    echo save-session=%BACKUP_DIR%\others\aria2\aria2.session
    echo # 定时保存会话, 0 为退出时才保存, 需 1.16.1 以上版本, 默认:0
    echo save-session-interval=60
    echo.
    echo ## RPC 相关设置 ##
    echo.
    echo # 启用 RPC, 默认:false
    echo enable-rpc=true
    echo # 允许所有来源, 默认:false
    echo rpc-allow-origin-all=true
    echo # 允许非外部访问, 默认:false
    echo rpc-listen-all=true
    echo # 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同
    echo #event-poll=select
    echo # RPC 监听端口, 端口被占用时可以修改, 默认:6800
    echo #rpc-listen-port=6800
    echo # 设置的 RPC 授权令牌, v1.18.4 新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
    echo #rpc-secret=12345678
    echo # 设置的 RPC 访问用户名, 此选项新版已废弃, 建议改用 --rpc-secret 选项
    echo #rpc-user=《USER》
    echo #rpc-passwd=《PASSWD》
    echo.
    echo ## BT/PT 下载相关 ##
    echo.
    echo # 当下载的是一个种子（以.torrent 结尾） 时, 自动开始 BT 任务, 默认:true
    echo #follow-torrent=true
    echo # BT 监听端口, 当端口被屏蔽时使用, 默认:6881-6999
    echo listen-port=51413
    echo # 单个种子最大连接数, 默认:55
    echo #bt-max-peers=55
    echo # 打开 DHT 功能, PT 需要禁用, 默认:true
    echo enable-dht=false
    echo # 打开 IPv6 DHT 功能, PT 需要禁用
    echo #enable-dht6=false
    echo # DHT 网络监听端口, 默认:6881-6999
    echo #dht-listen-port=6881-6999
    echo # 本地节点查找, PT 需要禁用, 默认:false
    echo #bt-enable-lpd=false
    echo # 种子交换, PT 需要禁用, 默认:true
    echo enable-peer-exchange=false
    echo # 每个种子限速, 对少种的 PT 很有用, 默认:50K
    echo #bt-request-peer-speed-limit=50K
    echo # 客户端伪装, PT 需要
    echo peer-id-prefix=-TR2770-
    echo user-agent=Transmission/2.77
    echo # 当种子的分享率达到这个数时, 自动停止做种, 0 为一直做种, 默认:1.0
    echo seed-ratio=0
    echo # 强制保存会话, 即使任务已经完成, 默认:false
    echo # 较新的版本开启后会在任务完成后依然保留.aria2 文件
    echo #force-save=false
    echo # BT 校验相关, 默认:true
    echo #bt-hash-check-seed=true
    echo # 继续之前的 BT 任务时, 无需再次校验, 默认:false
    echo bt-seed-unverified=true
    echo # 保存磁力链接元数据为种子文件（.torrent 文件）, 默认:false
    echo bt-save-metadata=true
  )> %BACKUP_DIR%\others\aria2\aria2.conf
    call curl -s https://trackerslist.com/best_aria2.txt>%BACKUP_DIR%\others\aria2\trackerslist.txt
    set /p trackerslist=<%BACKUP_DIR%\others\aria2\trackerslist.txt
    echo bt-tracker=%trackerslist%>>%BACKUP_DIR%\others\aria2\aria2.conf

  @REM aria2.vbs
  echo CreateObject("WScript.Shell").Run "aria2c --conf-path=%BACKUP_DIR%\others\aria2\aria2.conf",0 > %BACKUP_DIR%\others\aria2\aria2.vbs
  cscript //Nologo %BACKUP_DIR%\others\aria2\aria2.vbs
goto :eof
