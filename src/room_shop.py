def draw_room(controller):
    # Draw shop menu
    controller.draw_sprite('hud', 'shop_menu', controller.screen_size['width']/12, controller.screen_size['height']/12, rot=0, scale=6)

    # Draw shop items
    controller.draw_sprite('items', controller.shop.stock[0].id, x=17.5, y=42.5, rot=0, scale=(6 + controller.shop.token_size) - 1)
    controller.draw_sprite('items', controller.shop.stock[1].id, x=35.5, y=42.5, rot=0, scale=(6 + controller.shop.token_size) - 1)
    controller.draw_sprite('items', controller.shop.stock[2].id, x=53.5, y=42.5, rot=0, scale=(6 + controller.shop.token_size) - 1)

    # Draw player health and money
    controller.draw_sprite('hud', 'meter_health', x=14, y=66, rot=0, scale=(6 + controller.symbol_health_size) - 1)
    hp_text = f'{controller.player.hp}/{controller.player.hp_max}'
    controller.draw_text(hp_text, x=23, y=66, rot=0, scale=6, colour='red')

    controller.draw_sprite('hud', 'meter_money', x=14, y=76, rot=0, scale=(6 + controller.symbol_money_size) - 1)
    controller.draw_sprite('number', 'number_$_yellow', x=23, y=76, rot=0, scale=6)
    controller.draw_text(controller.player.money, x=27, y=76, rot=0, scale=6, colour='yellow')

    pass