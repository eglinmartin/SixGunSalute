local anim8 = require("src/libraries/anim8")
local Class = require("src/libraries/class")


AbilityTypes = {
    DAMAGE = 'damage',
    HEALTH = 'health',
    EXPLOSIVE = 'explosive',
    MONEY = 'money',
    DEFENCE = 'defence'
}


Token = Class{}
function Token:init(id, type, name, ability_type, ability_val, discovered, canvas)
    self.id = id
    self.type = type
    self.name = name
    self.ability_type = ability_type
    self.ability_val = ability_val
    self.discovered = discovered

    local columnsPerRow = math.floor(canvas.sprite_sheets.tokens[1]:getWidth() / 15)
    local x = ((self.id - 1) % columnsPerRow) + 1
    local y = math.floor((id - 1) / columnsPerRow) + 1
    self.sprite = anim8.newAnimation(canvas.sprite_sheets.tokens[2](x, y), 1)
end


Card = Class{}
function Card:init(id, type, name, cost, ability_val, active, canvas)
    self.id = id
    self.type = type
    self.name = name
    self.cost = cost
    self.ability_val = ability_val
    self.active = active

    local columnsPerRow = math.floor(canvas.sprite_sheets.cards[1]:getWidth() / 11) - 1
    local x = ((self.id - 1) % columnsPerRow) + 1
    local y = math.floor((self.id - 1) / columnsPerRow) + 1

    self.sprite = anim8.newAnimation(canvas.sprite_sheets.cards[2](x, y), 1)
    self.sprite_large = anim8.newAnimation(canvas.sprite_sheets.cards_large[2](x, y), 1)
end


local function generate_tokens(canvas)
    return {
        AMMO_BRASSBULLET = Token(1, 'AMMO', 'Brass bullet', 1, 1, true, canvas),
        AMMO_SILVERBULLET = Token(2, 'AMMO', 'Silver bullet', 2, 2, false, canvas),
        AMMO_GOLDBULLET = Token(3, 'AMMO', 'Gold bullet', 3, 5, false, canvas),
        AMMO_TITANIUMBULLET = Token(4, 'AMMO', 'Titanium bulle\\\\\\\\\\\\t', 5, 10, false, canvas),
        AMMO_PLUTONIUMBULLET = Token(5, 'AMMO', 'Plutonium bullet', 10, 15, false, canvas),
        HEALTH_GIN = Token(6, 'HEALTH', 'Gin', 5, 2, false, canvas),
        HEALTH_WHISKY = Token(7, 'HEALTH', 'Whisky', 5, 2, false, canvas),
        HEALTH_COFFEE = Token(8, 'HEALTH', 'Coffee', 5, 2, false, canvas),
        HEALTH_BEANS = Token(9, 'HEALTH', 'Beans', AbilityTypes.HEALTH, 2, false, canvas),
        HEALTH_BREAD = Token(10, 'HEALTH', 'Bread', AbilityTypes.HEALTH, 2, false, canvas),
        HEALTH_BISCUITS = Token(11, 'HEALTH', 'Biscuits', AbilityTypes.HEALTH, 2, false, canvas),
        HEALTH_HEALTHPACK = Token(12, 'HEALTH', 'Health pack', AbilityTypes.HEALTH, 2, false, canvas),
        EXPLOSIVE_DYNAMITE = Token(13, 'EXPLOSIVE', 'Dynamite', AbilityTypes.DAMAGE, 2, false, canvas),
        EXPLOSIVE_BOMB = Token(14, 'EXPLOSIVE', 'Bomb', AbilityTypes.DAMAGE, 2, false, canvas),
        EXPLOSIVE_GUNPOWDERBARREL = Token(15, 'EXPLOSIVE', 'Gunpowder barrel', AbilityTypes.DAMAGE, 2, false, canvas),
        EXPLOSIVE_SHOTGUN = Token(16, 'EXPLOSIVE', 'Shotgun', AbilityTypes.DAMAGE, 2, false, canvas),
        MONEY_BAG = Token(17, 'MONEY', 'Bag of money', AbilityTypes.MONEY, 5, false, canvas),
        MONEY_TREASURE_CHEST = Token(18, 'MONEY', 'Treasure chest', AbilityTypes.MONEY, 50, false, canvas),
        HEALTH_CIGARETTES = Token(19, 'HEALTH', 'Cigarettes', AbilityTypes.HEALTH, 2, false, canvas),
        MONEY_DOLLAR_BILL = Token(20, 'MONEY', 'Dollar bill', AbilityTypes.MONEY, 5, false, canvas),
        EXPLOSIVE_TNT = Token(21, 'EXPLOSIVE', 'TNT', AbilityTypes.EXPLOSIVE, 2, false, canvas),
        DEFENCE_STOVEPIPE = Token(22, 'DEFENCE', 'Stove-pipe', AbilityTypes.DEFENCE, 2, false, canvas),
        DEFENCE_STETSON = Token(23, 'DEFENCE', 'Stetson', AbilityTypes.DEFENCE, 2, false, canvas),
        DEFENCE_GAMBLER = Token(24, 'DEFENCE', 'Gambler', AbilityTypes.DEFENCE, 2, false, canvas),
        EXPLOSIVE_ANVIL = Token(25, 'EXPLOSIVE', 'Anvil', AbilityTypes.EXPLOSIVE, 2, false, canvas),
        EXPLOSIVE_PIANO = Token(26, 'EXPLOSIVE', 'Piano', AbilityTypes.EXPLOSIVE, 2, false, canvas),
        MONEY_GEM = Token(27, 'MONEY', 'Gem', AbilityTypes.MONEY, 10, false, canvas),
        MONEY_PILE_OF_MONEY = Token(28, 'MONEY', 'Pile of money', AbilityTypes.MONEY, 25, false, canvas)
    }
