
-- Create a firebase object

firebase = Firebase.new("https://beacon.firebaseio.com/")
server = Server.new("http://marauder.aws.af.cm/")

application.username = "guest"..math.random(0,100)

--[[
-- Write a lua table and then get a subtable
firebase:write("new/data", { gideros = "Gideros Mobile", thisIs = { anExample = { ofANested = "table" } } }, function(r)
   if r.error then
      print("ERROR")
      print(r.url)
   else
      firebase:get("new/data")
      firebase:get("new/data/thisIs/anExample")
   end
end)


-- Write another lua table, then delete part of it
firebase:write("anotherExample", { 1,2,3,4,5,6,6,8, anotherTable={444,444,44,44,44} }, function(r)
   if r.error then
      print("ERROR")
      print(r.url)
   else
      firebase:remove("anotherExample/anotherTable")
   end
end)


-- Append elements to a collection
firebase:append("gideros/chatroom", { name="ND", msg="amessage" }, function(r)
   if r.error then
      print("ERROR")
      print(r.url)
   else
      firebase:get("gideros/chatroom", function(r)
         if not r.error then
            print("---> CHAT MESSAGES <---")
            for i,v in pairs(r.data) do
               print(v.name .. " said: " .. v.msg)
            end
         end
      end)
   end
end)
]]

if application:getDeviceInfo() == "Android" then
	require("bluetooth")
end

if application:getDeviceInfo() == "Android" then
    --require your plugin
	--[[
    require("exampleplugin")
 
     local text = TextField.new(nil, exampleplugin.modifyString(" world"))
    text:setPosition(300, 300);
    stage:addChild(text)
 
    local text = TextField.new(nil, exampleplugin.addNumbers(21, 22).."")
    text:setPosition(300, 300);
    stage:addChild(text)
	]]
    --use your plugin methods
	--[[
	bluetooth:enable()
	bluetooth:discoverDevices()
	bluetooth:addEventListener(Event.DISCOVERY_FINISHED, function(event) 
	
	end)]]
	--Bluetooth:discoverDevices()
	--require("facebook")
	
end

application:setLogicalDimensions(480,800)

application.keyboard = KeyBoard.new()
application.keyboard:Create()

local camera = Camera.new({minZoom=0.1,maxZoom=3.0,friction=.1})
stage:addChild(camera)
application.camera = camera

-- Add map
local map = Bitmap.new(Texture.new("ilab.png"))
camera:addChild(map)

-- Center camera
camera:centerPoint(map:getWidth()/2,map:getHeight()/2)

-- Add Beacon

beaconGroup = Sprite.new()
sampleGroup = Sprite.new()

local function addPin()
	local point = {x=application:getLogicalWidth()/2,y=application:getLogicalHeight()/2}
	point = camera:translateEvent(point)
	local beacon = Beacon.new(point.x,point.y)
	beaconGroup:addChild(beacon)
end

--[[

-- Add Beacon Button

local dropPinUp = Bitmap.new(Texture.new("button_up.png"))
local dropPinDown = Bitmap.new(Texture.new("button_down.png"))
local dropPinBtn = Button.new(dropPinUp, dropPinDown)
dropPinBtn:addEventListener("click", 
	function() 
		addPin()
	end)
stage:addChild(dropPinBtn)
snapToBottomLeft(dropPinBtn)

-- Lock Toggle Button

local lockBeaconUp = Bitmap.new(Texture.new("button_up.png"))
local lockBeaconDown = Bitmap.new(Texture.new("button_down.png"))
local lockBeaconTBtn = ToggleButton.new(lockBeaconUp, lockBeaconDown)
			
lockBeaconTBtn:addEventListener("on", 
	function()
		for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacon:setLocked(true)
		end
	end)
lockBeaconTBtn:addEventListener("off", 
	function()
		for i = 1, beaconGroup:getNumChildren() do
			beacon = beaconGroup:getChildAt(i)
			beacon:setLocked(false)
		end
	end)

stage:addChild(lockBeaconTBtn)
snapToTopLeft(lockBeaconTBtn)

-- Save Button

local saveUp = Bitmap.new(Texture.new("button_up.png"))
local saveDown = Bitmap.new(Texture.new("button_down.png"))
local saveBtn = Button.new(saveUp, saveDown)
			
saveBtn:addEventListener("click", 
	function()
	
	end)

stage:addChild(saveBtn)
snapToTopRight(saveBtn)

-- Zero Profiling Button

local zeroProfUp = Bitmap.new(Texture.new("button_up.png"))
local zeroProfDown = Bitmap.new(Texture.new("button_down.png"))
local zeroProfBtn = Button.new(zeroProfUp, zeroProfDown)
			
zeroProfBtn:addEventListener("click", 
	function()
	
	end)

stage:addChild(zeroProfBtn)
snapToBottomRight(zeroProfBtn)
]]

local bluetoothBtn = createToggleButton("buttons/bluetooth_off.png","buttons/bluetooth_on.png")
snapToBottomRight(bluetoothBtn,-96*3)
local broadcastBtn = createToggleButton("buttons/broadcast_off.png","buttons/broadcast_on.png")
snapToBottomRight(broadcastBtn,-96*2)
local locateBtn = createToggleButton("buttons/locate_off.png","buttons/locate_on.png")
snapToBottomRight(locateBtn,-96)
local advancedBtn = createToggleButton("buttons/advanced_off.png","buttons/advanced_on.png")
snapToBottomRight(advancedBtn)

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
snapToBottomRight(statusTxt, -10,-100)
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
				statusTxt:setText("Locating... " .. formatNumber(count/MAX_COUNT*100) .. "%")
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

