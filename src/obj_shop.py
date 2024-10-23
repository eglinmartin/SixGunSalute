import random

import obj_item_dictionary


class Shop:
    def __init__(self, screen):
        self.tokens_library, self.cards_library = obj_item_dictionary.get_tokens()
        self.stock = []

        self.token_size = 1

        self.reroll_shop()

    def reroll_shop(self):
        self.token_size = 3
        self.stock = [self.tokens_library[random.randint(0, len(self.tokens_library)-1)] for i in range(3)]
        self.stock.append(self.cards_library[random.randint(0, len(self.cards_library)-1)])
        self.stock.sort(key=lambda x: x.code)

    def update(self):
        if self.token_size > 1:
            self.token_size -= 0.15
        else:
            self.token_size = 1
