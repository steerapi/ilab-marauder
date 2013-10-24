TopBar = Core.class(Sprite)

function TopBar:init()
	local usernameBox = UsernameBox.new()
	self:addChild(usernameBox)
end
