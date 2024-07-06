/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/robot_module/robot/lost
	name = "lost robot module"
	hide_on_manifest = 1
	sprites = list(
		"Drone" = "drone-lost"
	)

/obj/item/robot_module/robot/lost/get_modules()
	. = ..()
	. |= list(
		// Sec
		/obj/item/melee/baton/shocker/robot,
		/obj/item/handcuffs/cyborg,
		/obj/item/borg/combat/shield,

		// Med
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/borghypo/lost,

		// Engi
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,

		// Sci
		/obj/item/robotanalyzer
	)

/obj/item/robot_module/robot/lost/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_WIRE, wire)

/obj/item/robot_module/robot/lost/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// Potato
	emag = new /obj/item/gun/projectile/energy/retro/mounted(src)

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(synths_by_kind[MATSYN_WIRE])
	. += C

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	hide_on_manifest = 1
	sprites = list(
		"Drone" = "drone-gravekeeper",
		"Sleek" = "sleek-gravekeeper"
	)

/obj/item/robot_module/robot/gravekeeper/get_modules()
	. = ..()
	. |= list(
		// For fending off animals and looters
		/obj/item/melee/baton/shocker/robot,
		/obj/item/borg/combat/shield,

		// For repairing gravemarkers
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,

		// For growing flowers
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/plant_analyzer,
		/obj/item/storage/bag/plants,
		/obj/item/robot_harvester,

		// For digging and beautifying graves
		/obj/item/shovel,
		/obj/item/gripper/gravekeeper
	)

/obj/item/robot_module/robot/gravekeeper/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_WOOD, wood, 25000)

/obj/item/robot_module/robot/gravekeeper/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// For really persistent looters
	emag = new /obj/item/gun/projectile/energy/retro/mounted(src)

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(synths_by_kind[MATSYN_WOOD])
	. += W
