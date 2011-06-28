local addonName, addon = ...

if not addon.settings.memory.enable then return end

local settings = addon.settings.memory

local Stat = addon.stat.memory
Stat:RegisterEvent('PLAYER_ENTERING_WORLD')
Stat:EnableMouse(true)
Stat:SetFrameStrata('BACKGROUND')
Stat:SetFrameLevel(3)

local Text  = Stat:CreateFontString(nil, 'OVERLAY')
Text:SetFont(settings.font, settings.font_size)
Text:SetPoint(unpack(settings.position))
Text:SetShadowColor(0, 0, 0)
Text:SetShadowOffset(1, -1)
if settings.class_color then
	local _, class = UnitClass('player')
	Text:SetTextColor(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b )
end

local bandwidthString = '%.2f Mbps'
local percentageString = '%.2f%%'

local kiloByteString = '%d |cffffffffkb|r'
local megaByteString = '%.2f |cffffffffmb|r'

local function formatMem(memory)
	local mult = 10^1
	if (memory > 999) then
		local mem = ((memory/1024) * mult) / mult
		return string.format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return string.format(kiloByteString, mem)
	end
end

local memoryTable = {}

local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) or self.tooltip == true then return end

	-- Number of loaded addons changed, create new memoryTable for all addons
	memoryTable = {}
	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
	self:SetAllPoints(Text)
end

local function UpdateMemory()
	-- Update the memory usages of the addons
	UpdateAddOnMemoryUsage()
	-- Load memory usage in table
	local addOnMem = 0
	local totalMemory = 0

	for i = 1, #memoryTable do
		addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addOnMem
		totalMemory = totalMemory + addOnMem
	end

	-- Sort the table to put the largest addon on top
	table.sort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	
	return totalMemory
end

local int = 10

local function Update(self, t)
	int = int - t
	
	if (int < 0) then
		RebuildAddonList(self)
		local total = UpdateMemory()
		Text:SetText(formatMem(total))
		int = 10
	end
end

Stat:SetScript('OnMouseDown', function () collectgarbage('collect') Update(Stat, 10) end)
Stat:SetScript('OnEnter', function(self)
	if not InCombatLockdown() then
		self.tooltip = true

		local bandwidth = GetAvailableBandwidth()
		GameTooltip:SetOwner(self, unpack(settings.tooltip_position))
		GameTooltip:ClearLines()

		if bandwidth ~= 0 then
			GameTooltip:AddDoubleLine('Bandwidth: ', string.format(bandwidthString, bandwidth), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
			GameTooltip:AddDoubleLine('Download: ', string.format(percentageString, GetDownloadedPercentage() * 100), 0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
			GameTooltip:AddLine(' ')
		end

		local totalMemory = UpdateMemory()
		GameTooltip:AddDoubleLine('Total Memory Usage:', formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddLine(' ')

		for i = 1, #memoryTable do
			if (memoryTable[i][4]) then
				local red = memoryTable[i][3] / totalMemory
				local green = 1 - red
				GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
			end						
		end

		GameTooltip:Show()
	end
end)
Stat:SetScript('OnLeave', function(self) self.tooltip = false GameTooltip:Hide() end)
Stat:SetScript('OnUpdate', Update)
Stat:SetScript('OnEvent', function(self, event) collectgarbage('collect') end)
Update(Stat, 10)
