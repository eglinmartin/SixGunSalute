local Class = require("src/hump/class")
local Canvas = require("src/canvas")
local Constants = require("src/constants")
local Gun = Class{}


function Gun:init(owner, canvas)
    self.owner = owner
    self.xy = {2, 100}
    self.ammo = {}
    self.canvas = canvas

    for i = 1, 6 do
        self.ammo[i] = Constants.Tokens.AMMO_BRASSBULLET
    end
    
end


function Gun:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_sprite("assets/sprites/hud/barrel_base.png", self.xy[1], self.xy[2], 0, true, false)
    self.canvas:add_sprite("assets/sprites/hud/barrel_chambers.png", self.xy[1], self.xy[2], 0, true, false)
end


return Gun