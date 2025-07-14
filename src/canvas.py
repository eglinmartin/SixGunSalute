import glob
import os
import pygame

from dataclasses import dataclass

from constants import Colour, DepthLayer
from utils import rgb


@dataclass
class Canvas:
    base_dir: str
    screen: pygame.Surface
    screen_width: int
    screen_height: int
    screen_scale: int

    def __post_init__(self):
        # Load sprites from bin directory
        self.sprites = self.load_sprites()

        self.surfaces = {}
        for depth_layer_type in DepthLayer:
            self.surfaces[depth_layer_type] = self.generate_layer_surface(depth_layer_type)

    def load_sprites(self):
        """
        Loads sprite image files from disk
        """
        sprite_dir = os.path.join(self.base_dir, 'bin')
        sprites = {os.path.splitext(os.path.basename(f))[0]: pygame.image.load(f).convert_alpha() for f in
                   glob.glob(f"{sprite_dir}/**/*.png", recursive=True)}
        return sprites

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
            layer.set_alpha(128)

        return layer

    def draw(self, objects: list):
        """
        Takes all objects, sorts into layers and handles drawing
        """
        # Sort objects into depths
        self.screen.fill(rgb(Colour.L_GREEN))

        # Draw sprites for each depth layer, inverted
        for depth_layer_type, surface in self.surfaces.items():
            surface.fill((2, 3, 4))

            # Draw all objects
            for obj in objects:
                colour = obj.colour
                if depth_layer_type == DepthLayer.SHADOW:
                    colour = Colour.BLACK
                sprite, rect = self.draw_sprite(self.sprites[obj.sprite], obj.x, obj.y, obj.rotation, obj.scale, colour)
                surface.blit(sprite, rect)

            if depth_layer_type == DepthLayer.SHADOW:
                self.screen.blit(surface, (0+self.screen_scale, 0+self.screen_scale))
            else:
                self.screen.blit(surface, (0, 0))

    def draw_sprite(self, sprite_img_original, x, y, rot, scale, colour=None, flipped=False):
        """
        Draws individual sprite on the screen
        """
        sprite_img = sprite_img_original.copy()

        # Recolour the sprite if colour = True
        if colour:
            pixel_array = pygame.PixelArray(sprite_img)
            for px in range(sprite_img.get_width()):
                for py in range(sprite_img.get_height()):
                    alpha = pixel_array[px, py] >> 24
                    pixel_array[px, py] = (alpha << 24) | (rgb(colour)[0] << 16) | (rgb(colour)[1] << 8) | rgb(colour)[2]

        # Upscale sprite if scalable
        sprite_img = pygame.transform.scale(sprite_img, (sprite_img.get_width()*scale, sprite_img.get_height()*scale))

        # Rotate the sprite if rotatable
        if rot:
            sprite_img = pygame.transform.rotate(sprite_img, rot)

        # Flip the sprite if flippable
        if flipped:
            sprite_img = pygame.transform.flip(sprite_img, flip_x=flipped, flip_y=False)

        rect = sprite_img.get_rect(center=((x*self.screen_scale), (y*self.screen_scale)))
        return sprite_img, rect
