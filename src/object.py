import pygame

from dataclasses import dataclass, field

from constants import Colour
from utils import create_sine_wave


@dataclass(slots=True)
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

    def update(self):
        self.parse_keybinds()

    def parse_keybinds(self):
        pass

    def loop_through_sequence(self, frame, sequence):
        if frame == len(sequence):
            frame = 0
        else:
            frame += 1
        return frame


class Player(Object):
    def __init__(self, x, y, depth, shadow):
        super().__init__(x=x, y=y, depth=depth, shadow=shadow)
        self.health = 5
        self.sprite = 'player_shoot'


class Background(Object):
    def __init__(self, x, y, depth, sprite, colour, background):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, colour=colour, background=background)

        self.rotation_wave = create_sine_wave(10, 2, 2, 1000)
        self.rotation_frame = 0

        self.scale_wave = create_sine_wave(5, 10, 2, 600)
        self.scale_frame = 0

    def update(self):
        self.rotation = (self.rotation_wave[self.rotation_frame-1])
        self.rotation_frame = self.loop_through_sequence(self.rotation_frame, self.rotation_wave)

        self.scale = abs(1 + self.scale_wave[self.scale_frame-1] / 500)
        self.scale_frame = self.loop_through_sequence(self.scale_frame, self.scale_wave)

