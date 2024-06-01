@REM ==================================================================
@REM aria2: 直接通过shell启动会被它占用,此处通过vbs另开
@REM 调用链: utils.bat -> aria2.vbs -> aria2.exe -> aria2.conf -> aria2.session
@REM 需要通过参数传递或者手动修改下面设置 BACKUP_DIR 和 DOWNLOAD_DIR
@REM ==================================================================
@echo off

@REM 检测是否已运行
@REM https://blog.csdn.net/yelllowcong/article/details/78424329
@REM ps |grep aria2 |grep -v "grep" |wc -l
@REM https://blog.csdn.net/asfuyao/article/details/8931828 | windows-find 在 powershell 中会提示 "FIND: 参数格式不正确"
tasklist | find /i "aria2c.exe" && goto :eof

@REM 配置和启动脚本目录 (空的就行)
set BACKUP_DIR=%1
  if not defined BACKUP_DIR set BACKUP_DIR=backup

@REM 下载目录, 默认为 D:\Download
set DOWNLOAD_DIR=%2
  if not defined DOWNLOAD_DIR set DOWNLOAD_DIR=D:\Download
@REM ==================================================================

@REM aria2.session
mkdir %BACKUP_DIR%\others\aria2\ >nul 2>&1
touch %BACKUP_DIR%\others\aria2\aria2.session

@REM 括号内命令的标准输出会重定向到 aria2.conf
@REM https://aria2.github.io/manual/en/html/aria2c.html
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
  echo file-allocation=falloc
  echo # 断点续传
  echo continue=true
  echo.
  echo ## 下载连接相关 ##
  echo.
  echo # 代理服务器
  echo all-proxy=http://127.0.0.1:7890
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
  echo # 防止出现CA版本低导致的下载失败
  echo # aria2 SSL/TLS handshake failure: unable to get local issuer certificate https://github.com/aria2/aria2/issues/1636
  echo check-certificate=false
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
  echo enable-dht=true
  echo # 打开 IPv6 DHT 功能, PT 需要禁用
  echo #enable-dht6=true
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
  echo seed-ratio=1.0
  echo # 强制保存会话, 即使任务已经完成, 默认:false
  echo # 较新的版本开启后会在任务完成后依然保留.aria2 文件
  echo #force-save=false
  echo # BT 校验相关, 默认:true
  echo #bt-hash-check-seed=true
  echo # 继续之前的 BT 任务时, 无需再次校验, 默认:false
  echo bt-seed-unverified=true
  echo # 保存磁力链接元数据为种子文件（.torrent 文件）, 默认:false
  echo bt-save-metadata=true

  echo # 使用 UTF-8 处理 Content-Disposition, 默认:false
  echo content-disposition-default-utf8=true
  echo # 启用后台进程
  echo daemon=true
  echo user-agent=LogStatistic
  echo check-certificate=false
)> %BACKUP_DIR%\others\aria2\aria2.conf

@REM Tracker 服务器地址 https://trackerslist.com/#/zh
call curl -s https://gitea.com/XIU2/TrackersListCollection/raw/branch/master/all_aria2.txt>%BACKUP_DIR%\others\aria2\trackerslist.txt

@REM 不换行追加 https://blog.csdn.net/qq_45534098/article/details/111556785
>>%BACKUP_DIR%\others\aria2\aria2.conf set /p="bt-tracker=" <nul
type %BACKUP_DIR%\others\aria2\trackerslist.txt >> %BACKUP_DIR%\others\aria2\aria2.conf
del %BACKUP_DIR%\others\aria2\trackerslist.txt

@REM https://learn.microsoft.com/zh-cn/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.3
powershell Start-Process -WindowStyle hidden aria2c.exe --conf-path=%BACKUP_DIR%\others\aria2\aria2.conf
