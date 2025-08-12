local Constants = require("src/constants")


local Gun = {
    xy = {2, ScreenHeight-8},
    ammo = {}
}


function Gun:new(owner)
    local obj = {}
    setmetatable(obj, {__index = Gun})
    obj.owner = owner

    for i = 1, 6 do
        obj.ammo[i] = Constants.Tokens.AMMO_BRASSBULLET
    end

    return obj
end


return Gun