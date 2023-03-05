/obj/machinery/chemical_dispenser/full
	synth_modules = list(
		/obj/item/reagent_synth/chemistry,
	)

/obj/machinery/chemical_dispenser/full/unanchored
	anchored = FALSE

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	synth_modules = list(
		/obj/item/reagent_synth/medicine,
	)

/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soda machine."
	icon_state = "soda_dispenser"
	ui_title = "Soda Dispenser"
	accept_drinking = 1

/obj/machinery/chemical_dispenser/bar_soft/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/icetea,
			/obj/item/reagent_containers/chem_disp_cartridge/cola,
			/obj/item/reagent_containers/chem_disp_cartridge/smw,
			/obj/item/reagent_containers/chem_disp_cartridge/dr_gibb,
			/obj/item/reagent_containers/chem_disp_cartridge/spaceup,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/watermelon,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon,
			/obj/item/reagent_containers/chem_disp_cartridge/sassafras,
			/obj/item/reagent_containers/chem_disp_cartridge/sarsaparilla
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
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/beer,
			/obj/item/reagent_containers/chem_disp_cartridge/kahlua,
			/obj/item/reagent_containers/chem_disp_cartridge/whiskey,
			/obj/item/reagent_containers/chem_disp_cartridge/wine,
			/obj/item/reagent_containers/chem_disp_cartridge/whitewine,
			/obj/item/reagent_containers/chem_disp_cartridge/vodka,
			/obj/item/reagent_containers/chem_disp_cartridge/gin,
			/obj/item/reagent_containers/chem_disp_cartridge/rum,
			/obj/item/reagent_containers/chem_disp_cartridge/tequila,
			/obj/item/reagent_containers/chem_disp_cartridge/vermouth,
			/obj/item/reagent_containers/chem_disp_cartridge/cognac,
			/obj/item/reagent_containers/chem_disp_cartridge/cider,
			/obj/item/reagent_containers/chem_disp_cartridge/ale,
			/obj/item/reagent_containers/chem_disp_cartridge/mead,
			/obj/item/reagent_containers/chem_disp_cartridge/alcsassafras
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
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/cafe_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/soy_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco,
			/obj/item/reagent_containers/chem_disp_cartridge/milk,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/mint,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/berry,
			// /obj/item/reagent_containers/chem_disp_cartridge/greentea,
			// /obj/item/reagent_containers/chem_disp_cartridge/decaf
		)

/obj/machinery/chemical_dispenser/bar_coffee/unanchored
	anchored = FALSE
