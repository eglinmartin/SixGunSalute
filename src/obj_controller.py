import pygame
import os


class Controller:
    def __init__(self, screen, screen_size, player, enemy, background):
        self.screen = screen
        self.player = player
        self.enemy = enemy
        self.background = background

        self.base_dir = r"C:\Storage\Coding\Games\SixGunSalute"
        self.scale_factor = 6

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
        # Draw background
        self.draw_sprite('background', 'background_1',
                         x=self.screen_size['width']/12, y=self.screen_size['height']/12, rot=self.background.rotation,
                         scale=6+(self.background.size/6))

        # Draw the hud gun barrel
        self.draw_sprite('hud', 'barrel_shadow', x=-1.5, y=84.5, rot=0, scale=6)
        self.draw_sprite('hud', 'barrel_base', x=-2.5, y=84.5, rot=0, scale=6)
        self.draw_sprite('hud', 'barrel_chambers', x=-2.5, y=84.5, rot=self.player.revolver.rotation, scale=6)

        # Draw the player's hud
        self.draw_sprite('hud', 'player_head', x=18.5, y=12, rot=0, scale=6)

        # Draw the player's revolver
        player_barrel = self.player.revolver.barrel
        coordinates = [[self.player.x-4, 24], [self.player.x+3, 29],
                       [self.player.x+3, 36], [self.player.x-4, 41],
                       [self.player.x-11, 36], [self.player.x-11, 29]]
        for i in range(len(player_barrel)):
            coords = coordinates[i]
            sprite_name = 'chamber_full'
            if player_barrel[i] == 'empty':
                sprite_name = 'chamber_empty'
            self.draw_sprite('hud', sprite_name, x=coords[0], y=coords[1], rot=0, scale=6)
            if i == self.player.revolver.active_chamber:
                self.draw_sprite('hud', 'chamber_selected', x=coords[0], y=coords[1], rot=0, scale=6)

        # Draw the enemy's revolver
        enemy_barrel = self.enemy.revolver.barrel
        coordinates = [[self.enemy.x-4, 24], [self.enemy.x+3, 29],
                       [self.enemy.x+3, 36], [self.enemy.x-4, 41],
                       [self.enemy.x-11, 36], [self.enemy.x-11, 29]]
        for i in range(len(enemy_barrel)):
            coords = coordinates[i]
            sprite_name = 'chamber_full'
            if enemy_barrel[i] == 'empty':
                sprite_name = 'chamber_empty'
            self.draw_sprite('hud', sprite_name, x=coords[0], y=coords[1], rot=0, scale=6)
            if i == self.enemy.revolver.active_chamber:
                self.draw_sprite('hud', 'chamber_selected', x=coords[0], y=coords[1], rot=0, scale=6)

        # Draw the item in the player's revolver
        if self.player.revolver.active_chamber >= 0:
            active_item = self.player.revolver.barrel[self.player.revolver.active_chamber]
            self.draw_sprite('items', active_item, x=16.5, y=73.5, rot=0, scale=6)

        # Draw player
        self.draw_sprite('player', self.player.current_sprite, x=self.player.x, y=self.player.y, rot=0, scale=6)

        if self.player.revolver.can_spin:
            self.draw_sprite('hud', 'tooltip_spin', x=26, y=69, rot=0, scale=6)

        if self.player.revolver.can_shoot:
            self.draw_sprite('hud', 'tooltip_shoot', x=26, y=69, rot=0, scale=6)

        # Draw player
        self.draw_sprite('enemy', self.enemy.current_sprite, x=self.enemy.x, y=self.enemy.y, rot=0, scale=6)

    def draw_sprite(self, sprite_dir, sprite_name, x, y, rot, scale):
        sprite_img = (pygame.image.load(os.path.join(self.base_dir, 'bin', sprite_dir, f'{sprite_name}.png'))
                      .convert_alpha())
        sprite_img_scaled = pygame.transform.scale(sprite_img, (sprite_img.get_width()*scale, sprite_img.get_height()*scale))
        sprite_img_rotated = pygame.transform.rotate(sprite_img_scaled, rot)
        rect = sprite_img_rotated.get_rect(center=((x*6)+self.screen_shake_x, (y*6)+self.screen_shake_y))
        self.screen.blit(sprite_img_rotated, rect.topleft)
