/datum/tgui_module/lathe_control/prosfab
	tgui_id = "TGUIProsfabControl"
	expected_type = /obj/machinery/lathe/mecha_part_fabricator/pros


/datum/tgui_module/lathe_control/prosfab/data(mob/user, ...)
	. = ..()
	var/obj/machinery/lathe/mecha_part_fabricator/pros/pfab = host
	if(isnull(pfab))
		return
	.["selected_species"] = pfab.species
	.["available_species"] = pfab.species_types


/datum/tgui_module/lathe_control/prosfab/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/obj/machinery/lathe/mecha_part_fabricator/pros/pfab = host
	switch(action)
		if("set_selected_species")
			pfab.species = params["species"]
