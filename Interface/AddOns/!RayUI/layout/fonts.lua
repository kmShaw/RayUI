﻿local R, C, L, DB = unpack(select(2, ...))
local ADDON_NAME = ...

local RayUIFonts = CreateFrame("Frame", nil, UIParent)

SetFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

RayUIFonts:RegisterEvent("ADDON_LOADED")
RayUIFonts:SetScript("OnEvent", function(self, event, addon)
	if addon ~= ADDON_NAME then return end
	
	local NORMAL     = C["media"].font
	local COMBAT     = C["media"].dmgfont
	local NUMBER     = C["media"].font	
	local _, editBoxFontSize, _, _, _, _, _, _, _, _ = GetChatWindowInfo(1)
	
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {12, 13, 14, 15, 16, 17, 18, 19, 20}
	
	UNIT_NAME_FONT     = NORMAL
	NAMEPLATE_FONT     = NORMAL
	DAMAGE_TEXT_FONT   = COMBAT
	STANDARD_TEXT_FONT = NORMAL
	
	-- Base fonts
	SetFont(GameTooltipHeader,                  NORMAL, C["media"].fontsize)
	SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, C["media"].fontsize, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            NUMBER, 28, "THICKOUTLINE")
	SetFont(NumberFont_Outline_Large,           NUMBER, 15, "OUTLINE")
	SetFont(NumberFont_Outline_Med,             NUMBER, C["media"].fontsize*1.1, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,              NORMAL, C["media"].fontsize) --chat editbox uses this
	SetFont(NumberFont_Shadow_Small,            NORMAL, C["media"].fontsize)
	SetFont(QuestFont,                          NORMAL, C["media"].fontsize)
	SetFont(ErrorFont,                          NORMAL, 15, "THINOUTLINE") -- Quest Progress & Errors
	SetFont(SubZoneTextFont,                          NORMAL, 26, "THINOUTLINE", nil, nil, nil, 0, 0, 0, R.mult, -R.mult)
	SetFont(ZoneTextFont,                          NORMAL, 112, "THINOUTLINE", nil, nil, nil, 0, 0, 0, R.mult, -R.mult)
	SetFont(PVPInfoTextFont,                          NORMAL, 20, "THINOUTLINE", nil, nil, nil, 0, 0, 0, R.mult, -R.mult)
	SetFont(QuestFont_Large,                    NORMAL, 14)
	SetFont(SystemFont_Large,                   NORMAL, 15)
	SetFont(SystemFont_Shadow_Huge1,			NORMAL, 20, "THINOUTLINE") -- Raid Warning, Boss emote frame too
	SetFont(SystemFont_Med1,                    NORMAL, C["media"].fontsize)
	SetFont(SystemFont_Med3,                    NORMAL, C["media"].fontsize*1.1)
	SetFont(SystemFont_OutlineThick_Huge2,      NORMAL, 20, "THICKOUTLINE")
	SetFont(SystemFont_Outline_Small,           NUMBER, C["media"].fontsize, "OUTLINE")
	SetFont(SystemFont_Shadow_Large,            NORMAL, 15)
	SetFont(SystemFont_Shadow_Med1,             NORMAL, C["media"].fontsize)
	SetFont(SystemFont_Shadow_Med3,             NORMAL, C["media"].fontsize*1.1)
	SetFont(SystemFont_Shadow_Outline_Huge2,    NORMAL, 20, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            NORMAL, C["media"].fontsize*0.95)
	SetFont(SystemFont_Small,                   NORMAL, C["media"].fontsize)
	SetFont(SystemFont_Tiny,                    NORMAL, C["media"].fontsize)
	SetFont(Tooltip_Med,                        NORMAL, C["media"].fontsize)
	SetFont(Tooltip_Small,                      NORMAL, C["media"].fontsize)
	SetFont(ZoneTextString,						NORMAL, 32, "OUTLINE")
	SetFont(SubZoneTextString,					NORMAL, 25, "OUTLINE")
	SetFont(PVPInfoTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(PVPArenaTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(CombatTextFont,                     COMBAT, 100, "THINOUTLINE") -- number here just increase the font quality.

	SetFont = nil
	self:SetScript("OnEvent", nil)
	self:UnregisterAllEvents()
	self = nil
end)