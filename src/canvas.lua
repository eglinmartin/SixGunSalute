local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens")

local Canvas = Class{}
local AnimatedSprite = Class{}


function Canvas:init()
    self.sprites_foreground = {}
    self.sprites_shadow = {}
    self.sprites_background = {}
end


function AnimatedSprite:init(animation, sprite_sheet_image, x, y, w, h, rotation, scale, depth, shadow, background)
    self.animation = animation
    self.sprite_sheet_image = sprite_sheet_image
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.rotation = rotation
    self.scale = scale
    self.depth = depth
    self.shadow = shadow
    self.background = background
end


function Canvas:add_animated_sprite(animation, sprite_sheet_image, x, y, w, h, rotation, scale, depth, shadow, background)
    local sprite = AnimatedSprite(animation, sprite_sheet_image, x, y, w, h, rotation, scale, depth, shadow, background)

    table.insert(self.sprites_foreground, sprite)

    if sprite.shadow then
        table.insert(self.sprites_shadow, sprite)
    end

    if sprite.background then
        table.insert(self.sprites_background, sprite)
    end

end


function Canvas:draw()
    love.graphics.clear(75/255, 90/255, 87/255)
    
    -- Draw the player sprite at its x, y position
    table.sort(self.sprites_foreground, function(a, b)
        return a.depth < b.depth
    end)

    love.graphics.setColor(81/255, 108/255, 94/255, 1)
    love.graphics.rectangle("fill", 10, 10, 172, 88)

    love.graphics.setColor(0, 0, 0, 0.25)
    for _, sprite in ipairs(self.sprites_shadow) do
        sprite.sprite_sheet_image:setFilter("nearest", "nearest")
        sprite.animation:draw(sprite.sprite_sheet_image, sprite.x + 1, sprite.y + 1, sprite.rotation, sprite.scale, sprite.scale, sprite.width/2, sprite.height/2)
    end
    self.sprites_shadow = {}

    love.graphics.setColor(1, 1, 1, 1)
    for _, sprite in ipairs(self.sprites_foreground) do
        sprite.sprite_sheet_image:setFilter("nearest", "nearest")
        sprite.animation:draw(sprite.sprite_sheet_image, sprite.x, sprite.y, sprite.rotation, sprite.scale, sprite.scale, sprite.width/2, sprite.height/2)
    end
    self.sprites_foreground = {}

    love.graphics.setColor(0/255, 0/255, 0/255, 1)
    love.graphics.rectangle("fill", 0, 108, 192, 108)

end


return Canvas