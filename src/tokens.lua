local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")

local items_list = {}

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

    local columnsPerRow = math.floor(self.sprite_sheet_image:getWidth() / 15)
    local x = ((self.id - 1) % columnsPerRow) + 1
    local y = math.floor((id - 1) / columnsPerRow) + 1

    self.sprite = anim8.newAnimation(sprite_sheet(x, y), 1)
end


local Card = Class{}
function Card:init(id, type, name, ability_type, ability_val, active)
    self.id = id
    self.type = type
    self.name = name
    self.ability_type = ability_type
    self.ability_val = ability_val
    self.active = active

    self.sprite_sheet_image = love.graphics.newImage('assets/sprites/cards.png')
    local sprite_sheet = anim8.newGrid(11, 15, self.sprite_sheet_image:getWidth(), self.sprite_sheet_image:getHeight(), 0, 0, 1)

    local columnsPerRow = math.floor(self.sprite_sheet_image:getWidth() / 11) - 1
    local x = ((self.id - 1) % columnsPerRow) + 1
    local y = math.floor((id - 1) / columnsPerRow) + 1

    self.sprite = anim8.newAnimation(sprite_sheet(x, y), 1)
end


local token_list = {
    AMMO_BRASSBULLET = Token(1, 'AMMO', 'Brass bullet', AbilityTypes.DAMAGE, 2, true),
    AMMO_SILVERBULLET = Token(2, 'AMMO', 'Silver bullet', AbilityTypes.DAMAGE, 2, false),
    AMMO_GOLDBULLET = Token(3, 'AMMO', 'Gold bullet', AbilityTypes.DAMAGE, 2, false),
    AMMO_TITANIUMBULLET = Token(4, 'AMMO', 'Titanium bullet', AbilityTypes.DAMAGE, 2, false),
    AMMO_PLUTONIUMBULLET = Token(5, 'AMMO', 'Plutonium bullet', AbilityTypes.DAMAGE, 2, false),
    HEALTH_GIN = Token(6, 'HEALTH', 'Gin', AbilityTypes.HEALTH, 2, false),
    HEALTH_WHISKY = Token(7, 'HEALTH', 'Whisky', AbilityTypes.HEALTH, 2, false),
    HEALTH_COFFEE = Token(8, 'HEALTH', 'Coffee', AbilityTypes.HEALTH, 2, false),
    HEALTH_BEANS = Token(9, 'HEALTH', 'Beans', AbilityTypes.HEALTH, 2, false),
    HEALTH_BREAD = Token(10, 'HEALTH', 'Bread', AbilityTypes.HEALTH, 2, false),
    HEALTH_BISCUITS = Token(11, 'HEALTH', 'Biscuits', AbilityTypes.HEALTH, 2, false),
    HEALTH_HEALTHPACK = Token(12, 'HEALTH', 'Health pack', AbilityTypes.HEALTH, 2, false),
    EXPLOSIVE_DYNAMITE = Token(13, 'EXPLOSIVE', 'Dynamite', AbilityTypes.DAMAGE, 2, false),
    EXPLOSIVE_BOMB = Token(14, 'EXPLOSIVE', 'Bomb', AbilityTypes.DAMAGE, 2, false),
    EXPLOSIVE_GUNPOWDERBARREL = Token(15, 'EXPLOSIVE', 'Gunpowder barrel', AbilityTypes.DAMAGE, 2, false),
    EXPLOSIVE_SHOTGUN = Token(16, 'EXPLOSIVE', 'Shotgun', AbilityTypes.DAMAGE, 2, false),
    MONEY_BAG = Token(17, 'MONEY', 'Bag of money', AbilityTypes.MONEY, 2, false),
    MONEY_TREASURE_CHEST = Token(18, 'MONEY', 'Treasure chest', AbilityTypes.MONEY, 2, false)
}


