import pygame


class Debugger:
    def __init__(self, controller, screen, clock):
        self.font = pygame.font.SysFont(None, 30)
        self.controller = controller
        self.screen = screen
        self.clock = clock

        self.debug_parameters = {
            'fps': clock.get_fps(),
            'health': self.controller.player.health
        }

    def update(self):
        for index, (key, param) in enumerate(self.debug_parameters.items()):
            text = self.font.render(f"{key}: {param}", True, (255, 255, 255))
            self.screen.blit(text, (16, 16 + (32 * index)))
