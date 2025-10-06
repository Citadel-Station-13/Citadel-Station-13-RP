/obj/machinery/lathe/mecha_part_fabricator/pros
	name = "Prosthetics Fabricator"
	desc = "A machine used for construction of prosthetics."
	icon_state = "profab"
	base_icon_state = "profab"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	circuit = /obj/item/circuitboard/prosthetics

	//Prosfab specific stuff
	var/species_types = list(SPECIES_HUMAN)
	var/species = SPECIES_HUMAN


	lathe_type = LATHE_TYPE_PROSTHETICS
	///A list of categories that valid LATHE_TYPE_PROSTHETICS design datums will broadly categorise themselves under.



/obj/machinery/lathe/mecha_part_fabricator/pros/tgui_controller()
	RETURN_TYPE(/datum/tgui_module)
	return ui_controller || (ui_controller = new /datum/tgui_module/lathe_control/prosfab(src))

/obj/machinery/lathe/mecha_part_fabricator/pros/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return TRUE

	add_fingerprint(usr)

	if(istype(I,/obj/item/disk/species))
		var/obj/item/disk/species/D = I
		if(!SScharacters.resolve_species(D.species))
			to_chat(user, SPAN_WARNING("This disk seems to be corrupted!"))
		else
			to_chat(user, SPAN_NOTICE("Uploading modification files for [D.species]..."))
			if(do_after(user,50,src))
				species_types |= D.species
				to_chat(user, SPAN_NOTICE("Uploaded [D.species] files!"))
				qdel(I)
		return
