# NekoSpecials
Specials plugin that can be customized in real time!<br>
可实时自定化的多特插件!<br>
最新版本下载[点我跳转](https://himeneko.cn/nekospecials)<br>
插件介绍:<br>[[【求生之路2】NEKO多特插件更新内容介绍!]](https://www.bilibili.com/video/BV1Eh411n7op)<br>[[求生之路2 更好的多特与击杀统计插件]](https://www.bilibili.com/video/BV1GN411Z7um)

# 插件推荐平台
[Sourcemod-1.11-Dev6826](https://www.sourcemod.net/downloads.php?branch=dev)

# 插件模块介绍
【插件必备组件】BinHooks<br>
【插件必备组件】[dhooks](https://forums.alliedmods.net/showthread.php?p=2588686#post2588686)<br>
【插件必备组件】[left4dhooks](https://forums.alliedmods.net/showthread.php?p=2684862)<br>
【插件必备组件】[nativevotes](https://github.com/sapphonie/sourcemod-nativevotes-updated)(投票插件需要)<br>
【多特本体模块】[NekoSpecials](https://himeneko.cn/nekospecials)<br>
【击杀统计模块】NekoKillHud<br>
【管理员快捷功能模块】NekoAdminMenu<br>
【服务器名字功能模块】NekoServerName<br>
【玩家特感投票模块】NekoVote 投票插件默认开关为关闭，需手动在cfg/或者管理员菜单开启<br>
【控制坦克女巫刷新】[l4d2_boss_spawn](https://forums.alliedmods.net/showthread.php?p=2694435)（可选)（开启Special_CanCloseDirector后请配合使用）<br>

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
6.25NS 更新日志 2022/01/06 04:00<br>
修复随即特感bug<br>

6.24NS 更新日志 2022/01/06 03:50<br>
修复投票小bug<br>

6.23NS 更新日志 2022/01/06 03:30<br>
修复投票崩溃问题<br>

6.21NS 更新日志 2021/12/09 14:58<br>
服务器名字模块增加防止服务器休眠参数
HUD模块修复了下聊天栏样式的问题<br>

6.2NS 更新日志 2021/12/08 17:20<br>
优化步骤，修复一些小问题
更新投票模块
更新boss_spawn到最新版本<br>

6.1NS 更新日志 2021/12/02 20:30<br>
更新cfg写入, 优化代码流程
更新至最新的1.11版本，包括语法<br>


# 使用规范
使用本插件时请遵守总监的使用规范，勿将本插件用作与商用，有BUG问题等请联系作者：846490391
