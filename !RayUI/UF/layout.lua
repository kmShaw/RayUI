local R, C, L, DB = unpack(select(2, ...))
local _, ns = ...
local PLAYER_WIDTH = 240
local PLAYER_HEIGHT = 22
local TARGET_WIDTH = 240
local TARGET_HEIGHT = 22
local SMALL_WIDTH = 140
local SMALL_HEIGHT = 8
local BOSS_WIDTH = 190
local BOSS_HEIGHT = 22
local PARTY_WIDTH = 190
local PARTY_HEIGHT = 22

local UnitFrame_OnEnter = function(self)
	if IsShiftKeyDown() or not UnitAffectingCombat("player") then
		UnitFrame_OnEnter(self)
	end
	self.Mouseover:Show()	
	self.isMouseOver = true
	for _, element in ipairs(self.mouseovers) do
		element:ForceUpdate()
	end
end

local UnitFrame_OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Mouseover:Hide()
	self.isMouseOver = nil
	for _, element in ipairs(self.mouseovers) do
		element:ForceUpdate()
	end
end

local function Shared(self, unit)
	self.FrameBackdrop = R.CreateBackdrop(self, self)
	
	-- Register Frames for Click
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	-- Setup Menu
	self.menu = R.SpawnMenu
	
	-- Frame Level
	self:SetFrameLevel(5)
	
	-- Health
	local health = R.ContructHealthBar(self, true, true)
	health:SetPoint("LEFT")
	health:SetPoint("RIGHT")
	health:SetPoint("TOP") 
	self.Health = health
	
	-- Name
	local name = health:CreateFontString(nil, "OVERLAY")
	name:SetFont(C["media"].font, 15, C["media"].fontflag)
	self.Name = name
	
	-- mouseover highlight
    local mouseover = health:CreateTexture(nil, "OVERLAY")
	mouseover:SetAllPoints(health)
	mouseover:SetTexture("Interface\\AddOns\\!RayUI\\media\\mouseover")
	mouseover:SetVertexColor(1,1,1,.36)
	mouseover:SetBlendMode("ADD")
	mouseover:Hide()
	self.Mouseover = mouseover
	
	-- threat highlight
	local Thrt = health:CreateTexture(nil, "OVERLAY")
	Thrt:SetAllPoints(health)
	Thrt:SetTexture("Interface\\AddOns\\!RayUI\\media\\threat")
	Thrt:SetBlendMode("ADD")
	Thrt:Hide()
	self.ThreatHlt = Thrt	
	
	-- update threat
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", R.UpdateThreatStatus)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", R.UpdateThreatStatus)
	
	-- SpellRange
	self.SpellRange = {
		  insideAlpha = 1,
		  outsideAlpha = 0.3}

	if unit == "player" then
		health:SetSize(PLAYER_WIDTH, PLAYER_HEIGHT * 0.9)
		health.value:Point("LEFT", self, "LEFT", 5, 0)
		name:Point("BOTTOM", health, 0, -13)
		name:Point("LEFT", health, -3, 0)
		name:SetJustifyH("LEFT")
		if C["ouf"].HealthcolorClass then
			self:Tag(name, '[freeb:name] [freeb:info]')
		else
			self:Tag(name, '[freeb:color][freeb:name] [freeb:info]')
		end
		local power = R.ConstructPowerBar(self, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", self, "RIGHT", -5, 0)
		power:SetWidth(PLAYER_WIDTH)
		power:SetHeight(PLAYER_HEIGHT * 0.1)
		self.Power = power
		
		-- Alternative Power Bar
		local altpp = CreateFrame("StatusBar", nil, self)
		altpp:SetStatusBarTexture(C["media"].normal)
		altpp:GetStatusBarTexture():SetHorizTile(false)
		altpp:SetHeight(4)
		altpp:Point('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
		altpp:Point('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -2)
		altpp.bg = altpp:CreateTexture(nil, 'BORDER')
		altpp.bg:SetAllPoints(altpp)
		altpp.bg:SetTexture(C["media"].normal)
		altpp.bg:SetVertexColor( 0,  0.76, 1)
		altpp.bd = R.CreateBackdrop(altpp, altpp)
		altpp.Text = altpp:CreateFontString(nil, "OVERLAY")
		altpp.Text:SetFont(C["media"].font, 12, C["media"].fontflag)
		altpp.Text:SetPoint("CENTER")
		self:Tag(altpp.Text, "[freeb:altpower]")
		altpp.PostUpdate = R.PostAltUpdate
		self.AltPowerBar = altpp
		
		-- CastBar
		local castbar = R.ConstructCastBar(self)
		castbar:ClearAllPoints()
		castbar:Point("BOTTOM",UIParent,"BOTTOM",0,305)
		castbar:Width(350)
		castbar:Height(5)
		castbar.Text:ClearAllPoints()
		castbar.Text:SetPoint("BOTTOMLEFT", castbar, "TOPLEFT", 5, -2)
		castbar.Time:ClearAllPoints()
		castbar.Time:SetPoint("BOTTOMRIGHT", castbar, "TOPRIGHT", -5, -2)
		castbar.Icon:Hide()
		castbar.Iconbg:Hide()
		self.Castbar = castbar
		
		-- Debuffs
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(PLAYER_HEIGHT)
		debuffs:SetWidth(PLAYER_WIDTH)
		debuffs:Point("BOTTOMRIGHT", self, "TOPRIGHT", -1, 7)
		debuffs.spacing = 5
		debuffs["growth-x"] = "LEFT"
		debuffs["growth-y"] = "UP"
		debuffs.size = PLAYER_HEIGHT
		debuffs.initialAnchor = "BOTTOMRIGHT"
		debuffs.num = 9
		debuffs.PostCreateIcon = R.PostCreateIcon
		debuffs.PostUpdateIcon = R.PostUpdateIcon

		self.Debuffs = debuffs
		
		-- BarFader
		self.BarFade = true
		self.BarFaderMinAlpha = "0"
		
		-- ClassBar
		 if R.myclass == "DEATHKNIGHT" or R.myclass == "WARLOCK" or R.myclass == "PALADIN" then
            local count
            if R.myclass == "DEATHKNIGHT" then 
                count = 6 
            else 
                count = 3 
            end

            local bars = CreateFrame("Frame", nil, self)
			bars:SetSize(200/count - 5, 5)
			if count == 3 then
				bars:Point("BOTTOMRIGHT", self, "TOP", bars:GetWidth()*1.5 + 5,0)
			else
				bars:Point("BOTTOMRIGHT", self, "TOP", bars:GetWidth()*3 + 12.5,0)
			end

            local i = count
            for index = 1, count do
                bars[i] = CreateFrame("StatusBar", nil, bars)
				bars[i]:SetStatusBarTexture(C["media"].normal)
				bars[i]:SetWidth(200/count-5)
				bars[i]:SetHeight(5)
				bars[i]:GetStatusBarTexture():SetHorizTile(false)

                if R.myclass == "WARLOCK" then
                    local color = oUF.colors.class["WARLOCK"]
                    bars[i]:SetStatusBarColor(color[1], color[2], color[3])
                elseif R.myclass == "PALADIN" then
                    local color = self.colors.power["HOLY_POWER"]
                    bars[i]:SetStatusBarColor(color[1], color[2], color[3])
                end 

                if i == count then
                    bars[i]:SetPoint("TOPLEFT", bars, "TOPLEFT")
                else
                    bars[i]:Point("RIGHT", bars[i+1], "LEFT", -5, 0)
                end

                bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
                bars[i].bg:SetAllPoints(bars[i])
                bars[i].bg:SetTexture(C["media"].normal)
                bars[i].bg.multiplier = .2

                bars[i].bd = R.CreateBackdrop(bars[i], bars[i])
                i=i-1
            end

            if R.myclass == "DEATHKNIGHT" then
                bars[3], bars[4], bars[5], bars[6] = bars[5], bars[6], bars[3], bars[4]
                self.Runes = bars
            elseif R.myclass == "WARLOCK" then
                self.SoulShards = bars
            elseif R.myclass == "PALADIN" then
                self.HolyPower = bars
            end
        end
		
		if R.myclass == "DRUID" then
            local ebar = CreateFrame("Frame", nil, self)
            ebar:Point("BOTTOM", self, "TOP", 0, 0)
            ebar:SetSize(200, 5)
            ebar.bd = R.createBackdrop(ebar, ebar)

			local lbar = CreateFrame("StatusBar", nil, ebar)
			lbar:SetStatusBarTexture(C["media"].normal)
			lbar:SetStatusBarColor(0, .4, 1)
			lbar:SetWidth(200)
			lbar:SetHeight(5)
			lbar:GetStatusBarTexture():SetHorizTile(false)
            lbar:SetPoint("LEFT", ebar, "LEFT")
            ebar.LunarBar = lbar

			local sbar = CreateFrame("StatusBar", nil, ebar)
			sbar:SetStatusBarTexture(C["media"].normal)
			sbar:SetStatusBarColor(1, .6, 0)
			sbar:SetWidth(200)
			sbar:SetHeight(5)
			sbar:GetStatusBarTexture():SetHorizTile(false)
            sbar:SetPoint("LEFT", lbar:GetStatusBarTexture(), "RIGHT")
            ebar.SolarBar = sbar

            ebar.Spark = sbar:CreateTexture(nil, "OVERLAY")
            ebar.Spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
            ebar.Spark:SetBlendMode("ADD")
            ebar.Spark:SetAlpha(0.5)
            ebar.Spark:SetHeight(20)
            ebar.Spark:Point("LEFT", sbar:GetStatusBarTexture(), "LEFT", -15, 0)

            self.EclipseBar = ebar
            self.EclipseBar.PostUnitAura = R.UpdateEclipse
        end

        if  R.myclass == "SHAMAN" then
            self.TotemBar = {}
            self.TotemBar.Destroy = true
            for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", nil, self)
				self.TotemBar[i]:SetStatusBarTexture(C["media"].normal)
				self.TotemBar[i]:SetWidth(200/4-5)
				self.TotemBar[i]:SetHeight(5)
				self.TotemBar[i]:GetStatusBarTexture():SetHorizTile(false)

                if (i == 1) then
                    self.TotemBar[i]:SetPoint("BOTTOM", self, "TOP", 75,0)
                else
                    self.TotemBar[i]:SetPoint("RIGHT", self.TotemBar[i-1], "LEFT", -5, 0)
                end
                self.TotemBar[i]:SetBackdrop({bgFile = C["media"].blank})
                self.TotemBar[i]:SetBackdropColor(0.5, 0.5, 0.5)
                self.TotemBar[i]:SetMinMaxValues(0, 1)

                self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
                self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
                self.TotemBar[i].bg:SetTexture(C["media"].normal)
                self.TotemBar[i].bg.multiplier = 0.3

                self.TotemBar[i].bd = R.CreateBackdrop(self.TotemBar[i], self.TotemBar[i])
            end
        end
		
		-- Experienc & Reputation
		local experience = CreateFrame("StatusBar", nil, self)
		experience:SetStatusBarTexture(C["media"].normal)
		experience:SetStatusBarColor(0.58, 0.0, 0.55)
		experience:GetStatusBarTexture():SetHorizTile(false)
		
		experience:Point('TOPLEFT', BottomInfoBar, 'TOPLEFT', 2, -2)
		experience:Point('BOTTOMRIGHT', BottomInfoBar, 'BOTTOMRIGHT', -2, 2)
		experience:SetParent(BottomInfoBar)
		experience:SetFrameStrata("BACKGROUND")
		experience:SetFrameLevel(1)
		
		experience.Rested = CreateFrame("StatusBar", nil, experience)
		experience.Rested:SetStatusBarTexture(C["media"].normal)
		experience.Rested:SetStatusBarColor(0, 0.39, 0.88)
		experience.Rested:GetStatusBarTexture():SetHorizTile(false)
		experience.Rested:SetAllPoints(experience)
		experience.Rested:SetFrameStrata("BACKGROUND")
		experience.Rested:SetFrameLevel(0)
		
		experience.Tooltip = true		
		
		local reputation = CreateFrame("StatusBar", nil, self)
		reputation:SetStatusBarTexture(C["media"].normal)
		reputation:SetStatusBarColor(0, .7, 1)
		reputation:GetStatusBarTexture():SetHorizTile(false)
		
		reputation:Point('TOPLEFT', BottomInfoBar, 'TOPLEFT', 2, -2)
		reputation:Point('BOTTOMRIGHT', BottomInfoBar, 'BOTTOMRIGHT', -2, 2)
		reputation:SetParent(BottomInfoBar)
		reputation:SetFrameStrata("BACKGROUND")
		reputation:SetFrameLevel(1)
		
		reputation.PostUpdate = function(self, event, unit, bar)
															local name, id = GetWatchedFactionInfo()
															bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
														end
		reputation.Tooltip = true
		
		self:SetScript("OnEnter", UnitFrame_OnEnter)
		self:SetScript("OnLeave", UnitFrame_OnLeave)
		
		RayUIThreatBar:HookScript("OnShow", function()
			if RayUIThreatBar:GetAlpha() > 0 then
				experience:SetAlpha(0)
				reputation:SetAlpha(0)
			end
		end)
		RayUIThreatBar:HookScript("OnHide", function()
			experience:SetAlpha(1)
			reputation:SetAlpha(1)
		end)
		hooksecurefunc(RayUIThreatBar, "SetAlpha", function()
			if RayUIThreatBar:GetAlpha() > 0 then
				experience:SetAlpha(0)
				reputation:SetAlpha(0)
			else
				experience:SetAlpha(1)
				reputation:SetAlpha(1)
			end
		end)
		
		self.Experience = experience
		self.Reputation = reputation
		
		-- Heal Prediction
		local mhpb = CreateFrame('StatusBar', nil, self)
		mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
		mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT')	
		mhpb:SetWidth(health:GetWidth())
		mhpb:SetStatusBarTexture(C["media"].blank)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
		
		local ohpb = CreateFrame('StatusBar', nil, self)
		ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)		
		ohpb:SetWidth(mhpb:GetWidth())
		ohpb:SetStatusBarTexture(C["media"].blank)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)
		
		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
			PostUpdate = function(self)
				if self.myBar:GetValue() == 0 then self.myBar:SetAlpha(0) else self.myBar:SetAlpha(1) end
				if self.otherBar:GetValue() == 0 then self.otherBar:SetAlpha(0) else self.otherBar:SetAlpha(1) end
			end
		}
	end
	
	if unit == "target" then
		health:SetSize(TARGET_WIDTH, TARGET_HEIGHT * 0.9)
		health.value:Point("LEFT", self, "LEFT", 5, 0)
		name:Point("BOTTOM", health,  0, -13)
		name:Point("RIGHT", health, 3, 0)
		name:SetJustifyH("RIGHT")		
		if C["ouf"].HealthcolorClass then
			self:Tag(name, '[freeb:name] [freeb:info]')
		else
			self:Tag(name, '[freeb:color][freeb:name] [freeb:info]')
		end
		R.FocusText(self)
		local power = R.ConstructPowerBar(self, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", self, "RIGHT", -5, 0)
		power:SetWidth(PLAYER_WIDTH)
		power:SetHeight(PLAYER_HEIGHT * 0.1)
		self.Power = power
		
		local castbar = R.ConstructCastBar(self)
		castbar:ClearAllPoints()
		castbar:Point("TOPRIGHT", self, "TOPRIGHT", 0, -55)
		castbar:Width(health:GetWidth()-27)
		castbar:Height(20)
		castbar.Text:ClearAllPoints()
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 5, 0)
		castbar.Time:ClearAllPoints()
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -5, 0)
		self.Castbar = castbar
		
		-- Auras
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetHeight(PLAYER_HEIGHT)
		buffs:SetWidth(PLAYER_WIDTH)
		buffs:Point("TOPLEFT", self, "BOTTOMLEFT", 1, -5)
		buffs.spacing = 5
		buffs["growth-x"] = "RIGHT"
		buffs["growth-y"] = "DOWN"
		buffs.size = PLAYER_HEIGHT
		buffs.initialAnchor = "TOPLEFT"
		buffs.num = 9
		buffs.PostCreateIcon = R.PostCreateIcon
		buffs.PostUpdateIcon = R.PostUpdateIcon
		
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(PLAYER_HEIGHT)
		debuffs:SetWidth(PLAYER_WIDTH)
		debuffs:Point("BOTTOMLEFT", self, "TOPLEFT", 1, 7)
		debuffs.spacing = 5
		debuffs["growth-x"] = "RIGHT"
		debuffs["growth-y"] = "UP"
		debuffs.size = PLAYER_HEIGHT
		debuffs.initialAnchor = "BOTTOMLEFT"
		debuffs.num = 9
		debuffs.PostCreateIcon = R.PostCreateIcon
		debuffs.PostUpdateIcon = R.PostUpdateIcon

		self.Buffs = buffs
		self.Debuffs = debuffs
		
		-- Combo Bar
		local bars = CreateFrame("Frame", nil, self)
		bars:SetWidth(35)
		bars:SetHeight(5)
		bars:Point("BOTTOMLEFT", self, "TOP", - bars:GetWidth()*2.5 - 10,0)
		
		bars:SetBackdropBorderColor(0,0,0,0)
		bars:SetBackdropColor(0,0,0,0)
			
		for i = 1, 5 do					
			bars[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, bars)
			bars[i]:SetHeight(5)					
			bars[i]:SetStatusBarTexture(C["media"].normal)
			bars[i]:GetStatusBarTexture():SetHorizTile(false)
								
			if i == 1 then
				bars[i]:SetPoint("LEFT", bars)
			else
				bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 5, 0)
			end
			bars[i]:SetAlpha(0.15)
			bars[i]:SetWidth(35)
			bars[i].bg = bars[i]:CreateTexture(nil, "BACKGROUND")
			bars[i].bg:SetAllPoints(bars[i])
			bars[i].bg:SetTexture(C["media"].normal)
			bars[i].bg.multiplier = .2

			bars[i].bd = R.CreateBackdrop(bars[i], bars[i])
		end
			
		bars[1]:SetStatusBarColor(255/255, 0/255, 0)		
		bars[2]:SetStatusBarColor(255/255, 0/255, 0)
		bars[3]:SetStatusBarColor(255/255, 255/255, 0)
		bars[4]:SetStatusBarColor(255/255, 255/255, 0)
		bars[5]:SetStatusBarColor(0, 1, 0)
			
		self.CPoints = bars
		self.CPoints.Override = R.ComboDisplay
		
		-- Heal Prediction
		local mhpb = CreateFrame('StatusBar', nil, self)
		mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
		mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT')	
		mhpb:SetWidth(health:GetWidth())
		mhpb:SetStatusBarTexture(C["media"].blank)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)
		
		local ohpb = CreateFrame('StatusBar', nil, self)
		ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)		
		ohpb:SetWidth(mhpb:GetWidth())
		ohpb:SetStatusBarTexture(C["media"].blank)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)
		
		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
			PostUpdate = function(self)
				if self.myBar:GetValue() == 0 then self.myBar:SetAlpha(0) else self.myBar:SetAlpha(1) end
				if self.otherBar:GetValue() == 0 then self.otherBar:SetAlpha(0) else self.otherBar:SetAlpha(1) end
			end
		}
	end
	
	if unit == "party" or unit == "focus" then
		health:SetSize(PARTY_WIDTH, PARTY_HEIGHT * 0.9)
		health.value:Point("LEFT", self, "LEFT", 5, 0)
		name:Point("BOTTOM", health, -6, -15)
		name:Point("LEFT", health, 0, 0)
		name:SetJustifyH("LEFT")
		if C["ouf"].HealthcolorClass then
			self:Tag(name, '[freeb:name] [freeb:info]')
		else
			self:Tag(name, '[freeb:color][freeb:name] [freeb:info]')
		end
		if unit == "focus" then
			R.ClearFocusText(self)
		end
		local power = R.ConstructPowerBar(self, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", self, "RIGHT", -5, 0)
		power:SetWidth(PLAYER_WIDTH)
		power:SetHeight(PLAYER_HEIGHT * 0.1)
		self.Power = power
	end
	
	if unit == "targettarget" or unit == "pet" or unit == "pettarget" or unit == "focustarget" then
		health:SetSize(SMALL_WIDTH, SMALL_HEIGHT * 0.9)
		health.value:Point("LEFT", self, "LEFT", 5, 0)
		name:Point("TOP", health, 0, 12)
		name:SetFont(C["media"].font, 14, C["media"].fontflag)
		if C["ouf"].HealthcolorClass then
			self:Tag(name, '[freeb:name]')
		else
			self:Tag(name, '[freeb:color][freeb:name]')
		end
		if unit == "pet" then
			--Dummy Cast Bar, so we don't see an extra castbar while in vehicle
			local castbar = CreateFrame("StatusBar", nil, self)
			self.Castbar = castbar
		end
	end
	
	if (unit and unit:find("arena%d") and C["ouf"].showArenaFrames == true) or (unit and unit:find("boss%d") and C["ouf"].showBossFrames == true) then
		health:SetSize(BOSS_WIDTH, BOSS_HEIGHT * 0.9)
		health.value:Point("LEFT", self, "LEFT", 5, 0)
		name:Point("BOTTOM", health, -6, -15)
		name:Point("LEFT", health, 0, 0)
		name:SetJustifyH("LEFT")
		if C["ouf"].HealthcolorClass then
			self:Tag(name, '[freeb:name] [freeb:info]')
		else
			self:Tag(name, '[freeb:color][freeb:name] [freeb:info]')
		end
		local power = R.ConstructPowerBar(self, true, true)
		power:SetPoint("LEFT")
		power:SetPoint("RIGHT")
		power:SetPoint("BOTTOM") 
		power.value:Point("RIGHT", self, "RIGHT", -5, 0)
		power:SetWidth(PLAYER_WIDTH)
		power:SetHeight(PLAYER_HEIGHT * 0.1)
		self.Power = power
	end

    local leader = health:CreateTexture(nil, "OVERLAY")
    leader:SetSize(16, 16)
    leader:Point("TOPLEFT", health, "TOPLEFT", 5, 10)
    self.Leader = leader

    local masterlooter = health:CreateTexture(nil, 'OVERLAY')
    masterlooter:SetSize(16, 16)
    masterlooter:Point("TOPLEFT", health, "TOPLEFT", 25, 10)
    self.MasterLooter = masterlooter

    local LFDRole = health:CreateTexture(nil, 'OVERLAY')
    LFDRole:SetSize(16, 16)
    LFDRole:Point("TOPLEFT", health, -10, 10)
	self.LFDRole = LFDRole
	self.LFDRole:SetTexture("Interface\\AddOns\\!RayUI\\media\\lfd_role")
	
    local PvP = health:CreateTexture(nil, 'OVERLAY')
    PvP:SetSize(20, 20)
    PvP:Point('TOPRIGHT', health, 12, 8)
    self.PvP = PvP

    local Combat = health:CreateTexture(nil, 'OVERLAY')
    Combat:SetSize(20, 20)
    Combat:Point('BOTTOMLEFT', health, -10, -10)
    self.Combat = Combat

    local Resting = health:CreateTexture(nil, 'OVERLAY')
    Resting:SetSize(20, 20)
    Resting:Point('BOTTOM', Combat, 'BOTTOM', -9, 20)
    self.Resting = Resting

    local QuestIcon = health:CreateTexture(nil, 'OVERLAY')
    QuestIcon:SetSize(24, 24)
    QuestIcon:Point('BOTTOMRIGHT', health, 15, -20)
    self.QuestIcon = QuestIcon

    local PhaseIcon = health:CreateTexture(nil, 'OVERLAY')
    PhaseIcon:SetSize(24, 24)
    PhaseIcon:SetPoint('RIGHT', QuestIcon, 'LEFT')
    self.PhaseIcon = PhaseIcon
	
    local ricon = health:CreateTexture(nil, 'OVERLAY')
    ricon:Point("BOTTOM", health, "TOP", 0, -7)
    ricon:SetSize(16,16)
    self.RaidIcon = ricon
	
	self.mouseovers = {}
	tinsert(self.mouseovers, self.Health)
	
	if self.Power then
		if self.Power.value then 
			tinsert(self.mouseovers, self.Power)
		end
	end
end

local function LoadDPSLayout()
	local oUF = RayUF or ns.oUF or oUF
	assert(oUF, "RayUF was unable to locate oUF.")

	oUF:RegisterStyle('Ray', Shared)

	-- Player
	local player = oUF:Spawn('player', "RayUF_player")
	player:Point("BOTTOMRIGHT", UIParent, "BOTTOM", -70, 380)
	player:Size(PLAYER_WIDTH, PLAYER_HEIGHT)

	-- Target
	local target = oUF:Spawn('target', "RayUF_target")
	target:Point("BOTTOMLEFT", UIParent, "BOTTOM", 70, 380)
	target:Size(TARGET_WIDTH, TARGET_HEIGHT)

	-- Focus
	local focus = oUF:Spawn('focus', "RayUF_focus")
	focus:Point("BOTTOMRIGHT", RayUF_player, "TOPLEFT", -20, 37)
	focus:Size(PARTY_WIDTH, PARTY_HEIGHT)

	-- Target's Target
	local tot = oUF:Spawn('targettarget', "RayUF_targettarget")
	tot:Point("BOTTOMLEFT", RayUF_target, "TOPRIGHT", 10, 6)
	tot:Size(SMALL_WIDTH, SMALL_HEIGHT)

	-- Player's Pet
	local pet = oUF:Spawn('pet', "RayUF_pet")
	pet:Point("BOTTOM", UIParent, "BOTTOM", 0, 220)
	pet:Size(SMALL_WIDTH, SMALL_HEIGHT)
	pet:SetParent(player)

	-- Focus's target
	local focustarget = oUF:Spawn('focustarget', "RayUF_focustarget")
	focustarget:Point("BOTTOMRIGHT", RayUF_focus, "BOTTOMLEFT", -10, 1)
	focustarget:Size(SMALL_WIDTH, SMALL_HEIGHT)

	if C["ouf"].showArenaFrames then
		local arena = {}
		for i = 1, 5 do
			arena[i] = oUF:Spawn("arena"..i, "RayUFArena"..i)
			if i == 1 then
				arena[i]:Point("RIGHT", -80, 130)
			else
				arena[i]:Point("TOP", arena[i-1], "BOTTOM", 0, -25)
			end
			arena[i]:Size(BOSS_WIDTH, BOSS_HEIGHT)
		end
	end

	if C["ouf"].showBossFrames then
		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("boss"..i, "RayUFBoss"..i)
			if i == 1 then
				boss[i]:Point("RIGHT", -80, 130)
			else
				boss[i]:Point('TOP', boss[i-1], 'BOTTOM', 0, -25)             
			end
			boss[i]:Size(BOSS_WIDTH, BOSS_HEIGHT)
		end
	end
	
	if C["ouf"].ShowParty then
		local party = oUF:SpawnHeader('RayUFParty', nil, 
		"custom [@raid6,exists] hide;show",
		-- "custom [group:party,nogroup:raid][@raid,noexists,group:raid] show;hide",
		-- "solo",
		"showParty", true,
		'showPlayer', false,
		-- 'showSolo',true,
		'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
		'initial-width', PARTY_WIDTH,
		'initial-height', PARTY_HEIGHT,
		"yOffset", -36.5,
		"groupBy", "CLASS",
		"groupingOrder", "WARRIOR,PALADIN,DEATHKNIGHT,DRUID,SHAMAN,PRIEST,MAGE,WARLOCK,ROGUE,HUNTER"	-- Trying to put classes that can tank first
		)
		party:Point("TOPRIGHT", RayUF_player, "TOPLEFT", -20, 0)
		party:SetScale(1)
	end
end

R.Layouts["DPS"] = LoadDPSLayout