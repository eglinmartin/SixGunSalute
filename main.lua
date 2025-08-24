ScreenWidth, ScreenHeight = love.window.getDesktopDimensions()
ScreenWidth = ScreenWidth * 0.8
ScreenHeight = math.floor(ScreenWidth / 1.77777)
ScreenScale = ScreenWidth/192

Canvas = require("src/canvas")

local anim8 = require("src/libraries/anim8")
local Camera = require("src/libraries/camera")
local Enemy = require("src/enemy")
local GameState = require("src/libraries/gamestate")
local Player = require("src/player")
local Shop = require("src/shop")

local tokens = require("src/tokens")

local canvas
local camera
local enemy
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
    love.window.setMode(ScreenWidth, ScreenHeight, {fullscreen=false, vsync=true, resizable=false, msaa=4})

    GameState.registerEvents()

    canvas = Canvas()
    
    Tokens = tokens.generate_tokens(canvas)
    Cards = tokens.generate_cards(canvas)

    player = Player(canvas, Tokens, Cards)

    GameState.switch(gamestate_gunfight, canvas, player, Tokens)
end


function love.keypressed(key)
    if key == "1" then
        GameState.switch(gamestate_gunfight, canvas, player, Tokens)
    elseif key == "2" then
        GameState.switch(gamestate_shop, canvas, player)
    end
end


function gamestate_gunfight:enter(previous, canvas, player)
    if not enemy then
        self:create_enemy()
    end
end


function gamestate_gunfight:create_enemy()
    if not enemy then
        enemy = Enemy(canvas, player, Tokens, 10)
        player.enemy = enemy
    end
end


function gamestate_gunfight:update(dt)
    if enemy then
        enemy:update()
        if enemy.health <= 0 then
            enemy = false
        end
    end

    local time = love.timer.getTime()
    player:update(dt, time)
end


function gamestate_gunfight:draw()
    love.graphics.push()
    love.graphics.scale(ScreenScale, ScreenScale)

    player:draw()

    if enemy then
        enemy:draw()
    end

    canvas:draw()
    
    love.graphics.pop()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end


function gamestate_gunfight:keypressed(key)
    if key == "a" then
        player.gun:spin()
    elseif key == "space" then
        player:action()
    elseif key == "escape" then
        love.event.quit()
    end
end

-- ************************************************************ SHOP ************************************************************

function gamestate_shop:enter(previous, canvas, player)
    self.player = player
    self.canvas = canvas

    self.shop = Shop(canvas, player, Tokens, Cards)
end


function gamestate_shop:keypressed(key)
    if key == "q" or key == "e" then
        self.shop.selection = 0
        if self.shop.current_mode == self.shop.modes.TOKENS then
            self.shop.current_mode = self.shop.modes.CARDS
            self.shop:animate_stock()
        elseif self.shop.current_mode == self.shop.modes.CARDS then
            self.shop.current_mode = self.shop.modes.TOKENS
            self.shop:animate_stock()
        end
    end

    if key == "a" then
        self.shop:select('left')
    end
    if key == 'd' then
        self.shop:select('right')
    end
end


function gamestate_shop:update()
    local time = love.timer.getTime()
    local mouse_x, mouse_y = love.mouse.getPosition()
    self.shop:update(time, mouse_x, mouse_y)
end


function gamestate_shop:draw()
    love.graphics.push()
    love.graphics.scale(ScreenScale, ScreenScale)

    self.shop:draw()
    self.canvas:draw()
    
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
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