/obj/item/robot_module/robot/research
	name = "research module"
	channels = list("Science" = 1)
	sprites = list(
		"L'Ouef" = "peaceborg",
		"Cabeiri" = "eyebot-science",
		"Haruka" = "marinaSCI",
		"WTDove" = "whitespider",
		"WTOperator" = "sleekscience",
		"Droid" = "droid-science",
		"Drone" = "drone-science",
		"Handy" = "handy-science",
		"Insekt" = "insekt-Sci",
		"L3P1-D0T" = "Glitterfly-Research",
		"Coffsearch" = "coffin-Research",
		"X-88" = "xeightyeight-science",
		"Acheron" = "mechoid-Science",
		"ZOOM-BA" = "zoomba-research",
		"W02M" = "worm-engineering"
	)

/obj/item/robot_module/robot/research/get_synths()
	. = ..()
	MATTER_SYNTH(MATSYN_NANITES, nanite, 10000)
	MATTER_SYNTH(MATSYN_WIRE, wire)

/obj/item/robot_module/robot/research/get_modules()
	. = ..()
	. |= list(
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
		/obj/item/shockpaddles/robot/jumper,
		/obj/item/melee/baton/slime/robot,
		/obj/item/gun/energy/taser/xeno/robot
	)

/obj/item/robot_module/robot/research/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	src.emag = new /obj/item/borg/combat/shield(src)

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(synths_by_kind[MATSYN_NANITES])
	src.modules += N

	CYBORG_STACK(cable_coil/cyborg, list(MATSYN_WIRE))

/obj/item/robot_module/robot/research/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	..()

/obj/item/robot_module/robot/quad/sci
	name = "SciQuad Module"
	sprites = list(
		"Research Hound" = "science",
		"Borgi" = "borgi-sci",
		"F3-LINE" = "FELI-Research",
		"Sci-9" = "scihound",
		"Sci-9 Dark" = "scihounddark"
	)
	channels = list("Science" = 1)
	can_be_pushed = 0
	can_shred = TRUE

/obj/item/robot_module/robot/quad/sci/get_modules()
	. = ..()
	. |= list(
		/obj/item/portable_destructive_analyzer,
		/obj/item/dogborg/jaws/small,
		/obj/item/gripper/research,
		/obj/item/gripper/circuit,
		/obj/item/gripper/no_use/organ/robotics,
		/obj/item/gripper/no_use/mech,
		/obj/item/gripper/no_use/loader,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/robotanalyzer,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/multitool,
		/obj/item/reagent_containers/glass/beaker/large,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/part_replacer,
		/obj/item/card/robot,
		/obj/item/shockpaddles/robot/jumper,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/melee/baton/slime/robot,
		/obj/item/gun/energy/taser/xeno/robot,
		/obj/item/surgical/scalpel/cyborg,
		/obj/item/surgical/circular_saw/cyborg
	)

/obj/item/robot_module/robot/quad/sci/get_synths()
	. = ..()
	MATTER_SYNTH(MATSYN_NANITES, nanite, 10000)
	MATTER_SYNTH(MATSYN_WIRE, wire)

/obj/item/robot_module/robot/quad/sci/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(synths_by_kind[MATSYN_NANITES])
	. += N

	var/obj/item/dogborg/sleeper/compactor/analyzer/B = new /obj/item/dogborg/sleeper/compactor/analyzer(src)
	B.water = synths_by_kind[MATSYN_WATER]
	. += B

	CYBORG_STACK(cable_coil/cyborg, list(MATSYN_WIRE))

	src.emag = new /obj/item/borg/combat/shield(src)
