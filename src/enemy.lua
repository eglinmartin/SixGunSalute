local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Canvas = require("src/canvas")
local Gun = require("src/gun")
local Hat = require("src/hat")
local States = require("src/constants/states")

local Enemy = Class{}


function Enemy:init(canvas, player, tokens, health)
    self.base_xy = {128, 75}
    self.xy = {128, 80}
    self.canvas = canvas
    self.player = player

    self.health = health
    self.health_sprite_scale = 1

    self.animation_idle = anim8.newAnimation(self.canvas.sprite_sheets.enemy[2]('1-2', 1), 0.5)
    self.animation_hit = anim8.newAnimation(self.canvas.sprite_sheets.enemy[2]('3-3', 1), 0.5)
    self.animation_dead = anim8.newAnimation(self.canvas.sprite_sheets.enemy[2]('5-5', 1), 0.5)

    self.gun = Gun(self, self.canvas, tokens)
    self.hat = Hat(self, self.canvas, 5, -10, 0)

    self.state = States.IDLE
    self.animation = self.animation_idle

    self.hit_cooldown = 50
    self.hit_timer = 0

    self.death_cooldown = 150
    self.death_timer = 0
end


function Enemy:hit(amount_health)
    self.state = States.HIT
    self.health = self.health - amount_health
    self.hit_timer = self.hit_cooldown

    if self.health <= 0 then
        self.xy[1] = self.xy[1] + 5
        self:die()
    else
        self.xy[1] = self.xy[1] + 20
    end
end


function Enemy:die()
    self.player.enemy = false
    self.state = States.DEAD
    self.death_timer = self.death_cooldown
end


function Enemy:update(dt)
    self:return_to_xy()

    if self.state == States.IDLE then
        self.animation = self.animation_idle
        self.animation:gotoFrame(self.player.animation.position)
        self.hat.y_off = -11 + (self.animation.position - 1)
    
    elseif self.state == States.HIT then
        self.animation = self.animation_hit
        self.hit_timer = self.hit_timer - 1
        if self.hit_timer <= 0 then
            self.state = States.IDLE
        end

    elseif self.state == States.DEAD then
        self.animation = self.animation_dead
        self.death_timer = self.death_timer - 1
        -- self.hat:launch()
    end

    self.animation:update(dt)
    self.hat:update(dt)
end


function Enemy:return_to_xy()
    if self.xy[1] > (self.base_xy[1] + 0.1) then
        self.xy[1] = self.xy[1] - ((self.xy[1] - self.base_xy[1]) / 4)
    elseif self.xy[1] < (self.base_xy[1] - 0.1) then
        self.xy[1] = self.xy[1] + ((self.base_xy[1] - self.xy[1]) / 4)
    end

    if self.xy[2] > (self.base_xy[2] + 0.1) then
        self.xy[2] = self.xy[2] - ((self.xy[2] - self.base_xy[2]) / 4)
    elseif self.xy[2] < (self.base_xy[2] - 0.1) then
        self.xy[2] = self.xy[2] + ((self.base_xy[2] - self.xy[2]) / 4)
    end
end


function Enemy:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_animated_sprite(self.animation, self.canvas.sprite_sheets.enemy[1], self.xy[1], self.xy[2], 28, 28, 0, 1, 0, true, false)

    self.canvas:add_animated_sprite(self.player.animation_icons[1], self.canvas.sprite_sheets.icons[1], 180.5, 33, 7, 7, 0, self.health_sprite_scale, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.health, 169, 33, 'red', self.health_sprite_scale)

    self.hat:draw()
end


return Enemy