// Tennis Balls

/obj/item/toy/tennis
	name = "tennis ball"
	desc = "A classical tennis ball. It appears to have faint bite marks scattered all over its surface."
	icon = 'modular_citadel/icons/obj/balls.dmi'
	icon_state = "tennis_classic"
	item_icons = list(
		slot_l_hand_str = 'modular_citadel/icons/mob/inhands/balls_left.dmi',
		slot_r_hand_str = 'modular_citadel/icons/mob/inhands/balls_right.dmi',
		slot_wear_mask_str = 'modular_citadel/icons/mob/mouthball.dmi'
		)
	item_state = "tennis_classic"
	slot_flags = SLOT_MASK
	throw_range = 14
	w_class = ITEMSIZE_SMALL

/obj/item/toy/tennis/rainbow
	name = "pseudo-euclidean interdimensional tennis sphere"
	desc = "A tennis ball from another plane of existence. Really groovy."
	icon_state = "tennis_rainbow"
	item_state = "tennis_rainbow"

	var/list/squeak_sounds = list(
		'modular_citadel/sound/items/toysqueak1.ogg',
		'modular_citadel/sound/items/toysqueak2.ogg',
		'modular_citadel/sound/items/toysqueak3.ogg'
		)

/obj/item/toy/tennis/rainbow/attack_self(mob/user as mob)
	playsound(src.loc, pick(squeak_sounds), 50, 1,)

/obj/item/toy/tennis/red
	name = "red tennis ball"
	desc = "A red tennis ball."
	icon_state = "tennis_red"
	item_state = "tennis_red"

/obj/item/toy/tennis/yellow
	name = "yellow tennis ball"
	desc = "A yellow tennis ball."
	icon_state = "tennis_yellow"
	item_state = "tennis_yellow"

/obj/item/toy/tennis/green
	name = "green tennis ball"
	desc = "A green tennis ball."
	icon_state = "tennis_green"
	item_state = "tennis_green"

/obj/item/toy/tennis/cyan
	name = "cyan tennis ball"
	desc = "A cyan tennis ball."
	icon_state = "tennis_cyan"
	item_state = "tennis_cyan"

/obj/item/toy/tennis/blue
	name = "blue tennis ball"
	desc = "A blue tennis ball."
	icon_state = "tennis_blue"
	item_state = "tennis_blue"

/obj/item/toy/tennis/purple
	name = "purple tennis ball"
	desc = "A purple tennis ball."
	icon_state = "tennis_purple"
	item_state = "tennis_purple"
