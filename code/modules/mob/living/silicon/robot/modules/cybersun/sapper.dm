/datum/prototype/robot_module/cybersun/sapper
	use_robot_module_path = /obj/item/robot_module/robot/
	allowed_frames = list(
	)

#warn translate chassis below
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
		/obj/item/melee/transforming/energy/sword/ionic_rapier,

		// FBP repair.
		/obj/item/robotanalyzer,
		/obj/item/shockpaddles/robot,
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
