import os
import pygame

from dataclasses import dataclass


@dataclass
class Mixer:
    base_dir: str

    # Start mixer
    pygame.mixer.init(channels=8)

    def play_sound(self, input_type, channel: int):
        ogg = f'{str(input_type).lower().split('.')[1]}.ogg'

        sound = pygame.mixer.Sound(os.path.join(self.base_dir, 'ogg', ogg))
        pygame.mixer.Channel(channel).play(sound)
