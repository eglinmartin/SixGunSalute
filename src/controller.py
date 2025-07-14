import pygame
import random

from dataclasses import dataclass

from canvas import Canvas
from constants import Colour
from mixer import Mixer
from object import Object


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

        for i in range(64):
            self.create_object(Object(
                x=random.randint(0, self.screen_width), y=random.randint(0, self.screen_height),
                depth=(random.randint(0, 10)/10), sprite='square', colour=Colour.M_BLUE, rotation=0,
                scale=self.screen_scale * random.randint(0, 10), shadow=True
            ))

    def update(self):
        self.canvas.draw(self.objects)

        for obj in self.objects:
            obj.update()

    def create_object(self, obj):
        self.objects.append(obj)
