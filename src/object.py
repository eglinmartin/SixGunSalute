import pygame

from dataclasses import dataclass, field

from numpy.linalg.lapack_lite import xerbla

from constants import Colour, Direction, State
from utils import create_sine_wave, loop_through_sequence


@dataclass()
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

    def __post_init__(self):
        self.counter = 0
        self.base_x = self.x
        self.base_y = self.y
        self.state = State.IDLE

    def update(self):
        pass

    def move(self, direction: Direction, distance: int):
        self.base_x = self.x
        if direction == Direction.LEFT:
            self.x -= distance

    def return_to_xy(self):
        if self.state != State.DEAD:
            if self.x < self.base_x:
                self.x += (self.base_x - self.x)/4
            else:
                self.x = self.base_x


class Player(Object):
    def __init__(self, controller, x, y, depth, shadow):
        super().__init__(x=x, y=y, depth=depth, shadow=shadow)
        self.controller = controller
        self.health = 5
        self.sprite = 'player_idle1'

        self.state = State.IDLE
        self.shoot_timeout = 0

        self.idle_animation = [0, 1]
        self.idle_frame = 0
        self.idle_counter = 0

        self.barrel = Barrel(self, x=2, y=self.controller.screen_height-2, depth=0, sprite='barrel_base', shadow=shadow)

        self.controller.create_object(self.barrel)
        self.controller.create_object(self.barrel.spinner)

    def idle(self):
        self.state = State.IDLE
        self.sprite = 'player_idle1'

    def shoot(self):
        self.state = State.SHOOT
        self.shoot_timeout = 20
        self.sprite = 'player_shoot'

    def update(self):
        if self.state == State.IDLE:
            self.idle_frame, self.idle_counter = loop_through_sequence(self.idle_frame, self.idle_animation, frame_delay=25, counter=self.idle_counter)
            self.sprite = f'player_idle{self.idle_frame+1}'

        if self.shoot_timeout > 0:
            self.shoot_timeout -= 1
        else:
            self.state = State.IDLE


class Enemy(Object):
    def __init__(self, controller, player, x, y, depth, shadow):
        super().__init__(x=x, y=y, depth=depth, shadow=shadow)
        self.controller = controller
        self.health = 5
        self.sprite = 'enemy_idle1'
        self.player = player

        self.state = State.IDLE

        self.speed = 0

        self.barrel = Barrel(self, x=controller.screen_width-2, y=self.controller.screen_height-2, depth=2, sprite='barrel_base', shadow=shadow)
        self.barrel.spinner = Object(x=self.barrel.x, y=self.barrel.y, depth=1,sprite='barrel_chambers', shadow=False)

        self.controller.create_object(self.barrel)
        self.controller.create_object(self.barrel.spinner)

    def update(self):
        if self.state == State.IDLE:
            self.sprite = f'enemy_idle{self.player.idle_frame + 1}'

        elif self.state == State.DEAD:
            if self.speed > 0:
                self.speed = self.speed / 2
            else:
                self.speed = 0

        self.move(direction=Direction.RIGHT, distance=self.speed)

    def move(self, direction, distance):
        self.x += self.speed

    def die(self):
        if self.state == State.IDLE:
            self.state = State.DEAD
            self.speed = 10

class Barrel(Object):
    def __init__(self, player, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)
        self.player = player

        self.coordinates = [
            [self.player.x, 40.5], [self.player.x+7, 45.5],
            [self.player.x+7, 52.5], [self.player.x, 57.5],
            [self.player.x-7, 52.5], [self.player.x-7, 45.5]
        ]
        self.chambers = [Chamber(self.coordinates[i][0], self.coordinates[i][1], depth=2, sprite='chamber_full',
                                 shadow=shadow) for i in range(len(self.coordinates))]
        for chamber in self.chambers:
            self.player.controller.create_object(chamber)

        self.spinner = Object(x=self.x, y=self.y, depth=1, sprite='barrel_chambers', shadow=False)


class Chamber(Object):
    def __init__(self, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)


class Cursor(Object):
    def __init__(self, controller, x, y, depth, sprite, shadow):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, shadow=shadow)
        self.controller = controller

    def update(self):
        self.x = (pygame.mouse.get_pos()[0] / self.controller.screen_scale) + (self.controller.screen_scale / 2)
        self.y = (pygame.mouse.get_pos()[1] / self.controller.screen_scale) + (2 + self.controller.screen_scale / 2)

    def move(self, direction, distance):
        pass

    def return_to_xy(self):
        pass


class Background(Object):
    def __init__(self, x, y, depth, sprite, colour, background):
        super().__init__(x=x, y=y, depth=depth, sprite=sprite, colour=colour, background=background)
        self.scale = 4

    def move(self, direction, distance):
        pass

    def return_to_xy(self):
        pass
