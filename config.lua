local addonName, addon = ...

-- Use these local values for parenting internally among the data texts
local Durability = addon.stat.durability
local FPS = addon.stat.fps
local Friend = addon.stat.friend
local Gold = addon.stat.gold
local Guild = addon.stat.guild
local Memory = addon.stat.memory

-- Set font and size for all data texts
local font = 'Fonts\\ARIALN.ttf'
local font_size = 16

-- Displays durability on equipped items
addon.settings.durability = {
	enable 				= true,

	font 				= font,
	font_size 			= font_size,
	position 			= {'BOTTOMRIGHT', Gold, 'TOPRIGHT', 0, 3},
	tooltip_position 	= {'ANCHOR_TOP', 0, 6},
	class_color 		= true,
}

-- Shows online friends
addon.settings.friend = {
	enable 				= true,

	font 				= font,
	font_size 			= font_size,
	position 			= {'TOPRIGHT', Minimap, 'BOTTOMRIGHT', -5, -5},
	tooltip_position 	= {'ANCHOR_BOTTOM', 0, -6},
	class_color 		= true,
}

-- Shows online guild members, right-click to send a whisper or invite
addon.settings.guild = {
	enable 				= true,

	font 				= font,
	font_size 			= font_size,
	position 			= {'TOPLEFT', Minimap, 'BOTTOMLEFT', 5, -5},
	tooltip_position 	= {'ANCHOR_BOTTOM', 0, -6},
	class_color 		= true,
}

-- Displays amount of gold your characters, and shows gold gained/lost in current session
addon.settings.gold = {
	enable 				= true,

	font 				= font,
	font_size 			= font_size,
	position 			= {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -5, 3},
	tooltip_position 	= {'ANCHOR_TOP', 0, 6},
	class_color 		= true,
}

-- Displays memory and bandwidth usage of addons
addon.settings.memory = {
	enable 				= true,

	font 				= font,
	font_size 			= font_size,
	position 			= {'BOTTOMRIGHT', Durability, 'TOPRIGHT', 0, 3},
	tooltip_position 	= {'ANCHOR_TOP', 0, 6},
	class_color 		= true,
}

-- Displays framerate and latency
addon.settings.fps = {
	enable 				= true,

	font 				= font,
	font_size 			= font_size,
	position 			= {'BOTTOMRIGHT', Memory, 'TOPRIGHT', 0, 3},
	tooltip_position 	= {'ANCHOR_TOP', 0, 6},
	class_color 		= true,
}
