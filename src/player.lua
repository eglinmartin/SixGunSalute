local Class = require("src/hump/class")
local Constants = require("src/constants")
local Gun = require("src/gun")

local Player = Class{}


function Player:init()
    self.sprite = love.graphics.newImage("assets/sprites/player/player_idle1.png")
    self.sprite:setFilter("nearest", "nearest")
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()

    self.base_xy = {64, 75}
    self.gun = Gun(self)
end


function Player:draw()
    -- Draw the player sprite at its x, y position
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.draw(self.sprite, (self.base_xy[1] + 1 - (self.width / 2)) * ScreenScale, (self.base_xy[2] + 1 - (self.height / 2)) * ScreenScale, 0, ScreenScale, ScreenScale)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, (self.base_xy[1] - (self.width / 2)) * ScreenScale, (self.base_xy[2] - (self.height / 2)) * ScreenScale, 0, ScreenScale, ScreenScale)
end


return Player