/datum/design/item/augment
	materials = list(DEFAULT_WALL_MATERIAL = 30, "glass" = 20)

/datum/design/item/augment/AssembleDesignName()
	..()
	name = "Cybernetic augment prototype ([item_name])"

// These were going to go into Biotech, but I decided to make them their own category in case we decide to expand.

/datum/design/item/augment/hand
	name = "resonant analyzer"
	id = "aug_hand"
	req_tech = list(TECH_BIO = 3, TECH_MAGNET = 4, TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 500)
	build_path = /obj/item/organ/internal/augment/armmounted/hand
	sort_string = "ATCJA"

/datum/design/item/augment/shoulder
	name = "rotary toolkit"
	id = "aug_shoulder"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_DATA = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple
	sort_string = "ATCJB"

/datum/design/item/augment/arm
	name = "implanted taser"
	id = "aug_arm"
	req_tech = list(TECH_BIO = 4, TECH_COMBAT = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "plastic" = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted/taser
	sort_string = "ATCJC"

/datum/design/item/augment/shoulder_med
	name = "rotary medical kit"
	id = "aug_shouldermed"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_DATA = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 1000, "plastic" = 1000)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/multiple/medical
	sort_string = "ATCJD"

/datum/design/item/augment/shoulder_combat
	name = "muscular overclocker"
	id = "aug_shouldercombat"
	req_tech = list(TECH_BIO = 5, TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "plastic" = 3000, "silver" = 1000, "gold" = 500)
	build_path = /obj/item/organ/internal/augment/armmounted/shoulder/surge
	sort_string = "ATCJE"

/datum/design/item/augment/pelvis
	name = "locomotive optimizer"
	id = "aug_pelvis"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "plastic" = 2000, "silver" = 500, "gold" = 1000)
	build_path = /obj/item/organ/internal/augment/bioaugment/sprint_enhance
	sort_string = "ATCJF"

/datum/design/item/augment/arm_laser
	name = "implanted laser rifle"
	id = "aug_armlaser"
	req_tech = list(TECH_BIO = 5, TECH_COMBAT = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 1000, "plastic" = 2000, "gold" = 2000)
	build_path = /obj/item/organ/internal/augment/armmounted
	sort_string = "ATCJG"

/datum/design/item/augment/eyes
	name = "thermolensing sunglasses"
	id = "aug_eyes"
	req_tech = list(TECH_BIO = 6, TECH_ILLEGAL = 4, TECH_MATERIAL = 4, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 1000, "plastic" = 1500, "gold" = 1000, "diamond" = 2000)
	build_path = /obj/item/organ/internal/augment/bioaugment/thermalshades
	sort_string = "ATCJH"

/datum/design/item/augment/hand_sword
	name = "implanted energy blade"
	id = "aug_handsword"
	req_tech = list(TECH_BIO = 6, TECH_COMBAT = 6, TECH_ILLEGAL = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 500, "plastic" = 2000, "gold" = 2000, "uranium" = 1500, "diamond" = 2500)
	build_path = /obj/item/organ/internal/augment/armmounted/hand/sword
	sort_string = "ATCJI"
