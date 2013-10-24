-- Create a firebase object
firebase = Firebase.new("https://beacon.firebaseio.com/")
server = Server.new("http://marauder.aws.af.cm/")

application.username = "guest"..math.random(0,100)

if application:getDeviceInfo() == "Android" then
	require("bluetooth")
end

-- Set logical dimension
application:setLogicalDimensions(480,800)

-- Create Keyboard
application.keyboard = KeyBoard.new()
application.keyboard:Create()

-- Create Camera
local camera = Camera.new({minZoom=0.1,maxZoom=3.0,friction=.1})
stage:addChild(camera)
application.camera = camera

-- Add map to camera
local map = Bitmap.new(Texture.new("ilab.png"))
camera:addChild(map)
-- Center camera
camera:centerPoint(map:getWidth()/2,map:getHeight()/2)

-- Create Beacon Group
beaconGroup = Sprite.new()
-- Create Sample Group
sampleGroup = Sprite.new()

local function addPin()
	local point = {x=application:getLogicalWidth()/2,y=application:getLogicalHeight()/2}
	point = camera:translateEvent(point)
	local beacon = Beacon.new(point.x,point.y)
	beaconGroup:addChild(beacon)
end

-- Create tool bar
-- Set up bottom buttons
local bluetoothBtn = Utils.createToggleButton("buttons/bluetooth_off.png","buttons/bluetooth_on.png")
Snapper.snapToBottomRight(bluetoothBtn,-96*3)
local broadcastBtn = Utils.createToggleButton("buttons/broadcast_off.png","buttons/broadcast_on.png")
Snapper.snapToBottomRight(broadcastBtn,-96*2)
local locateBtn = Utils.createToggleButton("buttons/locate_off.png","buttons/locate_on.png")
Snapper.snapToBottomRight(locateBtn,-96)
local advancedBtn = Utils.createToggleButton("buttons/advanced_off.png","buttons/advanced_on.png")
Snapper.snapToBottomRight(advancedBtn)

-- Set up bottom button bar
local toolbar = Sprite.new()
toolbar:addChild(bluetoothBtn)
toolbar:addChild(broadcastBtn)
toolbar:addChild(locateBtn)
toolbar:addChild(advancedBtn)
stage:addChild(toolbar)

-- Here
local hereBitmap = Here.new()
camera:addChild(hereBitmap)
hereBitmap:setVisible(false)

local locateHandler
local measuring = false

local statusTxt = TextWrap.new("", 300, "right")
Snapper.snapToBottomRight(statusTxt, -10,-100)
stage:addChild(statusTxt)

