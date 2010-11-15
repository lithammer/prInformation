local addonName, addon = ...

local font = "Fonts\\ARIALN.ttf"
local font_size = 12

-- Displays durability on equipped items
addon.settings.durability = {
	["enable"] = false,
	
	["font"] = font,
	["font_size"] = 12,
	["position"] = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 20},
	["tooltip_position"] = {"ANCHOR_TOP", 0, 6},
	["class_color"] = true,
}

-- Shows online friends
addon.settings.friend = {
	["enable"] = true,
	
	["font"] = font,
	["font_size"] = 12,
	["position"] = {"TOPRIGHT", Minimap, "BOTTOMRIGHT", -5, -5},
	["tooltip_position"] = {"ANCHOR_BOTTOM", 0, -6},
	["class_color"] = true,
}

-- Shows online guild members, right-click to send a whisper or invite
addon.settings.guild = {
	["enable"] = true,
	
	["font"] = font,
	["font_size"] = 12,
	["position"] = {"TOPLEFT", Minimap, "BOTTOMLEFT", 5, -5},
	["tooltip_position"] = {"ANCHOR_BOTTOM", 0, -6},
	["class_color"] = true,
}

-- Displays amount of gold your characters, and shows gold gained/lost in current session
addon.settings.gold = {
	["enable"] = true,
	
	["font"] = font,
	["font_size"] = 12,
	["position"] = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 5},
	["tooltip_position"] = {"ANCHOR_TOP", 0, 6},
}

-- Displays memory and bandwidth usage of addons
addon.settings.memory = {
	["enable"] = false,
	
	["font"] = font,
	["font_size"] = 12,
	["position"] = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 20},
	["tooltip_position"] = {"ANCHOR_TOP", 0, 6},
	["class_color"] = true,
}

-- Displays framerate and memory usage
addon.settings.fps = {
	["enable"] = false,
	
	["font"] = font,
	["font_size"] = 12,
	["position"] = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 20},
	["tooltip_position"] = {"ANCHOR_TOP", 0, 6},
	["class_color"] = true,
}