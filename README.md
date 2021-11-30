<!--
 * @Author: Weidows
 * @Date: 2020-11-28 17:36:36
 * @LastEditors: Weidows
 * @LastEditTime: 2021-11-30 18:17:13
 * @FilePath: \Keeper\README.md
 * @Description:
-->

<h1 align="center">

- ## 🌈Keeper

一些实用的的定时任务集合(线上/线下组合拳).

</h1>

# GitHub-Action

- [x] daily-push `刷绿 profile 格子` (Fork 项目不被计数刷绿; 主旨非作弊行为
- [x] 访问唤醒休眠的 LeanCloud 评论后台 (也可以是其他地址
- [x] 获取`必应壁纸`,存储在 tasks 分支的 Bing 里面.
- [x] 同步 github 仓库到 gitee.
- [x] 调用 dailycheckin / automihoyobbs 定时任务

- 进入 settings 配置 secret :

  |         name         |                                                                               value (不会泄露,未填的项不会启用)                                                                               |
  | :------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
  |      PUSH_EMAIL      |                                                                         github 推送邮箱 (默认使用 Github-action[bot])                                                                         |
  |         URL          |                                                    需要唤醒的地址,支持多个如 `https://weidows.avosapps.us/comments https://www.baidu.com`                                                     |
  |      GITEE_RSA       | 私钥文件内容; 公钥复制到 [用户设置](https://gitee.com/profile/sshkeys); 如何生成秘钥可以查看 [这篇文章](https://weidows.github.io/post/experience/SSH); 需要提前在 gitee 创建同名同邮箱的仓库 |
  |     GITEE_TOKEN      |                                            用于镜像时自动创建不存在的仓库,Gitee 可以在[这里](https://gitee.com/profile/personal_access_tokens)找到                                            |
  | DAILY_CHECKIN_CONFIG |                                                       [dailycheckin](https://github.com/Sitoi/dailycheckin) 的 config.json 配置文件内容                                                       |
  | AUTOMIHOYOBBS_CONFIG |                                                     [automihoyobbs](https://github.com/Womsxd/AutoMihoyoBBS) 的 config.json 配置文件内容                                                      |

![分割线](https://cdn.jsdelivr.net/gh/Weidows/Images/img/divider.png)

# 本机

- 全堆在 [utils.bat](./utils.bat) 里,注释很明确; 下图为样式

  <img src="https://i.loli.net/2021/11/30/dwC5itDyuMkjhWL.png" alt="20211130180628" />

- [x] 备份各种开发配置信息 (包括装的软件/SDK,每个工具装的库,config 文件...)

  `机子有价,数据无价`,可参考我的备份仓库: [Weidows-projects/Programming-Configuration](https://github.com/Weidows-projects/Programming-Configuration)

- [x] 各平台每日签到,某些交给 github-action 容易被查封,所以在本机手动跑.
- [x] 用于管理开机启动/批量启动软件,aria2 后台启动(最佳方案)

![分割线](https://cdn.jsdelivr.net/gh/Weidows/Images/img/divider.png)

# 借鉴

> [justjavac/auto-green](https://github.com/justjavac/auto-green) \
> [mstf/bingdownload](https://gitee.com/mstf/bingdownload) \
> [Yikun/hub-mirror-action](https://github.com/Yikun/hub-mirror-action/)

> [Sitoi/dailycheckin](https://github.com/Sitoi/dailycheckin)\
> [Womsxd/AutoMihoyoBBS](https://github.com/Womsxd/AutoMihoyoBBS)
