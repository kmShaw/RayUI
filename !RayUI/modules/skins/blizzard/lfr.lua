local R, C, L, DB = unpack(select(2, ...))
local AddOnName = ...

local function LoadSkin()
	R.Reskin(LFRQueueFrameFindGroupButton)
	R.Reskin(LFRQueueFrameAcceptCommentButton)
	R.Reskin(LFRBrowseFrameSendMessageButton)
	R.Reskin(LFRBrowseFrameInviteButton)
	R.Reskin(LFRBrowseFrameRefreshButton)
	R.ReskinCheck(LFRQueueFrameRoleButtonTank:GetChildren())
	R.ReskinCheck(LFRQueueFrameRoleButtonHealer:GetChildren())
	R.ReskinCheck(LFRQueueFrameRoleButtonDPS:GetChildren())
	R.ReskinDropDown(LFRBrowseFrameRaidDropDown)
	LFRQueueFrame:DisableDrawLayer("BACKGROUND")
	LFRBrowseFrame:DisableDrawLayer("BACKGROUND")
	for i = 1, 7 do
		_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
	end
	if R.HoT then
		R.SetBD(RaidParentFrame)
		RaidParentFrame:DisableDrawLayer("BACKGROUND")
		RaidParentFrame:DisableDrawLayer("BORDER")
		RaidParentFrameInset:DisableDrawLayer("BORDER")
		RaidFinderFrameRoleInset:DisableDrawLayer("BORDER")
		LFRQueueFrameRoleInset:DisableDrawLayer("BORDER")
		LFRQueueFrameListInset:DisableDrawLayer("BORDER")
		LFRQueueFrameCommentInset:DisableDrawLayer("BORDER")
		LFRQueueFrameRoleInsetBg:Hide()
		LFRQueueFrameListInsetBg:Hide()
		LFRQueueFrameCommentInsetBg:Hide()
		local a1, p, a2, x, y = LFRParentFrameSideTab1:GetPoint()
		LFRParentFrameSideTab1:SetPoint(a1, p, a2, x + 11, y)
		LFRParentFrameSideTab1:GetRegions():Hide()
		LFRParentFrameSideTab1:SetCheckedTexture(C.Aurora.checked)
		select(2, LFRParentFrameSideTab1:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		LFRParentFrameSideTab2:SetCheckedTexture(C.Aurora.checked)
		select(2, LFRParentFrameSideTab2:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		RaidFinderQueueFrameBackground:Hide()
		RaidParentFrameInsetBg:Hide()
		RaidFinderFrameRoleInsetBg:Hide()
		RaidFinderFrameRoleBackground:Hide()
		RaidParentFramePortraitFrame:Hide()
		RaidParentFramePortrait:Hide()
		RaidParentFrameTopBorder:Hide()
		RaidParentFrameTopRightCorner:Hide()			
		RaidFinderFrameFindRaidButton_RightSeparator:Hide()
		RaidFinderFrameCancelButton_LeftSeparator:Hide()

		for i = 1, 3 do
			R.CreateTab(_G["RaidParentFrameTab"..i])
		end
		R.CreateBG(LFRParentFrameSideTab1)
		R.CreateBG(LFRParentFrameSideTab2)
		R.CreateSD(LFRParentFrameSideTab1, 5, 0, 0, 0, 1, 1)
		R.CreateSD(LFRParentFrameSideTab2, 5, 0, 0, 0, 1, 1)
		R.Reskin(RaidFinderFrameFindRaidButton)
		R.Reskin(RaidFinderFrameCancelButton)
		R.Reskin(RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)
		R.ReskinDropDown(RaidFinderQueueFrameSelectionDropDown)		
		R.ReskinClose(RaidParentFrameCloseButton)		
	else
		LFRParentFrameIcon:Hide()
		for i = 1, 2 do
			R.CreateTab(_G["LFRParentFrameTab"..i])
		end
		local LFRClose = LFRParentFrame:GetChildren()
		R.ReskinClose(LFRClose, "TOPRIGHT", LFRParentFrame, "TOPRIGHT", -4, -14)
		R.SetBD(LFRParentFrame, 10, -10, 0, 4)		
	end
end

tinsert(R.SkinFuncs[AddOnName], LoadSkin)