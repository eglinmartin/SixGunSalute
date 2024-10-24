def draw_room(controller):
    # Draw shop menu
    controller.draw_sprite('hud', 'shop_menu', controller.screen_size['width']/12, controller.screen_size['height']/12, rot=0, scale=6)

    # Draw player health and money
    controller.draw_sprite('hud', 'meter_health', x=14, y=66, rot=0, scale=(6 + controller.symbol_health_size) - 1)
    hp_text = f'{controller.player.hp}/{controller.player.hp_max}'
    controller.draw_text(hp_text, x=23, y=66, rot=0, scale=6, colour='red')
    controller.draw_sprite('hud', 'meter_money', x=14, y=76, rot=0, scale=(6 + controller.symbol_money_size) - 1)
    controller.draw_sprite('number', 'number_$_yellow', x=23, y=76, rot=0, scale=6)
    controller.draw_text(controller.player.money, x=27, y=76, rot=0, scale=6, colour='yellow')

    # Draw shop items
    controller.draw_sprite('items', controller.shop.stock[0].id, x=17.5, y=42.5, rot=0, scale=(6 + controller.shop.token_size[0]) - 1)
    controller.draw_sprite('items', controller.shop.stock[1].id, x=35.5, y=42.5, rot=0, scale=(6 + controller.shop.token_size[1]) - 1)
    controller.draw_sprite('items', controller.shop.stock[2].id, x=53.5, y=42.5, rot=0, scale=(6 + controller.shop.token_size[2]) - 1)

    # Draw gun barrel base
    controller.draw_sprite('hud', 'barrel_shadow', x=120.5, y=46.5, rot=0, scale=6)
    controller.draw_sprite('hud', 'barrel_base', x=119.5, y=45.5, rot=0, scale=6)
    controller.draw_sprite('hud', 'barrel_chambers', x=119.5, y=45.5, rot=controller.player.revolver.rotation, scale=6)

    # Draw gun barrel items
    coordinates_dict = {0: [119.5, 23.5], 1: [138.5, 34.5], 2: [138.5, 56.5],
                        3: [119.5, 67.5], 4: [100.5, 56.5], 5: [100.5, 34.5]}
    for item in coordinates_dict:
        item_rotated = item + controller.shop.revolver_rotation
        if item_rotated > 5:
            item_rotated -= 6
        controller.draw_sprite('items', controller.player.revolver.barrel[item_rotated], x=coordinates_dict[item][0], y=coordinates_dict[item][1], rot=0, scale=6)
