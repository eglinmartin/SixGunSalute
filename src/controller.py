import sys

import pygame
import random

from dataclasses import dataclass

from canvas import Canvas, Sprite
from constants import FontColour, State, Token
from mixer import Mixer
from object import Player, Cursor, Enemy
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

        # Create enemy
        self.enemy = Enemy(self, self.canvas)
        self.objects.append(self.enemy)

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
        self.canvas.camera.update()
        self.canvas.draw_screen()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    if self.player.state == State.IDLE:
                        self.player.shoot()

                if event.key == pygame.K_a:
                    self.player.barrel.spin()

                if event.key == pygame.K_s:
                    self.player.barrel.reload()

    def create_hud(self):
        # Draw player head
        self.canvas.sprites.append(Sprite(image='player_head', x=16, y=18, depth=254, shadow=True))

        # Draw player health
        self.canvas.sprites.append(Sprite(image='meter_health', x=16, y=32, depth=254, shadow=True))
        for i, spr in enumerate(text_to_sprites(str(self.player.health), colour=FontColour.RED)):
            self.canvas.sprites.append(Sprite(image=spr, x=24+(i*4), y=32, depth=254, shadow=True))

        # Draw player money
        self.canvas.sprites.append(Sprite(image='meter_money', x=16, y=42, depth=254, shadow=True))
        for i, spr in enumerate(text_to_sprites(str(self.player.money), colour=FontColour.YELLOW)):
            self.canvas.sprites.append(Sprite(image=spr, x=24+(i*4), y=42, depth=254, shadow=True))

        # Draw enemy head
        self.canvas.sprites.append(Sprite(image='enemy_head', x=self.screen_width-16, y=18, depth=254, shadow=True))

        # Draw player health
        self.canvas.sprites.append(Sprite(image='meter_health', x=self.screen_width-16, y=32, depth=254, shadow=True))
        enemy_health_text = text_to_sprites(str(self.enemy.health), colour=FontColour.RED)
        for i, spr in enumerate(enemy_health_text):
            self.canvas.sprites.append(Sprite(image=spr, x=self.screen_width-20-(len(enemy_health_text)*4)+(i*4), y=32, depth=254, shadow=True))
