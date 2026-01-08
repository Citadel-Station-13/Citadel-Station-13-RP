GENERATE_ROBOT_MODULE_PRESET(/cybersun/triage)
/datum/prototype/robot_module/cybersun/triage
	id = "cybersun-triage"
	display_name = "Cybersun Triage"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/
	light_color = "#FF0000"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/baseline_toiletbot/syndicate,
		/datum/prototype/robot_iconset/raptor/syndicate_medical,
	)

/datum/prototype/robot_module/cybersun/triage/provision_resource_store(datum/robot_resource_store/store)
	..()
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/bruise_pack] = new /datum/robot_resource/provisioned/preset/bandages/advanced
	store.provisioned_stack_store[/obj/item/stack/medical/advanced/ointment] = new /datum/robot_resource/provisioned/preset/ointment/advanced
	store.provisioned_stack_store[/obj/item/stack/nanopaste] = new /datum/robot_resource/provisioned/preset/nanopaste
	store.provisioned_stack_store[/obj/item/stack/medical/splint] = new /datum/robot_resource/provisioned/preset/splints

/datum/prototype/robot_module/cybersun/triage/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/borg/sight/hud/med,
			/obj/item/healthanalyzer/advanced,
			/obj/item/reagent_containers/borghypo/merc,
			/obj/item/reagent_containers/glass/beaker/large,

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

			// General healing.
			/obj/item/gripper/medical,
			/obj/item/shockpaddles/robot/combat,
			/obj/item/reagent_containers/dropper, // Allows borg to fix necrosis apparently
			/obj/item/reagent_containers/syringe/unbreakable,
			/obj/item/robot_builtin/dog_mirrortool,
			/obj/item/roller_holder,
		)
