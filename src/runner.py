import pygame
import os
import sys

from canvas import Canvas
from constants import Colour
from controller import Controller
from mixer import Mixer
from debugger import Debugger


def main():
    """
    Set base parameters for game
    """
    pygame.init()

    os.chdir('..')
    base_dir = os.getcwd()

    # Set display parameters
    screen_width = 192
    screen_height = 108
    screen_scale = 5

    # Create screen
    screen = pygame.display.set_mode((screen_width * screen_scale, screen_height * screen_scale))

    # Create runners
    canvas = Canvas(base_dir, screen, screen_width, screen_height, screen_scale)
    mixer = Mixer(base_dir)

    # Set FPS
    fps = 60
    clock = pygame.time.Clock()

    # Create controller
    controller = Controller(screen, screen_width, screen_height, screen_scale, canvas, mixer)
    debugger = Debugger(controller, screen, clock)

    while True:
        run_game(clock, fps, controller, debugger)


def run_game(clock: pygame.time.Clock, fps: int, controller: Controller, debugger: Debugger):
    """
    Main game loop
    """
    controller.update()
    debugger.update()

    pygame.display.flip()
    clock.tick(fps)


if __name__ == '__main__':
    main()
