--[[ 

Drag the shapes around with your mouse or fingers

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 

]]

Beacon = Core.class(Sprite)

local count = 0

function Beacon:init(x,y,bitmap)
	local bitmap = bitmap
	if not bitmap then
		bitmap = Bitmap.new(Texture.new("pin.png"))
		bitmap:setAnchorPoint(0.2,1)
	end
	
	self:setX(x)
	self:setY(y)
	
	self.isFocus = false
	self.locked = false
	
	self:addChild(bitmap)

	local fontSize = 15
	local font = TTFont.new("arial.ttf",fontSize,true)
	self.locLabel = TextField.new(font, "("..formatNumber(x)..","..formatNumber(y)..")")
	self.locLabel:setPosition(40,-10)
	self:addChild(self.locLabel)

	self.inputbox = InputBox.new(40,-55, 100, 25)
	self.inputbox:setFont("arial.ttf")
	self.inputbox:setText("beacon"..count)
	count=count+1
	self.inputbox:SetKeyBoard(application.keyboard)
	self.inputbox:setBoxColors(0xefefef,0xff2222,2,0.8)
	self.inputbox:setActiveBoxColors(0xff5555,0xff2222,2,0.8)
	self:addChild(self.inputbox)

	-- register to all mouse and touch events
	self:addEventListener(Event.TOUCHES_BEGIN, self.onMouseDown, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onMouseUp, self)
	
end
function Beacon:noInput()
	return self.inputbox:removeFromParent()
end
function Beacon:getName()
	return self.inputbox:getText()
end
function Beacon:setName(name)
	return self.inputbox:setText(name)
end
function Beacon:onMouseDown(event)
	if self.locked then
		return
	end
	if self.inputbox:hitTestPoint(event.touch.x, event.touch.y) then
		local function enter()
			application.keyboard:removeEventListener('KeyboardHide', enter)
		end
		application.keyboard:addEventListener("KeyboardHide", enter)
	elseif self:hitTestPoint(event.touch.x, event.touch.y) then
		if self.removeMode then
			self:removeFromParent()
			return
		end
		local point = application.camera:translateEvent(event.touch)
		
		self.isFocus = true

		self.x0 = point.x
		self.y0 = point.y
		
		event:stopPropagation()
	end
end

function Beacon:onMouseMove(event)
	if self.isFocus then
		local point = application.camera:translateEvent(event.touch)
		
		local dx = point.x - self.x0
		local dy = point.y - self.y0
		
		self:setX(self:getX() + dx)
		self:setY(self:getY() + dy)

		self.x0 = point.x
		self.y0 = point.y
		
		self.locLabel:setText("("..formatNumber(self:getX())..","..formatNumber(self:getY())..")")

		event:stopPropagation()
	end
end

function Beacon:onMouseUp(event)
	if self.isFocus then
		self.isFocus = false
		event:stopPropagation()
	end
end

function Beacon:setLocked(locked)
	self.locked = locked
	if self.locked==true then
		self.inputbox:removeFromParent()
	else
		self:addChild(self.inputbox)
	end
end

function Beacon:setRemoveMode(removeMode)
	self.removeMode = removeMode
end
