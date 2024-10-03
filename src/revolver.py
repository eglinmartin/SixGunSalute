import random
from logzero import logger


class Revolver:
    def __init__(self, starting_ammo):
        self.barrel = starting_ammo
        self.active_chamber = 0
        self.can_spin = True
        self.can_shoot = False
        logger.debug(f'Barrel = {self.barrel}')

    def spin(self):
        if self.can_spin:
            self.active_chamber = random.randint(0, 5)
            self.can_spin = False
            self.can_shoot = True
            logger.debug(f'Active = {self.active_chamber} ({self.barrel[self.active_chamber]})')

    def shoot(self):
        if self.can_shoot:
            self.barrel[self.active_chamber] = 'empty'
            self.can_spin = True
            self.can_shoot = False
            logger.debug(f'Active = {self.active_chamber} ({self.barrel[self.active_chamber]})')
            logger.debug(f'Barrel = {self.barrel}')
