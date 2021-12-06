# NekoSpecials
Specials plugin that can be customized in real time!<br>
可实时自定化的多特插件!<br>
最新版本下载[点我跳转](https://himeneko.cn/nekospecials)<br>
插件介绍:<br>[[【求生之路2】NEKO多特插件更新内容介绍!]](https://www.bilibili.com/video/BV1Eh411n7op)<br>[[求生之路2 更好的多特与击杀统计插件]](https://www.bilibili.com/video/BV1GN411Z7um)

# 插件推荐平台
[Sourcemod-1.10-Dev6528](https://www.sourcemod.net/downloads.php?branch=stable)
[Sourcemod-1.11-Dev6826](https://www.sourcemod.net/downloads.php?branch=dev)

# 插件模块介绍
【插件必备组件】BinHooks<br>
【插件必备组件】[dhooks](https://forums.alliedmods.net/showthread.php?p=2588686#post2588686)<br>
【插件必备组件】[left4dhooks](https://forums.alliedmods.net/showthread.php?p=2684862)<br>
【多特本体模块】[NekoSpecials](https://himeneko.cn/nekospecials)<br>
【击杀统计模块】NekoKillHud<br>
【管理员快捷功能模块】NekoAdminMenu<br>
【服务器名字功能模块】NekoServerName<br>
【控制坦克女巫刷新】[l4d2_boss_spawn](https://forums.alliedmods.net/showthread.php?p=2694435)（可选)（开启Special_CanCloseDirector后请配合使用）<br>

# 插件指令
!ntg					    全功能特感菜单<br>
!ntgversion				特感版本查询/状态检查<br>
!nhud					    HUD显示调整<br>
!reloadntgconfig	重载多特配置文件(Neko_Specials_binhooks.cfg)<br>
!reloadhugconfig	重载HUD配置文件(Neko_KillHud_binhooks.cfg)<br>
!updateservername	手动更新服务器名字<br>
!nekoupdate				执行检查更新<br>

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
6.02NS 更新日志 2021/10/18 00:15 <br>
修复HUD模块聊天栏模式数据不准确问题，修复多特提示延迟问题

6.01NS 更新日志 2021/10/16 13:35 <br>
修复一些小问题

6.00NS 更新日志 2021/10/16 02:20 <br>
全面更新最新版拓展，更新更多自定义参数，优化插件逻辑与流程

5.56NS 更新日志 2021/10/10 18:00 <br>
修复bug

5.55NS 更新日志 2021/10/10 17:30 <br>
更新9D版本，融合最新API功能

5.52NS 更新日志 2021/9/05 22:05 <br>
修复不刷特问题，增加一些指令

5.51NS 更新日志 2021/9/05 16:41 <br>
回滚9b拓展版本，新增其他模式也能使用HUD

5.50NS 更新日志 2021/8/16 02:14 <br>
修复坦克统计伤害过高问题

5.49NS 更新日志 2021/8/9 17:00 <br>
更新新语法

5.48NS 更新日志 2021/7/28 12:28 <br>
更新拓展，更新一个选项

5.47NS 更新日志 2021/7/27 12:28 <br>
更新拓展，已支持玩家不在生还队伍时也能刷特

5.46NS 更新日志 2021/7/19 15:30 <br>
优化菜单显示，服名插件增加可选显秒，优化插件执行逻辑

5.43NS 更新日志 2021/7/19 14:00 <br>
修复服务器名字刷新时间不准确问题，增加一个新的Hook

5.42NS 更新日志 2021/7/19 12:35 <br>
紧急修复报错

5.41NS 更新日志 2021/7/19 12:10 <br>
修复提示问题，增加自动更新模块

5.40NS 更新日志 2021/7/19 01:10 <br>
增加更多API接口，菜单现在可显示状态，服务器改名插件更新，支持自定义！

# 使用规范
使用本插件时请遵守总监的使用规范，勿将本插件用作与商用，有BUG问题等请联系作者：846490391
