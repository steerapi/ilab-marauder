People = Core.class(Sprite)

local function populateFriends(people)
	--Keep polling
	firebase:get("people/ilab", function(r) 
		Utils.clearSprite(self)
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
						people:addChild(hereFriend)
					end
				end
			end
		end
	end)
end



function People:init(interval)
	self.interval = interval
	-- Refresh the map for new user every 4 secs
	local function onPollTimer()
		populateFriends(self)
	end
	local pollTimer = Timer.new(interval, 0)
	pollTimer:addEventListener(Event.TIMER, onPollTimer, self)
	pollTimer:start()
end
