local R, C, L, DB = unpack(select(2, ...))
local AddOnName = ...

local function LoadSkin()
	R.SetBD(SpellBookFrame)
	R.ReskinArrow(SpellBookPrevPageButton, 1)
	R.ReskinArrow(SpellBookNextPageButton, 2)
	R.Reskin(SpellBookCompanionSummonButton)
	R.ReskinClose(SpellBookFrameCloseButton)
	SpellBookFrame:DisableDrawLayer("BACKGROUND")
	SpellBookFrame:DisableDrawLayer("BORDER")
	SpellBookFrame:DisableDrawLayer("OVERLAY")
	SpellBookFrameInset:DisableDrawLayer("BORDER")
	SpellBookCompanionModelFrameShadowOverlay:Hide()
	SpellBookCompanionModelFrameRotateLeftButton:Hide()
	SpellBookCompanionModelFrameRotateRightButton:Hide()
	SpellBookCompanionsModelFrame:Hide()
	SpellBookPageText:SetTextColor(.8, .8, .8)
	
	hooksecurefunc("UpdateProfessionButton", function(self)
		self.spellString:SetTextColor(1, 1, 1);	
		self.subSpellString:SetTextColor(1, 1, 1)
	end)
	
	local lightbds = {
		"SpellBookCompanionModelFrame",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}
	for i = 1, #lightbds do
		R.CreateBD(_G[lightbds[i]], .25)
	end
	
	for i = 1, 5 do
		R.CreateTab(_G["SpellBookFrameTabButton"..i])
	end

	for i = 1, SPELLS_PER_PAGE do
		local bu = _G["SpellButton"..i]
		local ic = _G["SpellButton"..i.."IconTexture"]
		_G["SpellButton"..i.."Background"]:SetAlpha(0)
		_G["SpellButton"..i.."TextBackground"]:Hide()
		_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
		_G["SpellButton"..i.."UnlearnedSlotFrame"]:SetAlpha(0)
		_G["SpellButton"..i.."Highlight"]:SetAlpha(0)

		bu:SetCheckedTexture("")
		bu:SetPushedTexture("")

		ic:SetTexCoord(.08, .92, .08, .92)

		ic.bg = R.CreateBG(bu)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		local slot, slotType = SpellBook_GetSpellBookSlot(self);
		local name = self:GetName();
		local subSpellString = _G[name.."SubSpellName"]

		subSpellString:SetTextColor(1, 1, 1)
		if slotType == "FUTURESPELL" then
			local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
			if (level and level > UnitLevel("player")) then
				self.RequiredLevelString:SetTextColor(.7, .7, .7)
				self.SpellName:SetTextColor(.7, .7, .7)
				subSpellString:SetTextColor(.7, .7, .7)
			end
		end

		local ic = _G[name.."IconTexture"]
		if not ic.bg then return end
		if ic:IsShown() then
			ic.bg:Show()
		else
			ic.bg:Hide()
		end
	end)

	for i = 1, 5 do
		local tab = _G["SpellBookSkillLineTab"..i]
		tab:GetRegions():Hide()
		tab:SetCheckedTexture(C.Aurora.checked)
		local a1, p, a2, x, y = tab:GetPoint()
		tab:SetPoint(a1, p, a2, x + 11, y)
		R.CreateBG(tab)
		R.CreateSD(tab, 5, 0, 0, 0, 1, 1)
		_G["SpellBookSkillLineTab"..i.."TabardIconFrame"]:SetTexCoord(.08, .92, .08, .92)
		select(4, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
	end

	local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"}

	for _, button in pairs(professions) do
		local bu = _G[button]
		bu.professionName:SetTextColor(1, 1, 1)
		bu.missingHeader:SetTextColor(1, 1, 1)
		bu.missingText:SetTextColor(1, 1, 1)

		bu.statusBar:SetHeight(13)
		bu.statusBar:SetStatusBarTexture(C.Aurora.backdrop)
		bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
		bu.statusBar.rankText:SetPoint("CENTER")

		local _, p = bu.statusBar:GetPoint()
		bu.statusBar:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

		_G[button.."StatusBarLeft"]:Hide()
		bu.statusBar.capRight:SetAlpha(0)
		_G[button.."StatusBarBGLeft"]:Hide()
		_G[button.."StatusBarBGMiddle"]:Hide()
		_G[button.."StatusBarBGRight"]:Hide()

		local bg = CreateFrame("Frame", nil, bu.statusBar)
		bg:SetPoint("TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMRIGHT", 1, -1)
		bg:SetFrameLevel(bu:GetFrameLevel()-1)
		R.CreateBD(bg, .25)
	end

	local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"}

	for _, button in pairs(professionbuttons) do
		local icon = _G[button.."IconTexture"]
		local bu = _G[button]
		_G[button.."NameFrame"]:SetAlpha(0)

		bu:SetPushedTexture("")
		bu:SetCheckedTexture(C.Aurora.checked)
		bu:GetHighlightTexture():Hide()

		if icon then
			icon:SetTexCoord(.08, .92, .08, .92)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			R.CreateBG(icon)
		end					
	end

	for i = 1, 2 do
		local bu = _G["PrimaryProfession"..i]
		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, -4)
		bg:SetFrameLevel(0)
		R.CreateBD(bg, .25)
	end

	for i = 1, NUM_COMPANIONS_PER_PAGE do
		_G["SpellBookCompanionButton"..i.."Background"]:Hide()
		_G["SpellBookCompanionButton"..i.."TextBackground"]:Hide()
		_G["SpellBookCompanionButton"..i.."ActiveTexture"]:SetTexture(C.Aurora.checked)

		local bu = _G["SpellBookCompanionButton"..i]
		local ic = _G["SpellBookCompanionButton"..i.."IconTexture"]

		if ic then
			ic:SetTexCoord(.08, .92, .08, .92)

			bu.bd = CreateFrame("Frame", nil, bu)
			bu.bd:SetPoint("TOPLEFT", ic, -1, 1)
			bu.bd:SetPoint("BOTTOMRIGHT", ic, 1, -1)
			R.CreateBD(bu.bd, 0)

			bu:SetPushedTexture(nil)
			bu:SetCheckedTexture(nil)
		end
	end
end

tinsert(R.SkinFuncs[AddOnName], LoadSkin)