UsernameBox = Core.class(Sprite)

function UsernameBox:init()
	local fontSize = 20
	local font = TTFont.new("billo.ttf",fontSize,true)
	local label = TextField.new(font, "Name: ")
	label:setTextColor(0x666666)
	Snapper.snapToTopRight(label,-155,22)
	self:addChild(label)

	local inputbox = InputBox.new(application:getContentWidth()/2,application:getContentHeight()/2, 150, 30)
	--local x,y = inputbox:getPosition()
	Snapper.snapToTopRight(inputbox, 0, 0)
--	inputbox:setPosition(x-200/2,y-40/2)
	inputbox:setText(application.username)
	inputbox:SetKeyBoard(application.keyboard)
	inputbox:setBoxColors(0x666666,0x666666,5,0.5)
	inputbox:setActiveBoxColors(0x666666,0x666666,5,0.5)
	self:addChild(inputbox)
		
	inputbox:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if inputbox:hitTestPoint(event.touch.x,event.touch.y) then
			local function enter()
				firebase:write("people/ilab/"..application.username, {})
				application.username = inputbox:getText()
				--print(application.username)
				local event = Event.new("nameChanged")
				self:dispatchEvent(event)
				application.keyboard:removeEventListener('KeyboardHide', enter)
			end
			application.keyboard:addEventListener("KeyboardHide", enter)	
		end
	end)
end