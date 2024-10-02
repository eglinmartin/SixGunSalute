import sys
import pygame


def run_game(screen):
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    pygame.display.flip()


def main():
    pygame.init()

    screen_size = {'width': 640, 'height': 360, 'scale': 1}
    screen = pygame.display.set_mode((screen_size['width']*screen_size['scale'],
                                      screen_size['height']*screen_size['scale']))
    pygame.display.set_caption("Six-Gun Salute")

    screen.fill(pygame.Color("#516c5e"))

    while True:
        run_game(screen)


if __name__ == '__main__':
    main()