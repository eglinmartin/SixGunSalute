local Class = require("lib.class")
local peachy = require("lib.peachy")

local Card = Class{}
local Deck = Class{}


function Card:init(value, suit, name)
    self.value = value
    self.suit = suit
    self.name = name
end


Cards = {
    -- Hearts
    CARD_2_HEARTS  = Card('2', 'hearts',  '2 of hearts'),
    CARD_3_HEARTS  = Card('3', 'hearts',  '3 of hearts'),
    CARD_4_HEARTS  = Card('4', 'hearts',  '4 of hearts'),
    CARD_5_HEARTS  = Card('5', 'hearts',  '5 of hearts'),
    CARD_6_HEARTS  = Card('6', 'hearts',  '6 of hearts'),
    CARD_7_HEARTS  = Card('7', 'hearts',  '7 of hearts'),
    CARD_8_HEARTS  = Card('8', 'hearts',  '8 of hearts'),
    CARD_9_HEARTS  = Card('9', 'hearts',  '9 of hearts'),
    CARD_10_HEARTS = Card('10', 'hearts', '10 of hearts'),
    CARD_J_HEARTS  = Card('jack', 'hearts',  'jack of hearts'),
    CARD_Q_HEARTS  = Card('queen', 'hearts',  'queen of hearts'),
    CARD_K_HEARTS  = Card('king', 'hearts',  'king of hearts'),
    CARD_A_HEARTS  = Card('ace', 'hearts',  'ace of hearts'),

    -- Clubs
    CARD_2_CLUBS  = Card('2', 'clubs',  '2 of clubs'),
    CARD_3_CLUBS  = Card('3', 'clubs',  '3 of clubs'),
    CARD_4_CLUBS  = Card('4', 'clubs',  '4 of clubs'),
    CARD_5_CLUBS  = Card('5', 'clubs',  '5 of clubs'),
    CARD_6_CLUBS  = Card('6', 'clubs',  '6 of clubs'),
    CARD_7_CLUBS  = Card('7', 'clubs',  '7 of clubs'),
    CARD_8_CLUBS  = Card('8', 'clubs',  '8 of clubs'),
    CARD_9_CLUBS  = Card('9', 'clubs',  '9 of clubs'),
    CARD_10_CLUBS = Card('10', 'clubs', '10 of clubs'),
    CARD_J_CLUBS  = Card('jack', 'clubs',  'jack of clubs'),
    CARD_Q_CLUBS  = Card('queen', 'clubs',  'queen of clubs'),
    CARD_K_CLUBS  = Card('king', 'clubs',  'king of clubs'),
    CARD_A_CLUBS  = Card('ace', 'clubs',  'ace of clubs'),

    -- Spades
    CARD_2_SPADES  = Card('2', 'spades',  '2 of spades'),
    CARD_3_SPADES  = Card('3', 'spades',  '3 of spades'),
    CARD_4_SPADES  = Card('4', 'spades',  '4 of spades'),
    CARD_5_SPADES  = Card('5', 'spades',  '5 of spades'),
    CARD_6_SPADES  = Card('6', 'spades',  '6 of spades'),
    CARD_7_SPADES  = Card('7', 'spades',  '7 of spades'),
    CARD_8_SPADES  = Card('8', 'spades',  '8 of spades'),
    CARD_9_SPADES  = Card('9', 'spades',  '9 of spades'),
    CARD_10_SPADES = Card('10', 'spades', '10 of spades'),
    CARD_J_SPADES  = Card('jack', 'spades',  'jack of spades'),
    CARD_Q_SPADES  = Card('queen', 'spades',  'queen of spades'),
    CARD_K_SPADES  = Card('king', 'spades',  'king of spades'),
    CARD_A_SPADES  = Card('ace', 'spades',  'ace of spades'),

    -- Diamonds
    CARD_2_DIAMONDS  = Card('2', 'diamonds',  '2 of diamonds'),
    CARD_3_DIAMONDS  = Card('3', 'diamonds',  '3 of diamonds'),
    CARD_4_DIAMONDS  = Card('4', 'diamonds',  '4 of diamonds'),
    CARD_5_DIAMONDS  = Card('5', 'diamonds',  '5 of diamonds'),
    CARD_6_DIAMONDS  = Card('6', 'diamonds',  '6 of diamonds'),
    CARD_7_DIAMONDS  = Card('7', 'diamonds',  '7 of diamonds'),
    CARD_8_DIAMONDS  = Card('8', 'diamonds',  '8 of diamonds'),
    CARD_9_DIAMONDS  = Card('9', 'diamonds',  '9 of diamonds'),
    CARD_10_DIAMONDS = Card('10', 'diamonds', '10 of diamonds'),
    CARD_J_DIAMONDS  = Card('jack', 'diamonds',  'jack of diamonds'),
    CARD_Q_DIAMONDS  = Card('queen', 'diamonds',  'queen of diamonds'),
    CARD_K_DIAMONDS  = Card('king', 'diamonds',  'king of diamonds'),
    CARD_A_DIAMONDS  = Card('ace', 'diamonds',  'ace of diamonds'),
}


function Deck:init()
    -- Create pack of cards
    self.card_pack = {}
    for _, card in pairs(Cards) do
        table.insert(self.card_pack, card)
    end

    self.deck = {}
    self:shuffle()

    self.player_cards = {}
    self.enemy_cards = {}

    self:deal_cards()

    self.animations = {}
    self:refresh_sprites()
end


function Deck:shuffle()
    -- Copy the pack of cards
    self.deck = {}
    for i, card in ipairs(self.card_pack) do
        self.deck[i] = card
    end

    
    -- Shuffle the deck
    for i = #self.deck, 2, -1 do
        local j = math.random(i)
        self.deck[i], self.deck[j] = self.deck[j], self.deck[i]
    end

end


function Deck:deal_cards()
    for _, card in pairs(Cards) do
        table.insert(self.deck, card)
    end

    
    self.player_cards = {self.deck[1], self.deck[3], self.deck[5]}
    self.enemy_cards = {self.deck[2], self.deck[4], self.deck[6]}
end


function Deck:refresh_sprites()
    for i, card in ipairs(self.player_cards) do
        local json_file = "assets/json/cards_" .. card.suit .. ".json"
        local img_file  = "assets/sprites/cards_" .. card.suit .. ".png"
        self.animations["player_card" .. i] = {sprite = peachy.new(json_file, love.graphics.newImage(img_file), card.value), x = 9.5 + (9 * i), y = 77.5 + (3 * i)}
    end

    
    for i, card in ipairs(self.enemy_cards) do
        local json_file = "assets/json/cards_" .. card.suit .. ".json"
        local img_file  = "assets/sprites/cards_" .. card.suit .. ".png"
        self.animations["enemy_card" .. i] = {sprite = peachy.new(json_file, love.graphics.newImage(img_file), card.value), x = 183.5 - (9 * i), y = 77.5 + (3 * i)}
    end

end


function Deck:draw(sprites)
    for i, card in ipairs(self.player_cards) do
        table.insert(sprites, self.animations["player_card" .. i])
    end

    
    for i, card in ipairs(self.enemy_cards) do
        table.insert(sprites, self.animations["enemy_card" .. i])
    end
end


return Deck
