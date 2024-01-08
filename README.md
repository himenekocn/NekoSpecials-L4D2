# NekoSpecials
Specials plugin that can be customized in real time!<br>
可实时自定化的多特插件!<br>
官网[点我跳转](https://himeneko.cn/nekospecials)<br>
插件介绍:<br>[[【求生之路2】NEKO多特插件更新内容介绍!]](https://www.bilibili.com/video/BV1Eh411n7op)<br>[[求生之路2 更好的多特与击杀统计插件]](https://www.bilibili.com/video/BV1GN411Z7um)

# 使用注意
请看完本页说明，不看完的都是🐖<br>
如果你是直接下载仓库内最新版本使用，请记得在出现错误或不可用时提交日志，QQ:846490391

# 插件安装
1.安装Sourcemod插件平台到1.11+最新版本<br>
2.安装[left4dhooks](https://forums.alliedmods.net/showthread.php?p=2684862)最新版本<br>
3.需要投票的安装[nativevotes](https://github.com/sapphonie/sourcemod-nativevotes-updated)最新版本，不需要投票功能的可以忽略这一步<br>
4.下载[插件(点我开始下载)](https://mirror.ghproxy.com/https://github.com/himenekocn/NekoSpecials-L4D2/archive/refs/heads/NSPRE-SM1.11+.zip)，将插件拖到服务器的left4dead2文件夹中覆盖<br>
5.修改插件对应cfg

# 插件推荐平台
[Sourcemod-1.11-Dev6854](https://www.sourcemod.net/downloads.php?branch=stable)<br>
保持最新插件稳定平台就是啦！

# 注意：插件不生效请查看错误日志输入，日志在addons/sourcemod/logs里面，error开头就是

# 插件模块介绍
【插件必备组件】BinHooks<br>
【插件必备组件】[dhooks](https://forums.alliedmods.net/showthread.php?p=2588686#post2588686) SM1.11-6854后自带，不需要安装<br>
【插件必备组件】[left4dhooks](https://forums.alliedmods.net/showthread.php?p=2684862)(请手动安装最新版本)<br>
【插件必备组件】[nativevotes](https://github.com/sapphonie/sourcemod-nativevotes-updated)(请手动安装最新版本，不需要的可以忽略这个)<br>
【插件可选组件】[SourceScramble](https://github.com/nosoop/SMExt-SourceScramble/releases/tag/0.7.1)(插件版HUD需要)<br>
【多特本体模块】[NekoSpecials](https://himeneko.cn/nekospecials) (可选安装，默认安装)<br>
【击杀统计模块】[NekoKillHud](https://himeneko.cn/nekospecials) (可选安装，默认安装)<br>
【管理员快捷功能模块】[NekoAdminMenu](https://himeneko.cn/nekospecials) (可选安装，默认安装)<br>
【服务器名字功能模块】[NekoServerName](https://himeneko.cn/nekospecials) (可选安装，默认安装)<br>
【玩家特感投票模块】[NekoVote](https://himeneko.cn/nekospecials) (可选安装，默认安装) 投票插件默认开关为关闭，需手动在cfg/或者管理员菜单开启<br>
【击杀统计模块插件版】[NekoKillHud-Plu](https://himeneko.cn/nekospecials) (默认使用拓展版本，插件版在disabled文件夹中，建议使用拓展版本，插件版需要闪屏补丁，插件不自带)<br>
【控制坦克女巫刷新】[l4d2_boss_spawn](https://forums.alliedmods.net/showthread.php?p=2694435)(推荐可选)(开启Special_CanCloseDirector后请配合使用)<br>

# 玩家指令
!tgvote 或者直接输入tgvote等 即可打开玩家投票菜单

# 管理员指令
!ntg					    全功能特感菜单<br>
!ntgversion				特感版本查询/状态检查<br>
!nhud					    HUD显示调整<br>
!reloadntgconfig	重载多特配置文件(Neko_Specials_binhooks.cfg)<br>
!reloadhudconfig	重载HUD配置文件(Neko_KillHud_binhooks.cfg)<br>
!updateservername	手动更新服务器名字<br>
!nekoupdate				执行检查更新<br>
!tgvoteadmin			控制玩家投票模块

# 子模式说明：
普通模式下:<br>
有两个子模式,子模式1和子模式2无论是刷特位置和刷特性能并无明显的变化<br>
子模式1-更趋近于对每个幸存者的位置对应的刷特位置产生最优解;<br>
子模式2-更趋近于对于整体队伍的位置对应的刷特位置产生最优解;<br>
玩家可根据自身情况自由选择。<br>
<br>
噩梦模式下：<br>
子模式1-为原来噩梦模式；<br>
子模式2-开启梦魇模式，根据官方底层api基础上运用算法实现的，它比噩梦模式更加强大，<br>
无论是刷特机制，刷特位置，刷特性能等，以及开发自由度上，都比噩梦模式更加优越，它不是在噩梦基础上进行提升的，它是全新的更优越的算法模式。<br>
<br>
地狱模式下：<br>
请慎用此模式，非抖M请远离...<br>
子模式1-为原来地狱模式；<br>
子模式2-是炼狱模式，根据官方底层api基础上运用算法实现的，它比地狱模式更加强大，<br>
无论是刷特机制，刷特位置，刷特性能等，以及开发自由度上，都比地狱模式更加优越，它不是在地狱基础上进行提升的，它是全新的更优越的算法模式。<br>

# 更新日志
6.32NS 更新日志 2024/01/2 01:00<br>
修复聊天栏输入指令不显示问题<br>
部分语法更新优化简化<br>
增加了踢出卡住特感的开关选项<br>
修复坦克存活刷特关闭后依旧刷特问题<br>
HUD支持显示8人，并加入坦克女巫击杀统计<br>

6.30NS 更新日志 2023/06/1 22:20<br>
小更新<br>

# 插件版HUD闪烁问题
方法一：安装防止闪烁补丁（6.30包已经自带）
方法二：替换NekoKillHUD为拓展版本

# 解决开服等待过长问题（老版本，6.30已解决）
Linux:<br>
用 ip addr 获取主网卡名称<br>
然后输入<br>
ip route add 101.43.237.219 via 0.0.0.0 dev 网卡名称<br>
Win:<br>
添加一个虚拟网卡，设置虚拟网卡Ipv4为101.43.237.219

# 使用规范
使用本插件时请遵守顾问的使用规范，勿将本插件用作商用(RPG)，有BUG问题等请联系作者：846490391
