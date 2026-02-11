local peachy = require("lib.peachy")
local rs = require("lib.resolution_solution")

local Deck = require("src.deck")
local Player = require("src.player")
local utils = require("src.utils")

local joysticks = love.joystick.getJoysticks()
local gp = joysticks[1]


if arg[2] == "debug" then
    require("lldebugger").start()
end


rs.conf({
    game_width = 192,
    game_height = 108,
    scale_mode = rs.PIXEL_PERFECT_MODE,
    pixel_perfect = true
})
-- rs.setMode(960, 540, {})
rs.setMode(1920, 1080, {fullscreen=true})


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    DECK = Deck()
    PLAYER = Player()
end


function love.resize(w, h)
    rs.resize(w, h)
end


function love.update(dt)
    PLAYER:update(dt)
    
end


function love.draw()
    love.graphics.clear(0, 0, 0, 1)
    local sprites = {}

    rs.push()

    love.graphics.setColor(75/255, 90/255, 87/255, 1)
    love.graphics.rectangle("fill", 0, 0, 192, 108)

    love.graphics.setColor(81/255, 108/255, 94/255, 1)
    love.graphics.rectangle("fill", 5, 5, 182, 98)

    -- 
    DECK:draw(sprites)
    PLAYER:draw(sprites)
    
    -- Draw the shadow for each sprite
    for _, sprite in ipairs(sprites) do
        utils.DrawShadow(sprite.sprite, sprite.x, sprite.y, sprite.rot, sprite.scale, sprite.sprite:getWidth() / 2, sprite.sprite:getHeight() / 2)
    end

    -- Draw the sprite itself - recolour if necessary
    for _, sprite in ipairs(sprites) do
        sprite.sprite:draw(sprite.x, sprite.y, sprite.rot, sprite.scale, sprite.scale, sprite.sprite:getWidth() / 2, sprite.sprite:getHeight() / 2)
    end

    rs.pop()
end


local love_errorhandler = love.errorhandler
function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

