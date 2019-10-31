/* Other, unaffiliated modules */

// The module that borgs on the surface have.  Generally has a lot of useful tools in exchange for questionable loyalty to the crew.
/obj/item/weapon/robot_module/robot/lost
	name = "lost robot module"
	hide_on_manifest = 1
	sprites = list(
					"Drone" = "drone-lost"
				)

/obj/item/weapon/robot_module/robot/lost/Initialize(mapload)
	. = ..()
	// Sec
	modules += new /obj/item/weapon/melee/baton/shocker/robot(src)
	modules += new /obj/item/weapon/handcuffs/cyborg(src)
	modules += new /obj/item/borg/combat/shield(src)

	// Med
	modules += new /obj/item/device/healthanalyzer(src)
	modules += new /obj/item/weapon/reagent_containers/borghypo/lost(src)

	// Engi
	modules += new /obj/item/weapon/weldingtool/electric/mounted(src)
	modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	modules += new /obj/item/device/multitool(src)

	// Sci
	modules += new /obj/item/device/robotanalyzer(src)

	// Potato
	emag = new /obj/item/weapon/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += wire

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	modules += C

/obj/item/weapon/robot_module/robot/gravekeeper
	name = "gravekeeper robot module"
	hide_on_manifest = 1
	sprites = list(
					"Drone" = "drone-gravekeeper",
					"Sleek" = "sleek-gravekeeper"
				)

/obj/item/weapon/robot_module/robot/gravekeeper/Initialize(mapload)
	. = ..()
	// For fending off animals and looters
	modules += new /obj/item/weapon/melee/baton/shocker/robot(src)
	modules += new /obj/item/borg/combat/shield(src)

	// For repairing gravemarkers
	modules += new /obj/item/weapon/weldingtool/electric/mounted(src)
	modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	modules += new /obj/item/weapon/tool/wrench/cyborg(src)

	// For growing flowers
	modules += new /obj/item/weapon/material/minihoe(src)
	modules += new /obj/item/weapon/material/knife/machete/hatchet(src)
	modules += new /obj/item/device/analyzer/plant_analyzer(src)
	modules += new /obj/item/weapon/storage/bag/plants(src)
	modules += new /obj/item/weapon/robot_harvester(src)

	// For digging and beautifying graves
	modules += new /obj/item/weapon/pickaxe/shovel(src)
	modules += new /obj/item/weapon/gripper/gravekeeper(src)

	// For really persistent looters
	emag = new /obj/item/weapon/gun/energy/retro/mounted(src)

	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	synths += wood

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	modules += W