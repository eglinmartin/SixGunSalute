local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Canvas = require("src/canvas")
local Gun = require("src/gun")

local Player = Class{}


function Player:init(canvas, tokens, cards)
    self.base_xy = {64, 75}
    self.xy = {64, 75}
    self.canvas = canvas

    self.gun = Gun(self, self.canvas, tokens)
    self.cards = {cards.CARD_10_HEARTS, 'empty', 'empty', 'empty'}

    self.health = 5
    self.money = 10

    self.shooting = false
    self.shoot_cooldown = 0

    self.animation_idle = anim8.newAnimation(self.canvas.sprite_sheets.player[2]('1-2', 1), 0.5)
    self.animation_shoot = anim8.newAnimation(self.canvas.sprite_sheets.player[2]('3-3', 1), 0.5)
    self.animation_head = anim8.newAnimation(self.canvas.sprite_sheets.player_head[2]('1-2', 1), {4.8, 0.2})

    self.animation_icons = {}
    for i = 1, 3 do
        self.animation_icons[i] = anim8.newAnimation(self.canvas.sprite_sheets.icons[2](i, 1), 1)
    end

    -- Create dollar sign sprite
    self.dollar_sign_sprite = anim8.newAnimation(self.canvas.sprite_sheets.text_yellow[2](1, 5), 1)

    -- Create empty card sprite
    self.empty_card_sprite = anim8.newAnimation(self.canvas.sprite_sheets.cards[2](1, 5), 1)

    self.animation = self.animation_idle
    self.rotation = 0
    self.rotation_amplitude = 0
end


function Player:shoot()
    if self.gun.selected_chamber and self.gun.ammo[self.gun.selected_chamber].type == 'AMMO' then
        self.shooting = true
        self.shoot_cooldown = 30
        self.xy[1] = self.xy[1] - 12
        self.gun:shoot()
    end
end


function Player:return_to_xy()
    if self.xy[1] < (self.base_xy[1] - 0.1) then
        self.xy[1] = self.xy[1] + ((self.base_xy[1] - self.xy[1]) / 4)
    end
end


function Player:update(dt, time)
    self.animation:update(dt)
    self.animation_head:update(dt)

    self.rotation = math.sin(time * 1) * 0.05
    self.scale = math.sin(time * 1.75) * 0.025 + 1.025

    if self.shoot_cooldown > 0 then
        self.shoot_cooldown = self.shoot_cooldown - 1
    else
        self.shooting = false
    end

    if self.shooting then
        self.animation = self.animation_shoot
    else
        self.animation = self.animation_idle
    end

    self:return_to_xy()
    self.gun:update(dt)
end


function Player:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_animated_sprite(self.animation, self.canvas.sprite_sheets.player[1], self.xy[1], self.xy[2], 28, 28, 0, 1, 0, true, false)

    -- Draw player head and hud elements
    self.canvas:add_animated_sprite(self.animation_head, self.canvas.sprite_sheets.player_head[1], 16, 18, 18, 15, self.rotation, self.scale, 1, true, false)

    self.canvas:add_animated_sprite(self.animation_icons[1], self.canvas.sprite_sheets.icons[1], 14.5, 33, 7, 7, 0, 1, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.health, 21, 33, 'red')

    self.canvas:add_animated_sprite(self.animation_icons[2], self.canvas.sprite_sheets.icons[1], 14.5, 43, 7, 7, 0, 1, 1, true, false)
    self.canvas:add_animated_sprite(self.dollar_sign_sprite, self.canvas.sprite_sheets.text_yellow[1], 22.5, 42, 7, 7, 0, 1, 1, true, false)
    self.text_money = self.canvas:draw_letters_to_numbers(self.money, 25, 42, 'yellow')

    local cards_grid = {{73, 12}, {88, 12}, {103, 12}, {118, 12}}
    for i = 1, #self.cards do
        if self.cards[i] ~= 'empty' then
            self.canvas:add_animated_sprite(self.cards[i].sprite, self.canvas.sprite_sheets.cards[1], cards_grid[i][1], cards_grid[i][2], 11, 15, 0, 1, 252, true, false)
        else
            self.canvas:add_animated_sprite(self.empty_card_sprite, self.canvas.sprite_sheets.cards[1], cards_grid[i][1], cards_grid[i][2], 11, 15, 0, 1, 252, true, false)
        end
    end

    self.gun:draw()
end


return Player