local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")




AbilityTypes = {
    DAMAGE = 'damage',
    HEALTH = 'health',
    EXPLOSIVE = 'explosive',
    MONEY = 'money'
}


local Token = Class{}
function Token:init(id, type, name, ability_type, ability_val, discovered)
    self.id = id
    self.type = type
    self.name = name
    self.ability_type = ability_type
    self.ability_val = ability_val
    self.discovered = discovered

    self.sprite_sheet_image = love.graphics.newImage('assets/sprites/items.png')
    local sprite_sheet = anim8.newGrid(15, 15, self.sprite_sheet_image:getWidth(), self.sprite_sheet_image:getHeight(), 0, 0, 1)
    self.sprite = anim8.newAnimation(sprite_sheet(id, 1), 1)
end


local token_list = {
    AMMO_BRASSBULLET = Token(1, 'AMMO', 'Brass bullet', AbilityTypes.DAMAGE, 2, true),
    AMMO_SILVERBULLET = Token(2, 'AMMO', 'Silver bullet', AbilityTypes.DAMAGE, 2, true),
    AMMO_GOLDBULLET = Token(3, 'AMMO', 'Gold bullet', AbilityTypes.DAMAGE, 2, true),
    AMMO_TITANIUMBULLET = Token(4, 'AMMO', 'Titanium bullet', AbilityTypes.DAMAGE, 2, true),
    AMMO_PLUTONIUMBULLET = Token(5, 'AMMO', 'Plutonium bullet', AbilityTypes.DAMAGE, 2, true),
    HEALTH_GIN = Token(6, 'HEALTH', 'Gin', AbilityTypes.DAMAGE, 2, true)
}


return token_list