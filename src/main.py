import os
import sys
import numpy as np
from logzero import logger
import pygame

import revolver, back


class Controller:
    def __init__(self, screen, screen_size, player, background):
        self.screen = screen
        self.player = player
        self.background = background

        self.screen_size = screen_size

        self.screen_shake = None
        self.screen_shake_x = 0
        self.screen_shake_y = 0
        self.screen_shake_frame = 0

    def shake_screen(self):
        if self.screen_shake == 'shoot_right':
            adjuster = [-35, -50, -40, -30, -25, -20, -17.5, -15, -12.5, -10, 8, 6, 4, 3, 2, 1, 0]
            if self.screen_shake_frame < len(adjuster):
                self.screen_shake_x = adjuster[self.screen_shake_frame]
                self.screen_shake_frame += 1
            else:
                self.screen_shake = None
                self.screen_shake_frame = 0

    def draw(self):
        base_dir = f"C:\Storage\Coding\Games\SixGunSalute"

        self.draw_background(base_dir)

        self.draw_sprite('hud', 'barrel_base', base_dir, -2.5, 82.5)
        self.draw_sprite('hud', 'barrel_chambers', base_dir, -2.5, 82.5)
        self.draw_sprite('hud', 'player_head', base_dir, 18.5, 12)

        self.player.draw(self.screen_shake_x)
        self.player.revolver.draw(self.screen_shake_x)

        if self.player.revolver.active_chamber >= 0:
            active_item = self.player.revolver.barrel[self.player.revolver.active_chamber]
            if active_item != 'empty':
                self.draw_sprite('items', active_item, base_dir, 16.5+self.screen_shake_x, 71.5)

    def draw_background(self, base_dir):
        background_img = pygame.image.load(os.path.join(base_dir, 'bin', 'background', 'background_1.png')).convert_alpha()
        scaled_background = pygame.transform.scale(background_img, (self.screen_size['width'] + (self.background.size*25), self.screen_size['height'] + (self.background.size*25)))
        rotated_background = pygame.transform.rotate(scaled_background, self.background.rotation)
        rect = rotated_background.get_rect(center=((self.screen_size['width']/2)+self.screen_shake_x, self.screen_size['height']/2))
        self.screen.blit(rotated_background, rect.topleft)
        print(self.screen_shake_x)

    def draw_sprite(self, sprite_dir, sprite_name, base_dir, x, y):
        sprite_img = pygame.image.load(os.path.join(base_dir, 'bin', sprite_dir, f'{sprite_name}.png')).convert_alpha()
        scaled_sprite = pygame.transform.scale(sprite_img, (sprite_img.get_width()*6, sprite_img.get_height()*6))
        rect = scaled_sprite.get_rect(center=((x*6)+self.screen_shake_x*3, y*6))
        self.screen.blit(scaled_sprite, rect.topleft)


class Player:
    def __init__(self, screen, screen_size):
        self.hp = 2
        self.money = 5

        self.revolver = revolver.Revolver(screen, {i: f'ammo_brassbullet' for i in range(6)})

        self.width = 26
        self.height = 28
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

    def draw(self, screen_shake_x):
        self.screen.blit(self.sprites[self.current_index], (300+(screen_shake_x*1), 300))


def run_game(screen, player, background, controller):
    for event in pygame.event.get():

        if event.type == pygame.KEYDOWN:

            # Player presses 'A' key to spin the revolver barrel
            if event.key == pygame.K_a:
                player.revolver.spin()

            # Player presses 'X' key to 'shoot' the current item
            if event.key == pygame.K_x:
                if player.revolver.active_chamber >= 0:
                    if player.revolver.barrel[player.revolver.active_chamber] != 'empty':
                        controller.screen_shake = 'shoot_right'
                player.revolver.shoot()

        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    # Draw background colour to clear screen
    screen.fill(pygame.Color("#4b5a57"))
    background.update()

    controller.draw()
    controller.shake_screen()

    player.update()

    print(controller.screen_shake)

    pygame.display.flip()


def main():
    pygame.init()

    screen_size = {'width': 960, 'height': 540, 'scale': 1}
    screen = pygame.display.set_mode((screen_size['width']*screen_size['scale'],
                                      screen_size['height']*screen_size['scale']))
    pygame.display.set_caption("Six-Gun Salute")

    background = back.Background(screen, screen_size)
    player = Player(screen, screen_size)

    controller = Controller(screen, screen_size, player, background)

    while True:
        run_game(screen, player, background, controller)


if __name__ == '__main__':
    main()