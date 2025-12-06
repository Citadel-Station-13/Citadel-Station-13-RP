GENERATE_ROBOT_MODULE_PRESET(/lost)
/datum/prototype/robot_module/lost
	id = "lost"
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
			/obj/item/gun/projectile/energy/retro/mounted,
		)
