import pygame

from dataclasses import dataclass, field

from constants import Colour


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

    def update(self):
        self.parse_keybinds()

    def parse_keybinds(self):
        pass


class Player(Object):
    def __init__(self):
        super.__init__()


class Background(Object):
    def __init__(self):
        super.__init__()

