local Class = require("lib.class")
local peachy = require("lib.peachy")


local Player = Class{}


States = {
    IDLE = 1,
}


function Player:init()
    self.state = States.IDLE
    self.x = 64
    self.y = 78
    
    self.health = 5
    self.money = 10
    self.animations = {}

    self:refresh_sprites()


end


function Player:refresh_sprites()
    self.animations["player"] = {sprite = peachy.new("assets/json/player.json", love.graphics.newImage("assets/sprites/player.png"), "idle"), x = self.x, y = self.y}
end


function Player:update(dt)
    self.animations["player"].sprite:update(dt)
end


function Player:draw(sprites)
    table.insert(sprites, self.animations["player"])
end


return Player
