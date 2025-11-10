/obj/item/roguetown/blade/sentinel
	name = "The Truthsayer"
	desc = "A large blade forged out of an ancient metal. It appears to be covered in an incessantly burning flame."
	icon = 'icons/obj/props/roguetown/martyr_sword/sword.dmi'
	icon_state = "martyrsword_ulton"
	base_pixel_x = -7
	base_pixel_y = -10
	slot_flags = SLOT_BELT | SLOT_BACK
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	damage_force = 40
	throw_speed = 1
	throw_range = 0
	throw_force = 0
	worn_x_dimension = 64
	worn_y_dimension = 64
	w_class = WEIGHT_CLASS_HUGE
	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 35;
		parry_chance_projectile = 100;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/obj/props/roguetown/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/obj/props/roguetown/on_mob/left_hand_64.dmi'
	)
