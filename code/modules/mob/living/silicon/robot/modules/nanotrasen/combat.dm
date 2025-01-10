/datum/prototype/robot_module/nanotrasen/combat
	use_robot_module_path = /obj/item/robot_module/robot/combat
	allowed_frames = list(
	)

/datum/prototype/robot_module/nanotrasen/combat/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= list(
			/obj/item/gun/energy/laser/mounted,
			/obj/item/pickaxe/plasmacutter,
			/obj/item/borg/combat/shield,
			/obj/item/borg/combat/mobility,
			/obj/item/handcuffs/cyborg,
			/obj/item/melee/baton/robot,
			/obj/item/barrier_tape_roll/police,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/energy/lasercannon/mounted,
		)
	return ..()

#warn translate chassis below

/obj/item/robot_module/robot/security/combat
	name = "combat robot module"
	sprites = list(
		"Haruka" = "marinaCB",
		"Cabeiri" = "eyebot-combat",
		"Combat Android" = "droid-combat",
		"Insekt" = "insekt-Combat",
		"Acheron" = "mechoid-Combat",
		"ZOOM-BA" = "zoomba-combat"
	)

/obj/item/robot_module/robot/quad/ert
	name = "Emergency Response module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	sprites = list(
		"Standard" = "ert",
		"Borgi" = "borgi",
		"F3-LINE" = "FELI-Combat"
	)

	can_shred = TRUE

/obj/item/robot_module/robot/quad/ert/get_modules()
	. = ..()
	. |= list(
		/obj/item/robot_builtin/dog_swordtail
	)
