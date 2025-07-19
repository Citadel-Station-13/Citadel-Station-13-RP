/obj/item/roguetown/blade/martyr
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. The curvature pulses oddly, blinking in and out of sight."
	icon = 'icons/obj/props/roguetown/sword.dmi'
	icon_state = "martyrsword_ulton"
	slot_flags = SLOT_BELT
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	damage_force = 30
	throw_speed = 1
	throw_range = 5
	throw_force = 15
	worn_x_dimension = 64
	worn_y_dimension = 64
	w_class = WEIGHT_CLASS_SMALL
	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 30;
		parry_chance_projectile = 40;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/roguetown/sword/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/roguetown/sword/right_hand_64.dmi'
	)
