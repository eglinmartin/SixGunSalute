local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Canvas = require("src/canvas")
local Gun = require("src/gun")

local Enemy = Class{}


function Enemy:init(canvas, player, tokens, health)
    self.base_xy = {128, 75}
    self.xy = {128, 75}
    self.canvas = canvas
    self.player = player

    self.health = health
    self.health_sprite_scale = 1

    self.gun = Gun(self, self.canvas, tokens)

end


function Enemy:hit(amount_health)
    self.health = self.health - amount_health
    self.xy[1] = self.xy[1] + 20
end


function Enemy:die()
    self.player.enemy = false
    print('oh no')
end


function Enemy:return_to_xy()
    if self.xy[1] > (self.base_xy[1] + 0.1) then
        self.xy[1] = self.xy[1] - ((self.xy[1] - self.base_xy[1]) / 4)
    end
end


function Enemy:update()
    self:return_to_xy()

    if self.health <= 0 then
        self:die()
    end
end


function Enemy:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_animated_sprite(self.player.animation, self.canvas.sprite_sheets.enemy[1], self.xy[1], self.xy[2], 28, 28, 0, 1, 0, true, false)

    self.canvas:add_animated_sprite(self.player.animation_icons[1], self.canvas.sprite_sheets.icons[1], 180.5, 33, 7, 7, 0, self.health_sprite_scale, 1, true, false)
    self.text_tokens = self.canvas:draw_letters_to_numbers(self.health, 169, 33, 'red', self.health_sprite_scale)


    self.gun:draw()
end


return Enemy