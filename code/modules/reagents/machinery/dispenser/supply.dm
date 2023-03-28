/datum/supply_pack/chemical_dispenser
	name = "Reagent dispenser (Empty)"
	contains = list(
			/obj/machinery/chemical_dispenser/unanchored
		)
	cost = 10
	container_type = /obj/structure/largecrate
	container_name = "reagent dispenser crate"
	group = "Reagents"

/datum/supply_pack/beer_dispenser
	name = "Booze dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/catering/bar_alc/unanchored
		)
	cost = 20
	container_type = /obj/structure/largecrate
	container_name = "booze dispenser crate"
	group = "Reagents"

/datum/supply_pack/soda_dispenser
	name = "Soda dispenser"
	contains = list(
			/obj/machinery/chemical_dispenser/catering/bar_soft/unanchored
		)
	cost = 20
	container_type = /obj/structure/largecrate
	container_name = "soda dispenser crate"
	group = "Reagents"

/datum/supply_pack/reagent_synth_chemistry
	name = "Reagent Synthesis Module - Chemistry"
	contains = list(
		/obj/item/reagent_synth/chemistry,
	)
	cost = 20
	group = "Reagents"

/datum/supply_pack/dispenser_cartridges
	name = "Large Chemical Dispenser Cartridges"
	contains = list(
		/obj/item/reagent_containers/cartridge/dispenser/large = 10,
		)
	cost = 15
	container_type = /obj/structure/closet/crate
	container_name = "dispenser cartridge crate"
	group = "Reagents"
