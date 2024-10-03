import os
import sys
import random
from logzero import logger
import pygame

import revolver


class Hud:
    def __init__(self):
        pass


class Player:
    def __init__(self, screen, screen_size):
        self.hp = 2
        self.money = 5

        self.revolver = revolver.Revolver({i: f'ammo_brassbullet' for i in range(6)})

        self.width = 23
        self.height = 25
        self.x = 160 * screen_size['scale']
        self.y = 300 * screen_size['scale']
        self.scale = 6

        self.state = 'idle'
        self.actions = ['idle1', 'idle2']
        base_dir = f"C:\Storage\Coding\Games\SixGunSalute"
        self.sprites = [pygame.transform.scale(
            pygame.image.load(os.path.join(base_dir, 'bin', 'player', f'player_{action}.png')),
            (self.scale * self.width, self.scale * self.height)) for action in self.actions]

        self.max_index = len(self.sprites) - 1
        self.current_index = self.max_index

        self.screen = screen
        self.screen_size = screen_size

        self.animation_delay = 400  # Delay in milliseconds between frames
        self.last_update = pygame.time.get_ticks()  # Store the current time

    def update(self):
        now = pygame.time.get_ticks()  # Get the current time
        if now - self.last_update > self.animation_delay:
            self.last_update = now  # Update the last update time
            if self.current_index < self.max_index:
                self.current_index += 1
            else:
                self.current_index = 0
        self.draw()

    def draw(self):
        self.screen.blit(self.sprites[self.current_index], (self.x, self.y))


class Shop:
    def __init__(self):
        pass


def run_game(screen, player):
    for event in pygame.event.get():

        if event.type == pygame.KEYDOWN:

            # Player presses 'A' key to spin the revolver barrel
            if event.key == pygame.K_a:
                player.revolver.spin()

            # Player presses 'X' key to 'shoot' the current item
            if event.key == pygame.K_x:
                player.revolver.shoot()

        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    # Draw background colour to clear screen
    screen.fill(pygame.Color("#516c5e"))

    player.update()

    pygame.display.flip()


def main():
    pygame.init()

    screen_size = {'width': 960, 'height': 540, 'scale': 1}
    screen = pygame.display.set_mode((screen_size['width']*screen_size['scale'],
                                      screen_size['height']*screen_size['scale']))
    pygame.display.set_caption("Six-Gun Salute")

    player = Player(screen, screen_size)

    while True:
        run_game(screen, player)


if __name__ == '__main__':
    main()