import pygame
import os

import room_gunfight
import room_shop


class Controller:
    def __init__(self, screen, screen_size, player, enemy, background, shop, room):
        self.screen = screen
        self.player = player
        self.enemy = enemy
        self.background = background
        self.shop = shop

        self.room = room

        self.base_dir = r"C:\Storage\Coding\Games\SixGunSalute"
        self.scale_factor = 6

        self.screen_size = screen_size

        self.screen_shake = None
        self.screen_shake_x = 0
        self.screen_shake_y = 0
        self.screen_shake_frame = 0

        self.debug_mode = False

        self.money = 0

        self.symbol_health_size = 1
        self.symbol_money_size = 1

    def debug(self):
        my_font = pygame.font.SysFont('Consolas', 16)
        my_font.set_bold(True)

        debug_text = [
            f"DEBUG MODE",
            f"{self.shop.token_size[0]}",
            f"{self.shop.token_size[1]}",
            f"{self.shop.token_size[2]}"
        ]
        for i, text in enumerate(debug_text):
            text_shadow = my_font.render(text, False, (0, 0, 0))
            self.screen.blit(text_shadow, (12, 12 + (i * 20)))
            text_main = my_font.render(text, False, (255, 255, 255))
            self.screen.blit(text_main, (10, 10 + (i * 20)))

    def shake_screen(self):
        adjuster = []
        if self.screen_shake == 'shoot_right':
            adjuster = [0, 0, -35, -50, -40, -30, -25, -20, -17.5, -15, -12.5, -10, 8, 6, 4, 3, 2, 1, 0]

        if self.screen_shake_frame < len(adjuster):
            self.screen_shake_x = adjuster[self.screen_shake_frame]
            self.screen_shake_frame += 1
        else:
            self.screen_shake = None
            self.screen_shake_frame = 0

    def subtract_health(self):
        if self.player.hp > 0:
            self.player.hp -= 1
            self.symbol_health_size = 4
            self.player.state = 'hurt'

    def add_money(self):
        self.player.money += 1
        self.symbol_money_size = 4

    def animate_hud(self):
        if self.symbol_money_size > 1:
            self.symbol_money_size -= 0.2
        if self.symbol_health_size > 1:
            self.symbol_health_size -= 0.2

    def update(self):
        # Add screen-shake
        self.shake_screen()

        # Add hud animations
        self.animate_hud()

        # Draw everything
        self.draw()

    def draw(self):
        # Draw background
        self.draw_sprite('background', 'background_1',
                         x=self.screen_size['width']/12, y=self.screen_size['height']/12, rot=self.background.rotation,
                         scale=6+(self.background.size/6))

        if self.room == 'gunfight':
            room_gunfight.draw_room(self)

        elif self.room == 'shop':
            room_shop.draw_room(self)

    def draw_sprite(self, sprite_dir, sprite_name, x, y, rot, scale):
        sprite_img = (pygame.image.load(os.path.join(self.base_dir, 'bin', sprite_dir, f'{sprite_name}.png'))
                      .convert_alpha())
        sprite_img_scaled = pygame.transform.scale(sprite_img, (sprite_img.get_width()*scale, sprite_img.get_height()*scale))
        sprite_img_rotated = pygame.transform.rotate(sprite_img_scaled, rot)
        rect = sprite_img_rotated.get_rect(center=((x*6)+self.screen_shake_x, (y*6)+self.screen_shake_y))
        self.screen.blit(sprite_img_rotated, rect.topleft)

    def draw_text(self, text, x, y, rot, scale, colour):
        text_list = [x for x in str(text)]
        text_list = ['slash' if t=='/' else t for t in text_list]

        x_addon = 0
        for t in text_list:
            self.draw_sprite('number', f'number_{t}_{colour}', x=x+x_addon, y=y, rot=rot, scale=scale)
            x_addon += 4
            if t == 'slash':
                x_addon += 4
