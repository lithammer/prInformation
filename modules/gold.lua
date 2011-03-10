local addonName, addon = ...

if not addon.settings.gold.enable then return end

local settings = addon.settings.gold

local Stat = addon.stat.gold
Stat:EnableMouse(true)
Stat:SetFrameStrata('BACKGROUND')
Stat:SetFrameLevel(3)

local Text = Stat:CreateFontString(nil, 'OVERLAY')
Text:SetFont(settings.font, settings.font_size)
Text:SetPoint(unpack(settings.position))
Text:SetShadowColor(0, 0, 0)
Text:SetShadowOffset(1, -1)

local Profit = 0
local Spent	= 0
local OldMoney = 0
local myPlayerRealm = GetCVar('realmName')

local function OnEvent(self, event)
	if event == 'PLAYER_ENTERING_WORLD' then
		OldMoney = GetMoney()
	end

	local NewMoney = GetMoney()
	local Change = NewMoney - OldMoney -- Positive if we gain money
	
	if (OldMoney > NewMoney) then	-- Lost Money
		Spent = Spent - Change
	else							-- Gained Moeny
		Profit = Profit + Change
	end

	Text:SetText(GetCoinTextureString(NewMoney, settings.font_size))
	-- Setup Money Tooltip
	self:SetAllPoints(Text)

	if (prInformationData == nil) then
		prInformationData = {}
	end

	if (prInformationData.gold == nil) then
		prInformationData.gold = {}
	end

	if (prInformationData.gold[myPlayerRealm] == nil) then
		prInformationData.gold[myPlayerRealm] = {}
	end

	local myPlayerName = UnitName('player')
	prInformationData.gold[myPlayerRealm][myPlayerName] = GetMoney()

	OldMoney = NewMoney
end

Stat:RegisterEvent('PLAYER_MONEY')
Stat:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
Stat:RegisterEvent('SEND_MAIL_COD_CHANGED')
Stat:RegisterEvent('PLAYER_TRADE_MONEY')
Stat:RegisterEvent('TRADE_MONEY_CHANGED')
Stat:RegisterEvent('PLAYER_ENTERING_WORLD')
Stat:SetScript('OnMouseDown', function() OpenAllBags() end)
Stat:SetScript('OnEvent', OnEvent)
Stat:SetScript('OnEnter', function(self)
	if (not InCombatLockdown()) then
		self.hovered = true 
		GameTooltip:SetOwner(self, unpack(settings.tooltip_position))
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint('BOTTOM', self, 'TOP', 0, 0)
		GameTooltip:ClearLines()
		GameTooltip:AddLine('Session: ')
		GameTooltip:AddDoubleLine('Earned:', GetCoinTextureString(Profit), 1, 1, 1, 1, 1, 1)
		GameTooltip:AddDoubleLine('Spent:', GetCoinTextureString(Spent), 1, 1, 1, 1, 1, 1)

		if (Profit < Spent) then
			GameTooltip:AddDoubleLine('Deficit:', '-'..GetCoinTextureString(Spent - Profit), 1, 0, 0, 1, 1, 1)
		elseif (Profit - Spent) > 0 then
			GameTooltip:AddDoubleLine('Profit:', GetCoinTextureString(Profit - Spent), 0, 1, 0, 1, 1, 1)
		end
		GameTooltip:AddLine(' ')

		GameTooltip:AddLine('Character: ')
		local thisRealmList = prInformationData.gold[myPlayerRealm]
		local totalGold = 0

		for k, v in pairs(thisRealmList) do
			GameTooltip:AddDoubleLine(k, GetCoinTextureString(v), 1, 1, 1, 1, 1, 1)
			totalGold = totalGold + v
		end

		GameTooltip:AddLine(' ')
		GameTooltip:AddLine('Server: ')
		GameTooltip:AddDoubleLine('Total: ', GetCoinTextureString(totalGold), 1, 1, 1, 1, 1, 1)

		for i = 1, GetNumWatchedTokens() do
			local name, count, extraCurrencyType, icon, itemID = GetBackpackCurrencyInfo(i)

			if (name and i == 1) then
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(CURRENCY)
			end

			local r, g, b = 1, 1, 1
			if (itemID) then
				r, g, b = GetItemQualityColor(select(3, GetItemInfo(itemID)))
			end

			if (name and count) then
				GameTooltip:AddDoubleLine(name, count, r, g, b, 1, 1, 1)
			end
		end

		GameTooltip:Show()
	end
end)
Stat:SetScript('OnLeave', function() GameTooltip:Hide() end)

-- reset gold data
local function RESETGOLD()
	local myPlayerRealm = GetCVar('realmName')
	local myPlayerName  = UnitName('player')
	
	prInformationData.gold = {}
	prInformationData.gold[myPlayerRealm] = {}
	prInformationData.gold[myPlayerRealm][myPlayerName] = GetMoney()
end
SLASH_RESETGOLD1 = '/resetgold'
SlashCmdList['RESETGOLD'] = RESETGOLD
