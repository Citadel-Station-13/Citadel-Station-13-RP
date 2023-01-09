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
		"Miss M" = "miss-engineer",
		"Coffstruction" = "coffin-Construction",
		"Coffgineer" = "coffin-Engineering",
		"X-88" = "xeightyeight-engineering",
		"Acheron" = "mechoid-Engineering",
		"Shellguard Noble" = "Noble-ENG",
		"ZOOM-BA" = "zoomba-engineering",
		"W02M" = "worm-engineering"
	)

/obj/item/robot_module/robot/engineering/construction
	name = "construction robot module"
	no_slip = 1

/* Merged back into engineering (Hell, it's about time.)

/obj/item/robot_module/robot/engineering/construction/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/rcd/borg(src)
	src.modules += new /obj/item/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/pipe_painter(src)
	src.modules += new /obj/item/floor_painter(src)
	src.modules += new /obj/item/gripper/no_use/loader(src)
	src.modules += new /obj/item/geiger_counter(src)

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

/obj/item/robot_module/robot/engineering/general/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/meson,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/barrier_tape_roll/engineering,
		/obj/item/gripper,
		/obj/item/gripper/circuit,
		/obj/item/lightreplacer,
		/obj/item/pipe_painter,
		/obj/item/floor_painter,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/geiger_counter/cyborg,
		/obj/item/rcd/electric/mounted/borg,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/gripper/no_use/loader,
		/obj/item/pipe_dispenser
	)

/obj/item/robot_module/robot/engineering/general/get_synths(mob/living/silicon/robot/R)
	. = ..()
	MATTER_SYNTH(MATSYN_METAL, metal, 40000)
	MATTER_SYNTH(MATSYN_GLASS, glass, 40000)
	MATTER_SYNTH(MATSYN_PLASTEEL, plasteel, 20000)
	MATTER_SYNTH(MATSYN_WOOD, wood, 40000)
	MATTER_SYNTH(MATSYN_PLASTIC, plastic, 40000)
	MATTER_SYNTH(MATSYN_WIRE, wire)

/obj/item/robot_module/robot/engineering/general/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/melee/baton/robot/arm(src)

	var/datum/matter_synth/metal = synths_by_kind[MATSYN_METAL]
	var/datum/matter_synth/glass = synths_by_kind[MATSYN_GLASS]
	var/datum/matter_synth/plasteel = synths_by_kind[MATSYN_PLASTEEL]
	var/datum/matter_synth/wood = synths_by_kind[MATSYN_WOOD]
	var/datum/matter_synth/plastic = synths_by_kind[MATSYN_PLASTIC]

	var/obj/item/matter_decompiler/MD = new /obj/item/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	. += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	. += G

	var/obj/item/stack/rods/cyborg/rods = new /obj/item/stack/rods/cyborg(src)
	rods.synths = list(metal)
	. += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(synths_by_kind[MATSYN_WIRE])
	. += C

	var/obj/item/stack/material/cyborg/plasteel/PS = new (src)
	PS.synths = list(plasteel)
	. += PS

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	. += S

	var/obj/item/stack/tile/roofing/cyborg/CT = new /obj/item/stack/tile/roofing/cyborg(src)
	CT.synths = list(metal)
	. += CT

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	. += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	. += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	. += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	. += PL


/obj/item/robot_module/robot/quad/engi
	name = "EngiQuad module"
	sprites = list(
		"Pupdozer" = "pupdozer",
		"V2 Engidog" = "thottbot",
		"Borgi" = "borgi-eng",
		"Engineering Hound" = "engihound",
		"Engineering Hound Dark" = "engihounddark",
		"F3-LINE" = "FELI-Engineer"
	)
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	can_be_pushed = 0
	can_shred = TRUE

/obj/item/robot_module/robot/quad/engi/get_modules()
	. = ..()
	. |= list(
		/obj/item/borg/sight/meson,
		/obj/item/weldingtool/electric/mounted/cyborg,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/rcd/electric/mounted/borg,
		/obj/item/analyzer,
		/obj/item/barrier_tape_roll/engineering,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/pickaxe/plasmacutter,
		/obj/item/dogborg/jaws/small,
		/obj/item/dogborg/boop_module,
		/obj/item/geiger_counter,
		/obj/item/pipe_painter,
		/obj/item/floor_painter,
		/obj/item/gripper,
		/obj/item/gripper/no_use/loader,
		/obj/item/pipe_dispenser,
		/obj/item/gripper/circuit
	)

/obj/item/robot_module/robot/quad/engi/get_synths(mob/living/silicon/robot/R)
	. = ..()
	//Painfully slow charger regen but high capacity. Also starts with low amount.
	MATTER_SYNTH_WITH_NAME(MATSYN_METAL   , metal   , "Steel reserves"   , 40000)
	MATTER_SYNTH_WITH_NAME(MATSYN_GLASS   , glass   , "Glass reserves"   , 40000)
	MATTER_SYNTH_WITH_NAME(MATSYN_WOOD    , wood    , "Wood reserves"    , 40000)
	MATTER_SYNTH_WITH_NAME(MATSYN_PLASTIC , plastic , "Plastic reserves" , 40000)
	MATTER_SYNTH_WITH_NAME(MATSYN_PLASTEEL, plasteel, "Plasteel reserves", 20000)
	MATTER_SYNTH(MATSYN_WIRE, wire)

/obj/item/robot_module/robot/quad/engi/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()

	src.emag = new /obj/item/dogborg/pounce(src)

	var/datum/matter_synth/metal = synths_by_kind[MATSYN_METAL]
	var/datum/matter_synth/glass = synths_by_kind[MATSYN_GLASS]
	var/datum/matter_synth/wood = synths_by_kind[MATSYN_WOOD]
	var/datum/matter_synth/plastic = synths_by_kind[MATSYN_PLASTIC]
	// var/datum/matter_synth/plasteel = synths_by_kind[MATSYN_PLASTEEL]
	var/datum/matter_synth/wire = synths_by_kind[MATSYN_WIRE]

	var/obj/item/lightreplacer/dogborg/LR = new /obj/item/lightreplacer/dogborg(src)
	LR.glass = glass
	. += LR

	var/obj/item/dogborg/sleeper/compactor/decompiler/MD = new /obj/item/dogborg/sleeper/compactor/decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	MD.water = synths_by_kind[MATSYN_WATER]
	. += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	. += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	. += G

	var/obj/item/stack/rods/cyborg/RD = new /obj/item/stack/rods/cyborg(src)
	RD.synths = list(metal)
	. += RD

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	. += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	. += S

	var/obj/item/stack/tile/roofing/cyborg/CT = new /obj/item/stack/tile/roofing/cyborg(src)
	CT.synths = list(metal)
	. += CT

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	. += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	. += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	. += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	. += PL
