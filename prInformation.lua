local addonName, addon = ...

addon.settings = {}
addon.stat = {}

addon.stat.durability = CreateFrame('Frame')
addon.stat.fps = CreateFrame('Frame')
addon.stat.friend = CreateFrame('Frame')
addon.stat.gold = CreateFrame('Frame')
addon.stat.guild = CreateFrame('Frame')
addon.stat.memory = CreateFrame('Frame')

addon.ShortValue = function(v)
	if v >= 1e6 then
		return ('%.1fm'):format(v / 1e6):gsub('%.?0+([km])$', '%1')
	elseif v >= 1e3 or v <= -1e3 then
		return ('%.1fk'):format(v / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return v
	end
end

addon.RGBToHex = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format('|cff%02x%02x%02x', r*255, g*255, b*255)
end