locateBtn:addEventListener("on", 
	function()
		local mCount = 0
		local MAX_COUNT = 3
		local mBeacons = {}
		local cBeacons = {}
		statusTxt:setText("Locating...")
		if measuring then
			locateBtn:setOff()
			return
		end
		if application:getDeviceInfo() == "Android" then
			locateHandler = function(event) 
				-- beacons = {}
				for i = 1, beaconGroup:getNumChildren() do
					beacon = beaconGroup:getChildAt(i)
					result = Json.Decode(event.response)["result"]
					local mac
					local rssi
					for i,v in pairs(result) do
						if beacon:getName() == v.name then
							mac = v.mac
							rssi = v.rssi
							break
						end
					end
					-- beacons[beacon:getName()] = { name = beacon:getName(), mac = mac, rssi = rssi }
					local orssi = 0
					if mBeacons[beacon:getName()] and mBeacons[beacon:getName()].rssi then
						orssi = mBeacons[beacon:getName()].rssi
					end
					local name = beacon:getName()
					mBeacons[name] = { name = name, mac = mac, rssi = (rssi + orssi) }
					cBeacons[name] = cBeacons[name] + 1
				end
				count = count + 1
				statusTxt:setText("Locating... " .. Utils.formatNumber(count/MAX_COUNT*100) .. "%")
				if count < MAX_COUNT then
					socket.sleep(3)
					bluetooth:discoverDevices()
					return
				end
				statusTxt:setText("Calculating...")
				for name,beacon in pairs(mBeacons) do
					beacon.rssi = beacon.rssi/cBeacons[name]
				end
				mCount = 0
				mBeacons = {}
				cBeacons = {}
				server:locate({ beacons = beacons }, function(r) 
					if r.error then
						print("ERROR")
						print(r.url)
					else
						if r.data ~= nil and r.data.status == "ok" then
							statusTxt:setText("")
							hereBitmap:setVisible(true)
							application.userX = r.data.result.x
							application.userY = r.data.result.y
							if broadcastBtn.state then
								local t = os.date('*t')
								firebase:write("people/ilab/"..application.username, { name = application.username, x = application.userX, y = application.userY, time = os.time(t) }, function(r) 
								end)
							end
							hereBitmap:setPosition(r.data.result.x, r.data.result.y)
							--camera:setPosition(r.data.result.x, r.data.result.y)
						else
							statusTxt:setText('error locating you...')
						end
					end
				end)	
				socket.sleep(3)
				bluetooth:discoverDevices()
			end
			bluetooth:addEventListener(Event.DISCOVERY_FINISHED, locateHandler)		
			bluetooth:discoverDevices()
		else
			-- TODO REMOVE
			local function updateLoc()
				statusTxt:setText('Locating...')
				server:locate({ beacons = beacons }, function(r) 
					if r.error then
						print("ERROR")
						print(r.url)
					else
						if r.data ~= nil and r.data.status == "ok" then
							hereBitmap:setVisible(true)
							application.userX = r.data.result.x
							application.userY = r.data.result.y
							if broadcastBtn.state then
								local t = os.date('*t')
								firebase:write("people/ilab/"..application.username, { name = application.username, x = application.userX, y = application.userY, time = os.time(t) }, function(r) 
								end)
							end
							hereBitmap:setPosition(r.data.result.x, r.data.result.y)
							--camera:setPosition(r.data.result.x, r.data.result.y)
						else
							statusTxt:setText('error locating you...')
						end
					end
				end)			
			end
			local timer = Timer.new(5000,0)
			timer:addEventListener(Event.TIMER, updateLoc)
			timer:start()
			updateLoc()
			-- 	
		end
	end)
locateBtn:addEventListener("off", 
	function()
		statusTxt:setText("")
		if measuring then
			return
		end
		if application:getDeviceInfo() == "Android" then
			bluetooth:cancel()
			if locateHandler then
				bluetooth:removeEventListener(Event.DISCOVERY_FINISHED, locateHandler)
			end
		end
		hereBitmap:setVisible(false)
	end)

broadcastBtn:addEventListener("on", 
	function()
		if not locateBtn.state then
			locateBtn:setOn()
		end
	end)
broadcastBtn:addEventListener("off", 
	function()
		if application:getDeviceInfo() == "Android" then
			bluetooth:cancel()
		end
	end)

bluetoothBtn:addEventListener("on", 
	function()
		if application:getDeviceInfo() == "Android" then
			bluetooth:enable()
		end
	end)
bluetoothBtn:addEventListener("off", 
	function()
		if application:getDeviceInfo() == "Android" then
			bluetooth:disable()
		end
	end)
	
-- Create advance bar
local lockBtn = Utils.createToggleButton("buttons/lock_off.png","buttons/lock_on.png")
Snapper.snapToTopRight(lockBtn, -96*4)
local addBtn = Utils.createButton("buttons/add_off.png","buttons/add_on.png")
Snapper.snapToTopRight(addBtn, -96*3)
local removeBtn = Utils.createToggleButton("buttons/remove_off.png","buttons/remove_on.png")
Snapper.snapToTopRight(removeBtn, -96*2)
local saveBtn = Utils.createButton("buttons/save_off.png","buttons/save_on.png")
Snapper.snapToTopRight(saveBtn, -96*1)
local measureBtn = Utils.createToggleButton("buttons/measure_off.png","buttons/measure_on.png")
Snapper.snapToTopRight(measureBtn, -96*0)

