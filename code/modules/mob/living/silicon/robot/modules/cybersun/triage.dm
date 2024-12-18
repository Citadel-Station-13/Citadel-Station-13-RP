/datum/prototype/robot_module/cybersun/triage
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

/datum/prototype/robot_module/cybersun/triage/provision_resource_store(datum/robot_resource_store/store)
	..()

#warn translate chassis below

/obj/item/robot_module/robot/syndicate/combat_medic
	name = "combat medic robot module"
	sprites = list(
		"Telemachus" = "toiletbotantag"
	)

/obj/item/robot_module/robot/syndicate/combat_medic/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/hud/med,
		/obj/item/healthanalyzer/advanced,
		/obj/item/reagent_containers/borghypo/merc,

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
		/obj/item/reagent_containers/syringe,
		/obj/item/roller_holder
	)

/obj/item/robot_module/robot/syndicate/combat_medic/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_DRUGS, medicine, 15000)

/obj/item/robot_module/robot/syndicate/combat_medic/Initialize(mapload)
	. = ..()

	// Materials.
	var/datum/matter_synth/medicine = synths_by_kind[MATSYN_DRUGS]

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	. += O

	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	. += B

	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	. += S

/obj/item/robot_module/robot/syndicate/combat_medic/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	..()
