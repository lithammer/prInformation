local addonName, addon = ...

if not addon.settings.fps.enable then return end

local Stat = addon.stat.fps
Stat:SetFrameStrata('BACKGROUND')
Stat:SetFrameLevel(3)
Stat:EnableMouse(true)

local Text = Stat:CreateFontString(nil, 'OVERLAY')
Text:SetFont(addon.settings.fps.font, addon.settings.fps.font_size)
Text:SetPoint(unpack(addon.settings.fps.position))
Text:SetShadowColor(0, 0, 0)
Text:SetShadowOffset(1, -1)
if addon.settings.fps.class_color then
	local _, class = UnitClass('player')
	Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )
end

local int = 1
local function Update(self, t)
	int = int - t
	if int < 0 then
		Text:SetText(floor(GetFramerate())..' |cfffffffffps &|r '..select(3, GetNetStats())..' |cffffffffms|r')
		self:SetAllPoints(Text)
		int = 1			
	end	
end

Stat:SetScript('OnUpdate', Update)
Stat:SetScript('OnEnter', function(self)
	if not InCombatLockdown() then
		local _, _, latencyHome, latencyWorld = GetNetStats()
		local latency = format(MAINMENUBAR_LATENCY_LABEL, latencyHome, latencyWorld)
		GameTooltip:SetOwner(self, unpack(addon.settings.fps.tooltip_position))
		GameTooltip:ClearLines()
		GameTooltip:AddLine(latency)
		GameTooltip:Show()
	end
end)
Stat:SetScript('OnLeave', function() GameTooltip:Hide() end)	
Update(Stat, 10)