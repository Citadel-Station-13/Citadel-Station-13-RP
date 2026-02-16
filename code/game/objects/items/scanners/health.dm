/obj/item/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR
	belt_storage_class = BELT_CLASS_SMALL
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	materials_base = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/mode = 1
	var/advscan = 0
	var/showadvscan = 1

/obj/item/healthanalyzer/Initialize(mapload)
	. = ..()
	if(advscan >= 1)
		add_obj_verb(src, /obj/item/healthanalyzer/proc/toggle_adv)

/obj/item/healthanalyzer/do_surgery(mob/living/M, mob/living/user)
	if(user.a_intent != INTENT_HELP) //in case it is ever used as a surgery tool
		return ..()
	scan_mob(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/healthanalyzer/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	scan_mob(target, user)
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/healthanalyzer/proc/scan_mob(mob/living/M, mob/living/user)
	var/dat = ""
	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		user.visible_message(span_warning("\The [user] has analyzed the floor's vitals!"), span_warning("You try to analyze the floor's vitals!"))

		dat += "<span class='info'>Analyzing results for the floor:\n<blockquote class='notice'>Overall status: Healthy"
		dat += "\nDamage Specifics: 0-0-0-0"
		dat += "\nKey: Suffocation/Toxin/Burns/Brute"
		dat += "\nBody Temperature: ???"
		user.show_message(span_notice("[dat]"), 1)
		return
	if (!(user.IsAdvancedToolUser() || SSticker) && SSticker.mode.name != "monkey")
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return

	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation on a succesful scan
	user.visible_message(span_notice("[user] has analyzed [M]'s vitals."), span_notice("You have analyzed [M]'s vitals."))

	if (!ishuman(M) || M.isSynthetic())
		//these sensors are designed for organic life
		dat += "<span class='info'>Analyzing results for ERROR:\n<blockquote class='notice'>Overall status: ERROR"
		dat += "\nKey: <font color='cyan'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>"
		dat += "\nDamage Specifics: <font color='cyan'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>"
		dat += "\nBody Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>"
		dat += "\n<span class='warning'>Warning: Blood Level ERROR: --% --cl.</span> <span class='notice'>Type: ERROR</span>"
		dat += "\n<span class='notice'>Subject's pulse: <font color='red'>-- bpm.</font></span>"
		user.show_message(dat, 1)
		return

	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50   ? "<b>[M.getOxyLoss()]</b>"   : M.getOxyLoss()
	var/TX = M.getToxLoss() > 50   ? "<b>[M.getToxLoss()]</b>"   : M.getToxLoss()
	var/BU = M.getFireLoss() > 50  ? "<b>[M.getFireLoss()]</b>"  : M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 ? "<b>[M.getBruteLoss()]</b>" : M.getBruteLoss()
	if(M.status_flags & STATUS_FAKEDEATH)
		OX = fake_oxy > 50 ? "<b>[fake_oxy]</b>" : fake_oxy
		dat += span_notice("\nAnalyzing Results for [M]:")
		dat += span_notice("\nOverall Status: dead")
	else
		dat += "<span class='info'>Analyzing results for [M]:\n<blockquote class='notice'>Overall Status: [M.stat > 1 ? "dead" : "[round((M.health/M.getMaxHealth())*100) ]% healthy"]"
	dat += "\nKey: <font color='cyan'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>"
	dat += "\nDamage Specifics: <font color='cyan'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>"
	dat += "\nBody Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>"
	dat += "\nSpecies: <b>[M.get_species_name()]</b>"

	if(M.timeofdeath && (M.stat == DEAD || (M.status_flags & STATUS_FAKEDEATH)))
		dat += 	span_notice("\nTime of Death: [worldtime2stationtime(M.timeofdeath)]")
		var/tdelta = round(world.time - M.timeofdeath)
		dat += span_boldnotice("\nSubject died [DisplayTimeText(tdelta)] ago - resuscitation may be possible!")
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		dat += 	span_notice("\nLocalized Damage, Brute/Burn:")
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				if(org.robotic >= ORGAN_ROBOT)
					continue
				else
					dat += span_notice("\n[capitalize(org.name)]: [(org.brute_dam > 0) ? span_warning("[org.brute_dam]") : 0]")
					dat += span_notice("[(org.status & ORGAN_BLEEDING) ? span_danger("\[Bleeding\]") : ""] - ")
					dat += span_notice("[(org.burn_dam > 0) ? "<font color='#FFA500'>[org.burn_dam]</font>" : 0]")
		else
			dat += span_notice("\nLimbs are OK.")

	OX = M.getOxyLoss()   > 50 ? "<font color='cyan'><b>Severe oxygen deprivation detected</b></font>"   : "Subject bloodstream oxygen level normal"
	TX = M.getToxLoss()   > 50 ? "<font color='green'><b>Dangerous amount of toxins detected</b></font>" : "Subject bloodstream toxin level minimal"
	BU = M.getFireLoss()  > 50 ? "<font color='#FFA500'><b>Severe burn damage detected</b></font>"     : "Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>"     : "Subject brute-force injury status O.K"
	if(M.status_flags & STATUS_FAKEDEATH)
		OX = fake_oxy     > 50 ? span_warning("Severe oxygen deprivation detected")                      : "Subject bloodstream oxygen level normal"
	dat += "\n[OX] | [TX] | [BU] | [BR]"
	if(M.radiation)
		if(advscan >= 2 && showadvscan == 1)
			var/severity = ""
			if(M.radiation >= 75)
				severity = "Critical"
			else if(M.radiation >= 50)
				severity = "Severe"
			else if(M.radiation >= 25)
				severity = "Moderate"
			else if(M.radiation >= 1)
				severity = "Low"
			dat += span_warning("\n[severity] levels of radiation detected. [(severity == "Critical") ? " Immediate treatment advised." : ""]")
		else
			dat += span_warning("\nRadiation detected.")

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			var/unknownreagents[0]
			for(var/A in C.reagents.reagent_volumes)
				var/datum/reagent/R = SSchemistry.fetch_reagent(A)
				if(R.scannable)
					reagentdata["[R.id]"] = span_notice("\n[round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name]")
				else
					unknown++
					unknownreagents["[R.id]"] =  span_notice("\n[round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name]")
			if(reagentdata.len)
				dat += span_notice("\nBeneficial reagents detected in subject's blood:")
				for(var/d in reagentdata)
					dat += reagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += span_warning("\nWarning: Non-medical reagent[(unknown>1)?"s":""] detected in subject's blood:")
					for(var/d in unknownreagents)
						dat += unknownreagents[d]
				else
					dat += span_warning("\nWarning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.")
		if(C.ingested && C.ingested.total_volume)
			var/unknown = 0
			var/stomachreagentdata[0]
			var/stomachunknownreagents[0]
			for(var/B in C.ingested.reagent_volumes)
				var/datum/reagent/T = SSchemistry.fetch_reagent(B)
				if(T.scannable)
					stomachreagentdata["[T.id]"] = span_notice("\n[round(C.ingested.get_reagent_amount(T.id), 1)]u [T.name]")
					if (advscan == 0 || showadvscan == 0)
						dat += span_notice("\n[T.name] found in subject's stomach.")
				else
					++unknown
					stomachunknownreagents["[T.id]"] = span_notice("\n[round(C.ingested.get_reagent_amount(T.id), 1)]u [T.name]")
			if(advscan >= 1 && showadvscan == 1)
				dat += span_notice("\nBeneficial reagents detected in subject's stomach:")
				for(var/d in stomachreagentdata)
					dat += stomachreagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += span_warning("\nWarning: Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach:")
					for(var/d in stomachunknownreagents)
						dat += stomachunknownreagents[d]
				else
					dat += span_warning("\nUnknown substance[(unknown > 1)?"s":""] found in subject's stomach.")
		if(C.touching && C.touching.total_volume)
			var/unknown = 0
			var/touchreagentdata[0]
			var/touchunknownreagents[0]
			for(var/B in C.touching.reagent_volumes)
				var/datum/reagent/T = SSchemistry.fetch_reagent(B)
				if(T.scannable)
					touchreagentdata["[T.id]"] = span_notice("\n[round(C.touching.get_reagent_amount(T.id), 1)]u [T.name]")
					if (advscan == 0 || showadvscan == 0)
						dat += span_notice("\n[T.name] found in subject's dermis.")
				else
					++unknown
					touchunknownreagents["[T.id]"] = span_notice("\n[round(C.ingested.get_reagent_amount(T.id), 1)]u [T.name]")
			if(advscan >= 1 && showadvscan == 1)
				dat += span_notice("\nBeneficial reagents detected in subject's dermis:")
				for(var/d in touchreagentdata)
					dat += touchreagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += span_warning("\nWarning: Non-medical reagent[(unknown > 1)?"s":""] found in subject's dermis:")
					for(var/d in touchunknownreagents)
						dat += touchunknownreagents[d]
				else
					dat += span_warning("\nUnknown substance[(unknown > 1)?"s":""] found in subject's dermis.")
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					dat += span_warning("\nWarning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]")
				else
					dat += span_warning("\nWarning: Unknown pathogen detected in subject's blood.")
	if (M.getCloneLoss())
		dat += span_warning("\nSubject appears to have been imperfectly cloned.")
//	if (M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
//		user.show_message("<span class='notice'>Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals.</span>")
	if (M.has_brain_worms())
		dat += span_warning("\nSubject suffering from aberrant brain activity.  Recommend further scanning.")
	else if (M.getBrainLoss() >= 60 || !M.has_brain())
		dat += span_warning("\nSubject is brain dead.")
	else if (M.getBrainLoss() >= 25)
		dat += span_warning("\nSevere brain damage detected. Subject likely to have a traumatic brain injury.")
	else if (M.getBrainLoss() >= 10)
		dat += span_warning("\nSignificant brain damage detected. Subject may have had a concussion.")
	else if (M.getBrainLoss() >= 1 && advscan >= 2 && showadvscan == 1)
		dat += span_warning("\nMinor brain damage detected.")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/internal/appendix/a in H.internal_organs)
			var/severity = ""
			if(a.inflamed > 3)
				severity = "Severe"
			else if(a.inflamed > 2)
				severity = "Moderate"
			else if(a.inflamed >= 1)
				severity = "Mild"
			if(severity)
				dat += span_warning("\n[severity] inflammation detected in subject [a.name].")
		// Infections, fractures, and IB
		var/basic_fracture = 0	// If it's a basic scanner
		var/basic_ib = 0		// If it's a basic scanner
		var/fracture_dat = ""	// All the fractures
		var/infection_dat = ""	// All the infections
		var/ib_dat = ""			// All the IB
		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			// Broken limbs
			if(e.status & ORGAN_BROKEN)
				if((e.name in list("l_arm", "r_arm", "l_leg", "r_leg", "head", "chest", "groin")) && (!e.splinted))
					fracture_dat += span_warning("\nUnsecured fracture in subject [e.name]. Splinting recommended for transport.")
				else if(advscan >= 1 && showadvscan == 1)
					fracture_dat += span_warning("\nBone fractures detected in subject [e.name].")
				else
					basic_fracture = 1
			// Infections
			if(e.has_infected_wound())
				dat += span_warning("\nInfected wound detected in subject [e.name]. Disinfection recommended.")
			// IB
			for(var/datum/wound/W as anything in e.wounds)
				if(W.internal)
					if(advscan >= 1 && showadvscan == 1)
						ib_dat += span_warning("\nInternal bleeding detected in subject [e.name].")
					else
						basic_ib = 1
		if(basic_fracture)
			fracture_dat += span_warning("\nBone fractures detected. Advanced scanner required for location.")
		if(basic_ib)
			ib_dat += span_warning("\nInternal bleeding detected. Advanced scanner required for location.")
		dat += fracture_dat
		dat += infection_dat
		dat += ib_dat

		// Blood level
		if(H.blood_holder)
			var/blood_volume = H.blood_holder.get_total_volume()
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			if(blood_volume <= H.species.blood_volume*H.species.blood_level_danger)
				dat += span_danger("\n<i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl. Type: [blood_type]</i>")
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_warning)
				dat += span_danger("\n<i>Warning: Blood Level VERY LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]</i>")
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_safe)
				dat += span_danger("\nWarning: Blood Level LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]")
			else
				dat += span_notice("\nBlood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]")
		dat += span_notice("\nSubject's pulse: <font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font>")
	dat += "</blockquote>"
	user.show_message(dat, 1)

