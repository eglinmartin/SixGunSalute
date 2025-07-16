import pygame
import random

from dataclasses import dataclass

from canvas import Canvas
from constants import Colour
from mixer import Mixer
from object import Object, Background, Player


@dataclass
class Controller:
    screen: pygame.Surface
    screen_width: int
    screen_height: int
    screen_scale: int
    canvas: Canvas
    mixer: Mixer

    def __post_init__(self):
        self.objects = []
        self.backgrounds = []

        self.create_object(Player(self, x=58.5, y=64.5, depth=10, shadow=True))
        self.create_object(Background(x=80, y=45, depth=255, sprite='square', colour=Colour.GREEN4, background=True))

        # Create heads-up display
        self.create_object(Object(x=16, y=16, depth=0, sprite='player_head', shadow=True))
        self.create_object(Object(x=8, y=32, depth=0, sprite='meter_health', shadow=True))
        self.create_object(Object(x=8, y=42, depth=0, sprite='meter_money', shadow=True))

    def update(self):
        self.canvas.draw(self.objects)

        for obj in self.objects:
            obj.update()

    def create_object(self, obj):
        self.objects.append(obj)
