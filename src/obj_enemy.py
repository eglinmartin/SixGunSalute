import pygame
import os


class Enemy:
    def __init__(self, screen, screen_size):
        self.hp = 2

        self.x = 106
        self.y = 64

        self.width = 26
        self.height = 28

        self.state = 'idle'
        self.current_sprite = 'enemy1_idle1'
        self.current_index = 0

        self.screen = screen
        self.screen_size = screen_size

        self.last_update = pygame.time.get_ticks()  # Store the current time

    def update(self):
        now = pygame.time.get_ticks()  # Get the current time
        animation_delay = 400

        if self.state == 'idle':
            max_index = 1
            if now - self.last_update > animation_delay:
                self.last_update = now  # Update the last update time
                if self.current_index < max_index:
                    self.current_index += 1
                else:
                    self.current_index = 0
                self.current_sprite = f'enemy1_idle{self.current_index+1}'

