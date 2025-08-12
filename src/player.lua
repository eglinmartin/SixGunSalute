local Class = require("src/hump/class")
local Canvas = require("src/canvas")
local Constants = require("src/constants")
local Gun = require("src/gun")

local Player = Class{}


function Player:init(canvas)
    -- self.sprite = love.graphics.newImage("assets/sprites/player/player_idle1.png")
    -- self.sprite:setFilter("nearest", "nearest")
    -- self.width = self.sprite:getWidth()
    -- self.height = self.sprite:getHeight()

    self.base_xy = {64, 75}
    self.gun = Gun(self, canvas)
    self.canvas = canvas
end


function Player:draw()
    -- Draw the player sprite at its x, y position
    self.canvas:add_sprite("assets/sprites/player/player_idle1.png", self.base_xy[1], self.base_xy[2], 0, true, false)
    self.gun:draw()
end


return Player