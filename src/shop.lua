local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens").Tokens
local Cards = require("src/tokens").Cards

local Shop = Class{}


function Shop:init(canvas, player)
    self.canvas = canvas
    self.player = player
    self.randomized_token_ids = {}
    self.randomized_card_ids = {}

    self.modes = {TOKENS = 'Tokens', CARDS = 'Cards'}
    self.current_mode = self.modes.TOKENS
    self.tokens = {}
    self.cards = {}

    -- Create hud sprites
    self.shop_sign_sprite_sheet_image = love.graphics.newImage('assets/sprites/title_shop.png')
    local shop_sign_sprite_sheet = anim8.newGrid(38, 12, self.shop_sign_sprite_sheet_image:getWidth(), self.shop_sign_sprite_sheet_image:getHeight(), 0, 0, 0)
    self.shop_sign_sprite = anim8.newAnimation(shop_sign_sprite_sheet(1, 1), 1)

    -- Create hud sprites
    self.arrows_sprite_sheet_image = love.graphics.newImage('assets/sprites/arrows.png')
    local arrows_sign_sprite_sheet = anim8.newGrid(8, 8, self.arrows_sprite_sheet_image:getWidth(), self.arrows_sprite_sheet_image:getHeight(), 0, 0, 0)
    self.arrows_sprites = {}
    for i = 1, 4 do
        self.arrows_sprites[i] = anim8.newAnimation(arrows_sign_sprite_sheet(i, 1), 1)
    end

    -- Create empty card sprite
    self.card_sprite_sheet_image = love.graphics.newImage('assets/sprites/cards.png')
    local sprite_sheet = anim8.newGrid(11, 15, self.card_sprite_sheet_image:getWidth(), self.card_sprite_sheet_image:getHeight(), 0, 0, 1)
    self.empty_card_sprite = anim8.newAnimation(sprite_sheet(1, 5), 1)

    -- Create list of all tokens
    self.all_tokens = {}
    self.token_grid = {{33, 42}, {53, 42}, {73, 42}, {33, 60}, {53, 60}, {73, 60}}
    for _, token in pairs(Tokens) do
        table.insert(self.all_tokens, token)
    end

    -- Create list of all cards
    self.all_cards = {}
    self.card_grid = {{34, 53}, {48, 53}, {62, 53}, {76, 53}}
    for _, card in pairs(Cards) do
        table.insert(self.all_cards, card)
    end

    self:restock()
end


function Shop:restock()
    -- Restock tokens
    local token_keys = {}
    for k in pairs(self.all_tokens) do table.insert(token_keys, k) end
    for i = #token_keys, 2, -1 do
        local j = math.random(i)
        token_keys[i], token_keys[j] = token_keys[j], token_keys[i]
    end
    for i = 1, 6 do
        local key = token_keys[i]
        self.tokens[i] = self.all_tokens[key]
    end

    -- Restock cards
    local card_keys = {}
    for k in pairs(self.all_cards) do table.insert(card_keys, k) end
    for i = #card_keys, 2, -1 do
        local j = math.random(i)
        card_keys[i], card_keys[j] = card_keys[j], card_keys[i]
    end
    for i = 1, 4 do
        local key = card_keys[i]
        self.cards[i] = self.all_cards[key]
    end

end


function Shop:update(time, mouse_x, mouse_y)
    self.shop_sign_rotation = math.sin(time * 0.8) * 0.03
    self.shop_sign_scale = math.sin(time * 1.5) * 0.025 + 1.025
end


function Shop:draw()
    -- Draw shop hud (sign, text, buttons)
    self.canvas:add_animated_sprite(self.shop_sign_sprite, self.shop_sign_sprite_sheet_image, 54, 23, 38, 12, self.shop_sign_rotation, self.shop_sign_scale, 255, true, false)
    self.canvas:add_animated_sprite(self.arrows_sprites[1], self.arrows_sprite_sheet_image, 30, 79, 7, 7, 0, 1, 255, true, false)
    self.canvas:add_animated_sprite(self.arrows_sprites[3], self.arrows_sprite_sheet_image, 74, 79, 7, 7, 0, 1, 255, true, false)

    if self.current_mode == self.modes.TOKENS then
        self.text_tokens = self.canvas:draw_letters_to_numbers('tokens', 41.5, 80, 'white')
    elseif self.current_mode == self.modes.CARDS then
        self.text_tokens = self.canvas:draw_letters_to_numbers('cards', 43.5, 80, 'white')
    end

    -- Add player info
    self.canvas:add_animated_sprite(self.player.animation_icons[1], self.player.icons_sprite_sheet_image, 32, 92, 7, 7, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.player.health, 38.5, 92, 'red')
    self.canvas:add_animated_sprite(self.player.animation_icons[2], self.player.icons_sprite_sheet_image, 56, 92, 7, 7, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.player.money, 66.5, 92, 'yellow')

    if self.current_mode == self.modes.TOKENS then
        self.canvas:add_animated_sprite(self.player.gun.barrel_sprites[1], self.player.gun.barrel_sprite_sheet_image, 132, 54, 72, 72, 0, 1, 250, true, false)
        self.canvas:add_animated_sprite(self.player.gun.barrel_sprites[2], self.player.gun.barrel_sprite_sheet_image, 132, 54, 72, 72, self.rotation, 1, 251, true, false)

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

    if self.current_mode == self.modes.CARDS then
        for i = 1, #self.cards do
            self.canvas:add_animated_sprite(self.cards[i].sprite, self.cards[i].sprite_sheet_image, self.card_grid[i][1], self.card_grid[i][2], 15, 15, 0, self.cards[i].scale, 252, true, false)
        end

        local poker_hand_grid = {{106.5, 84}, {120.5, 84}, {134.5, 84}, {148.5, 84}, {162.5, 84},}
        for i = 1, 5 do
            self.canvas:add_animated_sprite(self.empty_card_sprite, self.card_sprite_sheet_image, poker_hand_grid[i][1], poker_hand_grid[i][2], 15, 15, 0, 1, 252, true, false)
        end
    end

end


return Shop