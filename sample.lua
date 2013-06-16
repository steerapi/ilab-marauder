--[[ 

Drag the shapes around with your mouse or fingers

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 

]]

Sample = Core.class(Sprite)

local count = 0

function Sample:init(x,y,bitmap)
	local bitmap = bitmap
	if not bitmap then
		bitmap = Bitmap.new(Texture.new("sample.png"))
		bitmap:setAnchorPoint(0.5,0.5)
	end
	
	self:setX(x)
	self:setY(y)
		
	self:addChild(bitmap)
	
end
