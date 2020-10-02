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
					"Acheron" = "mechoid-Science",
					"ZOOM-BA" = "zoomba-research",
					 )

/obj/item/robot_module/robot/research/New()
	..()
	src.modules += new /obj/item/portable_destructive_analyzer(src)
	src.modules += new /obj/item/gripper/research(src)
	src.modules += new /obj/item/gripper/circuit(src)
	src.modules += new /obj/item/gripper/no_use/organ/robotics(src)
	src.modules += new /obj/item/gripper/no_use/mech(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/robotanalyzer(src)
	src.modules += new /obj/item/card/robot(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/reagent_containers/syringe(src)
	src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/storage/part_replacer(src)
	src.modules += new /obj/item/shockpaddles/robot/jumper(src)
	src.modules += new /obj/item/melee/baton/slime/robot(src)
	src.modules += new /obj/item/gun/energy/taser/xeno/robot(src)
	src.emag = new /obj/item/hand_tele(src)

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()						//Added to allow repairs, would rather add cable now than be asked to add it later,
	synths += wire																		//Cable code, taken from engiborg,

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)	//Cable code, taken from engiborg,
	C.synths = list(wire)
	src.modules += C

/obj/item/robot_module/robot/research/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	..()

/obj/item/robot_module/robot/science
	name = "Research Hound Module"
	sprites = list(
					"Research Hound" = "science",
					"Borgi" = "borgi-sci"
					)
	channels = list("Science" = 1)
	can_be_pushed = 0

/obj/item/robot_module/robot/science/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.modules += new /obj/item/gripper/research(src)
	src.modules += new /obj/item/gripper/no_use/organ/robotics(src)
	src.modules += new /obj/item/gripper/no_use/mech(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/robotanalyzer(src)
	src.modules += new /obj/item/stack/cable_coil/cyborg(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/storage/part_replacer(src)
	src.modules += new /obj/item/card/robot(src)
	src.modules += new /obj/item/shockpaddles/robot/jumper(src)
	src.emag = new /obj/item/hand_tele(src)
	src.modules += new /obj/item/dogborg/jaws/small(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/dogborg/sleeper/compactor/analyzer/B = new /obj/item/dogborg/sleeper/compactor/analyzer(src)
	B.water = water
	src.modules += B

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.pixel_x 	 = -16
	R.old_x 	 = -16
	R.default_pixel_x = -16
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/robot_mount
	R.verbs |= /mob/living/proc/shred_limb
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
	..()
