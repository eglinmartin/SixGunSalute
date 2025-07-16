import pygame

from dataclasses import dataclass, field

from constants import Colour
from utils import create_sine_wave, loop_through_sequence


@dataclass()
class Object:
    x: int
    y: int
    depth: float
    rotation: int = field(default=0)
    scale: int = field(default=1)
    shadow: bool = field(default=False)
    sprite: str = field(default=False)
    colour: Colour = field(default=None)
    background: bool = field(default=False)

    def __post_init__(self):
        self.counter = 0

    def update(self):
        self.parse_keybinds()

    def parse_keybinds(self):
        pass


class Player(Object):
    def __init__(self, controller, x, y, depth, shadow):
        super().__init__(x=x, y=y, depth=depth, shadow=shadow)
        self.controller = controller
        self.health = 5
        self.sprite = 'player_idle1'

        self.idle_animation = [0, 1]
        self.idle_frame = 0

        self.barrel = Barrel(self, x=2, y=self.controller.screen_height-2, depth=0, sprite='barrel_base', shadow=shadow)
        self.controller.create_object(self.barrel)

    def update(self):
        self.idle_frame = loop_through_sequence(self.idle_frame, self.idle_animation, frame_delay=30, counter=self.counter)
        self.sprite = f'player_idle{self.idle_frame+1}'


class Enemy(Object):
    def __init__(self, controller, x, y, depth, shadow):
        super().__init__(x=x, y=y, depth=depth, shadow=shadow)
        self.controller = controller
        self.health = 5
        self.sprite = 'enemy_idle1'

        self.idle_animation = [0, 1]
        self.idle_frame = 0

        self.barrel = Barrel(self, x=controller.screen_width-2, y=self.controller.screen_height-2, depth=2, sprite='barrel_base', shadow=shadow)
        self.controller.create_object(self.barrel)

    def update(self):
        self.idle_frame = loop_through_sequence(self.idle_frame, self.idle_animation, frame_delay=30, counter=self.counter)
        self.sprite = f'enemy_idle{self.idle_frame+1}'


class Barrel(Object):
    def __init__(self, player, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)
        self.player = player

        self.coordinates = [
            [self.player.x, 40.5], [self.player.x+7, 45.5],
            [self.player.x+7, 52.5], [self.player.x, 57.5],
            [self.player.x-7, 52.5], [self.player.x-7, 45.5]
        ]
        self.chambers = [Chamber(self.coordinates[i][0], self.coordinates[i][1], depth=2, sprite='chamber_full',
                                 shadow=shadow) for i in range(len(self.coordinates))]
        for chamber in self.chambers:
            self.player.controller.create_object(chamber)


class Chamber(Object):
    def __init__(self, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)


class Cursor(Object):
    def __init__(self, controller, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)
        self.controller = controller

    def update(self):
        self.x = (pygame.mouse.get_pos()[0] / self.controller.screen_scale) + (self.controller.screen_scale / 2)
        self.y = (pygame.mouse.get_pos()[1] / self.controller.screen_scale) + (2 + self.controller.screen_scale / 2)


class Background(Object):
    def __init__(self, x, y, depth, sprite, colour, background):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, colour=colour, background=background)
        self.scale = 4

