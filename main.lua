ScreenWidth, ScreenHeight = love.window.getDesktopDimensions()
-- ScreenWidth = 1920
ScreenHeight = math.floor(ScreenWidth / 1.77777)
ScreenScale = ScreenWidth/192

local anim8 = require("src/libraries/anim8")
local Camera = require("src/libraries/camera")
local GameState = require("src/libraries/gamestate")
local Canvas = require("src/canvas")
local Player = require("src/player")
local Shop = require("src/shop")

local canvas
local camera
local player
local shop

local gamestate_gunfight = {}
local gamestate_shop = {}


if arg[2] == "debug" then
    require("lldebugger").start()
end


function love.load()
    math.randomseed(os.time())
    -- love.mouse.setVisible(false)

    love.window.setTitle("Six-Gun Silliness")
    love.window.setMode(ScreenWidth, ScreenHeight, {fullscreen=true, vsync=true, resizable=false})

    GameState.registerEvents()

    canvas = Canvas()
    player = Player(canvas)

    GameState.switch(gamestate_shop, canvas, player)
end


function gamestate_gunfight:enter(previous, canvas, player)
end


function gamestate_gunfight:update(dt)
    player:update(dt)
end


function gamestate_gunfight:draw()
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

end


function gamestate_gunfight:keypressed(key)
    if key == "a" then
        player.gun:spin()
    elseif key == "space" then
        player:shoot()
    elseif key == "escape" then
        love.event.quit()
    end
end

-- ************************************************************ SHOP ************************************************************

function gamestate_shop:enter(previous, canvas, player)
    self.player = player
    self.canvas = canvas
    self.shop = Shop(canvas)
end

function gamestate_shop:draw(previous, canvas, player)
    love.graphics.push()
    love.graphics.scale(ScreenScale, ScreenScale)

    self.shop:draw()
    self.canvas:draw()
    
    love.graphics.pop()
end

-- *********************************************************** ERRORS ***********************************************************

local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end