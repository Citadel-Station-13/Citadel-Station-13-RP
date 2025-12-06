GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/multirole)
/datum/prototype/robot_module/nanotrasen/multirole
	id = "nt-multirole"
	display_name = "NT-Multirole"
	use_robot_module_path = /obj/item/robot_module_legacy/robot
	light_color = "#FFFFFF"
	module_hud_state = "standard"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/biped_k4t,
		/datum/prototype/robot_iconset/baseline_old/standard,
		/datum/prototype/robot_iconset/hover_eyebot/standard,
		/datum/prototype/robot_iconset/biped_marina/standard,
		/datum/prototype/robot_iconset/biped_tall/tallflower,
		/datum/prototype/robot_iconset/baseline_toiletbot/standard,
		/datum/prototype/robot_iconset/biped_sleek/standard,
		/datum/prototype/robot_iconset/grounded_spider/standard,
		/datum/prototype/robot_iconset/biped_heavy/standard,
		/datum/prototype/robot_iconset/cat_feli/standard,
		/datum/prototype/robot_iconset/baseline_standard/standard,
		/datum/prototype/robot_iconset/baseline_misc/omoikane,
		/datum/prototype/robot_iconset/hover_drone/standard,
		/datum/prototype/robot_iconset/biped_insekt/standard,
		/datum/prototype/robot_iconset/biped_tall/alternative/standard,
		/datum/prototype/robot_iconset/hover_glitterfly/standard,
		/datum/prototype/robot_iconset/biped_miss/standard,
		/datum/prototype/robot_iconset/hover_x88/standard,
		/datum/prototype/robot_iconset/hover_coffin/standard,
		/datum/prototype/robot_iconset/hover_handy/standard,
		/datum/prototype/robot_iconset/grounded_mechoid/standard,
		/datum/prototype/robot_iconset/biped_noble/standard,
		/datum/prototype/robot_iconset/grounded_zoomba/standard,
		/datum/prototype/robot_iconset/grounded_worm/standard,
		/datum/prototype/robot_iconset/raptor/peacekeeper,
		/datum/prototype/robot_iconset/baseline_droid/standard,
	)

/datum/prototype/robot_module/nanotrasen/multirole/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/steel::id] = new /datum/robot_resource/provisioned/preset/material/steel{
		amount_max = 20 * SHEET_MATERIAL_AMOUNT;
	}
	store.provisioned_material_store[/datum/prototype/material/plastic::id] = new /datum/robot_resource/provisioned/preset/material/plastic{
		amount_max = 10 * SHEET_MATERIAL_AMOUNT;
	}
	store.provisioned_material_store[/datum/prototype/material/glass::id] = new /datum/robot_resource/provisioned/preset/material/glass{
		amount_max = 20 * SHEET_MATERIAL_AMOUNT;
	}
	store.provisioned_stack_store[/obj/item/stack/medical/bruise_pack] = new /datum/robot_resource/provisioned/preset/bandages{
		amount_max = 30;
	}
	store.provisioned_stack_store[/obj/item/stack/medical/ointment] = new /datum/robot_resource/provisioned/preset/ointment{
		amount_max = 30;
	}
	store.provisioned_stack_store[/obj/item/stack/nanopaste] = new /datum/robot_resource/provisioned/preset/nanopaste{
		amount_max = 10;
	}

/datum/prototype/robot_module/nanotrasen/multirole/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			// security
			/obj/item/melee/baton/shocker,
			// engineering
			/obj/item/switchtool,
			/obj/item/weldingtool/electric/mounted,
			/obj/item/multitool,
			// medical
			/obj/item/healthanalyzer,
			/obj/item/reagent_containers/dropper,
			/obj/item/reagent_containers/borghypo/stabilizer,
			// logistics
			/obj/item/pickaxe/borgdrill,
			/obj/item/storage/bag/ore,
			// science
			/obj/item/robotanalyzer,
			// service
			/obj/item/soap/nanotrasen,
			// haha fuck you it's the hour of the standard borg, yeehaw
			/obj/item/gripper/omni/no_attack,
		)
	if(emag_out)
		// LET'S FUCKIN GOOOOOOO
		emag_out |= list(
			/obj/item/gun/projectile/energy/ermitter,
		)
