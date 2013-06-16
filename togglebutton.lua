--[[
A generic button class

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 
]]

ToggleButton = Core.class(Sprite)

function ToggleButton:init(upState, downState)
	self.upState = upState
	self.downState = downState
		
	self.focus = false

	-- set the visual state as "up"
	self.state = false
	self:updateVisualState(self.state)
	-- register to all mouse and touch events
	
	self:addEventListener(Event.TOUCHES_BEGIN, self.onMouseDown, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onMouseUp, self)

--[[
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
--]]
end

function ToggleButton:onMouseDown(event)
	if self:hitTestPoint(event.touch.x, event.touch.y) then
		self.focus = true
		self:updateVisualState(not self.state)
		event:stopPropagation()
	end
end

function ToggleButton:onMouseMove(event)
	if self.focus then
		if not self:hitTestPoint(event.touch.x, event.touch.y) then	
			self.focus = false
			-- self:updateVisualState(false)
		end
		event:stopPropagation()
	end
end

function ToggleButton:onMouseUp(event)
	if self.focus then
		self.focus = false
		if self.state then
			self:dispatchEvent(Event.new("on"))
		else
			self:dispatchEvent(Event.new("off"))
		end
		event:stopPropagation()
	end
end

function ToggleButton:setOff()
	self:updateVisualState(false)
	self:dispatchEvent(Event.new("off"))
end

function ToggleButton:setOn()
	self:updateVisualState(true)
	self:dispatchEvent(Event.new("on"))
end

-- if state is true show downState else show upState
function ToggleButton:updateVisualState(state)
	self.state = state
	if state then
		if self:contains(self.upState) then
			self:removeChild(self.upState)
		end
		
		if not self:contains(self.downState) then
			self:addChild(self.downState)
		end
	else
		if self:contains(self.downState) then
			self:removeChild(self.downState)
		end
		
		if not self:contains(self.upState) then
			self:addChild(self.upState)
		end
	end
end
