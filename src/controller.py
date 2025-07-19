import sys

import pygame
import random

from dataclasses import dataclass

from canvas import Canvas
from constants import Colour, Direction, FontColour, State
from mixer import Mixer
from object import Object, Background, Player, Enemy, Cursor
from utils import text_to_sprites


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
        self.create_object(Background(x=self.screen_width/2, y=self.screen_height/2, depth=255, sprite='square', colour=Colour.GREEN4, background=True))

        self.player = Player(self, x=self.screen_width*0.33, y=80.5, depth=10, shadow=True)
        self.create_object(self.player)

        self.enemy = Enemy(self, self.player, x=self.screen_width*0.67, y=80.5, depth=10, shadow=True)
        self.create_object(self.enemy)

        # Create heads-up display
        self.create_object(Object(x=20, y=20, depth=1, sprite='player_head', shadow=True))
        self.create_object(Object(x=12, y=40, depth=1, sprite='meter_health', shadow=True))
        self.create_object(Object(x=12, y=52, depth=1, sprite='meter_money', shadow=True))

        # Create cursor
        pygame.mouse.set_visible(False)
        self.create_object(Cursor(self, x=0, y=0, depth=0, sprite='cursor', shadow=True))

    def update(self):
        self.canvas.draw(self.objects)

        for obj in self.objects:
            obj.update()
            obj.return_to_xy()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:

                    if self.player.state == State.IDLE:
                        for obj in self.objects:
                            obj.move(Direction.LEFT, distance=8)
                            self.player.shoot()
                            self.enemy.die()

    def create_object(self, obj):
        self.objects.append(obj)

