--[[
This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 
--]]

Here = Core.class(Sprite)

function Here:updateLabel()
	local x,y = self:getPosition()
	self.locLabel:setText("("..formatNumber(x)..","..formatNumber(y)..")")
end

local font = TTFont.new("arial.ttf",15,true)
local font2 = TTFont.new("billo.ttf",20,true)

function Here:init(bitmapName)
	local bitmapName = bitmapName or "buttons/here.png"
	
	local hereBitmap = Bitmap.new(Texture.new(bitmapName))
	hereBitmap:setAnchorPoint(0.5,0.5)
		
	self.locLabel = TextField.new(font, "")
	self.locLabel:setPosition(20,10)
	
	self:addChild(self.locLabel)

	self.name = TextField.new(font2, application.username or "You")
	self.name:setPosition(20,-15)
	self.name:setTextColor(0xff0000)
	self:addChild(self.name)

	self:addChild(hereBitmap)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
	
	self.subframe = 0
end
function Here:setName(name)
	self.name:setText(name)
end
function Here:onEnterFrame()
	
	local framerate = 120
	
	-- get the current position
	local x,y = self:getPosition()
		
	if self.subframe % framerate == 0 then
		x = x + 12
		y = y - 10
	elseif self.subframe % framerate == framerate/3 then
		-- change the position according to the speed
		x = x - 6
		y = y + 20
	elseif self.subframe % framerate == 2*framerate/3 then
		x = x - 6
		y = y - 10
	end

	-- set the new position
	self:setPosition(x, y)
	self:updateLabel()
	
	self.subframe = (self.subframe + 1) % framerate
	
end
