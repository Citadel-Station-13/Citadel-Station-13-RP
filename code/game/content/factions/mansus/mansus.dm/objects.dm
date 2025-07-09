/obj/item/mansus/prop/codex
	icon = 'code/game/content/factions/mansus/mansus.dmi/objects.dmi'
	icon_state = "book"
	name = "Bound Book"
	desc = "A book decorated in purple leather and a series of odd runes. It appears to be bound by a chain made of some type of metal."
	anchored = 0
	density = 0

/obj/item/mansus/prop/medallion
	icon = 'code/game/content/factions/mansus/mansus.dmi/objects.dmi'
	icon_state = "eye_medalion"
	name = "Odd Medallion"
	desc = "A strange medallion, looks like some sort of eye."
	anchored = 0
	density = 0

/obj/item/mansus/prop/flask
	icon = 'code/game/content/factions/mansus/mansus.dmi/objects.dmi'
	icon_state = "eldritch_flask"
	name = "Strange Flask"
	desc = "A strange flask. You can't seem to open it, but you don't recognize the material its made of. Or those runes..."


//armor

/obj/item/clothing/suit/storage/hooded/mansus
	name = "Strange Robes"
	desc = "A set of robes, crafted from some sort of leather you've never seen before. Various runes have been etched into it."
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritcharmor"
	hoodtype = /obj/item/clothing/head/hood/mansus
	w_class = WEIGHT_CLASS_NORMAL
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	clothing_flags = 0
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank/emergency/oxygen, /obj/item/flashlight,/obj/item/gun/projectile/energy, /obj/item/gun/projectile/ballistic, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,/obj/item/handcuffs, /obj/item/mansus/blade, /obj/item/mansus/prop/codex)
	armor_type = /datum/armor/eldritch/robes
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection_cover = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	siemens_coefficient = 0.7

/obj/item/clothing/head/hood/mansus
	name = "Strange Hood"
	desc = "A hood that comes attached to a set of robes. A few runes are etched into the leather."
	icon = 'icons/clothing/suit/antag/heretic.dmi'
	icon_state = "eldritchhood"
	body_cover_flags = HEAD
	cold_protection_cover = HEAD
	armor_type = /datum/armor/eldritch/robes
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	siemens_coefficient = 0.7


//Blades
/obj/item/mansus/blade/cursed
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. It has a gem embeded into its handle that pulses eerily."
	icon = 'code/game/content/factions/mansus/mansus.dmi/objects.dmi'
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

/obj/item/mansus/blade/rust
	name = "Odd Blade"
	desc = "An odd blade, shaped like a crescent. Some sort of rust looks like it's dripping off it."
	icon = 'code/game/content/factions/mansus/mansus.dmi/objects.dmi'
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
