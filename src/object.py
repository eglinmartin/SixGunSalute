import pygame

from abc import ABC, abstractmethod
from dataclasses import dataclass, field

from constants import Colour, Direction, State
from src.canvas import Sprite
from utils import create_sine_wave, loop_through_sequence


class Object(ABC):
    @abstractmethod
    def update(self):
        pass

    def draw(self):
        pass


class Cursor(Object):
    def __init__(self, controller, canvas):
        self.controller = controller
        self.canvas = canvas

        self.xy = [0, 0]
        self.draw()

    def update(self):
        self.xy[0] = (pygame.mouse.get_pos()[0] / self.controller.screen_scale) + (self.controller.screen_scale / 2)
        self.xy[1] = (pygame.mouse.get_pos()[1] / self.controller.screen_scale) + (2 + self.controller.screen_scale / 2)

    def draw(self):
        self.controller.canvas.add_sprite(Sprite('cursor', x=self.xy[0], y=self.xy[1], depth=255, shadow=True))


class Player(Object):
    def __init__(self, controller, canvas):
        self.controller = controller
        self.canvas = canvas

        self.xy = [self.controller.screen_width*0.33, 80.5]
        self.health = 10
        self.money = 10

        self.state = State.IDLE
        self.shoot_cooldown = 0

        self.animation_frame = 0
        self.animation_counter = 0

        self.sprite = Sprite(image='player_idle1', x=self.xy[0], y=self.xy[1], depth=10, shadow=True)

        self.barrel = Barrel(self)
        self.controller.objects.append(self.barrel)

    def idle(self):
        self.state = State.IDLE

    def shoot(self):
        self.state = State.SHOOT
        self.shoot_cooldown = 20

    def update(self):
        if self.shoot_cooldown > 0:
            self.shoot_cooldown -= 1
        else:
            self.shoot_cooldown = 0
            self.idle()

    def draw(self):
        if self.state == State.IDLE:
            self.animation_frame, self.animation_counter = loop_through_sequence(self.animation_frame, [0, 1], frame_delay=25, counter=self.animation_counter)
            self.sprite.image = f'player_idle{self.animation_frame+1}'

        elif self.state == State.SHOOT:
            self.sprite.image = f'player_shoot'

        self.canvas.add_sprite(self.sprite)


class Barrel:
    def __init__(self, player):
        self.xy = [2, player.controller.screen_height-2]
        self.player = player
        self.draw()

    def update(self):
        pass

    def draw(self):
        self.player.canvas.add_sprite(Sprite(image='barrel_base', x=-2, y=self.player.controller.screen_height-2, depth=253, shadow=True))
        self.player.canvas.add_sprite(Sprite(image='barrel_chambers', x=-2, y=self.player.controller.screen_height-2, depth=254, shadow=True))

        coordinates = [
            [self.player.xy[0], 40.5], [self.player.xy[0]+7, 45.5],
            [self.player.xy[0]+7, 52.5], [self.player.xy[0], 57.5],
            [self.player.xy[0]-7, 52.5], [self.player.xy[0]-7, 45.5]
        ]
        for coord_set in coordinates:
            self.player.canvas.add_sprite(Sprite(image='chamber_full', x=coord_set[0], y=coord_set[1],
                                                 depth=253, shadow = True))
