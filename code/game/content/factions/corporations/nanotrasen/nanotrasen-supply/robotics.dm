/*
*	Here is where any supply packs
*	related to robotics tasks live.
*/

//PROSTHETICS

/datum/supply_pack/nanotrasen/robotics
	category = "Robotics"
	container_type = /obj/structure/closet/crate/science

/datum/supply_pack/nanotrasen/robotics/robotics_assembly
	name = "Robotics assembly crate"
	contains = list(
		/obj/item/assembly/prox_sensor = 3,
		/obj/item/storage/toolbox/electrical,
		/obj/item/flash = 4,
		/obj/item/cell/high = 2,
	)
	worth = 250 // literally only because of the flashes; nerf flashes when?

/datum/supply_pack/nanotrasen/robotics/restrainingbolt
	name = "Restraining bolt crate"
	contains = list(
		/obj/item/implanter = 1,
		/obj/item/implantcase/restrainingbolt = 2,
	)
	worth = 1000 // stun combat tax intensifies

/datum/supply_pack/nanotrasen/robotics/some_robolimbs
	name = "Basic Robolimb Blueprints"
	contains = list(
		/obj/item/disk/limb/morpheus,
		/obj/item/disk/limb/xion,
		/obj/item/disk/limb/talon,
	)
	worth = 500

/datum/supply_pack/nanotrasen/robotics/all_robolimbs
	name = "Advanced Robolimb Blueprints (No Basic)"
	contains = list(
		/obj/item/disk/limb/bishop,
		/obj/item/disk/limb/hephaestus,
		/obj/item/disk/limb/veymed,
		/obj/item/disk/limb/wardtakahashi,
		/obj/item/disk/limb/zenghu,
		/obj/item/disk/limb/dsi_tajaran,
		/obj/item/disk/limb/dsi_lizard,
		/obj/item/disk/limb/dsi_sergal,
		/obj/item/disk/limb/dsi_nevrean,
		/obj/item/disk/limb/dsi_vulpkanin,
		/obj/item/disk/limb/dsi_akula,
		/obj/item/disk/limb/dsi_spider,
		/obj/item/disk/limb/dsi_teshari,
		/obj/item/disk/limb/eggnerdltd,
		/obj/item/disk/limb/eggnerdltdred,
		/obj/item/disk/limb/antares,
		/obj/item/disk/limb/grayson,
		/obj/item/disk/limb/cybersolutions,
		/obj/item/disk/limb/cenilimicybernetics,
	)
	worth = 2500
	container_type = /obj/structure/closet/crate/secure

//* Mechs *//

/datum/supply_pack/nanotrasen/robotics/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
		/obj/item/book/manual/ripley_build_and_repair,
		/obj/item/circuitboard/mecha/ripley/main,
		/obj/item/circuitboard/mecha/ripley/peripherals,
	)
	worth = 275
	container_name = "APLU \"Ripley\" Circuit Crate"

/datum/supply_pack/nanotrasen/robotics/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
		/obj/item/circuitboard/mecha/odysseus/peripherals,
		/obj/item/circuitboard/mecha/odysseus/main,
	)
	worth = 275
	container_name = "\"Odysseus\" Circuit Crate"

/datum/supply_pack/nanotrasen/robotics/mecha_gopher
	name = "Circuit Crate (\"Gopher\" APLU)"
	contains = list(
		/obj/item/circuitboard/mecha/gopher/main,
		/obj/item/circuitboard/mecha/gopher/peripherals,
	)
	worth = 275
	container_name = "APLU \"Gopher\" Circuit Crate"

/datum/supply_pack/nanotrasen/robotics/mecha_polecat
	name = "Circuit Crate (\"Polecat\" APLU)"
	contains = list(
		/obj/item/circuitboard/mecha/polecat/main,
		/obj/item/circuitboard/mecha/polecat/peripherals,
		/obj/item/circuitboard/mecha/polecat/targeting,
	)
	worth = 275
	container_name = "APLU \"Polecat\" Circuit Crate"

/datum/supply_pack/nanotrasen/robotics/mecha_weasel
	name = "Circuit Crate (\"Weasel\" APLU)"
	contains = list(
		/obj/item/circuitboard/mecha/weasel/main,
		/obj/item/circuitboard/mecha/weasel/peripherals,
		/obj/item/circuitboard/mecha/weasel/targeting,
	)
	worth = 275
	container_name = "APLU \"Weasel\" Circuit Crate"

//* Mechs - Paintkits *//

/datum/supply_pack/nanotrasen/robotics/exosuit_mod
	name = "Random APLU modkit"
	contains = list(
		/obj/random/paintkit,
	)
	worth = 750
	container_name = "heavy crate"

/datum/supply_pack/nanotrasen/robotics/exosuit_mod/durand
	name = "Random Durand exosuit modkit"
	contains = list(
		/obj/random/paintkit,
	)

/datum/supply_pack/nanotrasen/robotics/exosuit_mod/gygax
	name = "Random Gygax exosuit modkit"
	contains = list(
		/obj/random/paintkit/gygax,
	)
