/obj/machinery/chemical_dispenser/full
	synthesizers = list(
		/obj/item/reagent_synth/chemistry,
	)

/obj/machinery/chemical_dispenser/full/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/catering
	abstract_type = /obj/machinery/chemical_dispenser/catering
	allow_drinking = TRUE
	synthesizers_swappable = FALSE

/obj/item/circuitboard/machine/chemical_dispenser/soda
	build_path = /obj/machinery/chemical_dispenser/catering/bar_soft

/obj/machinery/chemical_dispenser/catering/bar_soft
	name = "soft drink dispenser"
	desc = "A soda machine."
	circuit = /obj/item/circuitboard/machine/chemical_dispenser/soda
	icon_state = "soda_dispenser"
	synthesizers_swappable = FALSE
	synthesizers = list(
		/obj/item/reagent_synth/drink,
	)

/obj/machinery/chemical_dispenser/catering/bar_soft/unanchored
	anchored = FALSE

/obj/item/circuitboard/machine/chemical_dispenser/booze
	build_path = /obj/machinery/chemical_dispenser/catering/bar_alc

/obj/machinery/chemical_dispenser/catering/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	circuit = /obj/item/circuitboard/machine/chemical_dispenser/booze
	icon_state = "booze_dispenser"
	synthesizers = list(
		/obj/item/reagent_synth/bar,
	)

/obj/machinery/chemical_dispenser/catering/bar_alc/unanchored
	anchored = FALSE

/obj/item/circuitboard/machine/chemical_dispenser/cafe
	build_path = /obj/machinery/chemical_dispenser/catering/bar_coffee

/obj/machinery/chemical_dispenser/catering/bar_coffee
	name = "coffee dispenser"
	desc = "Driving crack dealers out of employment since 2280."
	icon_state = "coffee_dispenser"
	circuit = /obj/item/circuitboard/machine/chemical_dispenser/cafe
	synthesizers = list(
		/obj/item/reagent_synth/cafe,
	)

/obj/machinery/chemical_dispenser/catering/bar_coffee/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/xenoflora
	name = "xenoflora chem dispenser"
	synthesizers_swappable = FALSE
	synthesizers = list(
		/obj/item/reagent_synth/botanical,
	)

/obj/machinery/chemical_dispenser/biochemistry
	name = "bioproduct dispenser"
	synthesizers_swappable = FALSE
	synthesizers = list(
		/obj/item/reagent_synth/bioproduct,
	)

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	synthesizers_swappable = FALSE
	synthesizers = list(
		/obj/item/reagent_synth/medicine,
	)

/obj/machinery/chemical_dispenser/ert/specialops
	synthesizers = list(
		/obj/item/reagent_synth/medicine,
		/obj/item/reagent_synth/medicine_addon,
	)

/obj/machinery/chemical_dispenser/ert/specialops/abductor
	name = "chemical dispenser"
	icon = 'icons/obj/abductor_vr.dmi'
	icon_state = "dispenser_2way"
	desc = "A mysterious machine which can fabricate many chemicals."
