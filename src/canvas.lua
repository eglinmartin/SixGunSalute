local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")

local Canvas = Class{}
local AnimatedSprite = Class{}


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


function Canvas:init()
    self.sprites_foreground = {}
    self.sprites_shadow = {}
    self.sprites_background = {}

    self.sprite_sheets = {}
    self:load_sprites()

    self:parse_sprite_sheet(self.sprite_sheets.barrel, 70, 70)
    self:parse_sprite_sheet(self.sprite_sheets.cards, 11, 15)
    self:parse_sprite_sheet(self.sprite_sheets.cards_large, 33, 47)
    self:parse_sprite_sheet(self.sprite_sheets.chambers, 6, 6)
    self:parse_sprite_sheet(self.sprite_sheets.cursors, 8, 12)
    self:parse_sprite_sheet(self.sprite_sheets.enemy, 28, 28)
    self:parse_sprite_sheet(self.sprite_sheets.icons, 7, 7)
    self:parse_sprite_sheet(self.sprite_sheets.player, 28, 28)
    self:parse_sprite_sheet(self.sprite_sheets.player_head, 16, 13)
    self:parse_sprite_sheet(self.sprite_sheets.text_green, 7, 9)
    self:parse_sprite_sheet(self.sprite_sheets.text_red, 7, 7)
    self:parse_sprite_sheet(self.sprite_sheets.text_white, 7, 7)
    self:parse_sprite_sheet(self.sprite_sheets.text_yellow, 7, 9)
    self:parse_sprite_sheet(self.sprite_sheets.titles, 37, 11)
    self:parse_sprite_sheet(self.sprite_sheets.tokens, 15, 15)
end


function Canvas:load_sprites()
    local files = {}
    local path = 'assets/sprites'
    local items = love.filesystem.getDirectoryItems(path)

    for _, item in ipairs(items) do
        local fullPath = path .. "/" .. item
        if love.filesystem.getInfo(fullPath, "directory") then
            -- Recurse into subdirectory
            local subFiles = getAllPNGs_LoveFS(fullPath)
            for _, f in ipairs(subFiles) do
                table.insert(files, f)
            end
        elseif item:match("%.png$") then
            local key = item:match("^(.*)%.png$")
            self.sprite_sheets[key] = {love.graphics.newImage(fullPath)}
        end
    end
end


function Canvas:parse_sprite_sheet(sprite, frame_width, frame_height)
    table.insert(sprite, anim8.newGrid(frame_width, frame_height, sprite[1]:getWidth(), sprite[1]:getHeight(), 0, 0, 1))
end


function Canvas:draw_letters_to_numbers(input, x, y, colour, scale)
    scale = scale or 1
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
            sprite_sheet = self.sprite_sheets.text_white[2]
            sprite_sheet_image = self.sprite_sheets.text_white[1]
        elseif colour == 'green' then
            sprite_sheet = self.sprite_sheets.text_green[2]
            sprite_sheet_image = self.sprite_sheets.text_green[1]
        elseif colour == 'yellow' then
            sprite_sheet = self.sprite_sheets.text_yellow[2]
            sprite_sheet_image = self.sprite_sheets.text_yellow[1]
        elseif colour == 'red' then
            sprite_sheet = self.sprite_sheets.text_red[2]
            sprite_sheet_image = self.sprite_sheets.text_red[1]
        end

        local digit_sprite = anim8.newAnimation(sprite_sheet(digit_x, digit_y), 1)
        local digit_width = 4
        self:add_animated_sprite(digit_sprite, sprite_sheet_image, screen_x + (scale * 5) - 5, y, digit_width, 7, 0, 1, 200, 1, 0)

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