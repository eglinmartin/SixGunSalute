-- local Colours = require("src.colours").colours

local utils = {}


local shadowShader = love.graphics.newShader([[
    vec4 effect(vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
        vec4 pixel = Texel(tex, texCoords);
        if (pixel.a == 0.0) {
            // Keep transparent pixels untouched
            return vec4(0.0, 0.0, 0.0, 0.0);
        }
        // Overwrite non-transparent pixels with outline color
        return vec4(color.rgb, pixel.a);
    }
]])


function utils.DrawShadow(anim, x, y, rot, scale, ox, oy)
    local outlineColor = {75/255, 90/255, 87/255, 1}

    love.graphics.setShader(shadowShader)
    love.graphics.setColor(outlineColor)

    anim:draw(x + 1, y + 1, rot, scale, scale, ox, oy)

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
end


return utils
