local Class = require("src/hump/class")
local Constants = require("src/constants")

local Canvas = Class{}
local Sprite = Class{}


function Canvas:init()
    self.sprites_foreground = {}
    self.sprites_shadow = {}
    self.sprites_background = {}
end


function Sprite:init(sprite_img, x, y, depth, shadow, background)
    self.sprite = love.graphics.newImage(sprite_img)
    self.sprite:setFilter("nearest", "nearest")
    self.x = x
    self.y = y
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.depth = depth
    self.shadow = shadow
    self.background = background
end


function Canvas:add_sprite(sprite_img, x, y, depth, shadow, background)
    local sprite = Sprite(sprite_img, x, y, depth, shadow, background)

    table.insert(self.sprites_foreground, sprite)

    if sprite.shadow then
        table.insert(self.sprites_shadow, sprite)
    end

    if sprite.background then
        table.insert(self.sprites_background, sprite)
    end

end


function Canvas:draw()
    -- Draw the player sprite at its x, y position
    table.sort(self.sprites_foreground, function(a, b)
        return a.depth < b.depth
    end)

    love.graphics.setColor(81/255, 108/255, 94/255, 1)
    love.graphics.rectangle("fill", 16 * ScreenScale, 9 * ScreenScale, 160 * ScreenScale, 90 * ScreenScale)

    love.graphics.setColor(0, 0, 0, 0.25)
    for _, sprite in ipairs(self.sprites_shadow) do
        love.graphics.draw(sprite.sprite, ((sprite.x + 1) - (sprite.width/2)) * ScreenScale, ((sprite.y + 1) - (sprite.height/2)) * ScreenScale, 0, ScreenScale, ScreenScale)
    end
    self.sprites_shadow = {}

    love.graphics.setColor(1, 1, 1, 1)
    for _, sprite in ipairs(self.sprites_foreground) do
        love.graphics.draw(sprite.sprite, (sprite.x - (sprite.width/2)) * ScreenScale, (sprite.y - (sprite.height/2)) * ScreenScale, 0, ScreenScale, ScreenScale)
    end
    self.sprites_foreground = {}


end


return Canvas