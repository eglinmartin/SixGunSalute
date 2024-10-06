import pygame
import os


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
            adjuster = [0, 0, -35, -50, -40, -30, -25, -20, -17.5, -15, -12.5, -10, 8, 6, 4, 3, 2, 1, 0]
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

    def draw_sprite(self, sprite_dir, sprite_name, base_dir, x, y):
        sprite_img = pygame.image.load(os.path.join(base_dir, 'bin', sprite_dir, f'{sprite_name}.png')).convert_alpha()
        scaled_sprite = pygame.transform.scale(sprite_img, (sprite_img.get_width()*6, sprite_img.get_height()*6))
        rect = scaled_sprite.get_rect(center=((x*6)+self.screen_shake_x, y*6))
        self.screen.blit(scaled_sprite, rect.topleft)
