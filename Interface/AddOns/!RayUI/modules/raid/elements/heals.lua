local R, C, L, DB = unpack(select(2, ...))

if not C["raid"].enable then return end

local _, ns = ...
local oUF = RayUF or ns.oUF or oUF
assert(oUF, "unable to locate oUF install.")

local numberize = ns.numberize
local colorCache = ns.colorCache

oUF.Tags['freebgrid:altpower'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
    if cur > 0 then
	    local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
        local per = floor(cur/max*100)

        local tPath, r, g, b = UnitAlternatePowerTextureInfo(u, 2)
    
        if not r then
            r, g, b = 1, 1, 1
        end

        return ns:hex(r,g,b)..format("%d", per).."|r"
    end
end
oUF.TagEvents['freebgrid:altpower'] = "UNIT_POWER UNIT_MAXPOWER"

oUF.Tags['freebgrid:def'] = function(u)
    if UnitIsAFK(u) then
        return "|cffCFCFCFAFK|r"
    elseif UnitIsDead(u) then
        return "|cffCFCFCFDead|r"
    elseif UnitIsGhost(u) then
        return "|cffCFCFCFGhost|r"
    elseif not UnitIsConnected(u) then
        return "|cffCFCFCFD/C|r"
    end

    if C["raid"].perc then
        local perc = oUF.Tags['perhp'](u)
        if perc < 90 then
            local _, class = UnitClass(u)
            local color = colorCache[class]

            return color..perc.."%|r"
        end
    elseif C["raid"].deficit or C["raid"].actual then
        local cur = UnitHealth(u)
        local max = UnitHealthMax(u)
        local per = cur/max

        if per < 0.9 then
            local _, class = UnitClass(u)
            local color = colorCache[class]
            if color then
                return color..(C["raid"].deficit and "-"..numberize(max-cur) or numberize(cur)).."|r"
            end
        end
    end 
end
oUF.TagEvents['freebgrid:def'] = 'UNIT_MAXHEALTH UNIT_HEALTH UNIT_HEALTH_FREQUENT UNIT_CONNECTION PLAYER_FLAGS_CHANGED '..oUF.TagEvents['freebgrid:altpower']

oUF.Tags['freebgrid:heals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags['freebgrid:def'](u)
        return def
    end
end
oUF.TagEvents['freebgrid:heals'] = 'UNIT_HEAL_PREDICTION '..oUF.TagEvents['freebgrid:def']

oUF.Tags['freebgrid:othersheals'] = function(u)
    local incheal = UnitGetIncomingHeals(u) or 0
    local player = UnitGetIncomingHeals(u, "player") or 0

    incheal = incheal - player

    if incheal > 0 then
        return "|cff00FF00"..numberize(incheal).."|r"
    else
        local def = oUF.Tags['freebgrid:def'](u)
        return def
    end
end
oUF.TagEvents['freebgrid:othersheals'] = oUF.TagEvents['freebgrid:heals']

local Update = function(self, event, unit)
    if self.unit ~= unit then return end

    local overflow = C["raid"].healoverflow and 1.20 or 1
    local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

    local health = self.Health:GetValue()
    local _, maxHealth = self.Health:GetMinMaxValues()

    if ( health + allIncomingHeal > maxHealth * overflow ) then
        allIncomingHeal = maxHealth * overflow - health
    end

    if ( allIncomingHeal < myIncomingHeal ) then
        myIncomingHeal = allIncomingHeal
        allIncomingHeal = 0
    else
        allIncomingHeal = allIncomingHeal - myIncomingHeal
    end

    self.myHealPredictionBar:SetMinMaxValues(0, maxHealth) 
    if C["raid"].healothersonly then
        self.myHealPredictionBar:SetValue(0)
    else
        self.myHealPredictionBar:SetValue(myIncomingHeal)
    end
    self.myHealPredictionBar:Show()

    self.otherHealPredictionBar:SetMinMaxValues(0, maxHealth)
    self.otherHealPredictionBar:SetValue(allIncomingHeal)
    self.otherHealPredictionBar:Show()
end

local Enable = function(self)
    if self.freebHeals then
        if C["raid"].healbar then
            self.myHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
			self.myHealPredictionBar:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			self.myHealPredictionBar:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			self.myHealPredictionBar:SetSize(C["raid"].width, 0)
			self.myHealPredictionBar:SetStatusBarTexture("", "BORDER")
			self.myHealPredictionBar:GetStatusBarTexture():SetTexture(0, 1, 0.5, 0.25)
			self.myHealPredictionBar:Hide()

            self.otherHealPredictionBar = CreateFrame('StatusBar', nil, self.Health)
			self.otherHealPredictionBar:SetPoint("TOPLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			self.otherHealPredictionBar:SetPoint("BOTTOMLEFT", self.myHealPredictionBar:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
			self.otherHealPredictionBar:SetSize(C["raid"].width, 0)
            self.otherHealPredictionBar:SetStatusBarTexture("", "BORDER")
            self.otherHealPredictionBar:GetStatusBarTexture():SetTexture(0, 1, 0, 0.25)
            self.otherHealPredictionBar:Hide() 

            self:RegisterEvent('UNIT_HEAL_PREDICTION', Update)
            self:RegisterEvent('UNIT_MAXHEALTH', Update)
            self:RegisterEvent('UNIT_HEALTH', Update)
        end

        local healtext = self.Health:CreateFontString(nil, "OVERLAY")
        healtext:SetPoint("BOTTOM")
        healtext:SetShadowOffset(1.25, -1.25)
        healtext:SetFont(C["media"].font, C["media"].fontsize - 2, C["media"].fontflag)
        healtext:SetWidth(C["raid"].width)
        self.Healtext = healtext

        self:Tag(healtext, "[freebgrid:def]")
    end
end

local Disable = function(self)
    if self.freebHeals then
        if C["raid"].healbar then
            self:UnregisterEvent('UNIT_HEAL_PREDICTION', Update)
            self:UnregisterEvent('UNIT_MAXHEALTH', Update)
            self:UnregisterEvent('UNIT_HEALTH', Update)
        end
    end
end

oUF:AddElement('freebHeals', Update, Enable, Disable)
