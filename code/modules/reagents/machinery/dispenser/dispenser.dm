/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "dispenser"

	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	anchored = TRUE
	allow_unanchor = TRUE
	allow_deconstruct = TRUE

	#warn circuitboard
	#warn unanchor / deconstruct
	#warn stock parts + cell

	/// reagent synthesizers in us - set to list of typepaths to init on Initialize().
	var/list/obj/item/reagent_synth/synthesizers
	/// cartridges in us, usable for dispensing with.
	var/list/obj/item/reagent_containers/chem_disp_cartridge/cartridges
	/// our cell
	var/obj/item/cell/cell
	/// initial cell type
	var/cell_type = /obj/item/cell/high
	/// recharge rate in KW
	var/recharge_rate = 5
	/// inserted beaker / whatever
	var/obj/item/reagent_containers/inserted
	/// allow beakers
	var/allow_beakers = TRUE
	/// allow drinking glasses
	var/allow_drinking = TRUE
	/// allow all other opencontainer reagent containers
	var/allow_other = FALSE
	/// current dispense amount
	var/dispense_amount = 10

/obj/machinery/chemical_dispenser/Initialize(mapload)
	. = ..()
	if(islist(synthesizers))
		var/list/created = list()
		for(var/path in synthesizers)
			if(!ispath(path, /obj/item/reagent_synth))
				if(istype(path, /obj/item/reagent_synth))
					created += path
				continue
			created += new path(src)
		synthesizers = created

/obj/machinery/chemical_dispenser/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()


/obj/machinery/chemical_dispenser/ui_data(mob/user)
	. = ..()


/obj/machinery/chemical_dispenser/ui_act(action, params)
	. = ..()

