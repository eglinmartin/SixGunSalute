import pygame
import os
import sys

from canvas import Canvas
from constants import Colour
from controller import Controller
from mixer import Mixer
from utils import create_sine_wave, rgb


def main():
    """
    Set base parameters for game
    """
    pygame.init()

    os.chdir('..')
    base_dir = os.getcwd()

    # Set display parameters
    screen_width = 160
    screen_height = 90
    screen_scale = 8

    # Create screen
    screen = pygame.display.set_mode((screen_width * screen_scale, screen_height * screen_scale))

    # Create runners
    canvas = Canvas(base_dir, screen, screen_width, screen_height, screen_scale)
    mixer = Mixer(base_dir)

    # Create controller
    controller = Controller(screen, screen_width, screen_height, screen_scale, canvas, mixer)

    # Set FPS
    fps = 60
    clock = pygame.time.Clock()

    while True:
        run_game(screen, clock, fps, controller)


def run_game(screen: pygame.Surface,
             clock: pygame.time.Clock,
             fps: int,
             controller: Controller):
    """
    Main game loop
    """
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    controller.update()

    pygame.display.flip()
    clock.tick(fps)


if __name__ == '__main__':
    main()
