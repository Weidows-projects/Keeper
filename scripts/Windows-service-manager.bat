@echo off
chcp 65001

@REM https://blog.csdn.net/weixin_40461281/article/details/111563206
@REM 自动
@REM sudo sc config 服务名 start= auto



@REM 手动
@REM sudo sc config 服务名 start= demand



@REM 禁用 (不会停止)
@REM sudo sc config 服务名 start= disabled
sudo sc config "VMAuthdService" start= disabled
sudo sc config "VMnetDHCP" start= disabled
sudo sc config "VMware NAT Service" start= disabled
sudo sc config "VMUSBArbService" start= disabled
sudo sc config "VmwareAutostartService" start= disabled

sudo sc config "AsusAppService" start= disabled
sudo sc config "LightingService" start= disabled
sudo sc config "ASUSLinkNear" start= disabled
sudo sc config "ASUSLinkRemote" start= disabled
sudo sc config "ASUSOptimization" start= disabled
sudo sc config "ASUSSoftwareManager" start= disabled
sudo sc config "ASUSSwitch" start= disabled
sudo sc config "ASUSSystemAnalysis" start= disabled
sudo sc config "ASUSSystemDiagnosis" start= disabled
sudo sc config "asus" start= disabled
sudo sc config "asusm" start= disabled

sudo sc config "pcmastersvc" start= disabled
sudo sc config "Winmgmt" start= disabled



@REM 停止
@REM sudo net stop 服务名
sudo net stop "VMAuthdService"
sudo net stop "VMnetDHCP"
sudo net stop "VMware NAT Service"
sudo net stop "VMUSBArbService"
sudo net stop "VmwareAutostartService"

sudo net stop "AsusAppService"
sudo net stop "LightingService"
sudo net stop "ASUSLinkNear"
sudo net stop "ASUSLinkRemote"
sudo net stop "ASUSOptimization"
sudo net stop "ASUSSoftwareManager"
sudo net stop "ASUSSwitch"
sudo net stop "ASUSSystemAnalysis"
sudo net stop "ASUSSystemDiagnosis"
sudo net stop "asus"
sudo net stop "asusm"

sudo net stop "pcmastersvc"

@REM 解决 WMI 占用问题: https://www.mobile01.com/topicdetail.php?f=296&t=6690829
sudo net stop "Winmgmt"



@REM 启动
@REM sudo net start "Winmgmt"

pause
