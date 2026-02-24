GENERATE_ROBOT_MODULE_PRESET(/lost)
/datum/prototype/robot_module/lost
	id = "lost"
	display_name = "???"
	light_color = "#AAAA00"
	module_hud_state = "recon"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/hover_drone/lost,
		/datum/prototype/robot_iconset/dog_vale/stray,
		/datum/prototype/robot_iconset/raptor/lost,
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
			/obj/item/mirrortool,

			// Engi
			/obj/item/weldingtool/electric/mounted,
			/obj/item/switchtool,
			/obj/item/multitool,

			// logistics
			/obj/item/pickaxe/borgdrill,
			/obj/item/storage/bag/ore,

			// Sci
			/obj/item/robotanalyzer,

			// service
			/obj/item/soap/nanotrasen,

			// haha fuck you it's the hour of the standard borg, yeehaw
			/obj/item/gripper/omni/no_attack,
			/obj/item/gripper/omni/no_attack,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/projectile/energy/retro/mounted,
		)
