import sys
import pygame

import obj_revolver
import obj_background
import obj_controller
import obj_player


def run_game(screen, player, background, controller):
    for event in pygame.event.get():

        if event.type == pygame.KEYDOWN:

            # Player presses 'A' key to spin the revolver barrel
            if event.key == pygame.K_a:
                player.revolver.spin()

            # Player presses 'X' key to 'shoot' the current item
            if event.key == pygame.K_x:
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

    controller.shake_screen()
    controller.draw()

    player.update()
    player.revolver.update()

    pygame.display.flip()


def main():
    pygame.init()

    screen_size = {'width': 960, 'height': 540, 'scale': 1}
    screen = pygame.display.set_mode((screen_size['width']*screen_size['scale'],
                                      screen_size['height']*screen_size['scale']))
    pygame.display.set_caption("Six-Gun Salute")

    background = obj_background.Background(screen, screen_size)

    player = obj_player.Player(screen, screen_size)
    player.revolver = obj_revolver.Revolver(screen, {i: f'ammo_brassbullet' for i in range(6)})

    controller = obj_controller.Controller(screen, screen_size, player, background)

    while True:
        run_game(screen, player, background, controller)


if __name__ == '__main__':
    main()