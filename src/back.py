import numpy as np
import pygame
import os

class Background:
    def __init__(self, screen, screen_size):
        self.rotation_wave = np.sin(np.linspace(0, 2 * np.pi, 1280))
        self.size_wave = np.sin(np.linspace(0, 2 * np.pi, 1920))
        self.rotframe = 0
        self.sizeframe = 0
        self.rotation = 0
        self.screen = screen
        self.screen_size = screen_size

    def update(self):
        self.rotation = self.rotation_wave[self.rotframe]
        if self.rotframe == 1279:
            self.rotframe = 0
        else:
            self.rotframe += 1

        self.size = self.size_wave[self.sizeframe]
        if self.sizeframe == 1919:
            self.sizeframe = 0
        else:
            self.sizeframe += 1

    def draw(self):
        base_dir = f"C:\Storage\Coding\Games\SixGunSalute"
        background_img = pygame.image.load(os.path.join(base_dir, 'bin', 'background', 'background_1.png')).convert_alpha()
        scaled_background = pygame.transform.scale(background_img, (self.screen_size['width'] + (self.size*50), self.screen_size['height'] + (self.size*50)))
        rotated_background = pygame.transform.rotate(scaled_background, self.rotation)
        rect = rotated_background.get_rect(center=(self.screen_size['width']/2, self.screen_size['height']/2))
        self.screen.blit(rotated_background, rect.topleft)
