AdvButton = Core.class(Sprite)

function AdvButton:init()
	self.advancedBtn = Utils.createToggleButton("buttons/advanced_off.png","buttons/advanced_on.png")
	Snapper.snapToBottomRight(advancedBtn)
end

function AdvButton:show()

end

function AdvButton:hide()

end

local function showAdvancedControl()
	topbar:removeFromParent()
	stage:addChild(advanceBar)
	loadBeacon()
	camera:addChild(beaconGroup)
	loadSample()
	camera:addChild(sampleGroup)
	-- load config
	--beaconGroup:setVisible(true)
	local point = {x=application:getLogicalWidth()/2,y=application:getLogicalHeight()/2}
	point = camera:translateEvent(point)
	myAnchor:setPosition(point.x,point.y)
	--myAnchor:setVisible(true)
	camera:addChild(myAnchor)
end

advancedBtn:addEventListener('off', function()
	stage:addChild(topbar)
	if stage:contains(advanceBar) then
		stage:removeChild(advanceBar)
	end
	if camera:contains(sampleGroup) then
		camera:removeChild(sampleGroup)
	end
	if camera:contains(beaconGroup) then
		camera:removeChild(beaconGroup)
	end
	if camera:contains(myAnchor) then
		camera:removeChild(myAnchor)
	end
	--beaconGroup:setVisible(false)
	--myAnchor:setVisible(false)
end)
--showAdvancedControl()
advancedBtn:addEventListener('on', function()
	
	local passwordDialog = Sprite.new()

	local fontSize = 30
	local font = TTFont.new("billo.ttf",fontSize,true)
	local label = TextField.new(font, "Password: ")
	label:setTextColor(0x0ff0000)
	Snapper.snapToCenter(label, 0, -40)
	passwordDialog:addChild(label)

	local inputbox = InputBox.new(application:getContentWidth()/2,application:getContentHeight()/2, 200, 40)
	--local x,y = inputbox:getPosition()
	Snapper.snapToCenter(inputbox)
--	inputbox:setPosition(x-200/2,y-40/2)
	inputbox:PasswordField(true)
	inputbox:SetKeyBoard(application.keyboard)
	inputbox:setBoxColors(0xefefef,0xff2222,5,1)
	inputbox:setActiveBoxColors(0xff5555,0xff2222,5,1)
	passwordDialog:addChild(inputbox)
	inputbox:setFocus()
	
	stage:addChild(passwordDialog)
	local function enter()
		firebase:get("password/ilab", function(r)
			if not r.error and inputbox:getText() == r.data then
				showAdvancedControl()
			else
				advancedBtn:setOff()
			end
			stage:removeChild(passwordDialog)
			application.keyboard:removeEventListener('KeyboardHide', enter)
		end)
	end
	application.keyboard:addEventListener("KeyboardHide", enter)
end)



