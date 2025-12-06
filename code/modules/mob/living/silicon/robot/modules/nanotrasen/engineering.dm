GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/engineering)
/datum/prototype/robot_module/nanotrasen/engineering
	id = "nt-engineering"
	display_name = "NT-Engineering"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/engineering
	module_hud_state = "engineering"
	light_color = "#FDD800"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/dog_borgi/engineering,
		/datum/prototype/robot_iconset/dog_k9/engineering,
		/datum/prototype/robot_iconset/dog_k9/engineering_dark,
		/datum/prototype/robot_iconset/dog_otie/engineering,
		/datum/prototype/robot_iconset/dog_pupdozer/engineering,
		/datum/prototype/robot_iconset/dog_vale/engineering,
		/datum/prototype/robot_iconset/cat_feli/engineering,
		/datum/prototype/robot_iconset/drake_mizartz/engineering,
		/datum/prototype/robot_iconset/hover_eyebot/engineering,
		/datum/prototype/robot_iconset/baseline_toiletbot/engineering,
		/datum/prototype/robot_iconset/biped_marina/engineering,
		/datum/prototype/robot_iconset/biped_sleek/engineering,
		/datum/prototype/robot_iconset/grounded_spider/engineering,
		/datum/prototype/robot_iconset/biped_heavy/engineering,
		/datum/prototype/robot_iconset/grounded_landmate/engineering,
		/datum/prototype/robot_iconset/grounded_landmate/engineering_tread,
		/datum/prototype/robot_iconset/grounded_landmate/treadwell,
		/datum/prototype/robot_iconset/hover_drone/engineering,
		/datum/prototype/robot_iconset/hover_handy/engineering,
		/datum/prototype/robot_iconset/hover_glitterfly/engineering,
		/datum/prototype/robot_iconset/hover_coffin/engineering,
		/datum/prototype/robot_iconset/hover_coffin/construction,
		/datum/prototype/robot_iconset/biped_miss/engineering,
		/datum/prototype/robot_iconset/biped_tall/alternative/engineer,
		/datum/prototype/robot_iconset/biped_marina/engineering,
		/datum/prototype/robot_iconset/grounded_zoomba/engineering,
		/datum/prototype/robot_iconset/hover_x88/engineering,
		/datum/prototype/robot_iconset/biped_noble/engineering,
		/datum/prototype/robot_iconset/grounded_mechoid/engineering,
		/datum/prototype/robot_iconset/grounded_worm/engineering,
		/datum/prototype/robot_iconset/baseline_standard/engineering,
		/datum/prototype/robot_iconset/baseline_old/hazardvest,
		/datum/prototype/robot_iconset/raptor/engineering,
		/datum/prototype/robot_iconset/baseline_old/engineer,
	)

/datum/prototype/robot_module/nanotrasen/engineering/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/steel::id] = new /datum/robot_resource/provisioned/preset/material/steel
	store.provisioned_material_store[/datum/prototype/material/glass::id] = new /datum/robot_resource/provisioned/preset/material/glass
	store.provisioned_material_store[/datum/prototype/material/plasteel::id] = new /datum/robot_resource/provisioned/preset/material/plasteel
	store.provisioned_material_store[/datum/prototype/material/wood_plank::id] = new /datum/robot_resource/provisioned/preset/material/wood
	store.provisioned_material_store[/datum/prototype/material/plastic::id] = new /datum/robot_resource/provisioned/preset/material/plastic
	store.provisioned_stack_store[/obj/item/stack/cable_coil] = new /datum/robot_resource/provisioned/preset/wire

/datum/prototype/robot_module/nanotrasen/engineering/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		// todo: better way to do 'sum types'?
		normal_out |= list(
			/obj/item/stack/rods,
			/obj/item/stack/tile/wood,
			/obj/item/stack/tile/floor,
			/obj/item/stack/tile/roofing,
			/obj/item/stack/material/glass/reinforced,
		)
		normal_out |= list(
			/obj/item/matter_decompiler,
			/obj/item/borg/sight/meson,
			/obj/item/weldingtool/electric/mounted/cyborg,
			/obj/item/tool/screwdriver/cyborg,
			/obj/item/tool/wrench/cyborg,
			/obj/item/tool/wirecutters/cyborg,
			/obj/item/multitool,
			/obj/item/t_scanner,
			/obj/item/rcd/electric/mounted/borg,
			/obj/item/atmos_analyzer,
			/obj/item/barrier_tape_roll/engineering,
			/obj/item/inflatable_dispenser/robot,
			/obj/item/pickaxe/plasmacutter,
			/obj/item/geiger_counter/cyborg,
			/obj/item/pipe_painter,
			/obj/item/floor_painter,
			/obj/item/gripper,
			/obj/item/gripper/no_use/loader,
			/obj/item/pipe_dispenser,
			/obj/item/gripper/circuit,
			/obj/item/lightreplacer,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/melee/baton/robot/arm,
		)

// todo: legacy
/obj/item/robot_module_legacy/robot/engineering
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
