/*
*	Here is where any supply packs
*	related to robotics tasks live.
*/

//PROSTHETICS

/datum/supply_pack/robotics
	group = "Robotics"

/datum/supply_pack/randomised/robotics
	group = "Robotics"
	access = access_robotics

/datum/supply_pack/robotics/robotics_assembly
	name = "Robotics assembly crate"
	contains = list(
			/obj/item/assembly/prox_sensor = 3,
			/obj/item/storage/toolbox/electrical,
			/obj/item/flash = 4,
			/obj/item/cell/high = 2
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Robotics assembly"
	access = access_robotics

/*/datum/supply_pack/robotics/robolimbs_basic
	name = "Basic robolimb blueprints"
	contains = list(
			/obj/item/disk/limb/morpheus,
			/obj/item/disk/limb/xion
			)
	cost = 15
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Robolimb blueprints (basic)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs_adv
	name = "All robolimb blueprints"
	contains = list(
	/obj/item/disk/limb/bishop,
	/obj/item/disk/limb/hephaestus,
	/obj/item/disk/limb/morpheus,
	/obj/item/disk/limb/veymed,
	/obj/item/disk/limb/wardtakahashi,
	/obj/item/disk/limb/xion,
	/obj/item/disk/limb/zenghu,
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/gear
	container_name = "Robolimb blueprints (adv)"
	access = access_robotics
*/

/datum/supply_pack/robotics/robolimbs/morpheus
	name = "Morpheus robolimb blueprints"
	contains = list(/obj/item/disk/limb/morpheus)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/morpheus
	container_name = "Robolimb blueprints (Morpheus)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/antares
	name = "Antares robolimb blueprints"
	contains = list(/obj/item/disk/limb/antares)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Robolimb blueprints (Antares)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/cybersolutions
	name = "Cyber Solutions robolimb blueprints"
	contains = list(/obj/item/disk/limb/cybersolutions)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Robolimb blueprints (Cyber Solutions)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/xion
	name = "Xion robolimb blueprints"
	contains = list(/obj/item/disk/limb/xion)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/xion
	container_name = "Robolimb blueprints (Xion)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/grayson
	name = "Grayson robolimb blueprints"
	contains = list(/obj/item/disk/limb/grayson)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/grayson
	container_name = "Robolimb blueprints (Grayson)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/hephaestus
	name = "Hephaestus robolimb blueprints"
	contains = list(/obj/item/disk/limb/hephaestus)
	cost = 35
	container_type = /obj/structure/closet/crate/secure/heph
	container_name = "Robolimb blueprints (Hephaestus)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/wardtakahashi
	name = "Ward-Takahashi robolimb blueprints"
	contains = list(/obj/item/disk/limb/wardtakahashi)
	cost = 35
	container_type = /obj/structure/closet/crate/secure/ward
	container_name = "Robolimb blueprints (Ward-Takahashi)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/zenghu
	name = "Zeng Hu robolimb blueprints"
	contains = list(/obj/item/disk/limb/zenghu)
	cost = 35
	container_type = /obj/structure/closet/crate/secure/zenghu
	container_name = "Robolimb blueprints (Zeng Hu)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/bishop
	name = "Bishop robolimb blueprints"
	contains = list(/obj/item/disk/limb/bishop)
	cost = 70
	container_type = /obj/structure/closet/crate/secure/bishop
	container_name = "Robolimb blueprints (Bishop)"
	access = access_robotics

/datum/supply_pack/robotics/robolimbs/cenilimicybernetics
	name = "Cenilimi Cybernetics robolimb blueprints"
	contains = list(/obj/item/disk/limb/cenilimicybernetics)
	cost = 45
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Robolimb blueprints (Cenilimi Cybernetics)"
	access = access_robotics

//MECHS

/datum/supply_pack/robotics/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
			/obj/item/book/manual/ripley_build_and_repair,
			/obj/item/circuitboard/mecha/ripley/main,
			/obj/item/circuitboard/mecha/ripley/peripherals
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
			/obj/item/circuitboard/mecha/odysseus/peripherals,
			/obj/item/circuitboard/mecha/odysseus/main
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "\"Odysseus\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/randomised/robotics/exosuit_mod
	num_contained = 1
	contains = list(
			/obj/random/paintkit,
			/obj/random/paintkit,
			/obj/random/paintkit,
			/obj/random/paintkit
			)
	name = "Random APLU modkit"
	cost = 200
	container_type = /obj/structure/closet/crate/science
	container_name = "heavy crate"

/datum/supply_pack/randomised/robotics/exosuit_mod/durand
	contains = list(
			/obj/random/paintkit/durand,
			/obj/random/paintkit/durand,
			/obj/random/paintkit/durand
			)
	name = "Random Durand exosuit modkit"

/datum/supply_pack/randomised/robotics/exosuit_mod/gygax
	contains = list(
			/obj/random/paintkit/gygax,
			/obj/random/paintkit/gygax,
			/obj/random/paintkit/gygax
			)
	name = "Random Gygax exosuit modkit"

/datum/supply_pack/robotics/jumper_cables
	name = "Jumper kit crate"
	contains = list(
			/obj/item/defib_kit/jumper_kit = 2
			)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "Jumper kit crate"
	access = access_robotics

/datum/supply_pack/robotics/restrainingbolt
	name = "Restraining bolt crate"
	contains = list(
			/obj/item/implanter = 1,
			/obj/item/implantcase/restrainingbolt = 2
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/cybersolutions
	container_name = "Restraining bolt crate"
	access = access_robotics


/datum/supply_pack/robotics/mecha_gopher
	name = "Circuit Crate (\"Gopher\" APLU)"
	contains = list(
			/obj/item/circuitboard/mecha/gopher/main,
			/obj/item/circuitboard/mecha/gopher/peripherals
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "APLU \"Gopher\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/mecha_polecat
	name = "Circuit Crate (\"Polecat\" APLU)"
	contains = list(
			/obj/item/circuitboard/mecha/polecat/main,
			/obj/item/circuitboard/mecha/polecat/peripherals,
			/obj/item/circuitboard/mecha/polecat/targeting
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "APLU \"Polecat\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/mecha_weasel
	name = "Circuit Crate (\"Weasel\" APLU)"
	contains = list(
			/obj/item/circuitboard/mecha/weasel/main,
			/obj/item/circuitboard/mecha/weasel/peripherals,
			/obj/item/circuitboard/mecha/weasel/targeting
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/science
	container_name = "APLU \"Weasel\" Circuit Crate"
	access = access_robotics

/datum/supply_pack/robotics/some_robolimbs
	name = "Basic Robolimb Blueprints"
	contains = list(
			/obj/item/disk/limb/morpheus,
			/obj/item/disk/limb/xion,
			/obj/item/disk/limb/talon
			)
	cost = 15
	container_type = /obj/structure/closet/crate/secure
	container_name = "Basic Robolimb Blueprint Crate"
	access = access_robotics

/datum/supply_pack/robotics/all_robolimbs
	name = "Advanced Robolimb Blueprints"
	contains = list(
			/obj/item/disk/limb/bishop,
			/obj/item/disk/limb/hephaestus,
			/obj/item/disk/limb/morpheus,
			/obj/item/disk/limb/veymed,
			/obj/item/disk/limb/wardtakahashi,
			/obj/item/disk/limb/xion,
			/obj/item/disk/limb/zenghu,
			/obj/item/disk/limb/talon,
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
			/obj/item/disk/limb/antares
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure
	container_name = "Advanced Robolimb Blueprint Crate"
	access = access_robotics
