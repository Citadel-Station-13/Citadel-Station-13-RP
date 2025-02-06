GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/janitor)
/datum/prototype/robot_module/nanotrasen/janitor
	id = "nt-janitor"
	use_robot_module_path = /obj/item/robot_module/robot/janitor
	light_color = "#CC60FF"
	iconsets = list(
		/datum/prototype/robot_iconset/baseline_toiletbot/janitor,
		/datum/prototype/robot_iconset/hover_eyebot/janitor,
		/datum/prototype/robot_iconset/biped_marina/janitor,
		/datum/prototype/robot_iconset/biped_sleek/janitor,
		/datum/prototype/robot_iconset/biped_heavy/janitor,
		/datum/prototype/robot_iconset/grounded_landmate/janitor,
		/datum/prototype/robot_iconset/biped_tall/alternative/janitor,
		/datum/prototype/robot_iconset/hover_drone/janitor,
		/datum/prototype/robot_iconset/hover_glitterfly/janitor,
		/datum/prototype/robot_iconset/biped_miss/janitor,
		/datum/prototype/robot_iconset/hover_handy/janitor,
		/datum/prototype/robot_iconset/grounded_mechoid/janitor,
		/datum/prototype/robot_iconset/grounded_zoomba/janitor,
		/datum/prototype/robot_iconset/biped_noble/janitor,
		/datum/prototype/robot_iconset/worm/janitor,
		/datum/prototype/robot_iconset/dog_borgi/janitor,
		/datum/prototype/robot_iconset/dog_k9/janitor,
		/datum/prototype/robot_iconset/dog_otie/janitor,
		/datum/prototype/robot_iconset/dog_vale/janitor,
		/datum/prototype/robot_iconset/drake_mizartz/janitor,
		/datum/prototype/robot_iconset/cat_feli/janitor,
	)

/datum/prototype/robot_module/nanotrasen/janitor/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/soap/nanotrasen,
			/obj/item/storage/bag/trash,
			/obj/item/mop/advanced,
			/obj/item/lightreplacer,
			/obj/item/gripper/service,
		)
	if(emag_out)
		var/obj/item/reagent_containers/spray/lube_spray = new
		lube_spray.reagents.add_reagent(/datum/reagent/lube, 250)
		lube_spray.name = "lube spray"
		emag_out |= lube_spray

/datum/prototype/robot_module/nanotrasen/janitor/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_material_store[/datum/prototype/material/glass::id] = new /datum/robot_resource/provisioned/preset/material/glass{regen_per_second = 1 * SHEET_MATERIAL_AMOUNT}

#warn translate chassis below

/obj/item/robot_module/robot/janitor
	name = "janitorial robot module"
	channels = list("Service" = 1)
	sprites = list(
		"M-USE Nanotrasen" = "robotJani",
		"Arachne" = "crawler",
		"Basic" = "JanBot2",
		"Mopbot"  = "janitorrobot",
		"Cleriffin" = "coffin-Clerical",
		"Coffstodial" = "coffin-Custodial",
	)

/obj/item/robot_module/robot/janitor/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)
