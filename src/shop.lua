local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Tokens = require("src/tokens").Tokens
local Cards = require("src/tokens").Cards

local Shop = Class{}
local StockItem = Class{}
local PlayerItem = Class{}


function StockItem:init(stock_id, item, x, y, width, height, picked_up)
    self.stock_id = stock_id
    self.item = item

    self.base_x = x
    self.base_y = y
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.picked_up = picked_up
    self.scale = 1
    self.rotation = 1
    self.visible = true
end


function StockItem:update()
    if self:IsMouseOver() then
        self:grow()
    else
        self:shrink()
    end

    local mx, my = love.mouse.getPosition()
    if self.picked_up then
        self.x = mx / ScreenScale
        self.y = my / ScreenScale
        if not love.mouse.isDown(1) then
            self.picked_up = false
        end
    else
        self:return_to_xy()
    end
end


function StockItem:return_to_xy()
    if self.x < (self.base_x - 0.1) then
        self.x = self.x + ((self.base_x - self.x) / 4)
    elseif self.x > (self.base_x + 0.1) then
        self.x = self.x - ((self.x - self.base_x) / 4)
    else
        self.x = self.base_x
    end

    if self.y < (self.base_y - 0.1) then
        self.y = self.y + ((self.base_y - self.y) / 4)
    elseif self.y > (self.base_y + 0.1) then
        self.y = self.y - ((self.y - self.base_y) / 4)
    else
        self.y = self.base_y
    end
end


function StockItem:grow()
    if self.scale < 1.1 then
        self.scale = self.scale + 0.05
    end
end


function StockItem:shrink()
    if self.scale > 1 then
        self.scale = self.scale - 0.02
    end
end


function StockItem:IsMouseOver()
    local mx, my = love.mouse.getPosition()
    local x_tol = (self.width * ScreenScale) / 2
    local y_tol = (self.height * ScreenScale) / 2

    return mx >= (self.base_x * ScreenScale) - x_tol and mx <= (self.base_x * ScreenScale) + x_tol and
           my >= (self.base_y * ScreenScale) - y_tol and my <= (self.base_y * ScreenScale) + y_tol
end


function Shop:init(canvas, player, Tokens, Cards)
    self.canvas = canvas
    self.player = player
    self.randomized_token_ids = {}
    self.randomized_card_ids = {}

    self.modes = {TOKENS = 'Tokens', CARDS = 'Cards'}
    self.current_mode = self.modes.TOKENS
    self.tokens = {}
    self.cards = {}
    self.stock = {}

    self.selection = 0
    self.selection_scale = 1

    -- Create hud sprites
    self.arrows_sprites = {}
    for i = 1, 4 do self.arrows_sprites[i] = anim8.newAnimation(self.canvas.sprite_sheets.icons[2](i, 2), 1) end
    self.shop_sign_sprite = anim8.newAnimation(self.canvas.sprite_sheets.titles[2](1, 1), 1)
    self.empty_card_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards[2](1, 5), 1)
    self.card_selection_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards[2](2, 5), 1)
    self.card_back_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards_large[2](1, 5), 1)

    -- Create large card sprites
    self.large_card_sprites = {}
    for i=1, 52 do
        local columnsPerRow = 13
        local x = ((i - 1) % columnsPerRow) + 1
        local y = math.floor((i - 1) / columnsPerRow) + 1
        self.large_card_sprites[i] = anim8.newAnimation(self.canvas.sprite_sheets.cards_large[2](x, y), 1)
    end

    -- Create list of all tokens
    self.all_tokens = {}
    for _, token in pairs(Tokens) do
        table.insert(self.all_tokens, token)
    end

    -- Create list of all cards
    self.all_cards = {}
    for _, card in pairs(Cards) do
        table.insert(self.all_cards, card)
    end

    self:restock()
    self.stock_animations = {0, 0, 0, 0, 0, 0}
    self:animate_stock()
end


