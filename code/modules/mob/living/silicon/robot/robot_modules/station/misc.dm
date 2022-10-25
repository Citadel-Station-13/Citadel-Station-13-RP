/obj/item/robot_module/robot/standard
	name = "standard robot module"
	sprites = list(
					"M-USE NanoTrasen" = "robot",
					"Cabeiri" = "eyebot-standard",
					"Haruka" = "marinaSD",
					"Usagi" = "tallflower",
					"Telemachus" = "toiletbot",
					"WTOperator" = "sleekstandard",
					"WTOmni" = "omoikane",
					"XI-GUS" = "spider",
					"XI-ALP" = "heavyStandard",
					"Basic" = "robot_old",
					"Android" = "droid",
					"Drone" = "drone-standard",
					"Insekt" = "insekt-Default",
					"Misato" = "tall2standard",
					"L3P1-D0T" = "Glitterfly-Standard",
					"Convict" = "servitor",
					"Miss M" = "miss-standard",
					"Coffin" = "coffin-Standard",
					"X-88" = "xeightyeight-standard"

					)


/obj/item/robot_module/robot/standard/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.emag = new /obj/item/melee/energy/sword(src)

/obj/item/robot_module/robot/basic_beast
	name = "Standard Beast module"
	sprites = list(
					"F3-LINE" = "FELI-Standard"
					)
	can_be_pushed = 0

// In a nutshell, basicly service/butler robot but in dog form.
/obj/item/robot_module/robot/basic_beast/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/R = loc
	src.modules += new /obj/item/melee/baton/loaded(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.emag = new /obj/item/melee/energy/sword(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500) // buffy fix, was 0
	water.name = "Water reserves"
	water.recharge_rate = 0
	water.max_energy = 1000
	R.water_res = water
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
	R.hands.icon = 'icons/mob/screen1_robot_vr.dmi'
	R.ui_style_vr = TRUE
	R.set_base_pixel_x(-16)
	R.dogborg = TRUE
	R.wideborg = TRUE
	R.icon_dimension_x = 64
	R.verbs |= /mob/living/silicon/robot/proc/ex_reserve_refill
	R.verbs |= /mob/living/silicon/robot/proc/rest_style
