/obj/item/hardsuit/breacher
	name = "\improper NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-hardsuit. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "\improper NT breacher"
	icon_state = "breacher_hardsuit_cheap"
	armor_type = /datum/armor/hardsuit/breacher
	emp_protection = -20
	slowdown = 6
	offline_slowdown = 10
	vision_restriction = 1
	offline_vision_restriction = 2
	siemens_coefficient = 0.75
	chest_type = /obj/item/clothing/suit/space/hardsuit/breacher
	helm_type = /obj/item/clothing/head/helmet/space/hardsuit/breacher
	boot_type = /obj/item/clothing/shoes/magboots/hardsuit/breacher

/datum/armor/hardsuit/breacher
	melee = 0.6
	bullet = 0.6
	laser = 0.6
	energy = 0.6
	bomb = 0.7
	bio = 1.0
	rad = 0.5

/obj/item/hardsuit/breacher/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor_type = /datum/armor/hardsuit/breacher/upgraded
	vision_restriction = 0
	siemens_coefficient = 0.2

/datum/armor/hardsuit/breacher/upgraded
	melee = 0.9
	bullet = 0.9
	laser = 0.9
	energy = 0.9
	bomb = 0.9
	rad = 0.8

/obj/item/clothing/head/helmet/space/hardsuit/breacher
	species_restricted = list(SPECIES_UNATHI, SPECIES_UNATHI_DIGI)
	damage_force = 5

/obj/item/clothing/suit/space/hardsuit/breacher
	species_restricted = list(SPECIES_UNATHI, SPECIES_UNATHI_DIGI)

/obj/item/clothing/shoes/magboots/hardsuit/breacher
	species_restricted = list(SPECIES_UNATHI, SPECIES_UNATHI_DIGI)
