/obj/item/hardsuit/breacher
	name = "\improper NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-hardsuit. Looks like a fish, moves like a fish, steers like a cow."
	icon_state = "breacher_hardsuit_cheap"
	armor_type = /datum/armor/hardsuit/breacher
	siemens_coefficient = 0.75

/datum/armor/hardsuit/breacher
	melee = 0.45
	melee_tier = 4
	bullet = 0.4
	bullet_tier = 4
	laser = 0.35
	laser_tier = 4
	energy = 0.35
	bomb = 0.7
	bio = 1.0
	rad = 0.5
	fire = 0.8
	acid = 1.0

/obj/item/hardsuit/breacher/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor_type = /datum/armor/hardsuit/breacher/upgraded
	vision_restriction = 0
	siemens_coefficient = 0.2

/datum/armor/hardsuit/breacher/upgraded
	melee = 0.55
	bullet = 0.55
	laser = 0.45
