GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/medical)
/datum/prototype/robot_module/nanotrasen/medical
	id = "nt-medical"
	display_name = "NT-MED"
	visible_name = "Medical"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/medical
	module_hud_state = "medical"
	light_color = "#0099FF"
	auto_iconsets = list(
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
		/datum/prototype/robot_iconset/raptor/medical,
		/datum/prototype/robot_iconset/hover_coffin/medical,
		/datum/prototype/robot_iconset/baseline_old/medical_2,
	)

/datum/prototype/robot_module/nanotrasen/medical/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |=  list(
			/obj/item/borg/sight/hud/med,
			/obj/item/healthanalyzer/advanced,
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
			/obj/item/mirrortool,
		)
	if(emag_out)
		var/obj/item/reagent_containers/spray/acid_spray = new
		acid_spray.reagents.add_reagent(/datum/reagent/acid/polyacid::id, 250)
		acid_spray.name = "Polyacid spray"
		emag_out |= acid_spray

/datum/prototype/robot_module/nanotrasen/medical/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/bruise_pack] = new /datum/robot_resource/provisioned/preset/bandages/advanced
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/ointment] = new /datum/robot_resource/provisioned/preset/ointment/advanced
	store.provisioned_stack_store[/obj/item/stack/medical/splint] = new /datum/robot_resource/provisioned/preset/splints
	store.provisioned_stack_store[/obj/item/stack/nanopaste] = new /datum/robot_resource/provisioned/preset/nanopaste

// todo: this is evil
/datum/prototype/robot_module/nanotrasen/medical/legacy_custom_regenerate_resources(mob/living/silicon/robot/robot, dt, multiplier)
	..()
	for(var/obj/item/reagent_containers/spray/maybe_evil_acid_spray in robot.robot_inventory.provided_items)
		if(maybe_evil_acid_spray.name != "Polyacid spray")
			continue
		maybe_evil_acid_spray.reagents?.add_reagent(/datum/reagent/acid/polyacid::id, 2 * dt)

// todo: legacy
/obj/item/robot_module_legacy/robot/medical
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
