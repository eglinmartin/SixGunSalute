-- ScreenWidth, ScreenHeight = love.window.getDesktopDimensions()
ScreenWidth = 960
ScreenHeight = math.floor(ScreenWidth / 1.77777)
ScreenScale = ScreenWidth/192

local Camera = require("src/hump/camera")
local Canvas = require("src/canvas")
local Player = require("src/player")

local canvas
local camera
local player


function love.load()
    camera = Camera(96 * ScreenScale, 54 * ScreenScale)
    canvas = Canvas()

    player = Player(canvas)


    love.window.setTitle("Six-Gun Silliness")
    love.window.setMode(ScreenWidth, ScreenHeight, {fullscreen=false, vsync=true, resizable=false})
end


function love.update(dt)
    local camera_x, camera_y = camera:position()
    --camera:lookAt(x - (1 * ScreenScale), y)
end


function love.draw()    
    -- camera:attach()

    player:draw()

    canvas:draw()
    
    love.graphics.setBackgroundColor(75/255, 90/255, 87/255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Ammo: " .. player.gun.ammo[1], 10, 25)

    -- camera:detach()
end

