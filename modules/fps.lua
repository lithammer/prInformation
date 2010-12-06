local addonName, addon = ...

if not addon.settings.fps.enable then return end

local Stat = addon.stat.fps
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)

local Text = Stat:CreateFontString(nil, "OVERLAY")
Text:SetFont(addon.settings.fps.font, addon.settings.fps.font_size)
Text:SetPoint(unpack(addon.settings.fps.position))
Text:SetShadowColor(0, 0, 0)
Text:SetShadowOffset(1, -1)
if addon.settings.fps.class_color then
	local _, class = UnitClass('player')
	Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )
end

--Tooltip
Stat:EnableMouse(true)
local colorme = string.format("%02x%02x%02x", 1*255, 1*255, 1*255)
local function formatMem(memory, color)
	if color then
		statColor = { "|cff"..colorme, "|r" }
	else
		statColor = { "", "" }
	end
	
	local mult = 10^1
	if memory > 999 then
		local mem = floor((memory/1024) * mult + 0.5) / mult
		if mem % 1 == 0 then
			return mem..string.format(".0 %smb%s", unpack(statColor))
		else
			return mem..string.format(" %smb%s", unpack(statColor))
		end
	else
		local mem = floor(memory * mult + 0.5) / mult
			if mem % 1 == 0 then
				return mem..string.format(".0 %skb%s", unpack(statColor))
			else
				return mem..string.format(" %skb%s", unpack(statColor))
			end
	end
end

local Total, Mem, MEMORY_TEXT, LATENCY_TEXT, Memory
local function RefreshMem(self)
	Memory = {}
	collectgarbage("collect")
	UpdateAddOnMemoryUsage()
	Total = 0
	for i = 1, GetNumAddOns() do
		Mem = GetAddOnMemoryUsage(i)
		Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
		Total = Total + Mem
	end
	
	MEMORY_TEXT = formatMem(Total, true)
	table.sort(Memory, function(a, b)
		if a and b then
			return a[2] > b[2]
		end
	end)
	
	self:SetAllPoints(Text)
end
--End tooltip

local int, int2 = 1, 10
local function Update(self, t)
	int = int - t
	int2 = int2 - t
	if int2 < 0 then
		RefreshMem(self)
		int2 = 10
	end
	if int < 0 then
		Text:SetText(floor(GetFramerate()).." |cfffffffffps &|r "..select(3, GetNetStats()).." |cffffffffms|r")
		int = 1
	end	
end

Stat:SetScript("OnMouseDown", function() collectgarbage("collect") Update(Stat, 20) end)
if not addon.settings.memory.enable then -- Disable tooltip if the memory module is active
	Stat:SetScript("OnUpdate", Update) 
	Stat:SetScript("OnEnter", function(self)
		if not InCombatLockdown() then
			GameTooltip:SetOwner(self, unpack(addon.settings.fps.tooltip_position));
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 0)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine("Total Memory Usage:", formatMem(Total), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddLine(" ")
			for i = 1, #Memory do
				if Memory[i][3] then 
					local red = Memory[i][2]/Total*2
					local green = 1 - red
					GameTooltip:AddDoubleLine(Memory[i][1], formatMem(Memory[i][2], false), 1, 1, 1, red, green+1, 0)						
				end
			end
			GameTooltip:Show()
		end
	end)
	Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
end
Update(Stat, 20)