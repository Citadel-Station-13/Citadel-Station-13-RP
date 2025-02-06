GENERATE_ROBOT_MODULE_PRESET(/gravekeeper)
/datum/prototype/robot_module/gravekeeper
	id = "gravekeeper"
	use_robot_module_path = /obj/item/robot_module/robot/
	light_color = "#AAAA00"
	allowed_frames = list(
	)

/datum/prototype/robot_module/gravekeeper/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/wood_plank::id] = new /datum/robot_resource/provisioned/preset/material/wood

/datum/prototype/robot_module/gravekeeper/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
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
			/obj/item/gripper/gravekeeper,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/energy/retro/mounted,
		)


#warn translate chassis below

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	sprites = list(
		"Drone" = "drone-gravekeeper",
		"Sleek" = "sleek-gravekeeper"
	)
