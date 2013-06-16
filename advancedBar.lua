-- Add Beacon

local function addPin()
	local point = {x=application:getLogicalWidth()/2,y=application:getLogicalHeight()/2}
	point = application.camera:translateEvent(point)
	beacon = Beacon.new(point.x,point.y)
	beacon:setPosition(point.x,point.y)
	beaconGroup:addChild(beacon)
end

-- Create advance bar

local lockBtn = createToggleButton("buttons/lock_off.png","buttons/lock_on.png")
snapToTopLeft(lockBtn)
local addBtn = createButton("buttons/add_off.png","buttons/add_on.png")
snapToTopLeft(addBtn,96)
local removeBtn = createToggleButton("buttons/remove_off.png","buttons/remove_on.png")
snapToTopLeft(removeBtn,96*2)
local saveBtn = createButton("buttons/save_off.png","buttons/save_on.png")
snapToTopLeft(saveBtn,96*3)
local measureBtn = createToggleButton("buttons/measure_off.png","buttons/measure_on.png")
snapToTopLeft(measureBtn,96*4)

application.advanceBar = Sprite.new()
advanceBar:addChild(lockBtn)
advanceBar:addChild(addBtn)
advanceBar:addChild(removeBtn)
advanceBar:addChild(saveBtn)
advanceBar:addChild(measureBtn)

addBtn:addEventListener('click', function()
	addPin()
end)

lockBtn:addEventListener("on", 
	function()
		for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacon:setLocked(true)
		end
	end)
lockBtn:addEventListener("off", 
	function()
		for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacon:setLocked(false)
		end
	end)
	
saveBtn:addEventListener("click", 
	function()
	end)
measureBtn:addEventListener("on", 
	function()

	end)
measureBtn:addEventListener("off", 
	function()
	
	end)