local card_list = {
    CARD_2_HEARTS = Card(1, 'CARD', '2 of hearts', AbilityTypes.HEALTH, 2, false),
    CARD_3_HEARTS = Card(2, 'CARD', '3 of hearts', AbilityTypes.HEALTH, 3, false),
    CARD_4_HEARTS = Card(3, 'CARD', '4 of hearts', AbilityTypes.HEALTH, 4, false),
    CARD_5_HEARTS = Card(4, 'CARD', '5 of hearts', AbilityTypes.HEALTH, 5, false),
    CARD_6_HEARTS = Card(5, 'CARD', '6 of hearts', AbilityTypes.HEALTH, 6, false),
    CARD_7_HEARTS = Card(6, 'CARD', '7 of hearts', AbilityTypes.HEALTH, 7, false),
    CARD_8_HEARTS = Card(7, 'CARD', '8 of hearts', AbilityTypes.HEALTH, 8, false),
    CARD_9_HEARTS = Card(8, 'CARD', '9 of hearts', AbilityTypes.HEALTH, 9, false),
    CARD_10_HEARTS = Card(9, 'CARD', '10 of hearts', AbilityTypes.HEALTH, 10, false),
    CARD_J_HEARTS = Card(10, 'CARD', 'Jack of hearts', AbilityTypes.HEALTH, 11, false),
    CARD_Q_HEARTS = Card(11, 'CARD', 'Queen of hearts', AbilityTypes.HEALTH, 12, false),
    CARD_K_HEARTS = Card(12, 'CARD', 'King of hearts', AbilityTypes.HEALTH, 13, false),
    CARD_A_HEARTS = Card(13, 'CARD', 'Ace of hearts', AbilityTypes.HEALTH, 15, false),
    CARD_2_DIAMONDS = Card(14, 'CARD', '2 of diamonds', AbilityTypes.MONEY, 2, false),
    CARD_3_DIAMONDS = Card(15, 'CARD', '3 of diamonds', AbilityTypes.MONEY, 3, false),
    CARD_4_DIAMONDS = Card(16, 'CARD', '4 of diamonds', AbilityTypes.MONEY, 4, false),
    CARD_5_DIAMONDS = Card(17, 'CARD', '5 of diamonds', AbilityTypes.MONEY, 5, false),
    CARD_6_DIAMONDS = Card(18, 'CARD', '6 of diamonds', AbilityTypes.MONEY, 6, false),
    CARD_7_DIAMONDS = Card(19, 'CARD', '7 of diamonds', AbilityTypes.MONEY, 7, false),
    CARD_8_DIAMONDS = Card(20, 'CARD', '8 of diamonds', AbilityTypes.MONEY, 8, false),
    CARD_9_DIAMONDS = Card(21, 'CARD', '9 of diamonds', AbilityTypes.MONEY, 9, false),
    CARD_10_DIAMONDS = Card(22, 'CARD', '10 of diamonds', AbilityTypes.MONEY, 10, false),
    CARD_J_DIAMONDS = Card(23, 'CARD', 'Jack of diamonds', AbilityTypes.MONEY, 11, false),
    CARD_Q_DIAMONDS = Card(24, 'CARD', 'Queen of diamonds', AbilityTypes.MONEY, 12, false),
    CARD_K_DIAMONDS = Card(25, 'CARD', 'King of diamonds', AbilityTypes.MONEY, 13, false),
    CARD_A_DIAMONDS = Card(26, 'CARD', 'Ace of diamonds', AbilityTypes.MONEY, 15, false),
    CARD_2_CLUBS = Card(27, 'CARD', '2 of clubs', AbilityTypes.LUCK, 2, false),
    CARD_3_CLUBS = Card(28, 'CARD', '3 of clubs', AbilityTypes.LUCK, 3, false),
    CARD_4_CLUBS = Card(29, 'CARD', '4 of clubs', AbilityTypes.LUCK, 4, false),
    CARD_5_CLUBS = Card(30, 'CARD', '5 of clubs', AbilityTypes.LUCK, 5, false),
    CARD_6_CLUBS = Card(31, 'CARD', '6 of clubs', AbilityTypes.LUCK, 6, false),
    CARD_7_CLUBS = Card(32, 'CARD', '7 of clubs', AbilityTypes.LUCK, 7, false),
    CARD_8_CLUBS = Card(33, 'CARD', '8 of clubs', AbilityTypes.LUCK, 8, false),
    CARD_9_CLUBS = Card(34, 'CARD', '9 of clubs', AbilityTypes.LUCK, 9, false),
    CARD_10_CLUBS = Card(35, 'CARD', '10 of clubs', AbilityTypes.LUCK, 10, false),
    CARD_J_CLUBS = Card(36, 'CARD', 'Jack of clubs', AbilityTypes.LUCK, 11, false),
    CARD_Q_CLUBS = Card(37, 'CARD', 'Queen of clubs', AbilityTypes.LUCK, 12, false),
    CARD_K_CLUBS = Card(38, 'CARD', 'King of clubs', AbilityTypes.LUCK, 13, false),
    CARD_A_CLUBS = Card(39, 'CARD', 'Ace of clubs', AbilityTypes.LUCK, 15, false),
    CARD_2_SPADES = Card(40, 'CARD', '2 of spades', AbilityTypes.DAMAGE, 2, false),
    CARD_3_SPADES = Card(41, 'CARD', '3 of spades', AbilityTypes.DAMAGE, 3, false),
    CARD_4_SPADES = Card(42, 'CARD', '4 of spades', AbilityTypes.DAMAGE, 4, false),
    CARD_5_SPADES = Card(43, 'CARD', '5 of spades', AbilityTypes.DAMAGE, 5, false),
    CARD_6_SPADES = Card(44, 'CARD', '6 of spades', AbilityTypes.DAMAGE, 6, false),
    CARD_7_SPADES = Card(45, 'CARD', '7 of spades', AbilityTypes.DAMAGE, 7, false),
    CARD_8_SPADES = Card(46, 'CARD', '8 of spades', AbilityTypes.DAMAGE, 8, false),
    CARD_9_SPADES = Card(47, 'CARD', '9 of spades', AbilityTypes.DAMAGE, 9, false),
    CARD_10_SPADES = Card(48, 'CARD', '10 of spades', AbilityTypes.DAMAGE, 10, false),
    CARD_J_SPADES = Card(49, 'CARD', 'Jack of spades', AbilityTypes.DAMAGE, 11, false),
    CARD_Q_SPADES = Card(50, 'CARD', 'Queen of spades', AbilityTypes.DAMAGE, 12, false),
    CARD_K_SPADES = Card(51, 'CARD', 'King of spades', AbilityTypes.DAMAGE, 13, false),
    CARD_A_SPADES = Card(52, 'CARD', 'Ace of spades', AbilityTypes.DAMAGE, 15, false)
}


return {Tokens = token_list, Cards = card_list}