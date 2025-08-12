local player = require("src/player")

VirtualWidth, VirtualHeight = 1920, 1080
ScaleX, ScaleY = 10, 10


function love.load()
    love.window.setTitle("My First Love2D Game")
    love.window.setMode(VirtualWidth, VirtualHeight, {fullscreen = false, vsync = true, resizable = false})

    love.graphics.setBackgroundColor(75/255, 90/255, 87/255)

    player:load()

end


function love.draw()
    player:draw()
end

