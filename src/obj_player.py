import pygame
import os


class Player:
    def __init__(self, screen, screen_size):
        self.hp = 2
        self.money = 5

        self.width = 26
        self.height = 28
        self.scale = 6

        self.state = 'idle'
        self.actions = ['idle1', 'idle2']
        self.max_index = 0
        self.ticker = 0

        self.current_index = self.max_index

        self.screen = screen
        self.screen_size = screen_size

        self.animation_delay = 400  # Delay in milliseconds between frames
        self.last_update = pygame.time.get_ticks()  # Store the current time

    def update(self):
        now = pygame.time.get_ticks()  # Get the current time

        if self.state == 'idle':
            self.actions = ['idle1', 'idle2']
            if now - self.last_update > self.animation_delay:
                self.last_update = now  # Update the last update time
                if self.current_index < self.max_index:
                    self.current_index += 1
                else:
                    self.current_index = 0

        elif self.state == 'shoot':
            self.actions = ['shoot']
            if self.ticker < 60:
                self.current_index = 0
                self.ticker += 1
            else:
                self.ticker = 0
                self.state = 'idle'

    def draw(self, screen_shake_x):
        base_dir = r"C:\Storage\Coding\Games\SixGunSalute"
        sprites = [pygame.transform.scale(
            pygame.image.load(os.path.join(base_dir, 'bin', 'player', f'player_{action}.png')),
            (self.scale * self.width, self.scale * self.height)) for action in self.actions]
        self.max_index = len(sprites) - 1
        self.screen.blit(sprites[self.current_index], (300+screen_shake_x, 300))
