/obj/item/eldritch/prop/codex
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "book"
	name = "bound book"
	desc = "A heavy book that has been crafted out of purple leather and bound with a chain made of metal you don't recognize. A variety of runes have been etched into the cover."
	anchored = 0
	density = 0
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR | SUIT_STORAGE_CLASS_SOFTWEAR

/obj/item/eldritch/prop/medallion
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "eye_medalion"
	name = "medallion"
	desc = "A medallion that appears to resemble an eye."
	anchored = 0
	density = 0

/obj/item/eldritch/prop/flask
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "eldritch_flask"
	name = "strange flask"
	desc = "A flask made of some type of green glass. A variety of runes have been etched into the material, but it seems empty."


//Blades
/obj/item/eldritch/blade/cursed
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. It has a gem embeded into its handle that pulses eerily."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "cursed_blade"
	slot_flags = SLOT_BELT
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR
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
		parry_chance_default = 40;
		parry_chance_projectile = 30;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/rust
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. Some sort of rust looks like it's dripping off it."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "rust_blade"
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
		parry_chance_default = 60;
		parry_chance_projectile = 30;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/void
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. The curvature pulses oddly, blinking in and out of sight."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "void_blade"
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
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/flesh
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. It appears to be crafted from flesh, bone and skin. An eye stares at you from the handle."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "flesh_blade"
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
		parry_chance_default = 60;
		parry_chance_projectile = 30;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/ash
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. It appears to be covered in molten ash, the entire length incessantly aflame."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "ash_blade"
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
		parry_chance_default = 60;
		parry_chance_projectile = 30;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/cosmic
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. A star floats in the center of the blade, causing the material around it to glimmer."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "cosmic_blade"
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
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/key
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. It is made of a material you cannot identify, the air appears to ripple around you."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "key_blade"
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
		parry_chance_default = 40;
		parry_chance_projectile = 60;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/moon
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. The curvature appears to be an optical illusion while two white orbs circle around the length."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "moon_blade"
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
		parry_chance_default = 40;
		parry_chance_projectile = 60;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/duelist
	name = "Elegant Blade"
	desc = "An odd blade of excellent make. You can't identify what it is made of, but the edge looks impossibly sharp."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "dark_blade"
	slot_flags = SLOT_BELT
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	damage_force = 40
	throw_speed = 1
	throw_range = 5
	throw_force = 15
	worn_x_dimension = 64
	worn_y_dimension = 64
	w_class = WEIGHT_CLASS_SMALL
	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 30;
		parry_chance_projectile = 70;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)

/obj/item/eldritch/blade/cheat
	name = "Unknown Blade"
	desc = "An elegantly crafted blade, made of multiple metals which you've never seen before. Energy warps around its curvature, causing reality to deform around it."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "dark_blade_infused"
	slot_flags = SLOT_BELT
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	attack_sound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	damage_force = 50
	throw_speed = 1
	throw_range = 5
	throw_force = 15
	worn_x_dimension = 64
	worn_y_dimension = 64
	w_class = WEIGHT_CLASS_SMALL
	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 40;
		parry_chance_projectile = 100;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)
