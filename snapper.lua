local dx = application:getLogicalTranslateX() / application:getLogicalScaleX()
local dy = application:getLogicalTranslateY() / application:getLogicalScaleY()

function snapToTopLeft(obj, offsetX, offsetY)
offsetX = offsetX or 0;
offsetY = offsetY or 0;
local topleftX = -dx + offsetX;
local topleftY = -dy + offsetY;
obj:setPosition(topleftX,topleftY);
end

function snapToTopRight(obj, offsetX, offsetY)
offsetX = offsetX or 0;
offsetY = offsetY or 0;
local toprightX = dx+application:getContentWidth()-obj:getWidth() + offsetX;
local toprightY = -dy + offsetY;
obj:setPosition(toprightX,toprightY);
end

function snapToBottomLeft(obj, offsetX, offsetY)
offsetX = offsetX or 0;
offsetY = offsetY or 0;
local bottomleftX = -dx + offsetX;
local bottomleftY = dy + application:getContentHeight()-obj:getHeight() + offsetY;
obj:setPosition(bottomleftX,bottomleftY);
end

function snapToBottomRight(obj, offsetX, offsetY)
offsetX = offsetX or 0;
offsetY = offsetY or 0;
local bottomrightX = dx+application:getContentWidth()-obj:getWidth() + offsetX;
local bottomrightY = dy + application:getContentHeight()-obj:getHeight() + offsetY;
obj:setPosition(bottomrightX,bottomrightY);
end

function snapToCenter(obj, offsetX, offsetY)
offsetX = offsetX or 0;
offsetY = offsetY or 0;
local centerX = dx + application:getContentWidth()/2-obj:getWidth()/2 + offsetX;
local centerY = dy + application:getContentHeight()/2-obj:getHeight()/2 + offsetY;
obj:setPosition(centerX,centerY);
end
