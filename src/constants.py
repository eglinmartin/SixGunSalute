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
