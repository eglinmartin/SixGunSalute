def draw_room(controller):
    # Draw shop menu
    controller.draw_sprite('hud', 'mainmenu', controller.screen_size['width']/12, controller.screen_size['height']/12, rot=0, scale=6)

    # Draw player
    controller.draw_sprite('player', controller.player.current_sprite, x=46, y=48, rot=0, scale=12)
