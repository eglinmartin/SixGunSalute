import sys

import pygame
import random

from dataclasses import dataclass

from canvas import Canvas, Sprite
from constants import Colour, Direction, FontColour, State
from mixer import Mixer
from object import Player, Cursor
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

        # Create player
        self.player = Player(self, self.canvas)
        self.objects.append(self.player)

        # Create cursor
        pygame.mouse.set_visible(False)
        self.cursor = Cursor(self, self.canvas)
        self.objects.append(self.cursor)

    def update(self):
        self.canvas.sprites = []

        for obj in self.objects:
            obj.update()
            obj.draw()

        self.canvas.add_sprite(Sprite(image='square', x=int(self.screen_width/2), y=int(self.screen_height/2), depth=0,
                                      background=True, scale=4))

        self.create_hud()
        self.canvas.draw_screen()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:

                    if self.player.state == State.IDLE:
                        self.player.shoot()
                            # self.enemy.die()

    def create_hud(self):
        # Draw heads
        self.canvas.sprites.append(Sprite(image='player_head', x=16, y=18, depth=254, shadow=True))

        # Draw player health
        self.canvas.sprites.append(Sprite(image='meter_health', x=16, y=32, depth=254, shadow=True))
        for i, spr in enumerate(text_to_sprites(str(self.player.health), colour=FontColour.RED)):
            self.canvas.sprites.append(Sprite(image=spr, x=24+(i*4), y=32, depth=254, shadow=True))

        # Draw player money
        self.canvas.sprites.append(Sprite(image='meter_money', x=16, y=42, depth=254, shadow=True))
        for i, spr in enumerate(text_to_sprites(str(self.player.money), colour=FontColour.YELLOW)):
            self.canvas.sprites.append(Sprite(image=spr, x=24+(i*4), y=42, depth=254, shadow=True))
