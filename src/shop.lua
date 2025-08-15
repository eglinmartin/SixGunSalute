local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens")

local Shop = Class{}


function Shop:init(canvas)
    self.canvas = canvas
    self.randomized_token_ids = {}
    self.randomized_card_ids = {}

    self.tokens = {}
    self.cards = {}

    self.all_tokens = {}
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

    self:restock()
end


function Shop:restock()
    local keys = {}
    for k in pairs(self.all_tokens) do
        table.insert(keys, k)
    end
    
    for i = 1, 6 do
        local random_key = keys[math.random(#keys)]
        local random_token = self.all_tokens[random_key]
        self.tokens[i] = random_token
    end
end


function Shop:draw()
    self.canvas:add_animated_sprite(self.barrel_sprites[1], self.barrel_sprite_sheet_image, 132, 54, 72, 72, 0, 1, 250, true, false)
    self.canvas:add_animated_sprite(self.barrel_sprites[2], self.barrel_sprite_sheet_image, 132, 54, 72, 72, self.rotation, 1, 251, true, false)

    local token_grid = {{33, 42}, {53, 42}, {73, 42}, {33, 60}, {53, 60}, {73, 60}}
    for i = 1, #token_grid do
        self.canvas:add_animated_sprite(self.tokens[i].sprite, self.tokens[i].sprite_sheet_image, token_grid[i][1], token_grid[i][2], 15, 15, 0, 1, 252, true, false)
    end

end


return Shop