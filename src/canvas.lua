local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens")

local Canvas = Class{}
local AnimatedSprite = Class{}


function Canvas:init()
    self.sprites_foreground = {}
    self.sprites_shadow = {}
    self.sprites_background = {}

    self.text_white_sprite_sheet_image = love.graphics.newImage('assets/sprites/text_white.png')
    self.text_white_sprite_sheet = anim8.newGrid(7, 7, self.text_white_sprite_sheet_image:getWidth(), self.text_white_sprite_sheet_image:getHeight(), 0, 0, 1)

    self.text_yellow_sprite_sheet_image = love.graphics.newImage('assets/sprites/text_yellow.png')
    self.text_yellow_sprite_sheet = anim8.newGrid(7, 9, self.text_yellow_sprite_sheet_image:getWidth(), self.text_yellow_sprite_sheet_image:getHeight(), 0, 0, 1)
    self.digit_sprite = anim8.newAnimation(self.text_yellow_sprite_sheet(1, 5), 1)

    self.text_red_sprite_sheet_image = love.graphics.newImage('assets/sprites/text_red.png')
    self.text_red_sprite_sheet = anim8.newGrid(7, 7, self.text_red_sprite_sheet_image:getWidth(), self.text_red_sprite_sheet_image:getHeight(), 0, 0, 1)
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


function Canvas:draw_letters_to_numbers(input, x, y, colour)
    local result = {}
    input = tostring(input):upper()
    local screen_x = x + 0
    local number = 0

    for i = 1, #input do
        local char = input:sub(i, i)

        if char:match("%a") then
            number = string.byte(char) - string.byte("A") + 1

        elseif char:match("%d") then
            number = tonumber(char) + 30
            if char == '0' then number = 40 end
        end

        local digit_x = ((number - 1) % 10) + 1
        local digit_y = math.floor((number - 1) / 10) + 1

        local sprite_sheet
        local sprite_sheet_image
        if colour == 'white' then
            sprite_sheet = self.text_white_sprite_sheet
            sprite_sheet_image = self.text_white_sprite_sheet_image
        elseif colour == 'yellow' then
            sprite_sheet = self.text_yellow_sprite_sheet
            sprite_sheet_image = self.text_yellow_sprite_sheet_image
        elseif colour == 'red' then
            sprite_sheet = self.text_red_sprite_sheet
            sprite_sheet_image = self.text_red_sprite_sheet_image
        end

        local digit_sprite = anim8.newAnimation(sprite_sheet(digit_x, digit_y), 1)
        local digit_width = 4
        self:add_animated_sprite(digit_sprite, sprite_sheet_image, screen_x, y, digit_width, 7, 0, 1, 200, 1, 0)

        if char == 'N' or char == 'Q' then digit_width = 5 end
        if char == 'M' then digit_width = 6 end
        screen_x = screen_x + digit_width

    end
    
    return result
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