function Shop:restock()
    -- Shuffle tokens
    local token_keys = {}
    for k in pairs(self.all_tokens) do table.insert(token_keys, k) end
    for i = #token_keys, 2, -1 do
        local j = math.random(i)
        token_keys[i], token_keys[j] = token_keys[j], token_keys[i]
    end

    -- Shuffle cards
    local card_keys = {}
    for k in pairs(self.all_cards) do table.insert(card_keys, k) end
    for i = #card_keys, 2, -1 do
        local j = math.random(i)
        card_keys[i], card_keys[j] = card_keys[j], card_keys[i]
    end


    local stock_grid = {{33, 43}, {53, 43}, {73, 43}, {33, 61}, {53, 61}, {73, 61}, {32, 53}, {46, 53}, {60, 53}, {74, 53}}
    -- Restock tokens
    for i = 1, 6 do
        local key = token_keys[i]
        self.stock[i] = StockItem(i, self.all_tokens[key], stock_grid[i][1], stock_grid[i][2], 15, 15, false)
    end
    -- Restock cards
    for i = 7, 10 do
        local key = card_keys[i]
        self.stock[i] = StockItem(i, self.all_cards[key], stock_grid[i][1], stock_grid[i][2], 11, 15, false)
    end
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


function Shop:animate_stock()
    self.stock_clock = 0
    self.stock_time_interval = 3

    for _, obj in ipairs(self.stock) do
        obj.visible = false
    end

    
end


function Shop:update(time, mouse_x, mouse_y)
    self.shop_sign_rotation = math.sin(time * 0.8) * 0.03
    self.shop_sign_scale = math.sin(time * 1.5) * 0.025 + 1.025

    self.stock_clock = self.stock_clock + 1

    if self.current_mode == self.modes.TOKENS then
        for i=1, 6 do
            if self.stock_clock > self.stock_time_interval * (i-1) then
                if not self.stock[i].visible then
                    self.stock[i].y = self.stock[i].y + 2
                end
                self.stock[i].visible = true
            end
            self.stock[i]:update()
        end

    elseif self.current_mode == self.modes.CARDS then
        for i=7, 10 do
            if self.stock_clock > self.stock_time_interval * (i-7) then
                if not self.stock[i].visible then
                    self.stock[i].y = self.stock[i].y + 2
                end
                self.stock[i].visible = true
            end
            self.stock[i]:update()
        end 
    end

    -- Drag if mouse pressed
    local currently_dragging = false
        for _, stock_item in ipairs(self.stock) do
            if stock_item.picked_up then
                currently_dragging = true
            end
        end

    if self.current_mode == self.modes.TOKENS then
        for i=1, 6 do
            if self.stock[i]:IsMouseOver() and not currently_dragging then
                if love.mouse.isDown(1) then
                    self.stock[i].picked_up = true
                else
                    self.stock[i].picked_up = false
                end
            end
        end

    elseif self.current_mode == self.modes.CARDS then
        for i=7, 10 do
            if self.stock[i]:IsMouseOver() and not currently_dragging then
                if love.mouse.isDown(1) then
                    self.stock[i].picked_up = true
                else
                    self.stock[i].picked_up = false
                end
            end
        end
    end

end


