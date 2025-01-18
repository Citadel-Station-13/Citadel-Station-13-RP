GENERATE_ROBOT_MODULE_PRESET(/lost)
/datum/prototype/robot_module/lost
	allowed_frames = list(
		/datum/robot_frame{
			name = "Drone";
			robot_iconset = /datum/prototype/robot_iconset/hover_drone/lost;
			robot_chassis = /datum/prototype/robot_chassis/hover;
		},
		/datum/robot_frame{
			name = "Stray (Canine)";
			robot_iconset = /datum/prototype/robot_iconset/dog_vale/stray;
			robot_chassis = /datum/prototype/robot_chassis/quadruped/canine;
		},
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
