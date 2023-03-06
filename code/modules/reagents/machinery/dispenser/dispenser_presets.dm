/obj/machinery/chemical_dispenser/full
	synthesizers = list(
		/obj/item/reagent_synth/chemistry,
	)

/obj/machinery/chemical_dispenser/full/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	synthesizers = list(
		/obj/item/reagent_synth/medicine,
	)

#warn repath, use whitelists

/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soda machine."
	icon_state = "soda_dispenser"
	ui_title = "Soda Dispenser"
	accept_drinking = 1

/obj/machinery/chemical_dispenser/bar_soft/full
	synthesizers = list(
		/obj/item/reagent_synth/drink,
	)

/obj/machinery/chemical_dispenser/bar_soft/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	icon_state = "booze_dispenser"
	ui_title = "Booze Dispenser"
	accept_drinking = 1

/obj/machinery/chemical_dispenser/bar_alc/full
	synthesizers = list(
		/obj/item/reagent_synth/bar,
	)

/obj/machinery/chemical_dispenser/bar_alc/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/bar_coffee
	name = "coffee dispenser"
	desc = "Driving crack dealers out of employment since 2280."
	icon_state = "coffee_dispenser"
	ui_title = "Coffee Dispenser"
	accept_drinking = 1

/obj/machinery/chemical_dispenser/bar_coffee/full
	synthesizers = list(
		/obj/item/reagent_synth/cafe,
	)

/obj/machinery/chemical_dispenser/bar_coffee/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/xenoflora
	name = "xenoflora chem dispenser"

/obj/machinery/chemical_dispenser/xenoflora/full
	synthesizers = list(
		/obj/item/reagent_synth/botanical,
	)

/obj/machinery/chemical_dispenser/biochemistry
	name = "bioproduct dispenser"

/obj/machinery/chemical_dispenser/biochemistry/full
	synthesizers = list(
		/obj/item/reagent_synth/bioproduct,
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