end


local function generate_cards(canvas)
    return {
        CARD_A_HEARTS = Card(1, 'CARD', 'Ace of hearts', AbilityTypes.HEALTH, 1, false, canvas),
        CARD_2_HEARTS = Card(2, 'CARD', '2 of hearts', AbilityTypes.HEALTH, 2, false, canvas),
        CARD_3_HEARTS = Card(3, 'CARD', '3 of hearts', AbilityTypes.HEALTH, 3, false, canvas),
        CARD_4_HEARTS = Card(4, 'CARD', '4 of hearts', AbilityTypes.HEALTH, 4, false, canvas),
        CARD_5_HEARTS = Card(5, 'CARD', '5 of hearts', AbilityTypes.HEALTH, 5, false, canvas),
        CARD_6_HEARTS = Card(6, 'CARD', '6 of hearts', AbilityTypes.HEALTH, 6, false, canvas),
        CARD_7_HEARTS = Card(7, 'CARD', '7 of hearts', AbilityTypes.HEALTH, 7, false, canvas),
        CARD_8_HEARTS = Card(8, 'CARD', '8 of hearts', AbilityTypes.HEALTH, 8, false, canvas),
        CARD_9_HEARTS = Card(9, 'CARD', '9 of hearts', AbilityTypes.HEALTH, 9, false, canvas),
        CARD_10_HEARTS = Card(10, 'CARD', '10 of hearts', AbilityTypes.HEALTH, 10, false, canvas),
        CARD_J_HEARTS = Card(11, 'CARD', 'Jack of hearts', AbilityTypes.HEALTH, 11, false, canvas),
        CARD_Q_HEARTS = Card(12, 'CARD', 'Queen of hearts', AbilityTypes.HEALTH, 12, false, canvas),
        CARD_K_HEARTS = Card(13, 'CARD', 'King of hearts', AbilityTypes.HEALTH, 13, false, canvas),
        CARD_AH_HEARTS = Card(14, 'CARD', 'High Ace of hearts', AbilityTypes.HEALTH, 15, false, canvas),
        CARD_A_DIAMONDS = Card(15, 'CARD', 'Ace of diamonds', AbilityTypes.MONEY, 1, false, canvas),
        CARD_2_DIAMONDS = Card(16, 'CARD', '2 of diamonds', AbilityTypes.MONEY, 2, false, canvas),
        CARD_3_DIAMONDS = Card(17, 'CARD', '3 of diamonds', AbilityTypes.MONEY, 3, false, canvas),
        CARD_4_DIAMONDS = Card(18, 'CARD', '4 of diamonds', AbilityTypes.MONEY, 4, false, canvas),
        CARD_5_DIAMONDS = Card(19, 'CARD', '5 of diamonds', AbilityTypes.MONEY, 5, false, canvas),
        CARD_6_DIAMONDS = Card(20, 'CARD', '6 of diamonds', AbilityTypes.MONEY, 6, false, canvas),
        CARD_7_DIAMONDS = Card(21, 'CARD', '7 of diamonds', AbilityTypes.MONEY, 7, false, canvas),
        CARD_8_DIAMONDS = Card(22, 'CARD', '8 of diamonds', AbilityTypes.MONEY, 8, false, canvas),
        CARD_9_DIAMONDS = Card(23, 'CARD', '9 of diamonds', AbilityTypes.MONEY, 9, false, canvas),
        CARD_10_DIAMONDS = Card(24, 'CARD', '10 of diamonds', AbilityTypes.MONEY, 10, false, canvas),
        CARD_J_DIAMONDS = Card(25, 'CARD', 'Jack of diamonds', AbilityTypes.MONEY, 11, false, canvas),
        CARD_Q_DIAMONDS = Card(26, 'CARD', 'Queen of diamonds', AbilityTypes.MONEY, 12, false, canvas),
        CARD_K_DIAMONDS = Card(27, 'CARD', 'King of diamonds', AbilityTypes.MONEY, 13, false, canvas),
        CARD_AH_DIAMONDS = Card(28, 'CARD', 'High Ace of diamonds', AbilityTypes.MONEY, 15, false, canvas),
        CARD_A_CLUBS = Card(29, 'CARD', 'Ace of clubs', AbilityTypes.LUCK, 1, false, canvas),
        CARD_2_CLUBS = Card(30, 'CARD', '2 of clubs', AbilityTypes.LUCK, 2, false, canvas),
        CARD_3_CLUBS = Card(31, 'CARD', '3 of clubs', AbilityTypes.LUCK, 3, false, canvas),
        CARD_4_CLUBS = Card(32, 'CARD', '4 of clubs', AbilityTypes.LUCK, 4, false, canvas),
        CARD_5_CLUBS = Card(33, 'CARD', '5 of clubs', AbilityTypes.LUCK, 5, false, canvas),
        CARD_6_CLUBS = Card(34, 'CARD', '6 of clubs', AbilityTypes.LUCK, 6, false, canvas),
        CARD_7_CLUBS = Card(35, 'CARD', '7 of clubs', AbilityTypes.LUCK, 7, false, canvas),
        CARD_8_CLUBS = Card(36, 'CARD', '8 of clubs', AbilityTypes.LUCK, 8, false, canvas),
        CARD_9_CLUBS = Card(37, 'CARD', '9 of clubs', AbilityTypes.LUCK, 9, false, canvas),
        CARD_10_CLUBS = Card(38, 'CARD', '10 of clubs', AbilityTypes.LUCK, 10, false, canvas),
        CARD_J_CLUBS = Card(39, 'CARD', 'Jack of clubs', AbilityTypes.LUCK, 11, false, canvas),
        CARD_Q_CLUBS = Card(40, 'CARD', 'Queen of clubs', AbilityTypes.LUCK, 12, false, canvas),
        CARD_K_CLUBS = Card(41, 'CARD', 'King of clubs', AbilityTypes.LUCK, 13, false, canvas),
        CARD_AH_CLUBS = Card(42, 'CARD', 'High Ace of clubs', AbilityTypes.LUCK, 15, false, canvas),
        CARD_A_SPADES = Card(43, 'CARD', 'Ace of spades', AbilityTypes.DAMAGE, 1, false, canvas),
        CARD_2_SPADES = Card(44, 'CARD', '2 of spades', AbilityTypes.DAMAGE, 2, false, canvas),
        CARD_3_SPADES = Card(45, 'CARD', '3 of spades', AbilityTypes.DAMAGE, 3, false, canvas),
        CARD_4_SPADES = Card(46, 'CARD', '4 of spades', AbilityTypes.DAMAGE, 4, false, canvas),
        CARD_5_SPADES = Card(47, 'CARD', '5 of spades', AbilityTypes.DAMAGE, 5, false, canvas),
        CARD_6_SPADES = Card(48, 'CARD', '6 of spades', AbilityTypes.DAMAGE, 6, false, canvas),
        CARD_7_SPADES = Card(49, 'CARD', '7 of spades', AbilityTypes.DAMAGE, 7, false, canvas),
        CARD_8_SPADES = Card(50, 'CARD', '8 of spades', AbilityTypes.DAMAGE, 8, false, canvas),
        CARD_9_SPADES = Card(51, 'CARD', '9 of spades', AbilityTypes.DAMAGE, 9, false, canvas),
        CARD_10_SPADES = Card(52, 'CARD', '10 of spades', AbilityTypes.DAMAGE, 10, false, canvas),
        CARD_J_SPADES = Card(53, 'CARD', 'Jack of spades', AbilityTypes.DAMAGE, 11, false, canvas),
        CARD_Q_SPADES = Card(54, 'CARD', 'Queen of spades', AbilityTypes.DAMAGE, 12, false, canvas),
        CARD_K_SPADES = Card(55, 'CARD', 'King of spades', AbilityTypes.DAMAGE, 13, false, canvas),
        CARD_AH_SPADES = Card(56, 'CARD', 'High Ace of spades', AbilityTypes.DAMAGE, 15, false, canvas)
    }
end


return {
  Token = Token,
  Card = Card,
  AbilityTypes = AbilityTypes,
  generate_tokens = generate_tokens,
  generate_cards = generate_cards
}