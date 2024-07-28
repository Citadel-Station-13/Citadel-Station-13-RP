/datum/supply_pack/nanotrasen/reagents
	category = "Reagents"

/datum/supply_pack/nanotrasen/reagents/chemical_dispenser
	name = "Reagent Synthesizer"
	contains = list(
			/obj/machinery/chemical_dispenser/full,
		)
	container_type = /obj/structure/largecrate
	container_name = "reagent dispenser crate"

/datum/supply_pack/nanotrasen/reagents/beer_dispenser
	name = "Booze Synthesizer"
	contains = list(
		/obj/machinery/chemical_dispenser/catering/bar_alc/unanchored,
	)
	container_type = /obj/structure/largecrate
	container_name = "booze dispenser crate"

/datum/supply_pack/nanotrasen/reagents/soda_dispenser
	name = "Soda Synthesizer"
	contains = list(
		/obj/machinery/chemical_dispenser/catering/bar_soft/unanchored,
	)
	container_type = /obj/structure/largecrate
	container_name = "soda dispenser crate"

/datum/supply_pack/nanotrasen/reagents/coffee_dispenser
	name = "Coffee Synthesizer"
	contains = list(
		/obj/machinery/chemical_dispenser/catering/bar_coffee/unanchored,
	)
	container_type = /obj/structure/largecrate
	container_name = "coffee dispenser crate"

/datum/supply_pack/nanotrasen/reagents/reagent_synth_chemistry
	name = "Reagent Synthesis Module - Chemistry"
	contains = list(
		/obj/item/reagent_synth/chemistry,
	)

/datum/supply_pack/nanotrasen/reagents/dispenser_cartridges
	name = "Large Chemical Dispenser Cartridges"
	contains = list(
		/obj/item/reagent_containers/cartridge/dispenser/large = 10,
	)
	container_type = /obj/structure/closet/crate
	container_name = "dispenser cartridge crate"
