tokens_dict = {
    0: {'id': 'ammo_brassbullet', 'name': 'brass bullet', 'cost': 0, 'value': 1},
    1: {'id': 'ammo_silverbullet', 'name': 'silver bullet', 'cost': 2, 'value': 2},
    2: {'id': 'ammo_goldbullet', 'name': 'gold bullet', 'cost': 4, 'value': 3},
    3: {'id': 'ammo_titaniumbullet', 'name': 'titanium bullet', 'cost': 7, 'value': 4},
    4: {'id': 'ammo_plutoniumbullet', 'name': 'plutonium bullet', 'cost': 10, 'value': 5},
    5: {'id': 'drink_beer', 'name': 'beer', 'cost': 1, 'value': 2},
    6: {'id': 'drink_gin', 'name': 'gin bottle', 'cost': 1, 'value': 3},
}

# cards_dict = {f'card_{i}_{suit}': {'id': f'card_{i}_{suit}', 'name': f'{i} of {suit}', 'cost': 10, 'value': 0} for i in range(14) for suit in ['hearts', 'spades', 'diamonds', 'clubs']}

cards_dict = {}
suits = ['hearts', 'spades', 'diamonds', 'clubs']
counter = 100
for i in range(13):
    for suit in suits:
        cards_dict.update({counter: {'id': f'card_{i+1}_{suit}', 'name': f'{i+1} OF {suit.upper()}', 'cost': 10, 'value': 0}})
        counter += 1

class Token:
    def __init__(self, code, id, name, cost, value):
        self.code = code
        self.id = id
        self.name = name.upper()
        self.type = id.split('_')[0]
        self.cost = cost
        self.value = value


def get_tokens():
    tokens = [Token(i, tokens_dict[i]['id'], tokens_dict[i]['name'], tokens_dict[i]['cost'], tokens_dict[i]['value'])
              for i in range(len(tokens_dict))]
    cards = [Token(100+i, cards_dict[100+i]['id'], cards_dict[100+i]['name'], cards_dict[100+i]['cost'], cards_dict[100+i]['value'])
              for i in range(len(cards_dict))]
    return tokens, cards
