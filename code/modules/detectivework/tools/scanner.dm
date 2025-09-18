/obj/item/detective_scanner
	name = "forensic scanner"
	desc = "Used to scan objects for DNA and fingerprints."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic"
	var/list/stored = list()
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	slot_flags = SLOT_BELT

	var/reveal_fingerprints = TRUE
	var/reveal_incompletes = FALSE
	var/reveal_blood = TRUE
	var/reveal_fibers = FALSE

/obj/item/detective_scanner/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if (!ishuman(target))
		to_chat(user, SPAN_WARNING("\The [target] does not seem to be compatible with this device."))
		flick("[icon_state]0",src)
		return

	if(reveal_fingerprints)
		if((!( istype(target.dna, /datum/dna) ) || target.item_by_slot_id(SLOT_ID_GLOVES)))
			to_chat(user, "<span class='notice'>No fingerprints found on [target]</span>")
			flick("[icon_state]0",src)
			return
		else if(user.zone_sel.selecting == "r_hand" || user.zone_sel.selecting == "l_hand")
			var/obj/item/sample/print/P = new /obj/item/sample/print(user.loc)
			P.lazy_melee_interaction_chain(target, user)
			to_chat(user,"<span class='notice'>Done printing.</span>")
	//		to_chat(user, "<span class='notice'>[target]'s Fingerprints: [md5(target.dna.uni_identity)]</span>")

	if(reveal_blood && target.blood_DNA && target.blood_DNA.len)
		to_chat(user,"<span class='notice'>Blood found on [target]. Analysing...</span>")
		spawn(15)
			for(var/blood in target.blood_DNA)
				to_chat(user,"<span class='notice'>Blood type: [target.blood_DNA[blood]]\nDNA: [blood]</span>")

/obj/item/detective_scanner/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return
	if(ismob(target))
		return

/*
	if(istype(target,/obj/machinery/computer/forensic_scanning))
		user.visible_message("[user] takes a cord out of [src] and hooks its end into [target]" ,\
		"<span class='notice'>You download data from [src] to [target]</span>")
		var/obj/machinery/computer/forensic_scanning/F = target
		F.sync_data(stored)
		return
*/

	if(istype(target,/obj/item/sample/print))
		to_chat(user,"The scanner displays on the screen: \"ERROR 43: Object on Excluded Object List.\"")
		flick("[icon_state]0",src)
		return

	add_fingerprint(user)

	if(!(do_after(user, 1 SECOND)))
		to_chat(user, SPAN_WARNING("You must remain still for the device to complete its work."))
		return FALSE

	//General
	if ((!target.fingerprints || !target.fingerprints.len) && !target.suit_fibers && !target.blood_DNA)
		user.visible_message("\The [user] scans \the [target] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
		SPAN_NOTICE("Unable to locate any fingerprints, materials, fibers, or blood on [target]!"),\
		"You hear a faint hum of electrical equipment.")
		flick("[icon_state]0",src)
		return FALSE

	if(add_data(target))
		to_chat(user, SPAN_NOTICE("Object already in internal memory. Consolidating data..."))
		flick("[icon_state]1",src)
		return

	//PRINTS
	if(target.fingerprints && target.fingerprints.len)
		to_chat(user, SPAN_NOTICE("Isolated [target.fingerprints.len] fingerprints:"))
		if(!reveal_incompletes)
			to_chat(user, SPAN_WARNING("Rapid Analysis Imperfect: Scan samples with H.R.F.S. equipment to determine nature of incomplete prints."))
		var/list/complete_prints = list()
		var/list/incomplete_prints = list()
		for(var/i in target.fingerprints)
			var/print = target.fingerprints[i]
			if(stringpercent(print) <= FINGERPRINT_COMPLETE)
				complete_prints += print
			else
				incomplete_prints += print
		if(complete_prints.len < 1)
			to_chat(user, SPAN_NOTICE("No intact prints found"))
		else
			to_chat(user, SPAN_NOTICE("Found [complete_prints.len] intact prints"))
			if(reveal_fingerprints)
				for(var/i in complete_prints)
					to_chat(user, SPAN_NOTICE("&nbsp;&nbsp;&nbsp;&nbsp;[i]"))

		to_chat(user, SPAN_NOTICE("Found [incomplete_prints.len] incomplete prints"))
		if(reveal_incompletes)
			for(var/i in incomplete_prints)
				to_chat(user, SPAN_NOTICE("&nbsp;&nbsp;&nbsp;&nbsp;[i]"))


	//FIBERS
	if(target.suit_fibers && target.suit_fibers.len)
		to_chat(user, SPAN_NOTICE("Fibers/Materials detected.[reveal_fibers ? " Analysing..." : " Acquisition of fibers for H.R.F.S. analysis advised."]"))
		flick("[icon_state]1",src)
		if(reveal_fibers && do_after(user, 5 SECONDS))
			to_chat(user, SPAN_NOTICE("Apparel samples scanned:"))
			for(var/sample in target.suit_fibers)
				to_chat(user," - <span class='notice'>[sample]</span>")

	//Blood
	if (target.blood_DNA && target.blood_DNA.len)
		to_chat(user, SPAN_NOTICE("Blood detected.[reveal_blood ? " Analysing..." : " Acquisition of swab for H.R.F.S. analysis advised."]"))
		if(reveal_blood && do_after(user, 5 SECONDS))
			flick("[icon_state]1",src)
			for(var/blood in target.blood_DNA)
				to_chat(user,"Blood type: <span class='warning'>[target.blood_DNA[blood]]</span> DNA: <span class='warning'>[blood]</span>")

	user.visible_message("\The [user] scans \the [target] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
	SPAN_NOTICE("You finish scanning \the [target]."),\
	"You hear a faint hum of electrical equipment.")
	flick("[icon_state]1",src)
	return FALSE

