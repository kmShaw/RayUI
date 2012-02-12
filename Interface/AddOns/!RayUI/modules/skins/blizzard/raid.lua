local R, C, L, DB = unpack(select(2, ...))

local function LoadSkin()
	R.ReskinCheck(RaidFrameAllAssistCheckButton)
	ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)
	R.Reskin(RaidFrameReadyCheckButton)
	R.Reskin(ReadyCheckFrameYesButton)
	R.Reskin(ReadyCheckFrameNoButton)
	R.Reskin(RaidFrameReadyCheckButton)
	ReadyCheckPortrait:SetAlpha(0)
	select(2, ReadyCheckListenerFrame:GetRegions()):Hide()
	
	local StripAllTextures = {
		"RaidGroup1",
		"RaidGroup2",
		"RaidGroup3",
		"RaidGroup4",
		"RaidGroup5",
		"RaidGroup6",
		"RaidGroup7",
		"RaidGroup8",
	}

	for _, object in pairs(StripAllTextures) do		
		if _G[object] then
			_G[object]:StripTextures()
			R.CreateBD(_G[object], .2)
		end
	end

	for i=1, MAX_RAID_GROUPS*5 do
		_G["RaidGroupButton"..i]:StripTextures()
		R.Reskin(_G["RaidGroupButton"..i])
	end
	
	for i=1,8 do
		for j=1,5 do
			_G["RaidGroup"..i.."Slot"..j]:StripTextures()
			select(1,_G["RaidGroup"..i.."Slot"..j]:GetRegions()):Kill()
		end
	end
end

R.SkinFuncs["Blizzard_RaidUI"] = LoadSkin