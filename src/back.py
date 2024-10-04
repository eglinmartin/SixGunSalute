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
        self.size = 0
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


