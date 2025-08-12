local Class = require("src/hump/class")
local Constants = require("src/constants")
local Gun = Class{}


function Gun:init(owner)
    self.owner = owner
    self.xy = {2, ScreenHeight - 8}
    self.ammo = {}

    for i = 1, 6 do
        self.ammo[i] = Constants.Tokens.AMMO_BRASSBULLET
    end
    
end


return Gun