local advanceBar = Sprite.new()
advanceBar:addChild(lockBtn)
advanceBar:addChild(addBtn)
advanceBar:addChild(removeBtn)
advanceBar:addChild(saveBtn)
advanceBar:addChild(measureBtn)

addBtn:addEventListener('click', function()
	addPin()
	lockBtn:setOff()
	for i = 1, beaconGroup:getNumChildren() do
		beacon = beaconGroup:getChildAt(i)
		beacon:setLocked(false)
	end
	removeBtn:setOff()
	for i = 1, beaconGroup:getNumChildren() do
		beacon = beaconGroup:getChildAt(i)
		beacon:setRemoveMode(false)
	end
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
		beacons = {}
		for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacons[beacon:getName()] = { name = beacon:getName(), x = beacon:getX(), y = beacon:getY() }
		end
		
		firebase:write("configs/ilab", { name = "ilab", beacons = beacons }, function(r)
		   if r.error then
			  print("ERROR")
			  print(r.url)
		   else
			  firebase:get("configs/ilab")
		   end
		end)	
	end)

local fontSize = 15
local font = TTFont.new("arial.ttf",fontSize,true)
local measureText

local anchorBitmap = Bitmap.new(Texture.new("buttons/anchor.png"))
anchorBitmap:setAnchorPoint(0.5,0.7)
local point = {x=application:getLogicalWidth()/2,y=application:getLogicalHeight()/2}
point = camera:translateEvent(point)
local myAnchor = Beacon.new(point.x,point.y,anchorBitmap)
myAnchor:noInput()
--myAnchor:setVisible(false)

local measureHandler

local loadSample = function()
	Utils.clearSprite(sampleGroup)
	server:sample(nil, function(r) 
		if r.error then
			print("ERROR")
			print(r.url)
		else
			if r.data ~= nil and r.data.status == "ok" then
				for k,v in pairs(r.data.result) do
					--print(i)
					--print(v)
					local sample = Sample.new(v.x,v.y)
					sampleGroup:addChild(sample)
				end
			end
		end
	end)
end

