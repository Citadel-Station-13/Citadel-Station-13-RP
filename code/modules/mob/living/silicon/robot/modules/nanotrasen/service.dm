GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/service)
/datum/prototype/robot_module/nanotrasen/service
	id = "nt-service"
	display_name = "NT-Service"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/clerical
	module_hud_state = "service"
	light_color = "#6AED63"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/baseline_standard/service,
		/datum/prototype/robot_iconset/baseline_standard/clerical,
		/datum/prototype/robot_iconset/dog_k9/grey,
		/datum/prototype/robot_iconset/dog_k9/pink,
		/datum/prototype/robot_iconset/dog_vale/service,
		/datum/prototype/robot_iconset/dog_vale/service_dark,
		/datum/prototype/robot_iconset/cat_feli/service,
		/datum/prototype/robot_iconset/drake_mizartz/peacekeeper,
		/datum/prototype/robot_iconset/biped_marina/service,
		/datum/prototype/robot_iconset/biped_maid,
		/datum/prototype/robot_iconset/biped_tall/tallgreen,
		/datum/prototype/robot_iconset/baseline_toiletbot/security,
		/datum/prototype/robot_iconset/biped_sleek/service,
		/datum/prototype/robot_iconset/baseline_misc/omoikane,
		/datum/prototype/robot_iconset/grounded_spider/standard,
		/datum/prototype/robot_iconset/biped_heavy/service,
		/datum/prototype/robot_iconset/baseline_old/service,
		/datum/prototype/robot_iconset/baseline_old/service_fancy,
		/datum/prototype/robot_iconset/baseline_old/service_hydro,
		/datum/prototype/robot_iconset/baseline_old/service_skirt,
		/datum/prototype/robot_iconset/baseline_old/service_sweater,
		/datum/prototype/robot_iconset/grounded_spider/command,
		/datum/prototype/robot_iconset/biped_tall/alternative/service,
		/datum/prototype/robot_iconset/hover_drone/service,
		/datum/prototype/robot_iconset/hover_drone/hydroponics,
		/datum/prototype/robot_iconset/hover_glitterfly/clerical,
		/datum/prototype/robot_iconset/hover_glitterfly/service,
		/datum/prototype/robot_iconset/hover_handy/service,
		/datum/prototype/robot_iconset/grounded_mechoid/service,
		/datum/prototype/robot_iconset/grounded_zoomba/service,
		/datum/prototype/robot_iconset/biped_noble/service,
		/datum/prototype/robot_iconset/grounded_worm/service,
		/datum/prototype/robot_iconset/biped_miss/service,
		/datum/prototype/robot_iconset/hover_handy/clerk,
		/datum/prototype/robot_iconset/raptor/service,
	)

/datum/prototype/robot_module/nanotrasen/service/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/soap/nanotrasen,
			/obj/item/storage/bag/trash,
			/obj/item/gripper/service,
			/obj/item/reagent_containers/glass/bucket,
			/obj/item/reagent_containers/dropper/industrial,
			/obj/item/flame/lighter/zippo,
			/obj/item/reagent_containers/borghypo/service,
			/obj/item/material/minihoe,
			/obj/item/material/knife/machete/hatchet,
			/obj/item/plant_analyzer,
			/obj/item/storage/bag/plants,
			/obj/item/robot_harvester,
			/obj/item/material/knife,
			/obj/item/material/kitchen/rollingpin,
			/obj/item/pen/robopen,
			/obj/item/form_printer,
			/obj/item/gripper/paperwork,
			/obj/item/hand_labeler,
			/obj/item/stamp,
			/obj/item/stamp/denied,
			/obj/item/tray/robotray,
			/obj/item/rsf/loaded,
			/obj/item/reagent_containers/food/condiment/enzyme,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/stamp/chameleon,
			/obj/item/pen/chameleon,
		)

/datum/prototype/robot_module/nanotrasen/service/legacy_custom_regenerate_resources(mob/living/silicon/robot/robot, dt, multiplier)
	var/obj/item/reagent_containers/food/condiment/enzyme/E = locate() in robot
	E.reagents.add_reagent("enzyme", 2 * multiplier * dt)

// todo: legacy
/obj/item/robot_module_legacy/robot/clerical
	name = "service robot module"
	channels = list("Service" = 1)
	languages = list(
		LANGUAGE_AKHANI		= 1,
		LANGUAGE_BIRDSONG	= 1,
		LANGUAGE_CANILUNZT	= 1,
		LANGUAGE_DAEMON		= 1,
		LANGUAGE_EAL		= 1,
		LANGUAGE_ECUREUILIAN= 1,
		LANGUAGE_ENOCHIAN	= 1,
		LANGUAGE_GUTTER		= 1,
		LANGUAGE_ROOTLOCAL	= 0,
		LANGUAGE_SAGARU		= 1,
		LANGUAGE_SCHECHI	= 1,
		LANGUAGE_SIGN		= 0,
		LANGUAGE_SIIK		= 1,
		LANGUAGE_SKRELLIAN	= 1,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_SOL_COMMON	= 1,
		LANGUAGE_SQUEAKISH	= 1,
		LANGUAGE_TERMINUS	= 1,
		LANGUAGE_TRADEBAND	= 1,
		LANGUAGE_UNATHI		= 1,
		LANGUAGE_ZADDAT		= 1
	)
