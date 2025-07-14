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

        self.background = Object(x=int(self.screen_width/2), y=int(self.screen_height/2), depth=255,
                                 sprite='square', colour=Colour.GREEN4)
        self.objects.append(self.background)


    def update(self):
        self.canvas.draw(self.objects)

        for obj in self.objects:
            obj.update()

    def create_object(self, obj):
        self.objects.append(obj)
