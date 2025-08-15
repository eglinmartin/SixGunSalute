local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens")

local Shop = Class{}


function Shop:init(canvas, player)
    self.canvas = canvas
    self.player = player
    self.randomized_token_ids = {}
    self.randomized_card_ids = {}

    self.tokens = {}
    self.cards = {}

    self.all_tokens = {}
    self.token_grid = {{33, 42}, {53, 42}, {73, 42}, {33, 60}, {53, 60}, {73, 60}}
    for _, token in pairs(Tokens) do
        table.insert(self.all_tokens, token)
    end

    -- Create barrel sprites
    self.barrel_sprite_sheet_image = love.graphics.newImage('assets/sprites/barrel.png')
    local barrel_sprite_sheet = anim8.newGrid(72, 72, self.barrel_sprite_sheet_image:getWidth(), self.barrel_sprite_sheet_image:getHeight(), 0, 0, 0)
    self.barrel_sprites = {}
    for i = 1, 2 do
        self.barrel_sprites[i] = anim8.newAnimation(barrel_sprite_sheet(i, 1), 1)
    end

    -- Create hud sprites
    self.shop_sign_sprite_sheet_image = love.graphics.newImage('assets/sprites/title_shop.png')
    local shop_sign_sprite_sheet = anim8.newGrid(38, 12, self.shop_sign_sprite_sheet_image:getWidth(), self.shop_sign_sprite_sheet_image:getHeight(), 0, 0, 0)
    self.shop_sign_sprite = anim8.newAnimation(shop_sign_sprite_sheet(1, 1), 1)

    self:restock()
end


function Shop:restock()
    local keys = {}
    for k in pairs(self.all_tokens) do
        table.insert(keys, k)
    end

    -- Shuffle keys (Fisher-Yates)
    for i = #keys, 2, -1 do
        local j = math.random(i)
        keys[i], keys[j] = keys[j], keys[i]
    end

    -- Pick first 6 unique tokens
    for i = 1, 6 do
        local key = keys[i]
        self.tokens[i] = self.all_tokens[key]
    end
end


function Shop:update(time, mouse_x, mouse_y)
    self.shop_sign_rotation = math.sin(time * 0.8) * 0.03
    self.shop_sign_scale = math.sin(time * 1.5) * 0.025 + 1.025

    for i = 1, #self.tokens do
        local xy = {self.token_grid[i][1] * ScreenScale, self.token_grid[i][2] * ScreenScale}
        local tolerance = 8 * ScreenScale
        if mouse_x >= xy[1] - tolerance and mouse_x <= xy[1] + tolerance and mouse_y >= xy[2] - tolerance and mouse_y <= xy[2] + tolerance then
            self.tokens[i].scale = 1.1
        else
            self.tokens[i].scale = 1
        end
    end
end


function Shop:draw()
    self.canvas:add_animated_sprite(self.barrel_sprites[1], self.barrel_sprite_sheet_image, 132, 54, 72, 72, 0, 1, 250, true, false)
    self.canvas:add_animated_sprite(self.barrel_sprites[2], self.barrel_sprite_sheet_image, 132, 54, 72, 72, self.rotation, 1, 251, true, false)

    -- Draw shop hud (sign, text, buttons)
    self.canvas:add_animated_sprite(self.shop_sign_sprite, self.shop_sign_sprite_sheet_image, 54, 23, 38, 12, self.shop_sign_rotation, self.shop_sign_scale, 255, true, false)

    -- Draw player's current gun barrel
    local barrel_coordinates = {{132.5, 31.5}, {151.5, 42.5}, {151.5, 64.5}, {131.5, 76.5}, {112.5, 64.5}, {112.5, 42.5}}
    for i = 1, #self.player.gun.ammo do
        if self.player.gun.ammo[i] ~= 'empty' then
            self.canvas:add_animated_sprite(self.player.gun.ammo[i].sprite, self.player.gun.ammo[i].sprite_sheet_image, barrel_coordinates[i][1], barrel_coordinates[i][2], 15, 15, 0, 1, 252, true, false)
        end
    end
    
    for i = 1, #self.tokens do
        self.canvas:add_animated_sprite(self.tokens[i].sprite, self.tokens[i].sprite_sheet_image, self.token_grid[i][1], self.token_grid[i][2], 15, 15, 0, self.tokens[i].scale, 252, true, false)
    end

end


return Shop