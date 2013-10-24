MapName = Core.class(Sprite)

function MapName:init()
	local fontSize = 30
	local font = TTFont.new("billo.ttf",fontSize,true)
	local label = TextField.new(font, "Harvard Innovation Lab")
	label:setTextColor(0x000000)
	Snapper.snapToTopLeft(label,5,62)
	local label2 = TextField.new(font, "Marauder's Map")
	label2:setTextColor(0x000000)
	Snapper.snapToTopLeft(label2,5,32)
	self:addChild(label)
	self:addChild(label2)
end
