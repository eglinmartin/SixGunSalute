import pygame
import random

from abc import ABC, abstractmethod
from dataclasses import dataclass, field

from constants import Colour, Direction, State, Token
from src.canvas import Sprite
from utils import create_sine_wave, loop_through_sequence, return_to_xy


class Object(ABC):
    @abstractmethod
    def update(self):
        pass

    def draw(self):
        pass


class Cursor(Object):
    def __init__(self, controller, canvas):
        self.controller = controller
        self.canvas = canvas

        self.xy = [0, 0]

    def update(self):
        self.xy[0] = (pygame.mouse.get_pos()[0] / self.controller.screen_scale) + (self.controller.screen_scale / 2)
        self.xy[1] = (pygame.mouse.get_pos()[1] / self.controller.screen_scale) + (2 + self.controller.screen_scale / 2)

    def draw(self):
        self.controller.canvas.add_sprite(Sprite('cursor', x=self.xy[0], y=self.xy[1], depth=255, shadow=True))


class Enemy(Object):
    def __init__(self, controller, canvas):
        self.controller = controller
        self.canvas = canvas

        self.base_xy = [self.controller.screen_width*0.67, self.controller.player.xy[1]]
        self.xy = [self.controller.screen_width*0.67, self.controller.player.xy[1]]

        self.health = 5

        self.state = State.IDLE
        self.sprite = Sprite(image='enemy_idle1', x=self.xy[0], y=self.xy[1], depth=10, shadow=True)

    def update(self, return_speed=8, tolerance=0.1):
        if self.xy != self.base_xy:
            self.xy = return_to_xy(self.xy, self.base_xy)

    def hit(self):
        self.xy[0] += 20

    def draw(self):
        if self.state == State.IDLE:
            self.sprite.image = f'enemy_idle{self.controller.player.animation_frame+1}'
        self.canvas.sprites.append(Sprite(image=self.sprite.image, x=self.xy[0], y=self.xy[1], depth=254, shadow=True))


class Player(Object):
    def __init__(self, controller, canvas):
        self.controller = controller
        self.canvas = canvas

        self.xy = [self.controller.screen_width*0.33, 75.5]
        self.health = 5
        self.money = 10

        self.state = State.IDLE
        self.shoot_cooldown = 0

        self.animation_frame = 0
        self.animation_counter = 0

        self.sprite = Sprite(image='player_idle1', x=self.xy[0], y=self.xy[1], depth=10, shadow=True)

        self.barrel = Barrel(self)
        self.controller.objects.append(self.barrel)

    def idle(self):
        self.state = State.IDLE

    def shoot(self):
        if self.barrel.selected_chamber is not None:
            self.state = State.SHOOT
            self.barrel.shoot()
            self.shoot_cooldown = 20
            self.canvas.camera.xy[0] -= 32

            self.controller.enemy.hit()

    def update(self):
        if self.shoot_cooldown > 0:
            self.shoot_cooldown -= 1
        else:
            self.shoot_cooldown = 0
            self.idle()

    def draw(self):
        if self.state == State.IDLE:
            self.animation_frame, self.animation_counter = loop_through_sequence(self.animation_frame, [0, 1], frame_delay=25, counter=self.animation_counter)
            self.sprite.image = f'player_idle{self.animation_frame+1}'

        elif self.state == State.SHOOT:
            self.sprite.image = f'player_shoot'

        self.canvas.add_sprite(self.sprite)


class Barrel:
    def __init__(self, player):
        self.xy = [2, player.controller.screen_height-8]
        self.player = player

        self.selected_chamber = 0
        self.selected_item = None

        self.chambers = [Token.AMMO_BRASSBULLET] * 6
        self.chambers_scale = [1] * 6

        self.rotation = 0

        self.can_spin = True
        self.spin_cooldown = 0

    def spin(self):
        if self.can_spin:
            self.selected_chamber = None
            self.selected_item = None
            self.spin_cooldown = 30
            self.can_spin = False

    def shoot(self):
        self.chambers[self.selected_chamber] = None
        self.selected_chamber = None
        self.selected_item = None

    def reload(self):
        if None in self.chambers:
            for i, chamber in enumerate(self.chambers):
                if not chamber:
                    self.chambers[i] = Token.AMMO_BRASSBULLET
                    self.chambers_scale[i] += 0.5

    def update(self):
        if not self.can_spin:
            self.spin_cooldown -= 1
            self.rotation -= 15

            if self.spin_cooldown <= 0:
                self.spin_cooldown = 0
                self.selected_chamber = random.randint(0, 5)

                self.selected_item = self.chambers[self.selected_chamber]
                    
                self.can_spin = True
                self.rotation = 0

        for i, chamber_scale in enumerate(self.chambers_scale):
            if self.chambers_scale[i] > 1:
                self.chambers_scale[i] -= 0.05
            else:
                self.chambers_scale[i] = 1

    def draw(self):
        self.player.canvas.add_sprite(Sprite(image='barrel_base', x=self.xy[0], y=self.xy[1], depth=253, shadow=True))
        self.player.canvas.add_sprite(Sprite(image='barrel_chambers', x=self.xy[0], y=self.xy[1], depth=254,
                                             rotation=self.rotation, shadow=True))

        if self.selected_item:
            self.player.canvas.add_sprite(Sprite(image=self.selected_item.value, x=21, y=89, depth=254))

        coordinates = [
            [self.player.xy[0], 35], [self.player.xy[0]+7, 40],
            [self.player.xy[0]+7, 47], [self.player.xy[0], 52],
            [self.player.xy[0]-7, 47], [self.player.xy[0]-7, 40]
        ]
        for i, chamber in enumerate(self.chambers):
            sprite_img = 'chamber_empty'
            if chamber:
                sprite_img = 'chamber_full'

            self.player.canvas.add_sprite(Sprite(image=sprite_img, x=coordinates[i][0], y=coordinates[i][1],
                                                 depth=252, shadow=True, scale=self.chambers_scale[i]))

            if i == self.selected_chamber:
                self.player.canvas.add_sprite(Sprite(image='chamber_selected', x=coordinates[i][0],
                                                     y=coordinates[i][1], depth=253, shadow=True))
