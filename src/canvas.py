import pygame

from dataclasses import dataclass, field

from constants import Colour, DepthLayer
from utils import rgb, load_sprites


@dataclass()
class Sprite:
    image: str
    x: int
    y: int
    depth: float

    rotation: int = field(default=0)
    scale: int = field(default=1)
    sprite_img: str = field(default=False)
    colour: Colour = field(default=None)

    background: bool = field(default=False)
    shadow: bool = field(default=False)


@dataclass
class Canvas:
    base_dir: str
    screen: pygame.Surface
    screen_width: int
    screen_height: int
    screen_scale: int

    def __post_init__(self):
        # Load sprites from bin directory
        self.sprites_from_file = load_sprites(self)
        self.recolored_cache = {}
        self.sprites = []

        self.surfaces = {}
        for depth_layer_type in DepthLayer:
            self.surfaces[depth_layer_type] = self.generate_layer_surface(depth_layer_type)

    def generate_layer_surface(self, depth_layer_type: DepthLayer):
        """
        Creates new layer surfaces for each layer in objects list
        """
        # Create shadow layer for selected depth
        layer = pygame.Surface((
            self.screen_width * self.screen_scale,
            self.screen_height * self.screen_scale
        ))
        layer.set_colorkey((2, 3, 4))

        if depth_layer_type == DepthLayer.SHADOW:
            layer.set_alpha(70)

        return layer

    def add_sprite(self, sprite: Sprite):
        self.sprites.append(sprite)

    def draw_screen(self):
        """
        The main function - draws on each depth layer surface
        """
        self.screen.fill(rgb(Colour.GREEN5))

        # Sort sprites by depth layer
        sprites_by_depth = sorted(self.sprites, key=lambda spr: spr.depth)

        for depth_layer_type, depth_layer_surface in self.surfaces.items():
            depth_layer_surface.fill((2, 3, 4))
            for sprite in sprites_by_depth:

                if depth_layer_type == DepthLayer.FOREGROUND and sprite.background:
                    pass

                elif depth_layer_type == DepthLayer.BACKGROUND and not sprite.background:
                    pass

                elif depth_layer_type == DepthLayer.SHADOW and not sprite.shadow:
                    pass

                else:
                    colour = sprite.colour
                    if depth_layer_type == DepthLayer.SHADOW:
                        colour = Colour.BLACK

                    scale = sprite.scale * self.screen_scale

                    sprite, rect = self.draw_sprite(sprite.image, self.sprites_from_file[sprite.image], sprite.x, sprite.y,
                    sprite.rotation, scale, colour)
                    depth_layer_surface.blit(sprite, rect)

            if depth_layer_type == DepthLayer.SHADOW:
                self.screen.blit(depth_layer_surface, (0+self.screen_scale, 0+self.screen_scale))
            else:
                self.screen.blit(depth_layer_surface, (0, 0))

    def draw_sprite(self, sprite_name, sprite_img_original, x, y, rot, scale, colour=None, flipped=False):
        """
        Draws individual sprite on the screen
        """
        scale_rounded = round(scale, 2)
        rot_rounded = round(rot, 2)

        key = (sprite_name, colour, scale_rounded, rot_rounded)
        if key not in self.recolored_cache:
            sprite_img = sprite_img_original.copy()
            if colour:
                self.recolour_sprite(sprite_img, colour)

            # Upscale sprite if scalable
            if scale_rounded != 1:
                sprite_img = pygame.transform.scale(sprite_img,(sprite_img.get_width() * scale_rounded, sprite_img.get_height() * scale_rounded))

            if rot != 0:
                sprite_img = pygame.transform.rotate(sprite_img, rot)

            self.recolored_cache[key] = sprite_img

        sprite_img = self.recolored_cache[key]

        rect = sprite_img.get_rect(center=((x*self.screen_scale), (y*self.screen_scale)))
        return sprite_img, rect

    def recolour_sprite(self, sprite_img, colour):
        pixel_array = pygame.PixelArray(sprite_img)
        for px in range(sprite_img.get_width()):
            for py in range(sprite_img.get_height()):
                alpha = pixel_array[px, py] >> 24
                pixel_array[px, py] = (alpha << 24) | (rgb(colour)[0] << 16) | (rgb(colour)[1] << 8) | rgb(colour)[2]
