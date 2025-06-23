/mob/living/carbon/human/examine(mob/user, dist)
	#warn deal with
	var/datum/event_args/examine/examine_args = new(user)

	var/skip_gear = 0
	var/skip_body = 0

	var/looks_synth = looksSynthetic()

	//This is what hides what
	var/list/hidden

	. = list()

	var/skipface = (wear_mask && (wear_mask.inv_hide_flags & HIDEFACE)) || (head && (head.inv_hide_flags & HIDEFACE))

	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]

	if((skip_gear & EXAMINE_SKIPGEAR_JUMPSUIT) && (skip_body & EXAMINE_SKIPBODY_FACE)) //big suits/masks/helmets make it hard to tell their gender
		T = GLOB.gender_datums[PLURAL]

	else if(species && species.ambiguous_genders)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species && !istype(species, H.species))
				T = GLOB.gender_datums[PLURAL]// Species with ambiguous_genders will not show their true gender upon examine if the examiner is not also the same species.
		if(!(issilicon(user) || isobserver(user))) // Ghosts and borgs are all knowing
			T = GLOB.gender_datums[PLURAL]

	var/speciesblurb
	var/skip_species = FALSE

	if(skipface || get_visible_name() == "Unknown")
		skip_species = TRUE

	else if(looks_synth)
		speciesblurb += "a <font color='#555555'>[get_display_species()]</font>"
	else
		speciesblurb += "a <font color='[species.get_flesh_colour(src)]'>[get_display_species()]</font>"

	// The first line of the examine block.
	. += SPAN_INFO("[icon2html(src, user)] This is <EM>[src.name]</EM>[skip_species? ". [SPAN_WARNING("You can't make out what species they are.")]" : ", [T.he] [T.is] [speciesblurb]!"]")

	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		. += "[extra_species_text]"


	//uniform
	if(w_uniform && !(skip_gear & EXAMINE_SKIPGEAR_JUMPSUIT) && w_uniform.show_examine)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under) && !(skip_gear & EXAMINE_SKIPTIE))
			var/obj/item/clothing/under/U = w_uniform
			if(LAZYLEN(U.accessories))
				var/list/accessories_visible = list() //please let this fix the stupid fucking runtimes
				if(skip_gear & EXAMINE_SKIPHOLSTER)
					for(var/obj/item/clothing/accessory/A in U.accessories)
						if(A.show_examine && !istype(A, /obj/item/clothing/accessory/holster)) // If we're supposed to skip holsters, actually skip them
							accessories_visible.Add(FORMAT_TEXT_LOOKITEM(A))
				else
					for(var/obj/item/clothing/accessory/A in U.accessories)
						if(A.concealed_holster == FALSE && A.show_examine)
							accessories_visible.Add(FORMAT_TEXT_LOOKITEM(A))

				if(accessories_visible.len)
					tie_msg += SPAN_INFO(" Attached to it is [english_list(accessories_visible)].")

		if(w_uniform.blood_DNA)
			. += SPAN_WARNING("<hr>[icon2html(w_uniform, user)] [T.He] [T.is] wearing [w_uniform.gender == PLURAL ? "some" : "a"] [(w_uniform.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(w_uniform)]![tie_msg]")
		else
			. += SPAN_INFO("<hr>[icon2html(w_uniform, user)] [T.He] [T.is] wearing \a [FORMAT_TEXT_LOOKITEM(w_uniform)].[tie_msg]")

	// Pulse Checking.
	if(src.stat)
		. += SPAN_WARNING("[T.He] [T.is]n't responding to anything around [T.him] and seems to be asleep.")
		if((stat == DEAD || src.losebreath) && get_dist(user, src) <= 3)
			. += SPAN_WARNING("[T.He] [T.does] not appear to be breathing.")
		if(istype(user, /mob/living/carbon/human) && !user.stat && Adjacent(user))
			user.visible_message("<b>[usr]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
		spawn(15)
			if(isobserver(user) || (Adjacent(user) && !user.stat)) // If you're a corpse then you can't exactly check their pulse, but ghosts can see anything
				if(pulse == PULSE_NONE)
					to_chat(user, SPAN_DEADSAY("[T.He] [T.has] no pulse[src.client ? "" : " and [T.his] soul has departed"]..."))
				else
					to_chat(user, SPAN_DEADSAY("[T.He] [T.has] a pulse!"))


	//splints
	for(var/organ in BP_ALL)
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			. += SPAN_WARNING("[T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(o.splinted)] on [T.his] [o.name]!")

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			var/built = ""

			if(!looks_synth && temp.robotic == ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					built = SPAN_INFO("[T.He] [T.has] a [temp.name].")
				else
					built = SPAN_WARNING("[T.He] [T.has] a [temp.name] with [temp.get_wounds_desc()]!")
				continue
			else if(length(temp.wounds) > 0 || temp.open)
				if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
					var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
					built = SPAN_WARNING("[T.He] has [temp.get_wounds_desc()] on [T.his] [parent.name].")
				else
					built = SPAN_WARNING("[T.He] has [temp.get_wounds_desc()] on [T.his] [temp.name].")
			if(temp.dislocated == 2)
				built += SPAN_WARNING("[T.His] [temp.joint] is dislocated!")
			if(temp.brute_dam > temp.min_broken_damage || (temp.status & (ORGAN_BROKEN | ORGAN_MUTATED)))
				built += SPAN_WARNING("[T.His] [temp.name] is dented and swollen!")

			if(temp.germ_level > INFECTION_LEVEL_TWO && !(temp.status & ORGAN_DEAD))
				built += SPAN_WARNING("[T.His] [temp.name] looks very infected!")
			else if(temp.status & ORGAN_DEAD)
				built += SPAN_WARNING("[T.His] [temp.name] looks rotten!")

			if(temp.status & ORGAN_BLEEDING)
				is_bleeding["[temp.name]"] = SPAN_DANGER("[T.His] [temp.name] is bleeding!")

			if(temp.applied_pressure == src)
				applying_pressure = SPAN_NOTICE("[T.He] is applying pressure to [T.his] [temp.name].")
			if(length(built))
				wound_flavor_text["[temp.name]"] = built


	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		. += SPAN_NOTICE("[jointext(show_descs, "\n")]")

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(hasHUD_vr(H,hudtype))
			return 1 // Added records access for certain modes of omni-hud glasses
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return R.hudmode == "Security"
			if("medical")
				return R.hudmode == "Medical"
	return 0

//For OmniHUD records access for appropriate models
/proc/hasHUD_vr(mob/living/carbon/human/H, hudtype)
	if(H.nif)
		switch(hudtype)
			if("security")
				if(H.nif.flag_check(NIF_V_AR_SECURITY,NIF_FLAGS_VISION))
					return TRUE
			if("medical")
				if(H.nif.flag_check(NIF_V_AR_MEDICAL,NIF_FLAGS_VISION))
					return TRUE

	if(istype(H.glasses, /obj/item/clothing/glasses/omnihud))
		var/obj/item/clothing/glasses/omnihud/omni = H.glasses
		switch(hudtype)
			if("security")
				if(omni.mode == "sec" || omni.mode == "best")
					return TRUE
			if("medical")
				if(omni.mode == "med" || omni.mode == "best")
					return TRUE
			if("best")
				if(omni.mode == "best")
					return TRUE

	return FALSE
