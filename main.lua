--Width, Height = love.window.getDesktopDimensions()
ScreenWidth = 800
ScreenHeight = math.floor(ScreenWidth / 1.77777)
ScreenScale = ScreenWidth/192

local Player = require("src/player")
local player


function love.load()
    love.window.setTitle("Six-Gun Silliness")
    love.window.setMode(ScreenWidth, ScreenHeight, {fullscreen=false, vsync=true, resizable=false})

    love.graphics.setBackgroundColor(75/255, 90/255, 87/255)

    player = Player:new()
    player:load()

end


function love.update()
end


function love.draw()
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Ammo: " .. player.gun.ammo[1], 10, 25)
    player:draw()
end

