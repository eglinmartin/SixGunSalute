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

        self.barrel = Barrel(self, x=-3.5, y=85.5, depth=0, sprite='barrel_base', shadow=shadow)
        self.controller.create_object(self.barrel)

    def update(self):
        self.idle_frame = loop_through_sequence(self.idle_frame, self.idle_animation, frame_delay=30, counter=self.counter)
        self.sprite = f'player_idle{self.idle_frame+1}'


class Barrel(Object):
    def __init__(self, player, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)
        self.player = player

        self.coordinates = [
            [self.player.x-3, 25.5], [self.player.x+4, 30.5],
            [self.player.x+4, 37.5], [self.player.x-3, 42.5],
            [self.player.x-10, 37.5], [self.player.x-10, 30.5]
        ]
        self.chambers = [Chamber(self.coordinates[i][0], self.coordinates[i][1], depth=0,
                                 sprite='chamber_full', shadow=shadow) for i in range(len(self.coordinates))]
        for chamber in self.chambers:
            self.player.controller.create_object(chamber)


class Chamber(Object):
    def __init__(self, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)



class Background(Object):
    def __init__(self, x, y, depth, sprite, colour, background):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, colour=colour, background=background)

        self.rotation_wave = create_sine_wave(10, 2, 2, 1000)
        self.rotation_frame = 0

        self.scale_wave = create_sine_wave(5, 10, 2, 600)
        self.scale_frame = 0

    def update(self):
        self.rotation = (self.rotation_wave[self.rotation_frame-1])
        self.rotation_frame = loop_through_sequence(self.rotation_frame, self.rotation_wave, frame_delay=1, counter=0)

        self.scale = abs(1 + self.scale_wave[self.scale_frame-1] / 500)
        self.scale_frame = loop_through_sequence(self.scale_frame, self.scale_wave, frame_delay=1, counter=0)

