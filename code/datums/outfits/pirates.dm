/datum/outfit/pirate
	abstract_type = /datum/outfit/pirate

	name = "Pirate - Classic"
	uniform = /obj/item/clothing/under/pirate
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/bandana
	glasses = /obj/item/clothing/glasses/eyepatch
	l_hand = /obj/item/melee/energy/sword/pirate

/datum/outfit/pirate/norm

/datum/outfit/pirate/space
	name = "Pirate - Space"
	head = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/pirate
	back = /obj/item/tank/jetpack/oxygen
	flags = OUTFIT_HAS_JETPACK

/datum/outfit/pirate/vox
	name = "Pirate - Vox Raider"
	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/armor/vox_scrap
	shoes = /obj/item/clothing/shoes/magboots/vox
	gloves = /obj/item/clothing/gloves/light_brown
	mask = /obj/item/clothing/mask/breath
	back = /obj/item/tank/vox
	l_hand = /obj/item/melee/energy/sword/pirate
	r_hand = /obj/item/gun/ballistic/shotgun/pump/rifle/vox_hunting
	l_pocket = /obj/item/ammo_magazine/clip/c762
	r_pocket = /obj/item/ammo_magazine/clip/c762

	var/faction = "voxpirate"
