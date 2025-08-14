-- ScreenWidth, ScreenHeight = love.window.getDesktopDimensions()
ScreenWidth = 1920
ScreenHeight = math.floor(ScreenWidth / 1.77777)
ScreenScale = ScreenWidth/192

local anim8 = require("src/libraries/anim8")
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
    love.mouse.setVisible(false)

    camera = Camera(96 * ScreenScale, 54 * ScreenScale)
    canvas = Canvas()

    player = Player(canvas)

    love.window.setTitle("Six-Gun Silliness")
    love.window.setMode(ScreenWidth, ScreenHeight, {fullscreen=false, vsync=true, resizable=false})

    Cursor_sprite_sheet_image = love.graphics.newImage('assets/sprites/cursor.png')
    local cursor_sprite_sheet = anim8.newGrid(8, 12, Cursor_sprite_sheet_image:getWidth(), Cursor_sprite_sheet_image:getHeight(), 0, 0, 1)
    Animation_cursor = anim8.newAnimation(cursor_sprite_sheet('1-1', 1), 1)
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
    end

    local mouse_x, mouse_y = love.mouse.getPosition()
    canvas:add_animated_sprite(Animation_cursor, Cursor_sprite_sheet_image, mouse_x / ScreenScale, mouse_y / ScreenScale, 8, 12, 0, 1, 257, true, false)
    love.graphics.print("Shooting: " .. tostring(mouse_x) .. (mouse_y), 10, 70)
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end