/obj/item/detective_scanner/proc/add_data(atom/A as mob|obj|turf|area)
	var/datum/data/record/forensic/old = stored["\ref [A]"]
	var/datum/data/record/forensic/fresh = new(A)

	if(old)
		fresh.merge(old)
		. = 1
	stored["\ref [A]"] = fresh

/obj/item/detective_scanner/verb/examine_data()
	set name = "Examine Forensic Data"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	display_data(usr)

/obj/item/detective_scanner/proc/display_data(var/mob/user)
	if(user && stored && stored.len)
		for(var/objref in stored)
			if(!do_after(user, 1 SECOND)) // So people can move and stop the spam, if they refuse to wipe data.
				break

			var/datum/data/record/forensic/F = stored[objref]
			var/list/fprints = F.fields["fprints"]
			var/list/fibers = F.fields["fibers"]
			var/list/bloods = F.fields["blood"]

			to_chat(user, SPAN_NOTICE("Data for: [F.fields["name"]]"))

			if(reveal_fingerprints)
				var/list/complete_prints = list()
				var/list/incomplete_prints = list()
				for(var/i in fprints)
					var/print = fprints[i]
					if(stringpercent(print) <= FINGERPRINT_COMPLETE)
						complete_prints += print
						to_chat(user, " - <span class='notice'>[print]</span>")
					else
						incomplete_prints += print

				if(complete_prints.len < 1)
					to_chat(user, SPAN_NOTICE("No intact prints found."))

				if(reveal_incompletes)
					for(var/print in incomplete_prints)
						to_chat(user, " - <span class='notice'>[print]</span>")

			if(fibers && fibers.len)
				to_chat(user, SPAN_NOTICE("[fibers.len] samples of material were present."))
				if(reveal_fibers)
					for(var/sample in fibers)
						to_chat(user," - <span class='notice'>[sample]</span>")

			if(bloods && bloods.len)
				to_chat(user, SPAN_NOTICE("[bloods.len] samples of blood were present."))
				if(reveal_blood)
					for(var/bloodsample in bloods)
						to_chat(user, " - <span class='warning'>[bloodsample]</span> Type: [bloods[bloodsample]]")

/obj/item/detective_scanner/verb/wipe()
	set name = "Wipe Forensic Data"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	if (alert("Are you sure you want to wipe all data from [src]?",,"Yes","No") == "Yes")
		stored = list()
		to_chat(usr, SPAN_NOTICE("Forensic data erase complete."))

/obj/item/detective_scanner/advanced
	name = "advanced forensic scanner"
	icon_state = "forensic_neo"
	reveal_fibers = TRUE
	reveal_incompletes = TRUE
