/obj/item/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon = 'icons/obj/device.dmi'
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	throw_force = 5
	throw_speed = 4
	throw_range = 20
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 20)
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/reagent_scanner/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY) || user.stat || !istype(target))
		return
	if(!istype(user))
		return

	if(!isnull(target.reagents))
		if(!(target.atom_flags & OPENCONTAINER)) // The idea is that the scanner has to touch the reagents somehow. This is done to prevent cheesing unidentified autoinjectors.
			to_chat(user, SPAN_WARNING( "\The [target] is sealed, and cannot be scanned by \the [src] until unsealed."))
			return

		var/dat = ""
		if(target.reagents.reagent_volumes.len > 0)
			var/one_percent = target.reagents.total_volume / 100
			for (var/id in target.reagents.reagent_volumes)
				var/datum/reagent/R = SSchemistry.fetch_reagent(id)
				dat += "\n \t " + SPAN_NOTICE("[R][details ? ": [target.reagents.reagent_volumes[id] / one_percent]%" : ""]")
		if(dat)
			to_chat(user, SPAN_NOTICE("Chemicals found: [dat]"))
		else
			to_chat(user, SPAN_NOTICE("No active chemical agents found in [target]."))
	else
		to_chat(user, SPAN_NOTICE("No significant chemical agents found in [target]."))

	return

/obj/item/reagent_scanner/apidean
	name = "\improper Apidean taster"
	desc = "This reagent scanner appears to be an artificially created lifeform. Often used by Apidaen guards to test food and drinks during diplomatic meetings."
	icon_state = "apidae-reagent"

/obj/item/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)
