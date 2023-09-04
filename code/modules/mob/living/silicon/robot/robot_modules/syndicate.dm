/* Syndicate modules */

/obj/item/robot_module/robot/syndicate
	name = "illegal robot module"
	hide_on_manifest = 1
	languages = list(
		LANGUAGE_SOL_COMMON = 1,
		LANGUAGE_TRADEBAND = 1,
		LANGUAGE_UNATHI = 0,
		LANGUAGE_SIIK	= 0,
		LANGUAGE_AKHANI = 0,
		LANGUAGE_SKRELLIAN = 0,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_ROOTLOCAL = 0,
		LANGUAGE_GUTTER = 1,
		LANGUAGE_SCHECHI = 0,
		LANGUAGE_EAL	 = 1,
		LANGUAGE_SIGN	 = 0,
		LANGUAGE_TERMINUS = 1,
		LANGUAGE_ZADDAT = 0
	)
	sprites = list(
		"Cerberus" = "syndie_bloodhound",
		"Cerberus - Treaded" = "syndie_treadhound",
		"Ares" = "squats",
		"Telemachus" = "toiletbotantag",
		"WTOperator" = "hosborg",
		"XI-GUS" = "spidersyndi",
		"XI-ALP" = "syndi-heavy"
	)
	var/id

// All syndie modules get these, and the base borg items (flash, crowbar, etc).
/obj/item/robot_module/robot/syndicate/get_modules()
	. = ..()
	. |= list(
		/obj/item/pinpointer/shuttle/merc,
		/obj/item/melee/energy/sword
	)

/obj/item/robot_module/robot/syndicate/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	var/jetpack = new/obj/item/tank/jetpack/carbondioxide(src)
	. += jetpack
	R.internals = jetpack

	id = R.idcard
	. += id

/obj/item/robot_module/robot/syndicate/Destroy()
	src.modules -= id
	id = null
	return ..()

// Gets a big shield and a gun that shoots really fast to scare the opposing force.
/obj/item/robot_module/robot/syndicate/protector
	name = "protector robot module"
	sprites = list(
		"Cerberus - Treaded" = "syndie_treadhound",
		"Cerberus" = "syndie_bloodhound",
		"Ares" = "squats",
		"XI-ALP" = "syndi-heavy"
	)

/obj/item/robot_module/robot/syndicate/protector/get_modules()
	. = ..()
	. |= list(
		/obj/item/shield_projector/rectangle/weak,
		/obj/item/gun/projectile/energy/dakkalaser,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot
	)

// 95% engi-borg and 15% roboticist.
/obj/item/robot_module/robot/syndicate/mechanist
	name = "mechanist robot module"
	sprites = list(
		"XI-GUS" = "spidersyndi",
		"WTOperator" = "sleekhos"
	)

/obj/item/robot_module/robot/syndicate/mechanist/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/meson,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool/ai_detector,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/rcd/electric/mounted/borg/lesser, // Can't eat rwalls to prevent AI core cheese.
		/obj/item/melee/energy/sword/ionic_rapier,

		// FBP repair.
		/obj/item/robotanalyzer,
		/obj/item/shockpaddles/robot/jumper,
		/obj/item/gripper/no_use/organ/robotics,

		// Hacking other things.
		/obj/item/card/robot/syndi,
		/obj/item/card/emag
	)

/obj/item/robot_module/robot/syndicate/mechanist/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_NANITES, nanite, 10000)
	MATTER_SYNTH(MATSYN_WIRE, wire)
	MATTER_SYNTH(MATSYN_METAL, metal, 40000)
	MATTER_SYNTH(MATSYN_GLASS, glass, 40000)

/obj/item/robot_module/robot/syndicate/mechanist/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// General engineering/hacking.

	// Materials.
	var/datum/matter_synth/nanite = synths_by_kind[MATSYN_NANITES]
	var/datum/matter_synth/wire = synths_by_kind[MATSYN_WIRE]
	var/datum/matter_synth/metal = synths_by_kind[MATSYN_METAL]
	var/datum/matter_synth/glass = synths_by_kind[MATSYN_GLASS]

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	. += N

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	. += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	. += G

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	. += rods

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	. += C

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	. += RG


// Mediborg optimized for on-the-field healing, but can also do surgery if needed.
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
