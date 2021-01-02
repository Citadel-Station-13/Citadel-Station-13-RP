/obj/item/robot_module/robot/engineering
	name = "engineering robot module"
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	sprites = list(
					"M-USE NanoTrasen" = "robotEngi",
					"Cabeiri" = "eyebot-engineering",
					"Haruka" = "marinaENG",
					"Usagi" = "tallyellow",
					"Telemachus" = "toiletbotengineering",
					"WTOperator" = "sleekce",
					"XI-GUS" = "spidereng",
					"XI-ALP" = "heavyEng",
					"Basic" = "Engineering",
					"Antique" = "engineerrobot",
					"Landmate" = "landmate",
					"Landmate - Treaded" = "engiborg+tread",
					"Drone" = "drone-engineer",
					"Treadwell" = "treadwell",
					"Handy" = "handy-engineer",
					"Misato" = "tall2engineer",
					"L3P1-D0T" = "Glitterfly-Engineering",
					"Miss M" = "miss-engineer"
					)

/obj/item/robot_module/robot/engineering/construction
	name = "construction robot module"
	no_slip = 1

/* Merged back into engineering (Hell, it's about time.)

/obj/item/robot_module/robot/engineering/construction/New()
	..()
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/rcd/borg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/pipe_painter(src)
	src.modules += new /obj/item/floor_painter(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/geiger(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal()
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel()
	var/datum/matter_synth/glass = new /datum/matter_synth/glass()
	synths += metal
	synths += plasteel
	synths += glass

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/tile/floor/cyborg/F = new /obj/item/stack/tile/floor/cyborg(src)
	F.synths = list(metal)
	src.modules += F

	var/obj/item/stack/material/cyborg/plasteel/S = new (src)
	S.synths = list(plasteel)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG
*/

/obj/item/robot_module/robot/engineering/general/New()
	..()
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/t_scanner(src)
	src.modules += new /obj/item/analyzer(src)
	src.modules += new /obj/item/barrier_tape_roll/engineering(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/gripper/circuit(src)
	src.modules += new /obj/item/lightreplacer(src)
	src.modules += new /obj/item/pipe_painter(src)
	src.modules += new /obj/item/floor_painter(src)
	src.modules += new /obj/item/inflatable_dispenser/robot(src)
	src.emag = new /obj/item/melee/baton/robot/arm(src)
	src.modules += new /obj/item/geiger(src)
	src.modules += new /obj/item/rcd/electric/mounted/borg(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/pipe_dispenser(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(40000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(40000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(40000)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += metal
	synths += glass
	synths += plasteel
	synths += wood
	synths += plastic
	synths += wire

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/material/cyborg/plasteel/PS = new (src)
	PS.synths = list(plasteel)
	src.modules += PS

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/tile/roofing/cyborg/CT = new /obj/item/stack/tile/roofing/cyborg(src)
	CT.synths = list(metal)
	src.modules += CT

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	src.modules += PL


/obj/item/robot_module/robot/engiedog
	name = "Construction Hound module"
	sprites = list(
					"Pupdozer" = "pupdozer",
					"V2 Engidog" = "thottbot",
					"Borgi" = "borgi-eng"
					)
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	can_be_pushed = 0

/obj/item/robot_module/robot/engiedog/New(var/mob/living/silicon/robot/R)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/multitool(src)
	src.modules += new /obj/item/t_scanner(src)
	src.modules += new /obj/item/analyzer(src)
	src.modules += new /obj/item/barrier_tape_roll/engineering(src)
	src.modules += new /obj/item/inflatable_dispenser/robot(src)
	src.modules += new /obj/item/pickaxe(src)
	src.modules += new /obj/item/dogborg/jaws/small(src)
	src.modules += new /obj/item/dogborg/boop_module(src)
	src.modules += new /obj/item/geiger(src)
	src.modules += new /obj/item/pipe_painter(src)
	src.modules += new /obj/item/floor_painter(src)
	src.modules += new /obj/item/gripper(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/pipe_dispenser(src)
	src.modules += new /obj/item/gripper/circuit(src)
	src.emag 	 = new /obj/item/dogborg/pounce(src)

	//Painfully slow charger regen but high capacity. Also starts with low amount.
	var/datum/matter_synth/metal = new /datum/matter_synth/metal(40000)
	metal.name = "Steel reserves"
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	glass.name = "Glass reserves"
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(40000)
	wood.name = "Wood reserves"
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(40000)
	plastic.name = "Plastic reserves"
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	plasteel.name = "Plasteel reserves"

	var/datum/matter_synth/water = new /datum/matter_synth(500)
	water.name = "Water reserves"
	water.recharge_rate = 0
	R.water_res = water

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += metal
	synths += glass
	synths += plasteel
	synths += wood
	synths += plastic
	synths += wire
	synths += water

	var/obj/item/dogborg/tongue/T = new /obj/item/dogborg/tongue(src)
	T.water = water
	src.modules += T

	var/obj/item/lightreplacer/dogborg/LR = new /obj/item/lightreplacer/dogborg(src)
	LR.glass = glass
	src.modules += LR

	var/obj/item/dogborg/sleeper/compactor/decompiler/MD = new /obj/item/dogborg/sleeper/compactor/decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	MD.water = water
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/RD = new /obj/item/stack/rods/cyborg(src)
	RD.synths = list(metal)
	src.modules += RD

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/tile/roofing/cyborg/CT = new /obj/item/stack/tile/roofing/cyborg(src)
	CT.synths = list(metal)
	src.modules += CT

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	src.modules += PL

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

	if(R.client && R.client.ckey in list("nezuli"))
		sprites += "Alina"
		sprites["Alina"] = "alina-eng"

	..()
