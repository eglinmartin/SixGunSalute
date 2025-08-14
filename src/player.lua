local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Canvas = require("src/canvas")
local Constants = require("src/constants")
local Gun = require("src/gun")

local Player = Class{}


function Player:init(canvas, camera)
    self.base_xy = {64, 75}
    self.xy = {64, 75}
    self.canvas = canvas
    self.camera = camera
    self.gun = Gun(self, self.canvas, self.camera)

    self.shooting = false
    self.shoot_cooldown = 0

    self.sprite_sheet_image = love.graphics.newImage('assets/sprites/player.png')
    local sprite_sheet = anim8.newGrid(28, 28, self.sprite_sheet_image:getWidth(), self.sprite_sheet_image:getHeight())
    self.animation_idle = anim8.newAnimation(sprite_sheet('1-2', 1), 0.5)
    self.animation_shoot = anim8.newAnimation(sprite_sheet('3-3', 1), 0.5)

    self.head_sprite_sheet_image = love.graphics.newImage('assets/sprites/player_head.png')
    local head_sprite_sheet = anim8.newGrid(16, 13, self.head_sprite_sheet_image:getWidth(), self.head_sprite_sheet_image:getHeight(), 0, 0, 1)
    self.animation_head = anim8.newAnimation(head_sprite_sheet('1-2', 1), {4.8, 0.2})

    self.icons_sprite_sheet_image = love.graphics.newImage('assets/sprites/icons.png')
    local icons_sprite_sheet = anim8.newGrid(7, 7, self.icons_sprite_sheet_image:getWidth(), self.icons_sprite_sheet_image:getHeight(), 0, 0, 1)
    self.animation_icons = {}
    for i = 1, 3 do
        self.animation_icons[i] = anim8.newAnimation(icons_sprite_sheet(i, 1), 1)
    end

    self.animation = self.animation_idle
    self.rotation = 0
    self.rotation_amplitude = 0
end


function Player:shoot()
    if self.gun.selected_chamber and self.gun.ammo[self.gun.selected_chamber].type == 'AMMO' then
        self.shooting = true
        self.shoot_cooldown = 30
        self.xy[1] = self.xy[1] - 16
        self.gun:shoot()
    end
end


function Player:return_to_xy()
    if self.xy[1] < (self.base_xy[1] - 0.1) then
        self.xy[1] = self.xy[1] + ((self.base_xy[1] - self.xy[1]) / 4)
    end
end


function Player:update(dt)
    self.animation:update(dt)
    self.animation_head:update(dt)

    local time = love.timer.getTime()
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
    self.canvas:add_animated_sprite(self.animation, self.sprite_sheet_image, self.xy[1], self.xy[2], 28, 28, 0, 1, 0, true, false)

    -- Draw player head and hud elements
    self.canvas:add_animated_sprite(self.animation_head, self.head_sprite_sheet_image, 16, 18, 18, 15, self.rotation, self.scale, 1, true, false)
    self.canvas:add_animated_sprite(self.animation_icons[1], self.icons_sprite_sheet_image, 20, 38, 18, 15, 0, 1, 1, true, false)
    self.canvas:add_animated_sprite(self.animation_icons[2], self.icons_sprite_sheet_image, 20, 48, 18, 15, 0, 1, 1, true, false)

    self.gun:draw()
end


return Player