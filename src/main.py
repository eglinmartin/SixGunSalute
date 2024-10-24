import sys
import pygame

import obj_revolver
import obj_background
import obj_controller
import obj_player
import obj_enemy
import obj_shop
import obj_navigator


def run_game(screen, player, enemy, background, shop, controller):
    for event in pygame.event.get():

        if event.type == pygame.KEYDOWN:

            # Player presses 'A' key to spin the revolver barrel
            if event.key == pygame.K_a:
                if controller.room == 'gunfight':
                    player.revolver.spin()

            # Enable debug mode processes
            if event.key == pygame.K_BACKQUOTE:
                controller.debug_mode = not controller.debug_mode

            if event.key == pygame.K_1:
                if controller.debug_mode:
                    controller.subtract_health()

            if event.key == pygame.K_2:
                if controller.debug_mode:
                    controller.add_money()

            if event.key == pygame.K_3:
                if controller.debug_mode:
                    player.revolver.barrel = {i: 'ammo_brassbullet' for i in range(6)}

            if event.key == pygame.K_7:
                if controller.debug_mode:
                    controller.room = 'mainmenu'

            if event.key == pygame.K_8:
                if controller.debug_mode:
                    controller.room = 'gunfight'

            if event.key == pygame.K_9:
                if controller.debug_mode:
                    controller.room = 'shop'

            if event.key == pygame.K_0:
                if controller.debug_mode:
                    if controller.room == 'shop':
                        if shop.can_reroll:
                            shop.reroll_shop()

            if event.key == pygame.K_MINUS:
                if controller.room == 'shop':
                    shop.rotate_revolver('left')

            if event.key == pygame.K_EQUALS:
                if controller.room == 'shop':
                    shop.rotate_revolver('right')

            # Player presses 'X' key to 'shoot' the current item
            if event.key == pygame.K_x:
                if controller.room == 'gunfight':
                    if player.revolver.can_shoot:
                        if player.revolver.active_chamber >= 0:
                            if player.revolver.barrel[player.revolver.active_chamber] != 'empty':
                                controller.screen_shake = 'shoot_right'
                        player.revolver.shoot()
                        player.state = 'shoot'

        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    # Draw background colour to clear screen
    screen.fill(pygame.Color("#4b5a57"))
    background.update()

    enemy.update()

    player.update()
    player.revolver.update()

    shop.update()

    controller.shake_screen()
    controller.update()

    if controller.debug_mode:
        controller.debug()

    pygame.display.flip()


def main():
    pygame.init()

    screen_size = {'width': 960, 'height': 540, 'scale': 1}
    screen = pygame.display.set_mode((screen_size['width']*screen_size['scale'],
                                      screen_size['height']*screen_size['scale']))
    pygame.display.set_caption("Six-Gun Salute")

    room = 'mainmenu'

    background = obj_background.Background(screen, screen_size)

    player = obj_player.Player(screen, screen_size)
    player.revolver = obj_revolver.Revolver(screen, {i: f'ammo_brassbullet' for i in range(6)})

    enemy = obj_enemy.Enemy(screen, screen_size, player)
    enemy.revolver = obj_revolver.Revolver(screen, {i: f'ammo_brassbullet' for i in range(6)})

    shop = obj_shop.Shop(screen, player)

    navigator = obj_navigator.Navigator(screen)

    controller = obj_controller.Controller(screen, screen_size, player, enemy, background, shop, navigator, room)

    while True:
        run_game(screen, player, enemy, background, shop, controller)


if __name__ == '__main__':
    main()