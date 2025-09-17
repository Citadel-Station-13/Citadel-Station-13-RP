/obj/item/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon = 'icons/obj/device.dmi'
	icon_state = "spectrometer"
	w_class = WEIGHT_CLASS_SMALL
	atom_flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	throw_force = 5
	throw_speed = 4
	throw_range = 20

	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/mass_spectrometer/Initialize(mapload)
	. = ..()
	var/datum/reagent_holder/R = new/datum/reagent_holder(5)
	reagents = R
	R.my_atom = src

/obj/item/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/mass_spectrometer/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if (user.stat)
		return
	if (!(user.IsAdvancedToolUser() || SSticker) && SSticker.mode.name != "monkey")
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/id in reagents.reagent_volumes)
			var/datum/reagent/R = SSchemistry.fetch_reagent(id)
			if(R.type != /datum/reagent/blood)
				continue
			else
				var/datum/blood_mixture/mixture = reagents.reagent_datas?[id]
				blood_traces = params2list(mixture.legacy_trace_chem)
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(details)
				dat += "[R] ([blood_traces[R]] units) "
			else
				dat += "[R] "
		to_chat(user, "[dat]")
		reagents.clear_reagents()
	return

/obj/item/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)
