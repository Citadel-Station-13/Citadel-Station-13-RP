/obj/item/eldritch/prop/codex
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "book"
	name = "Bound Book"
	desc = "A book decorated in purple leather and a series of odd runes. It appears to be bound by a chain made of some type of metal."
	anchored = 0
	density = 0

/obj/item/eldritch/prop/medallion
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "eye_medalion"
	name = "Odd Medallion"
	desc = "A strange medallion, looks like some sort of eye."
	anchored = 0
	density = 0

/obj/item/eldritch/prop/flask
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "eldritch_flask"
	name = "Strange Flask"
	desc = "A strange flask. You can't seem to open it, but you don't recognize the material its made of. Or those runes..."


//Blades
/obj/item/eldritch/blade/cursed
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. It has a gem embeded into its handle that pulses eerily."
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/objects.dmi'
	icon_state = "cursed_blade"
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
		parry_chance_default = 50;
		parry_chance_projectile = 50;
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
		parry_chance_default = 50;
		parry_chance_projectile = 50;
	}
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/antagonists/heretic/on_mob/left_hand_64.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/antagonists/heretic/on_mob/right_hand_64.dmi'
	)



