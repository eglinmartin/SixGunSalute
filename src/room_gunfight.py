def draw_room(controller):
    # Draw the hud gun barrel
    controller.draw_sprite('hud', 'barrel_shadow', x=-1.5, y=85.5, rot=0, scale=6)
    controller.draw_sprite('hud', 'barrel_base', x=-2.5, y=84.5, rot=0, scale=6)
    controller.draw_sprite('hud', 'barrel_chambers', x=-2.5, y=84.5, rot=controller.player.revolver.rotation, scale=6)

    # Draw the player's hud
    controller.draw_sprite('hud', 'player_head', x=18.5, y=12, rot=0, scale=6)

    # Draw the enemy's hud
    controller.draw_sprite('hud', 'enemy_head', x=141.5, y=12, rot=0, scale=6)

    controller.draw_sprite('hud', 'meter_health', x=9, y=26, rot=0, scale=(6 + controller.symbol_health_size) - 1)
    hp_text = f'{controller.player.hp}/{controller.player.hp_max}'
    controller.draw_text(hp_text, x=18, y=26, rot=0, scale=6, colour='red')

    controller.draw_sprite('hud', 'meter_money', x=9, y=36, rot=0, scale=(6 + controller.symbol_money_size) - 1)
    controller.draw_sprite('number', 'number_$_yellow', x=18, y=36, rot=0, scale=6)
    controller.draw_text(controller.player.money, x=22, y=36, rot=0, scale=6, colour='yellow')


    coord_y = 24

    # Draw the player's revolver
    player_barrel = controller.player.revolver.barrel
    coordinates = [[controller.player.x - 4, coord_y+0], [controller.player.x + 3, coord_y+5],
                   [controller.player.x + 3, coord_y+12], [controller.player.x - 4, coord_y+17],
                   [controller.player.x - 11, coord_y+12], [controller.player.x - 11, coord_y+5]]
    for i in range(len(player_barrel)):
        coords = coordinates[i]
        sprite_name = 'chamber_full'
        if player_barrel[i] == 'empty':
            sprite_name = 'chamber_empty'
        controller.draw_sprite('hud', sprite_name, x=coords[0], y=coords[1], rot=0, scale=6)
        if i == controller.player.revolver.active_chamber:
            controller.draw_sprite('hud', 'chamber_selected', x=coords[0], y=coords[1], rot=0, scale=6)

    # Draw the enemy's revolver
    enemy_barrel = controller.enemy.revolver.barrel
    coordinates = [[controller.enemy.x - 4, coord_y+0], [controller.enemy.x + 3, coord_y+5],
                   [controller.enemy.x + 3, coord_y+12], [controller.enemy.x - 4, coord_y+17],
                   [controller.enemy.x - 11, coord_y+12], [controller.enemy.x - 11, coord_y+5]]
    for i in range(len(enemy_barrel)):
        coords = coordinates[i]
        sprite_name = 'chamber_full'
        if enemy_barrel[i] == 'empty':
            sprite_name = 'chamber_empty'
        controller.draw_sprite('hud', sprite_name, x=coords[0], y=coords[1], rot=0, scale=6)
        if i == controller.enemy.revolver.active_chamber:
            controller.draw_sprite('hud', 'chamber_selected', x=coords[0], y=coords[1], rot=0, scale=6)

    # Draw the item in the player's revolver
    if controller.player.revolver.active_chamber >= 0:
        active_item = controller.player.revolver.barrel[controller.player.revolver.active_chamber]
        controller.draw_sprite('items', active_item, x=16.5, y=73.5, rot=0, scale=6)

    # Draw player
    controller.draw_sprite('player', controller.player.current_sprite, x=controller.player.x, y=controller.player.y, rot=0, scale=6)

    if controller.player.revolver.can_spin:
        controller.draw_sprite('hud', 'tooltip_spin', x=26, y=69, rot=0, scale=6)

    if controller.player.revolver.can_shoot:
        controller.draw_sprite('hud', 'tooltip_shoot', x=26, y=69, rot=0, scale=6)

    # Draw player
    controller.draw_sprite('enemy', controller.enemy.current_sprite, x=controller.enemy.x, y=controller.enemy.y, rot=0, scale=6)
