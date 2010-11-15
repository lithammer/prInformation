local addonName, addon = ...

if not addon.settings.durability.enable then return end

local Stat = addon.stat.durability
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

local Text  = Stat:CreateFontString(nil, "OVERLAY")
Text:SetFont(addon.settings.durability.font, addon.settings.durability.font_size)
Text:SetPoint(unpack(addon.settings.durability.position))
Text:SetShadowColor(0, 0, 0)
Text:SetShadowOffset(1, -1)
if addon.settings.durability.class_color then
	local _, class = UnitClass('player')
	Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )
end

local Total = 0
local current, max

local Slots = {
	[1] = {1, "Head", 1000},
	[2] = {3, "Shoulder", 1000},
	[3] = {5, "Chest", 1000},
	[4] = {6, "Waist", 1000},
	[5] = {9, "Wrist", 1000},
	[6] = {10, "Hands", 1000},
	[7] = {7, "Legs", 1000},
	[8] = {8, "Feet", 1000},
	[9] = {16, "Main Hand", 1000},
	[10] = {17, "Off Hand", 1000},
	[11] = {18, "Ranged", 1000}
}

local function OnEvent(self)
	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then 
				Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end
	table.sort(Slots, function(a, b) return a[3] < b[3] end)
	
	if Total > 0 then
		Text:SetText(floor(Slots[1][3]*100).."% |cffffffffArmor|r")
	else
		Text:SetText("100% |cffffffffArmor|r")
	end
	-- Setup Durability Tooltip
	self:SetAllPoints(Text)
	Total = 0
end

Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
Stat:RegisterEvent("MERCHANT_SHOW")
Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
Stat:SetScript("OnEvent", OnEvent)
Stat:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(self, unpack(addon.settings.durability.tooltip_position));
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 0)
		GameTooltip:ClearLines()
		for i = 1, 11 do
			if Slots[i][3] ~= 1000 then
				green = Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(Slots[i][2], floor(Slots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:Show()
	end
end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)