import random

import obj_item_dictionary


class Shop:
    def __init__(self, screen, player):
        self.tokens_library, self.cards_library = obj_item_dictionary.get_tokens()
        self.rolled_stock = []
        self.stock = []

        self.player = player

        self.token_size = [1, 1, 1]
        self.shop_animation_frame = 0
        self.revolver_rotation = 0

        self.can_reroll = True
        self.reroll_shop()
        self.stock = self.rolled_stock

    def reroll_shop(self):
        self.can_reroll = False
        self.shop_animation_frame = 20

        self.rolled_stock = [self.tokens_library[random.randint(0, len(self.tokens_library)-1)] for i in range(3)]
        self.rolled_stock.append(self.cards_library[random.randint(0, len(self.cards_library)-1)])
        self.rolled_stock.sort(key=lambda x: x.code)

    def rotate_revolver(self, direction):
        if direction == 'right':
            if self.revolver_rotation > 0:
                self.revolver_rotation -= 1
            else:
                self.revolver_rotation = 5

        if direction == 'left':
            if self.revolver_rotation < 5:
                self.revolver_rotation += 1
            else:
                self.revolver_rotation = 0

    def update(self):
        animation_actions = {0: 20, 1: 15, 2: 10}
        for act in animation_actions:
            if self.shop_animation_frame == animation_actions[act]:
                self.token_size[act] = 3
                self.stock[act] = self.rolled_stock[act]
        if self.shop_animation_frame > 0:
            self.shop_animation_frame -= 1
        else:
            self.shop_animation_frame = 0
            self.can_reroll = True

        for i, t in enumerate(self.token_size):
            if t > 1:
                self.token_size[i] -= 0.15
            else:
                self.token_size[i] = 1