tokens_dict = {
    0: {'id': 'ammo_brassbullet', 'name': 'brass bullet', 'cost': 0, 'value': 1},
    1: {'id': 'ammo_silverbullet', 'name': 'silver bullet', 'cost': 2, 'value': 2},
    2: {'id': 'ammo_goldbullet', 'name': 'gold bullet', 'cost': 4, 'value': 3},
    3: {'id': 'ammo_titaniumbullet', 'name': 'titanium bullet', 'cost': 7, 'value': 4},
    4: {'id': 'ammo_plutoniumbullet', 'name': 'plutonium bullet', 'cost': 10, 'value': 5},
    5: {'id': 'drink_gin', 'name': 'gin bottle', 'cost': 1, 'value': 3},
    6: {'id': 'drink_beer', 'name': 'beer', 'cost': 1, 'value': 2}
}


class Token:
    def __init__(self, id, name, cost, value):
        self.id = id
        self.name = name.upper()
        self.type = id.split('_')[0]
        self.cost = cost
        self.value = value


def get_tokens():
    tokens = [Token(tokens_dict[i]['id'], tokens_dict[i]['name'], tokens_dict[i]['cost'], tokens_dict[i]['value'])
              for i in range(len(tokens_dict))]

    for t in tokens:
        print(t.id, t.type, t.name, t.cost, t.value)


get_tokens()