function Shop:draw()
    -- Draw shop hud (sign, text, buttons)
    self.canvas:add_animated_sprite(self.shop_sign_sprite, self.canvas.sprite_sheets.titles[1], 54, 23, 38, 12, self.shop_sign_rotation, self.shop_sign_scale, 255, true, false)
    self.canvas:add_animated_sprite(self.arrows_sprites[1], self.canvas.sprite_sheets.icons[1], 30, 79, 7, 7, 0, 1, 255, true, false)
    self.canvas:add_animated_sprite(self.arrows_sprites[3], self.canvas.sprite_sheets.icons[1], 74, 79, 7, 7, 0, 1, 255, true, false)
    if self.current_mode == self.modes.TOKENS then
        self.text_tokens = self.canvas:draw_letters_to_numbers('tokens', 41.5, 79, 'white')
    elseif self.current_mode == self.modes.CARDS then
        self.text_tokens = self.canvas:draw_letters_to_numbers('cards', 43.5, 79, 'white')
    end

    -- Add player info
    self.canvas:add_animated_sprite(self.player.animation_icons[1], self.canvas.sprite_sheets.icons[1], 36, 92, 7, 7, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.player.health, 42.5, 92, 'red')
    self.canvas:add_animated_sprite(self.player.animation_icons[2], self.canvas.sprite_sheets.icons[1], 56, 92, 7, 7, 0, 1, 1, true, false)
    -- self.canvas:add_animated_sprite(self.canvas.digit_sprite, self.canvas.text_yellow_sprite_sheet_image, 64, 92, 7, 9, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.player.money, 66.5, 91, 'yellow')

    -- Draw player's gun barrel
    if self.current_mode == self.modes.TOKENS then
        self.canvas:add_animated_sprite(self.player.gun.barrel_sprites[1], self.canvas.sprite_sheets.barrel[1], 132, 54, 72, 72, 0, 1, 250, true, false)
        self.canvas:add_animated_sprite(self.player.gun.barrel_sprites[2], self.canvas.sprite_sheets.barrel[1], 132, 54, 72, 72, 0, 1, 251, true, false)
        
        -- Draw player's current ammo
        local barrel_coordinates = {{131.5, 30.5}, {150.5, 41.5}, {150.5, 63.5}, {130.5, 75.5}, {111.5, 63.5}, {111.5, 41.5}}
        for i = 1, #self.player.gun.ammo do
            if self.player.gun.ammo[i] ~= 'empty' then
                self.canvas:add_animated_sprite(self.player.gun.ammo[i].sprite, self.canvas.sprite_sheets.tokens[1], barrel_coordinates[i][1], barrel_coordinates[i][2], 15, 15, self.shop_sign_rotation, self.shop_sign_scale, 252, true, false)
            end
        end

        -- Draw stock (tokens)
        for i = 1, 6 do
            local depth = 255
            if self.stock[i].picked_up then depth = 256 end
            if self.stock[i].visible then
                self.canvas:add_animated_sprite(self.stock[i].item.sprite, self.canvas.sprite_sheets.tokens[1], self.stock[i].x, self.stock[i].y, 15, 15, 0, self.stock[i].scale, depth, true, false)
            end
        end
    end

    if self.current_mode == self.modes.CARDS then
        -- Draw big card
        self.canvas:add_animated_sprite(self.card_back_sprite, self.canvas.sprite_sheets.cards_large[1], 134.5, 30 + (self.selection_scale * 10), 33, 47, self.shop_sign_rotation, self.shop_sign_scale, 252, true, false)
        -- elseif self.selection > 0 and self.selection <= 4 then
        --     self.canvas:add_animated_sprite(self.large_card_sprites[self.cards[self.selection].id], self.canvas.sprite_sheets.cards_large[1], 134.5, 30 + (self.selection_scale * 10), 33, 47, self.shop_sign_rotation, self.shop_sign_scale, 252, true, false)
        -- end

        -- Draw player's poker hand
        local poker_hand_grid = {{113.5, 84}, {127.5, 84}, {141.5, 84}, {155.5, 84}}
        for i = 1, 4 do
            self.canvas:add_animated_sprite(self.empty_card_sprite, self.canvas.sprite_sheets.cards[1], poker_hand_grid[i][1], poker_hand_grid[i][2], 11, 15, 0, 1, 250, true, false)
        end

        -- Draw stock (cards)
        for i = 7, 10 do
            local depth = 255
            if self.stock[i].picked_up then depth = 256 end
            if self.stock[i].visible then
                self.canvas:add_animated_sprite(self.stock[i].item.sprite, self.canvas.sprite_sheets.cards[1], self.stock[i].x, self.stock[i].y, 11, 15, 0, self.stock[i].scale, depth, true, false)
            end
        end
    end

end


return Shop