local Player = {
    sprite = nil,
    base_xy = {63, 75}
}


function Player:load()
    self.sprite = love.graphics.newImage("assets/sprites/player/player_idle1.png")
    self.sprite:setFilter("nearest", "nearest")
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
end


function Player:draw()
    -- Draw the player sprite at its x, y position
    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.draw(self.sprite, (self.base_xy[1] + 1 - (self.width / 2)) * ScaleX, (self.base_xy[2] + 1 - (self.height / 2)) * ScaleY, 0, ScaleX, ScaleY)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, (self.base_xy[1] - (self.width / 2)) * ScaleX, (self.base_xy[2] - (self.height / 2)) * ScaleY, 0, ScaleX, ScaleY)

    
end


return Player