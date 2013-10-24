Utils = Core.class()

function Utils.createButton(off,on)
	local btnOff = Bitmap.new(Texture.new(off))
	local btnOn = Bitmap.new(Texture.new(on))
	local btn = Button.new(btnOff, btnOn)
	return btn
end

function Utils.createToggleButton(off,on)
	local btnOff = Bitmap.new(Texture.new(off))
	local btnOn = Bitmap.new(Texture.new(on))
	local btn = ToggleButton.new(btnOff, btnOn)
	return btn
end

function Utils.formatNumber(num)
	return string.format("%d",num)
end

function Utils.clearSprite(sprite)
	if sprite == nil then
		return
	end
    while sprite:getNumChildren() > 0 do
        sprite:removeChildAt(1)
    end
end