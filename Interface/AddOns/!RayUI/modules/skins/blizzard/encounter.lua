local R, C, L, DB = unpack(select(2, ...))

local function LoadSkin()
	EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	EncounterJournal:DisableDrawLayer("BORDER")
	EncounterJournalInset:DisableDrawLayer("BORDER")
	EncounterJournalNavBar:DisableDrawLayer("BORDER")
	EncounterJournalSearchResults:DisableDrawLayer("BORDER")
	EncounterJournal:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectDungeonTab:DisableDrawLayer("OVERLAY")
	EncounterJournalInstanceSelectRaidTab:DisableDrawLayer("OVERLAY")

	EncounterJournalPortrait:Hide()
	EncounterJournalInstanceSelectBG:Hide()
	EncounterJournalNavBar:GetRegions():Hide()
	EncounterJournalNavBarOverlay:Hide()
	EncounterJournalBg:Hide() 
	EncounterJournalTitleBg:Hide()
	EncounterJournalInsetBg:Hide()
	EncounterJournalInstanceSelectDungeonTabMid:Hide()
	EncounterJournalInstanceSelectRaidTabMid:Hide()
	EncounterJournalNavBarHomeButtonLeft:Hide()
	for i = 8, 10 do
		select(i, EncounterJournalInstanceSelectDungeonTab:GetRegions()):SetAlpha(0)
		select(i, EncounterJournalInstanceSelectRaidTab:GetRegions()):SetAlpha(0)
	end
	EncounterJournalEncounterFrameModelFrameShadow:Hide()
	EncounterJournalEncounterFrameInfoDifficultyUpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficultyUpRIGHT:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficultyDownLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoDifficultyDownRIGHT:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoDifficulty:GetRegions()):Hide()
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterUpLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterUpRIGHT:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterDownLeft:SetAlpha(0)
	EncounterJournalEncounterFrameInfoLootScrollFrameFilterDownRIGHT:SetAlpha(0)
	select(5, EncounterJournalEncounterFrameInfoLootScrollFrameFilter:GetRegions()):Hide()
	select(6, EncounterJournalEncounterFrameInfoLootScrollFrameFilter:GetRegions()):Hide()
	EncounterJournalSearchResultsBg:Hide()

	R.SetBD(EncounterJournal)
	R.CreateBD(EncounterJournalEncounterFrameInfoLootScrollFrameClassFilterFrame)
	R.CreateBD(EncounterJournalSearchResults, .75)

	EncounterJournalEncounterFrameInfoBossTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoBossTab:SetPoint("TOPRIGHT", EncounterJournalEncounterFrame, "TOPRIGHT", 75, 20)
	EncounterJournalEncounterFrameInfoLootTab:ClearAllPoints()
	EncounterJournalEncounterFrameInfoLootTab:SetPoint("TOP", EncounterJournalEncounterFrameInfoBossTab, "BOTTOM", 0, -4)

	EncounterJournalEncounterFrameInfoBossTab:SetScale(0.75)
	EncounterJournalEncounterFrameInfoLootTab:SetScale(0.75)

	EncounterJournalEncounterFrameInfoBossTab:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1 / .75,
	})
	EncounterJournalEncounterFrameInfoBossTab:SetBackdropColor(0, 0, 0, alpha)
	EncounterJournalEncounterFrameInfoBossTab:SetBackdropBorderColor(0, 0, 0)

	EncounterJournalEncounterFrameInfoLootTab:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1 / .75,
	})
	EncounterJournalEncounterFrameInfoLootTab:SetBackdropColor(0, 0, 0, alpha)
	EncounterJournalEncounterFrameInfoLootTab:SetBackdropBorderColor(0, 0, 0)

	EncounterJournalEncounterFrameInfoBossTab:SetNormalTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:SetPushedTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:SetDisabledTexture(nil)
	EncounterJournalEncounterFrameInfoBossTab:SetHighlightTexture(nil)

	EncounterJournalEncounterFrameInfoLootTab:SetNormalTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:SetPushedTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:SetDisabledTexture(nil)
	EncounterJournalEncounterFrameInfoLootTab:SetHighlightTexture(nil)

	for i = 1, 14 do
		local bu = _G["EncounterJournalInstanceSelectScrollFrameinstance"..i] or _G["EncounterJournalInstanceSelectScrollFrameScrollChildInstanceButton"..i]

		if bu then
			bu:SetNormalTexture("")
			bu:SetHighlightTexture("")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", 4, -4)
			bg:SetPoint("BOTTOMRIGHT", -5, 3)
			R.CreateBD(bg, 0)
		end
	end

	local modelbg = CreateFrame("Frame", nil, EncounterJournalEncounterFrameModelFrame)
	modelbg:SetPoint("TOPLEFT", -1, 1)
	modelbg:SetPoint("BOTTOMRIGHT", 1, -1)
	modelbg:SetFrameLevel(EncounterJournalEncounterFrameModelFrame:GetFrameLevel()-1)
	R.CreateBD(modelbg, .25)

	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetTextColor(.9, .9, .9)
	EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollChildLore:SetShadowOffset(1, -1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetShadowOffset(1, -1)
	EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 1, 1)

	hooksecurefunc("EncounterJournal_DisplayInstance", function()
		local bossIndex = 1;
		local name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex)
		while bossID do
			local bossButton = _G["EncounterJournalBossButton"..bossIndex]

			if not bossButton.reskinned then
				bossButton.reskinned = true

				R.Reskin(bossButton, true)
				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = R.dummy
			end


			bossIndex = bossIndex + 1
			name, description, bossID, _, link = EJ_GetEncounterInfoByIndex(bossIndex)
		end
	end)

	hooksecurefunc("EncounterJournal_ToggleHeaders", function()
		for i = 1, 50 do 
			local name = "EncounterJournalInfoHeader"..i
			local header = _G[name]

			if header then

				if not header.button.bg then
					header.button.bg = header.button:CreateTexture(nil, "BACKGROUND")
					header.button.bg:SetPoint("TOPLEFT", header.button.abilityIcon, -1, 1)
					header.button.bg:SetPoint("BOTTOMRIGHT", header.button.abilityIcon, 1, -1)
					header.button.bg:SetTexture(C.media.backdrop)
					header.button.bg:SetVertexColor(0, 0, 0)
				end

				if header.button.abilityIcon:IsShown() then
					header.button.bg:Show()
				else
					header.button.bg:Hide()
				end

				if not header.reskinned then
					header.reskinned = true

					header.flashAnim.Play = R.dummy

					header.description:SetTextColor(1, 1, 1)
					header.description:SetShadowOffset(1, -1)
					header.button.title:SetTextColor(1, 1, 1)
					header.button.title.SetTextColor = R.dummy
					header.button.expandedIcon:SetTextColor(1, 1, 1)
					header.button.expandedIcon.SetTextColor = R.dummy
					header.descriptionBG:SetAlpha(0)
					header.descriptionBGBottom:SetAlpha(0)

					R.Reskin(header.button, true)

					header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)

					_G[name.."HeaderButtonELeftUp"]:SetAlpha(0)
					_G[name.."HeaderButtonERightUp"]:SetAlpha(0)
					_G[name.."HeaderButtonEMidUp"]:SetAlpha(0)
					_G[name.."HeaderButtonCLeftUp"]:SetAlpha(0)
					_G[name.."HeaderButtonCRightUp"]:SetAlpha(0)
					_G[name.."HeaderButtonCMidUp"]:SetAlpha(0)
					_G[name.."HeaderButtonELeftDown"]:SetAlpha(0)
					_G[name.."HeaderButtonERightDown"]:SetAlpha(0)
					_G[name.."HeaderButtonEMidDown"]:SetAlpha(0)
					_G[name.."HeaderButtonCLeftDown"]:SetAlpha(0)
					_G[name.."HeaderButtonCRightDown"]:SetAlpha(0)
					_G[name.."HeaderButtonCMidDown"]:SetAlpha(0)
					_G[name.."HeaderButtonHighlightLeft"]:Hide()
					_G[name.."HeaderButtonHighlightMid"]:Hide()
					_G[name.."HeaderButtonHighlightRight"]:Hide()
				end
			end
		end
	end)

	local items = EncounterJournal.encounter.info.lootScroll.buttons
	local item

	for i = 1, #items do
		item = items[i]

		item.boss:SetTextColor(1, 1, 1)
		item.slot:SetTextColor(1, 1, 1)
		item.armorType:SetTextColor(1, 1, 1)

		item.bossTexture:SetAlpha(0)
		item.bosslessTexture:SetAlpha(0)

		item.icon:SetPoint("TOPLEFT", 3, -3)
		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetDrawLayer("OVERLAY")
		R.CreateBG(item.icon)

		local bg = CreateFrame("Frame", nil, item)
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameStrata("BACKGROUND")
		R.CreateBD(bg, 0)

		local tex = item:CreateTexture(nil, "BACKGROUND")
		tex:SetPoint("TOPLEFT")
		tex:SetPoint("BOTTOMRIGHT", -1, 2)
		tex:SetTexture(C.media.backdrop)
		tex:SetVertexColor(0, 0, 0, .25)
	end

	hooksecurefunc("EncounterJournal_SearchUpdate", function()
		local results = EncounterJournal.searchResults.scrollFrame.buttons
		local result

		for i = 1, #results do
			results[i]:SetNormalTexture("")
		end
	end)

	R.Reskin(EncounterJournalNavBarHomeButton)
	R.Reskin(EncounterJournalInstanceSelectDungeonTab)
	R.Reskin(EncounterJournalInstanceSelectRaidTab)
	R.Reskin(EncounterJournalEncounterFrameInfoDifficulty)
	R.Reskin(EncounterJournalEncounterFrameInfoResetButton)
	R.Reskin(EncounterJournalEncounterFrameInfoLootScrollFrameFilter)
	R.ReskinClose(EncounterJournalCloseButton)
	R.ReskinClose(EncounterJournalSearchResultsCloseButton)
	R.ReskinInput(EncounterJournalSearchBox)
	R.ReskinScroll(EncounterJournalInstanceSelectScrollFrameScrollBar)
	R.ReskinScroll(EncounterJournalEncounterFrameInstanceFrameLoreScrollFrameScrollBar)
	R.ReskinScroll(EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollBar)
	R.ReskinScroll(EncounterJournalEncounterFrameInfoLootScrollFrameScrollBar)
	R.ReskinScroll(EncounterJournalSearchResultsScrollFrameScrollBar)
end

R.SkinFuncs["Blizzard_EncounterJournal"] = LoadSkin