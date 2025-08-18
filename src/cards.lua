local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")


local Token = Class{}
function Token:init(id, type, name, ability_type, ability_val, discovered)
    self.id = id
    self.type = type
    self.name = name
    self.ability_type = ability_type
    self.ability_val = ability_val
    self.discovered = discovered

    self.sprite = anim8.newAnimation(self.canvas.sprite_sheets.tokens[1](id, 1), 1)
end


local card_list = {
}


return token_list