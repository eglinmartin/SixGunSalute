import os
import random

import pygame
from logzero import logger


class Revolver:
    def __init__(self, screen, starting_ammo):
        self.barrel = starting_ammo
        self.active_chamber = -1
        self.can_spin = True
        self.can_shoot = False
        self.screen = screen

        self.spinning = False
        self.spinning_frame = 0
        self.rotation = 0

    def spin(self):
        if self.can_spin:
            self.spinning = True
            self.can_spin = False

    def select_item(self):
        if not self.spinning:
            self.active_chamber = random.randint(0, 5)
            self.can_spin = False
            self.can_shoot = True

    def update(self):
        if self.spinning:
            self.can_shoot = False
            if self.spinning_frame < 36:
                self.spinning_frame +=1
                self.rotation -= 20
            else:
                self.spinning_frame = 0
                self.spinning = False
                self.select_item()

    def shoot(self):
        if self.can_shoot:
            self.barrel[self.active_chamber] = 'empty'
            self.can_spin = True
            self.can_shoot = False
            self.active_chamber = -1

    def draw(self, screen_shake_x):
        base_dir = r"C:\Storage\Coding\Games\SixGunSalute"

        chamber_full_sprite = pygame.image.load(os.path.join(base_dir, 'bin', 'hud', 'chamber_full.png')).convert_alpha()
        chamber_empty_sprite = pygame.image.load(os.path.join(base_dir, 'bin', 'hud', 'chamber_empty.png')).convert_alpha()
        chamber_selected_sprite = pygame.image.load(os.path.join(base_dir, 'bin', 'hud', 'chamber_selected.png')).convert_alpha()

        coordinates = [[58, 23], [65, 28], [65, 35], [58, 40], [51, 35], [51, 28]]

        for i in range(len(self.barrel)):
            if self.barrel[i] == 'empty':
                sprite_scaled = pygame.transform.scale(chamber_empty_sprite, (42, 42))
            else:
                sprite_scaled = pygame.transform.scale(chamber_full_sprite, (42, 42))
            rect = sprite_scaled.get_rect(center=((coordinates[i][0]*6)+screen_shake_x, coordinates[i][1]*6))
            self.screen.blit(sprite_scaled, rect.topleft)

            if self.active_chamber == i:
                sprite_scaled = pygame.transform.scale(chamber_selected_sprite, (42, 42))
                rect = sprite_scaled.get_rect(center=((coordinates[i][0]*6)+screen_shake_x, coordinates[i][1]*6))
                self.screen.blit(sprite_scaled, rect.topleft)

