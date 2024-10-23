import random

import obj_item_dictionary


class Shop:
    def __init__(self, screen):
        self.tokens_library, self.cards_library = obj_item_dictionary.get_tokens()
        self.stock = []
        self.reroll_shop()

    def reroll_shop(self):
        self.stock = [self.tokens_library[random.randint(0, len(self.tokens_library)-1)] for i in range(3)]
        self.stock.append(self.cards_library[random.randint(0, len(self.cards_library)-1)])
        self.stock.sort(key=lambda x: x.code)
