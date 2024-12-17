/datum/prototype/robot_module/nanotrasen/combat
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

#warn translate chassis below

/obj/item/robot_module/robot/security/combat
	name = "combat robot module"
	hide_on_manifest = 1
	sprites = list(
		"Haruka" = "marinaCB",
		"Cabeiri" = "eyebot-combat",
		"Combat Android" = "droid-combat",
		"Insekt" = "insekt-Combat",
		"Acheron" = "mechoid-Combat",
		"ZOOM-BA" = "zoomba-combat"
	)

/obj/item/robot_module/robot/security/combat/get_modules()
	. = ..()
	. |= list(
		/obj/item/flash,
		// /obj/item/borg/sight/thermal,
		/obj/item/gun/energy/laser/mounted,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/borg/combat/shield,
		/obj/item/borg/combat/mobility,
	)

/obj/item/robot_module/robot/security/combat/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/gun/energy/lasercannon/mounted(src)

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
		/obj/item/handcuffs/cyborg,
		/obj/item/dogborg/jaws/big,
		/obj/item/melee/baton/robot,
		/obj/item/barrier_tape_roll/police,
		/obj/item/gun/energy/taser/mounted/cyborg/ertgun,
		/obj/item/dogborg/swordtail
	)

/obj/item/robot_module/robot/quad/ert/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/gun/energy/laser/mounted(src)

	var/obj/item/dogborg/sleeper/K9/B = new /obj/item/dogborg/sleeper/K9(src)
	B.water = synths_by_kind[MATSYN_WATER]
	. += B
