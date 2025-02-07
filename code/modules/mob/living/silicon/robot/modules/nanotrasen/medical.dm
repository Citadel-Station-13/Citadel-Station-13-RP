GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/medical)
/datum/prototype/robot_module/nanotrasen/medical
	id = "nt-medical"
	use_robot_module_path = /obj/item/robot_module/robot/medical
	light_color = "#0099FF"
	iconsets = list(
		/datum/prototype/robot_iconset/baseline_toiletbot/medical,
		/datum/prototype/robot_iconset/dog_borgi/medical,
		/datum/prototype/robot_iconset/dog_k9/medical,
		/datum/prototype/robot_iconset/dog_k9/medical_dark,
		/datum/prototype/robot_iconset/dog_vale/medical,
		/datum/prototype/robot_iconset/drake_mizartz/medical,
		/datum/prototype/robot_iconset/cat_feli/medical,
		/datum/prototype/robot_iconset/baseline_standard/medical,
		/datum/prototype/robot_iconset/hover_eyebot/medical,
		/datum/prototype/robot_iconset/biped_marina/medical,
		/datum/prototype/robot_iconset/biped_tall/tallwhite,
		/datum/prototype/robot_iconset/biped_tall/alternative/medical,
		/datum/prototype/robot_iconset/biped_sleek/cmo,
		/datum/prototype/robot_iconset/biped_sleek/medical,
		/datum/prototype/robot_iconset/biped_heavy/medical,
		/datum/prototype/robot_iconset/baseline_old/medical,
		/datum/prototype/robot_iconset/biped_droid/medical,
		/datum/prototype/robot_iconset/hover_drone/medical,
		/datum/prototype/robot_iconset/hover_handy/medical,
		/datum/prototype/robot_iconset/hover_drone/surgery,
		/datum/prototype/robot_iconset/biped_insekt/medical,
		/datum/prototype/robot_iconset/hover_glitterfly/surgeon,
		/datum/prototype/robot_iconset/biped_miss/medical,
		/datum/prototype/robot_iconset/hover_x88/medical,
		/datum/prototype/robot_iconset/grounded_mechoid/medical,
		/datum/prototype/robot_iconset/biped_noble/medical,
		/datum/prototype/robot_iconset/grounded_zoomba/medical,
		/datum/prototype/robot_iconset/grounded_worm/crisis,
		/datum/prototype/robot_iconset/,
		/datum/prototype/robot_iconset/,
	)

/datum/prototype/robot_module/nanotrasen/medical/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |=  list(
			/obj/item/borg/sight/hud/med,
			/obj/item/healthanalyzer,
			/obj/item/reagent_containers/borghypo/surgeon,
			/obj/item/reagent_containers/glass/beaker/large,
			/obj/item/reagent_scanner/adv,

			// Surgery things.
			/obj/item/autopsy_scanner,
			/obj/item/surgical/scalpel/cyborg,
			/obj/item/surgical/hemostat/cyborg,
			/obj/item/surgical/retractor/cyborg,
			/obj/item/surgical/cautery/cyborg,
			/obj/item/surgical/bonegel/cyborg,
			/obj/item/surgical/FixOVein/cyborg,
			/obj/item/surgical/bonesetter/cyborg,
			/obj/item/surgical/circular_saw/cyborg,
			/obj/item/surgical/surgicaldrill/cyborg,
			/obj/item/gripper/no_use/organ,

			/obj/item/gripper/medical,
			/obj/item/shockpaddles/robot,
			/obj/item/reagent_containers/dropper, // Allows surgeon borg to fix necrosis
			/obj/item/reagent_containers/syringe/unbreakable,
			/obj/item/roller_holder,
			/obj/item/robot_builtin/dog_mirrortool,
		)

/datum/prototype/robot_module/nanotrasen/medical/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/bruise_pack] = new /datum/robot_resource/provisioned/preset/bandages/advanced
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/ointment] = new /datum/robot_resource/provisioned/preset/ointment/advanced
	store.provisioned_stack_store[/obj/item/stack/medical/splint] = new /datum/robot_resource/provisioned/preset/splints
	store.provisioned_stack_store[/obj/item/stack/nanopaste] = new /datum/robot_resource/provisioned/preset/nanopaste

#warn translate chassis below

// todo: legacy
/obj/item/robot_module/robot/medical
	name = "medical robot module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)

/obj/item/robot_module/robot/medical/surgeon
	name = "medical robot module"
	sprites = list(
		"Minako" = "arachne",
		"Needles" = "medicalrobot",
		"Coffical" = "coffin-Medical",
		"Coffcue" = "coffin-Rescue",
	)

/obj/item/robot_module/robot/medical/surgeon/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

/obj/item/robot_module/robot/medical/surgeon/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	if(src.emag)
		var/obj/item/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)
	..()

