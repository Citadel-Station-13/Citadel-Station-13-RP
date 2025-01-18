GENERATE_ROBOT_MODULE_PRESET(/lost)
/datum/prototype/robot_module/lost
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

/datum/prototype/robot_module/lost/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire

/datum/prototype/robot_module/lost/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
		// Sec
		/obj/item/melee/baton/shocker/robot,
		/obj/item/handcuffs/cyborg,
		/obj/item/borg/combat/shield,

		// Med
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/borghypo/lost,
		/obj/item/shockpaddles/robot/hound,
		/obj/item/robot_builtin/dog_mirrortool,

		// Engi
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,

		// Sci
		/obj/item/robotanalyzer,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/energy/retro/mounted,
		)

#warn translate chassis below

/obj/item/robot_module/robot/lost
	name = "lost robot module"
	sprites = list(
		"Drone" = "drone-lost"
	)

/obj/item/robot_module/robot/quad/stray
	name = "stray robot module"
	sprites = list(
		"Stray" = "stray"
	)
	can_shred = TRUE
