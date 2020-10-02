/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/robot_module/robot/lost
	name = "lost robot module"
	hide_on_manifest = 1
	sprites = list(
					"Drone" = "drone-lost"
				)

/obj/item/robot_module/robot/lost/Initialize(mapload)
	. = ..()
	// Sec
	modules += new /obj/item/melee/baton/shocker/robot(src)
	modules += new /obj/item/handcuffs/cyborg(src)
	modules += new /obj/item/borg/combat/shield(src)

	// Med
	modules += new /obj/item/healthanalyzer(src)
	modules += new /obj/item/reagent_containers/borghypo/lost(src)

	// Engi
	modules += new /obj/item/weldingtool/electric/mounted(src)
	modules += new /obj/item/tool/screwdriver/cyborg(src)
	modules += new /obj/item/tool/wrench/cyborg(src)
	modules += new /obj/item/tool/wirecutters/cyborg(src)
	modules += new /obj/item/multitool(src)

	// Sci
	modules += new /obj/item/robotanalyzer(src)

	// Potato
	emag = new /obj/item/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

/obj/item/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	hide_on_manifest = 1
	sprites = list(
					"Drone" = "drone-gravekeeper",
					"Sleek" = "sleek-gravekeeper"
				)

/obj/item/robot_module/robot/gravekeeper/Initialize(mapload)
	. = ..()
	// For fending off animals and looters
	modules += new /obj/item/melee/baton/shocker/robot(src)
	modules += new /obj/item/borg/combat/shield(src)

	// For repairing gravemarkers
	modules += new /obj/item/weldingtool/electric/mounted(src)
	modules += new /obj/item/tool/screwdriver/cyborg(src)
	modules += new /obj/item/tool/wrench/cyborg(src)

	// For growing flowers
	modules += new /obj/item/material/minihoe(src)
	modules += new /obj/item/material/knife/machete/hatchet(src)
	modules += new /obj/item/analyzer/plant_analyzer(src)
	modules += new /obj/item/storage/bag/plants(src)
	modules += new /obj/item/robot_harvester(src)

	// For digging and beautifying graves
	modules += new /obj/item/shovel(src)
	modules += new /obj/item/gripper/gravekeeper(src)

	// For really persistent looters
	emag = new /obj/item/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	synths += wood

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	modules += W

/obj/item/robot_module/robot/stray
	name = "stray robot module"
	hide_on_manifest = 1
	sprites = list(
					"Stray" = "stray"
				)

/obj/item/robot_module/robot/stray/New(var/mob/living/silicon/robot/R)
	..()
	// General
	src.modules += new /obj/item/dogborg/boop_module(src)

	// Sec
	src.modules += new /obj/item/handcuffs/cyborg(src)
	src.modules += new /obj/item/dogborg/jaws/big(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/dogborg/pounce(src)

	// Med
	src.modules += new /obj/item/healthanalyzer(src)
	src.modules += new /obj/item/shockpaddles/robot/hound(src)

	// Engi
	src.modules += new /obj/item/weldingtool/electric/mounted(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)

	// Boof
	src.emag 	 = new /obj/item/gun/energy/retro/mounted(src)

	var/datum/matter_synth/water = new /datum/matter_synth(500) //Starts full and has a max of 500
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water
	synths += water

	var/obj/item/reagent_containers/borghypo/hound/lost/H = new /obj/item/reagent_containers/borghypo/hound/lost(src)
	H.water = water
	src.modules += H

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/dogborg/sleeper/B = new /obj/item/dogborg/sleeper(src)
	B.water = water
	src.modules += B

	R.icon 		 = 'icons/mob/widerobot_vr.dmi'
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
