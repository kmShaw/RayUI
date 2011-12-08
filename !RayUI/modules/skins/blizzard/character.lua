local R, C, L, DB = unpack(select(2, ...))
local AddOnName = ...

local function LoadSkin()
	local r, g, b = C.Aurora.classcolours[R.myclass].r, C.Aurora.classcolours[R.myclass].g, C.Aurora.classcolours[R.myclass].b
	R.SetBD(CharacterFrame)
	R.SetBD(PetStableFrame)
	local frames = {
		"CharacterFrame",
		"CharacterFrameInset",
		"CharacterFrameInsetRight",
		"CharacterModelFrame",		
	}
	for i = 1, #frames do
		_G[frames[i]]:DisableDrawLayer("BACKGROUND")
		_G[frames[i]]:DisableDrawLayer("BORDER")
	end
	CharacterModelFrame:DisableDrawLayer("OVERLAY")
	CharacterFramePortrait:Hide()
	CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
	CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
	CharacterStatsPaneTop:Hide()
	CharacterStatsPaneBottom:Hide()
	CharacterFramePortraitFrame:Hide()
	CharacterFrameTopRightCorner:Hide()
	CharacterFrameTopBorder:Hide()
	CharacterFrameExpandButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
	ReputationListScrollFrame:GetRegions():Hide()
	ReputationDetailCorner:Hide()
	ReputationDetailDivider:Hide()
	select(2, ReputationListScrollFrame:GetRegions()):Hide()
	select(3, ReputationDetailFrame:GetRegions()):Hide()
	for i = 1, 4 do
		select(i, GearManagerDialogPopup:GetRegions()):Hide()
	end
	GearManagerDialogPopupScrollFrame:GetRegions():Hide()
	select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)
	PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
	PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
	GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 1, 0)
	PaperDollSidebarTabs:GetRegions():Hide()
	select(2, PaperDollSidebarTabs:GetRegions()):Hide()
	select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()

	R.ReskinClose(CharacterFrameCloseButton)
	R.ReskinScroll(CharacterStatsPaneScrollBar)
	R.ReskinScroll(PaperDollTitlesPaneScrollBar)
	R.ReskinScroll(PaperDollEquipmentManagerPaneScrollBar)
	R.ReskinScroll(ReputationListScrollFrameScrollBar)
	R.ReskinScroll(GearManagerDialogPopupScrollFrameScrollBar)
	R.ReskinArrow(CharacterFrameExpandButton, 1)
	R.Reskin(PaperDollEquipmentManagerPaneEquipSet)
	R.Reskin(PaperDollEquipmentManagerPaneSaveSet)
	R.Reskin(GearManagerDialogPopupOkay)
	R.Reskin(GearManagerDialogPopupCancel)
	R.ReskinClose(ReputationDetailCloseButton)
	R.ReskinCheck(ReputationDetailAtWarCheckBox)
	R.ReskinCheck(ReputationDetailInactiveCheckBox)
	R.ReskinCheck(ReputationDetailMainScreenCheckBox)
	R.ReskinInput(GearManagerDialogPopupEditBox)
	
	hooksecurefunc("CharacterFrame_Expand", function()
		select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\!RayUI\\media\\arrow-left-active")
	end)

	hooksecurefunc("CharacterFrame_Collapse", function()
		select(15, CharacterFrameExpandButton:GetRegions()):SetTexture("Interface\\AddOns\\!RayUI\\media\\arrow-right-active")
	end)
	
	hooksecurefunc("PaperDollFrame_CollapseStatCategory", function(categoryFrame)
			categoryFrame.BgMinimized:Hide()
		end)

	hooksecurefunc("PaperDollFrame_ExpandStatCategory", function(categoryFrame)
		categoryFrame.BgTop:Hide()
		categoryFrame.BgMiddle:Hide()
		categoryFrame.BgBottom:Hide()
	end)

	local titles = false
	hooksecurefunc("PaperDollTitlesPane_Update", function()
		if titles == false then
			for i = 1, 17 do
				_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
			end
			titles = true
		end
	end)

	for i = 1, 4 do
		R.CreateTab(_G["CharacterFrameTab"..i])
	end

	function PaperDollFrame_SetLevel()
		local primaryTalentTree = GetPrimaryTalentTree()
		local classDisplayName, class = UnitClass("player")
		local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or C.Aurora.classcolours[class]
		local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
		local specName

		if (primaryTalentTree) then
			_, specName = GetTalentTabInfo(primaryTalentTree);
		end

		if (specName and specName ~= "") then
			CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
		else
			CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
		end
	end

	if R.HoT then
		EquipmentFlyoutFrameButtons:DisableDrawLayer("BACKGROUND")
		EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
	else
		CharacterModelFrameRotateLeftButton:Hide()
		CharacterModelFrameRotateRightButton:Hide()
		PaperDollFrameItemFlyoutButtons:DisableDrawLayer("BACKGROUND")
		PaperDollFrameItemFlyoutButtons:DisableDrawLayer("ARTWORK")
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Ranged", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local ic = _G["Character"..slots[i].."SlotIconTexture"]
		_G["Character"..slots[i].."SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		ic:SetTexCoord(.08, .92, .08, .92)
	end

	if R.HoT then
		select(10, CharacterMainHandSlot:GetRegions()):Hide()
		select(10, CharacterRangedSlot:GetRegions()):Hide()
		EquipmentFlyoutFrameButtons:HookScript("OnShow", function(self)
			for i = 1, 10 do
				local bu = _G["EquipmentFlyoutFrameButton"..i]
				if bu and not bu.reskinned then
					bu:SetNormalTexture("")
					bu:SetPushedTexture("")
					R.CreateBG(bu)
					_G["EquipmentFlyoutFrameButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					bu.reskinned = true
				end
			end
		end)
	else
		select(9, CharacterMainHandSlot:GetRegions()):Hide()
		select(9, CharacterRangedSlot:GetRegions()):Hide()
		PaperDollFrameItemFlyoutButtons:HookScript("OnShow", function(self)
			for i = 1, PDFITEMFLYOUT_MAXITEMS do
				local bu = _G["PaperDollFrameItemFlyoutButtons"..i]
				if bu and not bu.reskinned then
					bu:SetNormalTexture("")
					bu:SetPushedTexture("")
					R.CreateBG(bu)
					_G["PaperDollFrameItemFlyoutButtons"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					bu.reskinned = true
				end
			end
		end)
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function()
		for i = 1, #slots do
			local ic = _G["Character"..slots[i].."SlotIconTexture"]

			if not GetInventoryItemLink("player", i) then
				ic:SetTexture(nil)
			end
		end
	end)

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if i == 1 then
			for i = 1, 4 do
				local region = select(i, tab:GetRegions())
				region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
				region.SetTexCoord = R.dummy
			end
		end

		tab.Highlight:SetTexture(r, g, b, .2)
		tab.Highlight:SetPoint("TOPLEFT", 3, -4)
		tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
		tab.Hider:SetTexture(.3, .3, .3, .4)
		tab.TabBg:SetAlpha(0)

		select(2, tab:GetRegions()):ClearAllPoints()
		if i == 1 then
			select(2, tab:GetRegions()):SetPoint("TOPLEFT", 3, -4)
			select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, 0)
		else
			select(2, tab:GetRegions()):SetPoint("TOPLEFT", 2, -4)
			select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, -1)
		end

		tab.bg = CreateFrame("Frame", nil, tab)
		tab.bg:SetPoint("TOPLEFT", 2, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", 0, -1)
		tab.bg:SetFrameLevel(0)
		R.CreateBD(tab.bg)

		tab.Hider:SetPoint("TOPLEFT", tab.bg, 1, -1)
		tab.Hider:SetPoint("BOTTOMRIGHT", tab.bg, -1, 1)
	end

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local bu = _G["GearManagerDialogPopupButton"..i]
		local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

		bu:SetCheckedTexture(C.Aurora.checked)
		select(2, bu:GetRegions()):Hide()
		ic:SetPoint("TOPLEFT", 1, -1)
		ic:SetPoint("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		R.CreateBD(bu, .25)
	end

	local sets = false
	PaperDollSidebarTab3:HookScript("OnClick", function()
		if sets == false then
			for i = 1, 8 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
				local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

				bd:Hide()
				bd.Show = R.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				R.CreateBG(ic)
			end
			sets = true
		end
	end)
	
	-- Reputation frame
	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				statusbar:SetStatusBarTexture(C.Aurora.backdrop)

				if not statusbar.reskinned then
					R.CreateBD(statusbar, .25)
					statusbar.reskinned = true
				end

				_G["ReputationBar"..i.."Background"]:SetTexture(nil)
				_G["ReputationBar"..i.."LeftLine"]:SetAlpha(0)
				_G["ReputationBar"..i.."BottomLine"]:SetAlpha(0)
				_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)	
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
				_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
			end		
		end		
	end

	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	hooksecurefunc("ReputationFrame_OnEvent", UpdateFactionSkins)
	
	-- Pet stuff
	if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
		if class == "HUNTER" then
			PetStableFrame:DisableDrawLayer("BACKGROUND")
			PetStableFrame:DisableDrawLayer("BORDER")
			PetStableFrameInset:DisableDrawLayer("BACKGROUND")
			PetStableFrameInset:DisableDrawLayer("BORDER")
			PetStableBottomInset:DisableDrawLayer("BACKGROUND")
			PetStableBottomInset:DisableDrawLayer("BORDER")
			PetStableLeftInset:DisableDrawLayer("BACKGROUND")
			PetStableLeftInset:DisableDrawLayer("BORDER")
			PetStableFramePortrait:Hide()
			PetStableModelShadow:Hide()
			PetStableFramePortraitFrame:Hide()
			PetStableFrameTopBorder:Hide()
			PetStableFrameTopRightCorner:Hide()
			PetStableModelRotateLeftButton:Hide()
			PetStableModelRotateRightButton:Hide()

			R.ReskinClose(PetStableFrameCloseButton)
			R.ReskinArrow(PetStablePrevPageButton, 1)
			R.ReskinArrow(PetStableNextPageButton, 2)

			for i = 1, 10 do
				local bu = _G["PetStableStabledPet"..i]
				local bd = CreateFrame("Frame", nil, bu)
				bd:SetPoint("TOPLEFT", -1, 1)
				bd:SetPoint("BOTTOMRIGHT", 1, -1)
				R.CreateBD(bd, .25)
				bu:SetNormalTexture("")
				bu:DisableDrawLayer("BACKGROUND")
				_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end

		local function FixTab()
			if CharacterFrameTab2:IsShown() then
				CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
			else
				CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab1, "RIGHT", -15, 0)
			end
		end
		CharacterFrame:HookScript("OnEvent", FixTab)
		CharacterFrame:HookScript("OnShow", FixTab)

		PetModelFrameRotateLeftButton:Hide()
		PetModelFrameRotateRightButton:Hide()
		PetModelFrameShadowOverlay:Hide()
		PetPaperDollXPBar1:Hide()
		select(2, PetPaperDollFrameExpBar:GetRegions()):Hide()
		PetPaperDollPetModelBg:SetAlpha(0)
		PetPaperDollFrameExpBar:SetStatusBarTexture(C.media.normal)

		local bbg = CreateFrame("Frame", nil, PetPaperDollFrameExpBar)
		bbg:SetPoint("TOPLEFT", -1, 1)
		bbg:SetPoint("BOTTOMRIGHT", 1, -1)
		bbg:SetFrameLevel(PetPaperDollFrameExpBar:GetFrameLevel()-1)
		R.CreateBD(bbg, .25)
	end
end

tinsert(R.SkinFuncs[AddOnName], LoadSkin)