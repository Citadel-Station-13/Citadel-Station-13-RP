GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/research)
/datum/prototype/robot_module/nanotrasen/research
	id = "nt-research"
	display_name = "NT-Research"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/research
	module_hud_state = "science"
	light_color = "#CC60FF"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/dog_otie/science,
		/datum/prototype/robot_iconset/hover_eyebot/science,
		/datum/prototype/robot_iconset/biped_marina/service,
		/datum/prototype/robot_iconset/grounded_spider/science,
		/datum/prototype/robot_iconset/biped_sleek/science,
		/datum/prototype/robot_iconset/biped_droid/science,
		/datum/prototype/robot_iconset/hover_drone/science,
		/datum/prototype/robot_iconset/hover_handy/science,
		/datum/prototype/robot_iconset/biped_insekt/science,
		/datum/prototype/robot_iconset/hover_glitterfly/science,
		/datum/prototype/robot_iconset/hover_x88/science,
		/datum/prototype/robot_iconset/grounded_mechoid/science,
		/datum/prototype/robot_iconset/dog_borgi/science,
		/datum/prototype/robot_iconset/dog_k9/science,
		/datum/prototype/robot_iconset/dog_k9/science_dark,
		/datum/prototype/robot_iconset/dog_vale/science,
		/datum/prototype/robot_iconset/cat_feli/research,
		/datum/prototype/robot_iconset/grounded_zoomba/research,
		/datum/prototype/robot_iconset/hover_coffin/research,
		// the science coder's pet robot module can live on inside science :)
		/datum/prototype/robot_iconset/grounded_landmate/peacekeeper,
	)

/datum/prototype/robot_module/nanotrasen/research/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire
	store.provisioned_stack_store[/obj/item/stack/nanopaste] = new /datum/robot_resource/provisioned/preset/nanopaste

/datum/prototype/robot_module/nanotrasen/research/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/portable_destructive_analyzer,
			/obj/item/gripper/research,
			/obj/item/gripper/circuit,
			/obj/item/gripper/no_use/organ/robotics,
			/obj/item/gripper/no_use/mech,
			/obj/item/gripper/no_use/loader,
			/obj/item/robotanalyzer,
			/obj/item/card/robot,
			/obj/item/weldingtool/electric/mounted/cyborg,
			/obj/item/tool/screwdriver/cyborg,
			/obj/item/tool/wrench/cyborg,
			/obj/item/tool/wirecutters/cyborg,
			/obj/item/multitool,
			/obj/item/surgical/scalpel/cyborg,
			/obj/item/surgical/circular_saw/cyborg,
			/obj/item/reagent_containers/syringe,
			/obj/item/reagent_containers/glass/beaker/large,
			/obj/item/storage/part_replacer,
			/obj/item/shockpaddles/robot,
			/obj/item/melee/baton/slime/robot,
			/obj/item/gun/projectile/energy/taser/xeno/robot,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/borg/combat/shield,
		)

// todo: this is evil
/datum/prototype/robot_module/nanotrasen/research/legacy_custom_regenerate_resources(mob/living/silicon/robot/robot, dt, multiplier)
	..()
	for(var/obj/item/reagent_containers/syringe/syringe in robot.inventory.robot_modules)
		// todo: refactor syringes
		if(syringe.mode == 2)
			syringe.reagents?.clear_reagents()
			syringe.mode = initial(syringe.mode)
			syringe.desc = initial(syringe.desc)
			syringe.update_icon()

// todo: legacy
/obj/item/robot_module_legacy/robot/research
	channels = list("Science" = 1)