/obj/item/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = VERB_CATEGORY_OBJECT

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/healthanalyzer/proc/toggle_adv()
	set name = "Toggle Advanced Scan"
	set category = VERB_CATEGORY_OBJECT

	showadvscan = !showadvscan
	switch (showadvscan)
		if(1)
			to_chat(usr, "The scanner will now perform an advanced analysis.")
		if(0)
			to_chat(usr, "The scanner will now perform a basic analysis.")

/obj/item/healthanalyzer/apidean
	name = "\improper Apidean health analyzer"
	desc = "This medical scanner feels oddly warm and has two insectiod antennae."
	icon_state = "apidae-health"

/obj/item/healthanalyzer/improved //reports bone fractures, IB, quantity of beneficial reagents in stomach; also regular health analyzer stuff
	name = "improved health analyzer"
	desc = "A miracle of medical technology, this handheld scanner can produce an accurate and specific report of a patient's biosigns."
	advscan = 1
	origin_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	icon_state = "health1"

/obj/item/healthanalyzer/advanced //reports all of the above, as well as radiation severity and minor brain damage
	name = "advanced health analyzer"
	desc = "An even more advanced handheld health scanner, complete with a full biosign monitor and on-board radiation and neurological analysis suites."
	advscan = 2
	origin_tech = list(TECH_MAGNET = 6, TECH_BIO = 7)
	icon_state = "health2"

/obj/item/healthanalyzer/phasic //reports all of the above, as well as name and quantity of nonmed reagents in stomach
	name = "phasic health analyzer"
	desc = "Possibly the most advanced health analyzer to ever have existed, utilising bluespace technology to determine almost everything worth knowing about a patient."
	advscan = 3
	origin_tech = list(TECH_MAGNET = 7, TECH_BIO = 8)
	icon_state = "health3"
