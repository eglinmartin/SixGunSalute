from enum import Enum

class Colour(Enum):
    """
    Stores colour hex codes with names
    """
    WHITE = 'E2D9E4'
    L_GREEN = '6C9A9A'
    M_GREEN = '52675D'
    D_GREEN = '37403B'
    L_BLUE = '7C8FB2'
    M_BLUE = '4C5274'
    D_BLUE = '2E334D'
    H_BLUE = '1F2025'
    BLACK = '281F23'

class DepthLayer(Enum):
    SHADOW = 'shadow'
    FOREGROUND = 'foreground'
