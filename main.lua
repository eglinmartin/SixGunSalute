-- ScreenWidth, ScreenHeight = love.window.getDesktopDimensions()
ScreenWidth = 1920
ScreenHeight = math.floor(ScreenWidth / 1.77777)
ScreenScale = ScreenWidth/192

local Camera = require("src/libraries/camera")
local Canvas = require("src/canvas")
local Player = require("src/player")

local canvas
local camera
local player


if arg[2] == "debug" then
    require("lldebugger").start()
end


function love.load()
    math.randomseed(os.time())
    camera = Camera(96 * ScreenScale, 54 * ScreenScale)
    canvas = Canvas()

    player = Player(canvas)

    love.window.setTitle("Six-Gun Silliness")
    love.window.setMode(ScreenWidth, ScreenHeight, {fullscreen=false, vsync=true, resizable=false})
end


function love.keypressed(key)
    if key == "a" then
        player.gun:spin()
    end
    if key == "space" then
        player:shoot()
    end
    if key == "escape" then
        love.event.quit()
    end
end


function love.update(dt)
    local camera_x, camera_y = camera:position()
    player:update(dt)
end


function love.draw()
    love.graphics.push()

    love.graphics.scale(ScreenScale, ScreenScale)

    player:draw()
    canvas:draw()
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Shooting: " .. tostring(player.shooting), 10, 30)
    if player.gun.selected_chamber then
        love.graphics.print("Shooting: " .. tostring(player.gun.selected_chamber), 10, 50)
        love.graphics.print("Shooting: " .. tostring(player.gun.ammo[player.gun.selected_chamber].type), 10, 70)
    end
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end