local lockBtn = createToggleButton("buttons/lock_off.png","buttons/lock_on.png")
snapToTopRight(lockBtn, -96*4)
local addBtn = createButton("buttons/add_off.png","buttons/add_on.png")
snapToTopRight(addBtn, -96*3)
local removeBtn = createToggleButton("buttons/remove_off.png","buttons/remove_on.png")
snapToTopRight(removeBtn, -96*2)
local saveBtn = createButton("buttons/save_off.png","buttons/save_on.png")
snapToTopRight(saveBtn, -96*1)
local measureBtn = createToggleButton("buttons/measure_off.png","buttons/measure_on.png")
snapToTopRight(measureBtn, -96*0)

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
	clear(sampleGroup)
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
			snapToTopRight(measureText,-10,110)
			
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
			snapToTopRight(measureText,-10,110)
			
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
	clear(beaconGroup)
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

local topbar = Sprite.new()

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
	snapToCenter(label, 0, -40)
	passwordDialog:addChild(label)

	local inputbox = InputBox.new(application:getContentWidth()/2,application:getContentHeight()/2, 200, 40)
	--local x,y = inputbox:getPosition()
	snapToCenter(inputbox)
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

-- create Map name
local function createMapName()
	local fontSize = 30
	local font = TTFont.new("billo.ttf",fontSize,true)
	local label = TextField.new(font, "Harvard Innovation Lab")
	label:setTextColor(0x000000)
	snapToTopLeft(label,5,62)
	local label2 = TextField.new(font, "Marauder's Map")
	label2:setTextColor(0x000000)
	snapToTopLeft(label2,5,32)
	topbar:addChild(label)
	topbar:addChild(label2)
end
createMapName()

stage:addChild(topbar)
-- create username box
local function createUsernameBox()
	local usernameDialog = Sprite.new()

	local fontSize = 20
	local font = TTFont.new("billo.ttf",fontSize,true)
	local label = TextField.new(font, "Name: ")
	label:setTextColor(0x666666)
	snapToTopRight(label,-155,22)
	usernameDialog:addChild(label)

	local inputbox = InputBox.new(application:getContentWidth()/2,application:getContentHeight()/2, 150, 30)
	--local x,y = inputbox:getPosition()
	snapToTopRight(inputbox, 0, 0)
--	inputbox:setPosition(x-200/2,y-40/2)
	inputbox:setText(application.username)
	inputbox:SetKeyBoard(application.keyboard)
	inputbox:setBoxColors(0x666666,0x666666,5,0.5)
	inputbox:setActiveBoxColors(0x666666,0x666666,5,0.5)
	usernameDialog:addChild(inputbox)
	
	topbar:addChild(usernameDialog)
	
	inputbox:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if inputbox:hitTestPoint(event.touch.x,event.touch.y) then
			local function enter()
				firebase:write("people/ilab/"..application.username, {})
				application.username = inputbox:getText()
				print(application.username)
				hereBitmap:setName(application.username)
				application.keyboard:removeEventListener('KeyboardHide', enter)
			end
			application.keyboard:addEventListener("KeyboardHide", enter)	
		end
	end)
end 
createUsernameBox()

local hereFriends = Sprite.new()
camera:addChild(hereFriends)

local function populateFriends()
	--Keep polling
	firebase:get("people/ilab", function(r) 
		hereFriends:removeFromParent()
		hereFriends = Sprite.new()
		camera:addChild(hereFriends)
		if r.error then
			print("ERROR")
			print(r.url)
		else
			print("Updating")
			if r.data ~= nil then
				local t = os.date('*t')
				local time = os.time(t)
				for k,v in pairs(r.data) do
					if v.time and math.abs(v.time - time) > 3600 then
						firebase:write("people/ilab/"..k, {})
					end
					if application.username ~= k then
						local hereFriend = Here.new("buttons/heregreen.png")
						hereFriend.name:setTextColor(0x00ee00)
						hereFriend:setName(k)
						hereFriend:setPosition(v.x,v.y)
						hereFriends:addChild(hereFriend)
					end
				end
			end
		end
	end)
end

populateFriends()

local function onPollTimer()
	populateFriends()
end

local pollTimer = Timer.new(4000, 0)
 
pollTimer:addEventListener(Event.TIMER, onPollTimer, self)
pollTimer:start()

if application:getDeviceInfo() == "Android" then

    --require your plugin
	--[[
    require("exampleplugin")
 
     local text = TextField.new(nil, exampleplugin.modifyString(" world"))
    text:setPosition(300, 300);
    stage:addChild(text)
 
    local text = TextField.new(nil, exampleplugin.addNumbers(21, 22).."")
    text:setPosition(300, 300);
    stage:addChild(text)
	]]
    --use your plugin methods
	bluetooth:enable()
	if bluetooth:isEnabled() then
		bluetoothBtn:setOn()
	end
	--[[
	bluetooth:discoverDevices()
	bluetooth:addEventListener(Event.DISCOVERY_FINISHED, function(event) 
		local text = TextField.new(nil, event.response)
		text:setPosition(150, 150);
		stage:addChild(text)	
	end)
	]]
	--Bluetooth:discoverDevices()
	--require("facebook")
	
end