measureBtn:addEventListener("on", 
	function()
		measuring = true
		
		if measureText then
			measureText:removeFromParent()
			measureText = nil
		end

		measureText = TextWrap.new("", 400, "right")
		advanceBar:addChild(measureText)
		
		if application:getDeviceInfo() == "Android" then
			
			local count = 0
			measureText:setText("Measuring...")
			measureText:setLineSpacing(5)
			measureText:setTextColor(0xff0000)

			measureText:setTextColor(0xff0000)
			Snapper.snapToTopRight(measureText,-10,110)
			
			measureHandler = function(event) 
				beacons = {}
				local str = ""
				for i = 1, beaconGroup:getNumChildren() do
					beacon = beaconGroup:getChildAt(i)
					local result = Json.Decode(event.response)["result"]
					local mac
					local rssi
					for i,v in pairs(result) do
						if beacon:getName() == v.name then
							mac = v.mac
							rssi = v.rssi
							local t = os.date('*t')
							beacons[beacon:getName()] = { name = beacon:getName(), mac = mac, rssi = rssi, x = math.floor(beacon:getX()), y = math.floor(beacon:getY()), collector = application.username, time = os.time(t)  }
							str = str..tostring(Json.Encode(beacons[beacon:getName()])).."\n"
							break
						end
					end
				end
				local function retry()
					firebase:append("measurements/ilab", { x = math.floor(myAnchor:getX()), y = math.floor(myAnchor:getY()), beacons = beacons }, function(r)
					   if r.error then
						socket.sleep(1)
						retry()
						--print("ERROR")
						--print(r.url)
					   else
						loadSample()
						measureBtn:setOff()
						  --firebase:get("measurements/ilab")
					   end
					end)
				end
				retry()
				--[[
				firebase:append("measurements/ilab", { x = math.floor(myAnchor:getX()), y = math.floor(myAnchor:getY()), beacons = beacons }, function(r)
				   if r.error then
					retry()
					--print("ERROR")
					--print(r.url)
				   else
					  --firebase:get("measurements/ilab")
				   end
				end)
				]]
				local loc = "x = "..math.floor(myAnchor:getX())..", y = "..math.floor(myAnchor:getY())
				count = count + 1
				measureText:setText("Count: "..count.."\n"..loc.."\n".. str)
				
				--socket.sleep(1)
				--bluetooth:discoverDevices()
			end
			
			bluetooth:addEventListener(Event.DISCOVERY_FINISHED, measureHandler)
			bluetooth:discoverDevices()
		else
			-- TODO REMOVE
			local count = 0
			measureText = TextWrap.new("Measuring... ", 400, "right")
			measureText:setLineSpacing(5)
			measureText:setTextColor(0xff0000)

			stage:addChild(measureText)
			measureText:setTextColor(0xff0000)
			Snapper.snapToTopRight(measureText,-10,110)
			
			local function updateMeasure()
				beacons = {}
				local str = ""
				for i = 1, beaconGroup:getNumChildren() do
					beacon = beaconGroup:getChildAt(i)
					local result = { {name = "beacon2", mac = "", rssi = -20}, {name = "beacon4", mac = "", rssi = -50} }
					local mac
					local rssi
					for i,v in pairs(result) do
						if beacon:getName() == v.name then
							mac = v.mac
							rssi = v.rssi
							beacons[beacon:getName()] = { name = beacon:getName(), mac = mac, rssi = rssi, x = math.floor(beacon:getX()), y = math.floor(beacon:getY())}
							str = str..tostring(Json.Encode(beacons[beacon:getName()])).."\n"
							break
						end
					end
					
				end
				firebase:append("measurements/ilab-dummy", { x = math.floor(myAnchor:getX()), y = math.floor(myAnchor:getY()), beacons = beacons }, function(r)
				   if r.error then
					  print("ERROR")
					  print(r.url)
				   else
					  --firebase:get("measurements/ilab")
				   end
				end)
				local loc = "x = "..math.floor(myAnchor:getX())..", y = "..math.floor(myAnchor:getY())
				count = count + 1
				measureText:setText("Count: "..count.."\n"..loc.."\n".. str)
			end
			local timer = Timer.new(5000,0)
			timer:addEventListener(Event.TIMER, updateMeasure)
			timer:start()
			updateMeasure()
		
		end
	end)

measureBtn:addEventListener("off", 
	function()
		measuring = false
		--[[
		if measureText then
			measureText:removeFromParent()
		end
		]]
		if application:getDeviceInfo() == "Android" then
			bluetooth:cancel()
			if measureHandler then
				bluetooth:removeEventListener(Event.DISCOVERY_FINISHED, measureHandler)
			end
		end
	end)
removeBtn:addEventListener("on", 
	function()
	lockBtn:setOff()
	for i = 1, beaconGroup:getNumChildren() do
		beacon = beaconGroup:getChildAt(i)
		beacon:setLocked(false)
	end
	for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacon:setRemoveMode(true)
		end
	end)
removeBtn:addEventListener("off", 
	function()
		for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacon:setRemoveMode(false)
		end
	end)

local loadBeacon = function()
	Utils.clearSprite(beaconGroup)
	firebase:get("configs/ilab/beacons", function(r)
		if not r.error then
			for k,v in pairs(r.data) do
				local beacon = Beacon.new(v.x,v.y)
				beacon:setName(v.name)
				beaconGroup:addChild(beacon)
			end
			lockBtn:setOn()
		end
	end)
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

local mapName = MapName.new()
stage:addChild(mapName)

local usernameBox = UsernameBox.new()
stage:addChild(usernameBox)
usernameBox:addEventListener("nameChanged", function(oldName, newName)
	hereBitmap:setName(newName)
end)
				

local people = People.new(4000)
camera:addChild(people)

if application:getDeviceInfo() == "Android" then
	-- force Bluetooth to be enable the first time the app runs
	bluetooth:enable()
	if bluetooth:isEnabled() then
		bluetoothBtn:setOn()
	end
end