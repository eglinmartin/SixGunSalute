local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens").Tokens
local Cards = require("src/tokens").Cards

local Shop = Class{}


function Shop:init(canvas, player, Tokens, Cards)
    self.canvas = canvas
    self.player = player
    self.randomized_token_ids = {}
    self.randomized_card_ids = {}

    self.modes = {TOKENS = 'Tokens', CARDS = 'Cards'}
    self.current_mode = self.modes.TOKENS
    self.tokens = {}
    self.cards = {}

    self.selection = 0
    self.selection_scale = 1

    -- Create hud sprites
    self.shop_sign_sprite = anim8.newAnimation(self.canvas.sprite_sheets.titles[2](1, 1), 1)
    -- self.arrows_sprites = {}
    -- for i = 1, 4 do self.arrows_sprites[i] = anim8.newAnimation(arrows_sign_sprite_sheet(i, 1), 1) end

    -- Create empty card sprite
    self.empty_card_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards[2](1, 5), 1)
    self.card_selection_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards[2](2, 5), 1)

    -- Create large card sprites
    self.large_card_sprites = {}
    for i=1, 52 do
        local columnsPerRow = 13
        local x = ((i - 1) % columnsPerRow) + 1
        local y = math.floor((i - 1) / columnsPerRow) + 1
        self.large_card_sprites[i] = anim8.newAnimation(self.canvas.sprite_sheets.cards_large[2](x, y), 1)
    end

    -- Create large card back sprite
    self.card_back_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards_large[2](1, 5), 1)

    -- Create list of all tokens
    self.all_tokens = {}
    self.token_grid = {{33, 43}, {53, 43}, {73, 43}, {33, 61}, {53, 61}, {73, 61}}
    for _, token in pairs(Tokens) do
        table.insert(self.all_tokens, token)
    end

    -- Create list of all cards
    self.all_cards = {}
    self.card_grid = {{32, 53}, {46, 53}, {60, 53}, {74, 53}}
    for _, card in pairs(Cards) do
        table.insert(self.all_cards, card)
    end

    self:restock()
    self.stock_animations = {0, 0, 0, 0, 0, 0}
    self:animate_stock()
end


function Shop:select(direction)
    if not self.selection then
        self.selection = 1
    end

    local max_selection = 0
    if self.current_mode == self.modes.TOKENS then max_selection = 6 end
    if self.current_mode == self.modes.CARDS then max_selection = 4 end

    if direction == 'right' and self.selection < max_selection then
        self.selection = self.selection + 1
        self.selection_scale = 1.25
    elseif direction == 'left' and self.selection > 1 then
        self.selection = self.selection - 1
        self.selection_scale = 1.25
    end
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


function Shop:animate_stock()
    self.stock_clock = 0
    self.stock_time_interval = 2
    if self.current_mode == self.modes.CARDS then self.stock_time_interval = 3 end
    self.stock_animations = {-1, -1, -1, -1, -1, -1}
end


function Shop:update(time, mouse_x, mouse_y)
    self.shop_sign_rotation = math.sin(time * 0.8) * 0.03
    self.shop_sign_scale = math.sin(time * 1.5) * 0.025 + 1.025

    if self.selection_scale > 1 then
        self.selection_scale = self.selection_scale - 0.05
    end

    self.stock_clock = self.stock_clock + 1

    for i = 1, #self.stock_animations do
        if self.stock_animations[i] == -1 then
            if self.stock_clock > self.stock_time_interval * (i-1) then
                self.stock_animations[i] = 3
            end
        end
        if self.stock_animations[i] > 0 then
            self.stock_animations[i] = self.stock_animations[i] - 1
        end
    end
end


