local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Timer = require("src/libraries/timer")

local Gun = Class{}


function Gun:init(owner, canvas, tokens)
    self.owner = owner
    self.xy = {2, 100}
    self.ammo = {}
    self.canvas = canvas
    self.tokens = tokens

    self.can_spin = true
    self.can_shoot = false
    self.rotation = 0
    self.spin_speed = 0
    self.spin_cooldown = 30
    self.last_spin_time = -self.spin_cooldown
    self.selected_chamber = nil
    self.timer = Timer.new()
    self.token = nil
    self.spinning = false
    self.chamber_scale = 1

    -- Fill chambers
    for i=1, 6 do
        self.ammo[i] = tokens.AMMO_BRASSBULLET
    end
    self.ammo[4] = tokens.AMMO_SILVERBULLET
    self.ammo[5] = tokens.HEALTH_GIN

    -- Create chamber sprites
    self.chamber_sprites = {}
    for i = 1, 6 do
        self.chamber_sprites[i] = anim8.newAnimation(self.canvas.sprite_sheets.chambers[2](i, 1), 1)
        self.chamber_sprites[i] = anim8.newAnimation(self.canvas.sprite_sheets.chambers[2](i, 1), 1)
    end

    -- Create barrel sprites
    self.barrel_sprites = {}
    for i = 1, 2 do
        self.barrel_sprites[i] = anim8.newAnimation(self.canvas.sprite_sheets.barrel[2](i, 1), 1)
    end
end


function Gun:spin()
    if self.spinning then return end

    local now = love.timer.getTime()
    self.last_spin_time = now
    self.spinning = true
    self.selected_chamber = nil

    self.timer:after(0.75, function()
        self.selected_chamber = math.random(1, 6)
        self.chamber_scale = 2
        self.spinning = false
        self.rotation = 0
        self.can_shoot = true
    end)
end


function Gun:shoot()
    if self.can_shoot and self.selected_chamber then
        self.ammo[self.selected_chamber] = 'empty'
        self.selected_chamber = nil
    end
end


function Gun:update(dt)
    if self.spinning then
        if self.spin_speed < 30 then
            self.spin_speed = self.spin_speed + 1
        else
            self.spin_speed = 30
        end
        self.rotation = self.rotation + self.spin_speed * dt
    else
        self.spin_speed = 0
    end

    if self.timer then
        self.timer:update(dt)
    end

    if self.chamber_scale > 1 then
        self.chamber_scale = self.chamber_scale - ((self.chamber_scale - 1) / 2)
    else
        self.chamber_scale = 1
    end
end


function Gun:draw()
    local coordinates = {{self.owner.base_xy[1], 35}, {self.owner.base_xy[1]+7, 40}, {self.owner.base_xy[1]+7, 47}, {self.owner.base_xy[1], 52}, {self.owner.base_xy[1]-7, 47}, {self.owner.base_xy[1]-7, 40}}

    -- Draw chamber indicators above player
    for i=1, #self.ammo do
        if self.ammo[i] == 'empty' then
            spr = self.chamber_sprites[1]
        elseif self.ammo[i].type == 'AMMO' then
            spr = self.chamber_sprites[2]
        elseif self.ammo[i].type == 'HEALTH' then
            spr = self.chamber_sprites[3]
        elseif self.ammo[i].type == 'EXPLOSIVE' then
            spr = self.chamber_sprites[4]
        elseif self.ammo[i].type == 'MONEY' then
            spr = self.chamber_sprites[5]
        end
        self.canvas:add_animated_sprite(spr, self.canvas.sprite_sheets.chambers[1], coordinates[i][1], coordinates[i][2], 6, 6, 0, 1, 0, true, false)
    end

    self.canvas:add_animated_sprite(self.barrel_sprites[1], self.canvas.sprite_sheets.barrel[1], 2, 100, 70, 70, 0, 1, 250, true, false)
    self.canvas:add_animated_sprite(self.barrel_sprites[2], self.canvas.sprite_sheets.barrel[1], 2, 100, 70, 70, self.rotation, 1, 251, true, false)
    
    if self.selected_chamber then
        self.canvas:add_animated_sprite(self.chamber_sprites[6], self.canvas.sprite_sheets.chambers[1], coordinates[self.selected_chamber][1], coordinates[self.selected_chamber][2], 6, 6, 0, self.chamber_scale, 200, false, false)

        self.token = self.ammo[self.selected_chamber]
        if self.token ~= 'empty' then
            self.canvas:add_animated_sprite(self.token.sprite, self.canvas.sprite_sheets.tokens[1], 21.5, 88.5, 15, 15, 0, 1, 252, true, false)
        end
    end

end


return Gun