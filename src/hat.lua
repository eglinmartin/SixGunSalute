local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")
local Canvas = require("src/canvas")
local Gun = require("src/gun")


local Hat = Class{}
HatTypes = {
    STETSON = 1
}


function Hat:init(wearer, canvas, x_off, y_off, rot)
    self.wearer = wearer
    self.canvas = canvas
    self.x_off = x_off
    self.y_off = y_off
    self.rot = rot
    self.type = HatTypes.STETSON

    self.animation_hats = anim8.newAnimation(self.canvas.sprite_sheets.hats[2]('1-1', 1), 1)
    self.animation = self.animation_hats
end


function Hat:update(dt)
    self.xy = {self.wearer.xy[1] + self.x_off, self.wearer.xy[2] + self.y_off}
end


function Hat:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_animated_sprite(self.animation, self.canvas.sprite_sheets.hats[1], self.xy[1], self.xy[2], 28, 28, 0, 1, 0, true, false)
end


return Hat