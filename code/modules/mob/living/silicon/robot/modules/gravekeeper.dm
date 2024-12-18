/datum/prototype/robot_module/gravekeeper
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

#warn translate chassis below

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
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
	emag = new /obj/item/gun/energy/retro/mounted(src)

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(synths_by_kind[MATSYN_WOOD])
	. += W
