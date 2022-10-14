//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_helm", SLOT_ID_LEFT_HAND = "syndie_helm")
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green" //todo: species-specific light overlays

/obj/item/clothing/suit/space/void/merc
	icon_state = "rig-syndie"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/space/void/merc/fire
	icon_state = "rig0-firebug"
	name = "soot-covered voidsuit helmet"
	desc = "A blackened helmet that has had many of its protective plates coated in or replaced with high-grade thermal insulation, to protect against incineration. Property of Gorlex Marauders."
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 20, bomb = 50, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	light_overlay = "helmet_light_fire"

/obj/item/clothing/suit/space/void/merc/fire
	icon_state = "rig-firebug"
	name = "soot-covered voidsuit"
	desc = "A blackened suit that has had many of its protective plates coated in or replaced with high-grade thermal insulation, to protect against incineration. Property of Gorlex Marauders."
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 20, bomb = 50, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/material/twohanded/fireaxe,/obj/item/flamethrower)
	siemens_coefficient = 0.7

//Soviet Void Suit
/obj/item/clothing/head/helmet/space/void/merc/soviet
	name = "ancient red helmet"
	desc = "An antique helmet which served as one of the inspirations for Gorlex's designs, a faded logo on the interior resembles a shattered sickle."
	icon_state = "void_soviet"
	armor = list(melee = 40, bullet = 60, laser = 20,energy = 15, bomb = 45, bio = 100, rad = 100)
	light_overlay = "sr_overlay"

/obj/item/clothing/suit/space/void/merc/soviet
	name = "antique red voidsuit"
	desc = "A well maintained antique voidsuit, the scent of stale sweat and vodka is impossible to remove. Many features of this suit bear morphological similarities to more modern Gorlex voidsuits."
	icon_state = "void_soviet"
	armor = list(melee = 40, bullet = 60, laser = 20, energy = 15, bomb = 45, bio = 100, rad = 100)

//'Werewolf' Void Suit
/obj/item/clothing/head/helmet/space/void/merc/wulf
	name = "antique werwulf helmet"
	desc = "An antique helmet designed by a long-forgotten corporation. Their dreams of conquest were no match against their competitors. Few of these helmets remain."
	icon_state = "void_wulf"
	armor = list(melee = 40, bullet = 60, laser = 20,energy = 15, bomb = 45, bio = 100, rad = 100)
	light_overlay = "sr_overlay"

/obj/item/clothing/suit/space/void/merc/wulf
	name = "antique werwulf voidsuit"
	desc = "A well maintained antique, this armored voidsuit cuts an imposing silhouette. Many such suits used to be found in scrap heaps across the Frontier, although few now remain."
	icon_state = "void_wulf"
	armor = list(melee = 40, bullet = 60, laser = 20, energy = 15, bomb = 45, bio = 100, rad = 100)

// Honk Op Rig
/obj/item/clothing/head/helmet/space/void/clownop
	name = "clown commando voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. An intricate bananium wafer in the shape of a banana bears the crest of Columbina."
	icon_state = "rig0-clownop"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_helm", SLOT_ID_LEFT_HAND = "syndie_helm")
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "gk_overlay" //todo: species-specific light overlays

/obj/item/clothing/head/helmet/space/void/clownop/alt
	name = "sexy clown commando voidsuit helmet"
	icon_state = "rig0-clownop_alt"

/obj/item/clothing/suit/space/void/clownop
	icon_state = "rig-clownop"
	name = "clown commando voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. An intricate bananium wafer in the shape of a banana bears the crest of Columbina."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syndie_voidsuit", SLOT_ID_LEFT_HAND = "syndie_voidsuit")
	slowdown = 1
	w_class = ITEMSIZE_NORMAL
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.6