function Shop:draw()

    -- Draw shop hud (sign, text, buttons)
    self.canvas:add_animated_sprite(self.shop_sign_sprite, self.canvas.sprite_sheets.titles[1], 54, 23, 38, 12, self.shop_sign_rotation, self.shop_sign_scale, 255, true, false)
    -- self.canvas:add_animated_sprite(self.arrows_sprites[1], self.arrows_sprite_sheet_image, 30, 79, 7, 7, 0, 1, 255, true, false)
    -- self.canvas:add_animated_sprite(self.arrows_sprites[3], self.arrows_sprite_sheet_image, 74, 79, 7, 7, 0, 1, 255, true, false)

    if self.current_mode == self.modes.TOKENS then
        self.text_tokens = self.canvas:draw_letters_to_numbers('tokens', 41.5, 80, 'white')
    elseif self.current_mode == self.modes.CARDS then
        self.text_tokens = self.canvas:draw_letters_to_numbers('cards', 43.5, 80, 'white')
    end

    -- Add player info
    self.canvas:add_animated_sprite(self.player.animation_icons[1], self.canvas.sprite_sheets.icons[1], 36, 92, 7, 7, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.player.health, 42.5, 92, 'red')
    self.canvas:add_animated_sprite(self.player.animation_icons[2], self.canvas.sprite_sheets.icons[1], 56, 92, 7, 7, 0, 1, 1, true, false)
    -- self.canvas:add_animated_sprite(self.canvas.digit_sprite, self.canvas.text_yellow_sprite_sheet_image, 64, 92, 7, 9, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.player.money, 66.5, 91, 'yellow')

    if self.current_mode == self.modes.TOKENS then
        self.canvas:add_animated_sprite(self.player.gun.barrel_sprites[1], self.canvas.sprite_sheets.barrel[1], 132, 54, 72, 72, 0, 1, 250, true, false)
        self.canvas:add_animated_sprite(self.player.gun.barrel_sprites[2], self.canvas.sprite_sheets.barrel[1], 132, 54, 72, 72, 0, 1, 251, true, false)

        -- Draw player's current gun barrel
        local barrel_coordinates = {{133.5, 30.5}, {152.5, 41.5}, {152.5, 63.5}, {132.5, 75.5}, {113.5, 63.5}, {113.5, 41.5}}
        for i = 1, #self.player.gun.ammo do
            if self.player.gun.ammo[i] ~= 'empty' then
                self.canvas:add_animated_sprite(self.player.gun.ammo[i].sprite, self.canvas.sprite_sheets.tokens[1], barrel_coordinates[i][1], barrel_coordinates[i][2], 15, 15, self.shop_sign_rotation, self.shop_sign_scale, 252, true, false)
            end
        end

        for i = 1, #self.tokens do
            if self.stock_clock > self.stock_time_interval * (i-1) then
                self.canvas:add_animated_sprite(self.tokens[i].sprite, self.canvas.sprite_sheets.tokens[1], self.token_grid[i][1], self.token_grid[i][2] + self.stock_animations[i], 15, 15, 0, self.tokens[i].scale, 252, true, false)
            end
        end
    end

    if self.current_mode == self.modes.CARDS then
        for i = 1, #self.cards do
            if self.stock_clock > self.stock_time_interval * (i-1) then
                self.canvas:add_animated_sprite(self.cards[i].sprite, self.canvas.sprite_sheets.cards[1], self.card_grid[i][1], self.card_grid[i][2] + self.stock_animations[i], 11, 15, 0, self.cards[i].scale, 252, true, false)
            end
        end

        if self.selection == 0 then
            self.canvas:add_animated_sprite(self.card_back_sprite, self.canvas.sprite_sheets.cards_large[1], 134.5, 30 + (self.selection_scale * 10), 33, 47, self.shop_sign_rotation, self.shop_sign_scale, 252, true, false)
        elseif self.selection > 0 and self.selection <= 4 then
            self.canvas:add_animated_sprite(self.large_card_sprites[self.cards[self.selection].id], self.canvas.sprite_sheets.cards_large[1], 134.5, 30 + (self.selection_scale * 10), 33, 47, self.shop_sign_rotation, self.shop_sign_scale, 252, true, false)
        end
        

        local poker_hand_grid = {{113.5, 84}, {127.5, 84}, {141.5, 84}, {155.5, 84}}
        for i = 1, 4 do
            self.canvas:add_animated_sprite(self.empty_card_sprite, self.canvas.sprite_sheets.cards[1], poker_hand_grid[i][1], poker_hand_grid[i][2], 11, 15, 0, 1, 252, true, false)
        end

        if self.selection > 0 and self.selection <= 4 then
            self.canvas:add_animated_sprite(self.card_selection_sprite, self.canvas.sprite_sheets.cards[1], self.card_grid[self.selection][1], self.card_grid[self.selection][2], 11, 15, 0, self.selection_scale, 253, true, false)
        end
    end

end


return Shop