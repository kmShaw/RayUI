local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("RayUIConfig", "zhCN", true)
if not L then return end

L["|cff7aa6d6Ray|r|cffff0000U|r|cff7aa6d6I|r设置"] = true
L["版本"] = true
L["改变参数需重载应用设置"] = true
L["解锁锚点"] = true
L["解锁并移动头像和动作条"] = true
L["一般"] = true
	L["UI缩放"] = true
	L["UI界面缩放"] = true
L["头像"] = true
	L["生命条按职业着色"] = true
	L["法力条按职业着色"] = true
	L["平滑变化"] = true
	L["颜色随血量渐变"] = true
	L["显示小队"] = true
	L["显示BOSS"] = true
	L["显示竞技场头像"] = true
L["团队"] = true
	L["启用"] = true
	L["单位长度"] = true
	L["单位高度"] = true
	L["间距"] = true
	L["小队数"] = true
	L["solo时显示"] = true
	L["在队伍中显示自己"] = true
	L["小队也显示团队框体"] = true
	L["水平排列"] = true
		L["小队成员水平排列"] = true
	L["小队增长方向"] = true
		L["上"] = true
		L["下"] = true
		L["左"] = true
		L["右"] = true
	L["法力条高度"] = true
	L["超出距离透明度"] = true
	L["箭头方向指示"] = true
	L["鼠标悬停时显示"] = true
		L["只在鼠标悬停时显示方向指示"] = true
	L["治疗预读"] = true
	L["显示过量预读"] = true
	L["只显示他人预读"] = true
	L["职责图标"] = true
	L["AFK文字"] = true
	L["技能图标大小"] = true
	L["角标大小"] = true
	L["职责图标大小"] = true
	L["特殊标志大小"] = true
		L["特殊标志大小, 如愈合祷言标志"] = true
	L["缺失生命文字"] = true
	L["当前生命文字"] = true
	L["生命值百分比"] = true
	L["可驱散提示"] = true
	L["鼠标悬停高亮"] = true
	L["鼠标提示"] = true
	L["屏蔽右键菜单"] = true
L["动作条"] = true
	L["动作条缩放"] = true
	L["宠物动作条缩放"] = true
	L["按键大小"] = true
	L["按键间距"] = true
	L["显示宏名称"] = true
	L["显示物品数量"] = true
	L["显示快捷键"] = true
	L["动作条1"] = true
	L["动作条2"] = true
	L["动作条3"] = true
	L["动作条4"] = true
	L["动作条5"] = true
	L["宠物条"] = true
	L["姿态"] = true
		L["自动隐藏"] = true
		L["鼠标滑过显示"] = true
L["聊天"] = true
	L["自动隐藏聊天栏"] = true
	L["短时间内没有消息则自动隐藏聊天栏"] = true
	L["自动隐藏时间"] = true
	L["设置多少秒没有新消息时隐藏"] = true
	L["自动显示聊天栏"] = true
	L["频道内有信消息则自动显示聊天栏，关闭后如有新密语会闪烁提示"] = true
L["小玩意儿"] = true
	L["通报"] = true
		L["打断通报，打断、驱散、进出战斗文字提示"] = true
	L["拍卖行"] = true
		L["Shift + 右键直接一口价，价格上限请在misc/auction.lua里设置"] = true
	L["自动贪婪"] = true
		L["满级之后自动贪婪/分解绿装"] = true
	L["自动释放尸体"] = true
		L["战场中自动释放尸体"] = true
	L["商人"] = true
		L["自动修理、自动卖灰色物品"] = true
	L["补购毒药"] = true
		L["自动补购毒药，数量在misc/merchant.lua里修改"] = true
	L["任务"] = true
		L["任务等级，进/出副本自动收起/展开任务追踪，任务面板的展开/收起全部分类按钮"] = true
	L["自动交接任务"] = true
		L["自动交接任务，按shift点npc则不自动交接"] = true
	L["buff提醒"] = true
		L["缺失重要buff时提醒"] = true
L["插件美化"] = true
	L["Skada"] = true
		L["固定Skada位置"] = true
	L["DBM"] = true
		L["固定DBM位置"] = true
	L["ACE3控制台"] = true
	L["ACP"] = true
	L["Atlasloot"] = true
	L["BigWigs"] = true