/obj/machinery/lathe/mecha_part_fabricator
	icon = 'icons/obj/machines/fabricators/robotics.dmi'
	icon_state = "mechfab"
	base_icon_state = "mechfab"
	name = "Exosuit Fabricator"
	desc = "A machine used for construction of mechas."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(ACCESS_SCIENCE_ROBOTICS)
	circuit = /obj/item/circuitboard/mechfab
	lathe_type = LATHE_TYPE_MECHFAB | LATHE_TYPE_PROSTHETICS

	has_interface = TRUE
	var/datum/research/files

/obj/machinery/lathe/mecha_part_fabricator/Initialize(mapload)
	..()
	files = new /datum/research(src) //Setup the research data holder.
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/lathe/mecha_part_fabricator/LateInitialize()
	for(var/obj/machinery/computer/rdconsole/RDC in get_area(src))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		files.known_design_ids |= RDC.files.known_design_ids
		files.RefreshResearch()
		var/list/known_designs = files.legacy_all_design_datums()
		for(var/datum/prototype/design/D in known_designs)
			if(D.lathe_type & src.lathe_type)
				LAZYADD(design_holder.design_ids, D.id)
		atom_say("Successfully synchronized with R&D server.")
		return

	atom_say("Unable to connect to local R&D server.")
	return

/obj/machinery/lathe/mecha_part_fabricator/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("<b>Alt-click</b> to synchronize research data with a local computer.")

/obj/machinery/lathe/mecha_part_fabricator/AltClick(mob/user)
	..() //comsig
	for(var/obj/machinery/computer/rdconsole/RDC in get_area(src))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		files.known_design_ids |= RDC.files.known_design_ids
		files.RefreshResearch()
		var/list/known_designs = files.legacy_all_design_datums()
		for(var/datum/prototype/design/D in known_designs)
			if(D.lathe_type & src.lathe_type)
				LAZYADD(design_holder.design_ids, D.id)
		update_static_data(usr)
		atom_say("Successfully synchronized with R&D server.")
		return

	atom_say("Unable to connect to local R&D server.")
	return
