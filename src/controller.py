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

        # self.create_object(Background(x=int(self.screen_width/2), y=int(self.screen_height/2), depth=255, sprite='square', colour=Colour.GREEN4, background=True))

        self.create_object(Player(x=48.5, y=64.5, depth=10, shadow=True, background=False))

        self.create_object(Background(x=80, y=45, depth=255, sprite='square', colour=Colour.GREEN4, background=True))


    def update(self):
        self.canvas.draw(self.objects)

        for obj in self.objects:
            obj.update()

    def create_object(self, obj):
        self.objects.append(obj)
