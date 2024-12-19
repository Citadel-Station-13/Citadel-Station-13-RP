/datum/prototype/robot_module/lost
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

/datum/prototype/robot_module/lost/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire

#warn translate chassis below

/obj/item/robot_module/robot/lost
	name = "lost robot module"
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

/obj/item/robot_module/robot/lost/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// Potato
	emag = new /obj/item/gun/energy/retro/mounted(src)

/obj/item/robot_module/robot/quad/stray
	name = "stray robot module"
	sprites = list(
		"Stray" = "stray"
	)
	can_shred = TRUE

/obj/item/robot_module/robot/quad/stray/get_modules()
	. = ..()
	. |= list(
		// Sec
		/obj/item/handcuffs/cyborg,
		/obj/item/robot_builtin/dog_jaws/big,
		/obj/item/melee/baton/robot,
		/obj/item/robot_builtin/dog_pounce,

		// Med
		/obj/item/healthanalyzer,
		/obj/item/shockpaddles/robot/hound,
		/obj/item/robot_builtin/dog_mirrortool,

		// Engi
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool
	)

/obj/item/robot_module/robot/quad/stray/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// Boof
	src.emag 	 = new /obj/item/gun/energy/retro/mounted(src)

	var/obj/item/reagent_containers/borghypo/hound/lost/H = new /obj/item/reagent_containers/borghypo/hound/lost(src)
	H.water = synths_by_kind[MATSYN_WATER]
	. += H

	var/obj/item/robot_builtin/dog_sleeper/B = new /obj/item/robot_builtin/dog_sleeper(src)
	B.water = synths_by_kind[MATSYN_WATER]
	. += B
