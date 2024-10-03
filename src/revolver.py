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
        logger.debug(f'Barrel = {self.barrel}')

    def spin(self):
        if self.can_spin:
            self.active_chamber = random.randint(0, 5)
            self.can_spin = False
            self.can_shoot = True
            logger.debug(f'Active = {self.active_chamber} ({self.barrel[self.active_chamber]})')

    def shoot(self):
        if self.can_shoot:
            self.barrel[self.active_chamber] = 'empty'
            self.can_spin = True
            self.can_shoot = False
            logger.debug(f'Active = {self.active_chamber} ({self.barrel[self.active_chamber]})')
            logger.debug(f'Barrel = {self.barrel}')
            self.active_chamber = -1

    def draw(self):
        base_dir = f"C:\Storage\Coding\Games\SixGunSalute"

        chamber_full_sprite = pygame.image.load(os.path.join(base_dir, 'bin', 'hud', 'chamber_full.png')).convert_alpha()
        chamber_empty_sprite = pygame.image.load(os.path.join(base_dir, 'bin', 'hud', 'chamber_empty.png')).convert_alpha()
        chamber_selected_sprite = pygame.image.load(os.path.join(base_dir, 'bin', 'hud', 'chamber_selected.png')).convert_alpha()

        coordinates = [[59, 24], [66, 29], [66, 36], [59, 41], [52, 36], [52, 29]]

        for i in range(len(self.barrel)):
            if self.barrel[i] == 'empty':
                sprite_scaled = pygame.transform.scale(chamber_empty_sprite, (42, 42))
            else:
                sprite_scaled = pygame.transform.scale(chamber_full_sprite, (42, 42))
            rect = sprite_scaled.get_rect(center=(coordinates[i][0]*6, coordinates[i][1]*6))
            self.screen.blit(sprite_scaled, rect.topleft)

            if self.active_chamber == i:
                sprite_scaled = pygame.transform.scale(chamber_selected_sprite, (42, 42))
                rect = sprite_scaled.get_rect(center=(coordinates[i][0]*6, coordinates[i][1]*6))
                self.screen.blit(sprite_scaled, rect.topleft)

