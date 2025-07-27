from enum import Enum


class Colour(Enum):
    """
    Stores colour hex codes with names
    """
    GREEN1 = 'AFB381'
    GREEN2 = '8A996D'
    GREEN3 = '66845F'
    GREEN4 = '516C5E'
    GREEN5 = '4B5A57'
    BLACK = '281F23'


class DepthLayer(Enum):
    BACKGROUND = 'background'
    SHADOW = 'shadow'
    FOREGROUND = 'foreground'


class FontColour(Enum):
    RED = 'red'
    WHITE = 'white'
    YELLOW = 'yellow'


class ItemTypes(Enum):
    AMMO = 'ammo'
    HEALTH = 'health'
    EXPLOSIVE = 'explosive'
    MONEY = 'money'


class Direction(Enum):
    LEFT = 'left'
    RIGHT = 'right'
    UP = 'up'
    DOWN = 'down'


class State(Enum):
    IDLE = 0
    SHOOT = 1
    DEAD = 2


class Token(Enum):
    AMMO_BRASSBULLET = 'ammo_brassbullet'
