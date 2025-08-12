local Class = require("src/hump/class")
local Canvas = require("src/canvas")
local Constants = require("src/constants")
local Gun = Class{}


function Gun:init(owner, canvas)
    self.owner = owner
    self.xy = {2, 100}
    self.ammo = {}
    self.canvas = canvas

    -- Fill chambers
    for i=1, 6 do
        self.ammo[i] = Constants.Tokens.AMMO_BRASSBULLET
    end
end


function Gun:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_sprite("assets/sprites/hud/barrel_base.png", self.xy[1], self.xy[2], 49, true, false)
    self.canvas:add_sprite("assets/sprites/hud/barrel_chambers.png", self.xy[1], self.xy[2], 50, true, false)

    local coordinates = {{self.owner.base_xy[1], 35}, {self.owner.base_xy[1]+7, 40}, {self.owner.base_xy[1]+7, 47}, {self.owner.base_xy[1], 52}, {self.owner.base_xy[1]-7, 47}, {self.owner.base_xy[1]-7, 40}}
    local spr_image

    -- Draw chamber indicators above player
    for i=1, #self.ammo do
        if self.ammo[i] == Constants.Tokens.EMPTY then
            spr_image = "assets/sprites/hud/chamber_empty.png"
        elseif string.find(self.ammo[i], "ammo") then
            spr_image = "assets/sprites/hud/chamber_ammo.png"
        elseif string.find(self.ammo[i], "health") then
            spr_image = "assets/sprites/hud/chamber_health.png"
        elseif string.find(self.ammo[i], "explosive") then
            spr_image = "assets/sprites/hud/chamber_explosive.png"
        elseif string.find(self.ammo[i], "money") then
            spr_image = "assets/sprites/hud/chamber_money.png"
        end
        self.canvas:add_sprite(spr_image, coordinates[i][1], coordinates[i][2], 0, true, false)
    end

end


return Gun