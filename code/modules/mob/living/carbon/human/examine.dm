/mob/living/carbon/human/examine(mob/user)
	var/skip_gear = 0
	var/skip_body = 0

	if(alpha <= EFFECTIVE_INVIS)
		src.loc.examine(user)
		return

	var/looks_synth = looksSynthetic()

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		if(wear_suit.flags_inv & HIDESUITSTORAGE)
			skip_gear |= EXAMINE_SKIPSUITSTORAGE

		if(wear_suit.flags_inv & HIDEJUMPSUIT)
			skip_body |= EXAMINE_SKIPARMS | EXAMINE_SKIPLEGS | EXAMINE_SKIPBODY | EXAMINE_SKIPGROIN
			skip_gear |= EXAMINE_SKIPJUMPSUIT | EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER

		else if(wear_suit.flags_inv & HIDETIE)
			skip_gear |= EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER

		else if(wear_suit.flags_inv & HIDEHOLSTER)
			skip_gear |= EXAMINE_SKIPHOLSTER

		if(wear_suit.flags_inv & HIDESHOES)
			skip_gear |= EXAMINE_SKIPSHOES
			skip_body |= EXAMINE_SKIPFEET

		if(wear_suit.flags_inv & HIDEGLOVES)
			skip_gear |= EXAMINE_SKIPGLOVES
			skip_body |= EXAMINE_SKIPHANDS

	if(w_uniform)
		if(w_uniform.body_parts_covered & LEGS)
			skip_body |= EXAMINE_SKIPLEGS
		if(w_uniform.body_parts_covered & ARMS)
			skip_body |= EXAMINE_SKIPARMS
		if(w_uniform.body_parts_covered & UPPER_TORSO)
			skip_body |= EXAMINE_SKIPBODY
		if(w_uniform.body_parts_covered & LOWER_TORSO)
			skip_body |= EXAMINE_SKIPGROIN

	if(gloves && (gloves.body_parts_covered & HANDS))
		skip_body |= EXAMINE_SKIPHANDS

	if(shoes && (shoes.body_parts_covered & FEET))
		skip_body |= EXAMINE_SKIPFEET

	if(head)
		if(head.flags_inv & HIDEMASK)
			skip_gear |= EXAMINE_SKIPMASK
		if(head.flags_inv & HIDEEYES)
			skip_gear |= EXAMINE_SKIPEYEWEAR
			skip_body |= EXAMINE_SKIPEYES
		if(head.flags_inv & HIDEEARS)
			skip_gear |= EXAMINE_SKIPEARS
		if(head.flags_inv & HIDEFACE)
			skip_body |= EXAMINE_SKIPFACE

	if(wear_mask && (wear_mask.flags_inv & HIDEFACE))
		skip_body |= EXAMINE_SKIPFACE

	//This is what hides what
	var/list/hidden = list(
		BP_GROIN = skip_body & EXAMINE_SKIPGROIN,
		BP_TORSO = skip_body & EXAMINE_SKIPBODY,
		BP_HEAD  = skip_body & EXAMINE_SKIPHEAD,
		BP_L_ARM = skip_body & EXAMINE_SKIPARMS,
		BP_R_ARM = skip_body & EXAMINE_SKIPARMS,
		BP_L_HAND= skip_body & EXAMINE_SKIPHANDS,
		BP_R_HAND= skip_body & EXAMINE_SKIPHANDS,
		BP_L_FOOT= skip_body & EXAMINE_SKIPFEET,
		BP_R_FOOT= skip_body & EXAMINE_SKIPFEET,
		BP_L_LEG = skip_body & EXAMINE_SKIPLEGS,
		BP_R_LEG = skip_body & EXAMINE_SKIPLEGS)

	var/datum/gender/T = gender_datums[get_visible_gender()]

	if((skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)) //big suits/masks/helmets make it hard to tell their gender
		T = gender_datums[PLURAL]

	else if(species && species.ambiguous_genders)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species && !istype(species, H.species))
				T = gender_datums[PLURAL]// Species with ambiguous_genders will not show their true gender upon examine if the examiner is not also the same species.
		if(!(issilicon(user) || isobserver(user))) // Ghosts and borgs are all knowing
			T = gender_datums[PLURAL]

	if(!T)
		// Just in case someone VVs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Gender datum was null; key was '[((skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)) ? PLURAL : gender]'")

	var/obscure_name = FALSE //currently useless
	. = list("<span class='info'>*---------*\nThis is <EM>[!obscure_name ? name : "Unknown"]</EM>!")

	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))

	var/cyborg_dumbfuckery = (gender == MALE ? "an android" : (gender == FEMALE ? "a gynoid" : "a synthetic"))

	if(skipface || get_visible_name() == "Unknown")
		. += "You can't make out what species they are."
	else			//species isn't dna level!
		. += "[T.He] [T.is] a [(src.custom_species ? src.custom_species : (species.name != "Human" ? species.get_examine_name() : (looks_synth ? cyborg_dumbfuckery : "unknown")))]!"

	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		. += "[extra_species_text]"

	//uniform
	if(w_uniform && !(skip_gear & EXAMINE_SKIPJUMPSUIT) && w_uniform.show_examine)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under) && !(skip_gear & EXAMINE_SKIPTIE))
			var/obj/item/clothing/under/U = w_uniform
			if(LAZYLEN(U.accessories))
				var/list/accessories_visible = list() //please let this fix the stupid fucking runtimes
				if(skip_gear & EXAMINE_SKIPHOLSTER)
					for(var/obj/item/clothing/accessory/A in U.accessories)
						if(A.show_examine && !istype(A, /obj/item/clothing/accessory/holster)) // If we're supposed to skip holsters, actually skip them
							accessories_visible.Add(A)
				else
					for(var/obj/item/clothing/accessory/A in U.accessories)
						if(A.concealed_holster == 0 && A.show_examine)
							accessories_visible.Add(A)

				if(accessories_visible.len)
					tie_msg += " Attached to it is [english_list(accessories_visible)]."


		. += "[T.He] [T.is] wearing [w_uniform.get_examine_string(user)] [w_uniform.name]![tie_msg]"

	//head
	if(head && !(skip_gear & EXAMINE_SKIPHELMET) && head.show_examine)
		. += "[T.He] [T.is] wearing [head.get_examine_string(user)] on [T.his] head."

	//suit/armour
	if(wear_suit)
		var/tie_msg
		if(istype(wear_suit,/obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(LAZYLEN(U.accessories))
				tie_msg += " Attached to it is [english_list(U.accessories)]."

		. += "[T.He] [T.is] wearing [wear_suit.get_examine_string(user)].[tie_msg]!"

		//suit/armour storage
		if(s_store && !(skip_gear & EXAMINE_SKIPSUITSTORAGE) && s_store.show_examine)
			. += "[T.He] [T.is] carrying [s_store.get_examine_string(user)] on [T.his] [wear_suit.name]."

	//back
	if(back && !(skip_gear & EXAMINE_SKIPBACKPACK) && back.show_examine)
		. += "[T.He] [T.has] [back.get_examine_string(user)] on [T.his] back."

	//left hand
	if(l_hand && l_hand.show_examine)
		. += "[T.He] [T.is] holding [l_hand.get_examine_string(user)] in [T.his] left hand."

	//right hand
	if(r_hand && r_hand.show_examine)
		. += "[T.He] [T.is] holding [r_hand.get_examine_string(user)] in [T.his] right hand."

	//gloves
	if(gloves && !(skip_gear & EXAMINE_SKIPGLOVES) && gloves.show_examine)
		. += "[T.He] [T.has] [gloves.get_examine_string(user)] on [T.his] hands."
	else if(blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		. += "<span class='warning'>[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!</span>"

	//handcuffed?
	if(handcuffed && handcuffed.show_examine)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			. += "<span class='warning'>[T.He] [T.is] [icon2html(handcuffed, user)] restrained with cable!</span>"
		else
			. += "<span class='warning'>[T.He] [T.is] [icon2html(handcuffed, user)] handcuffed!</span>"

	//buckled
	if(buckled)
		. += "<span class='warning'>[T.He] [T.is] [icon2html(handcuffed, user)] buckled to [buckled]!</span>"

	//belt
	if(belt && !(skip_gear & EXAMINE_SKIPBELT) && belt.show_examine)
		. += "[T.He] [T.has] [belt.get_examine_string(user)] about [T.his] waist."

	//shoes
	if(shoes && !(skip_gear & EXAMINE_SKIPSHOES) && shoes.show_examine)
		. += "[T.He] [T.is] wearing [shoes.get_examine_string(user)] on [T.his] feet."
	else if(feet_blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		. += "<span class='warning'>[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!</span>"

	//mask
	if(wear_mask && !(skip_gear & EXAMINE_SKIPMASK) && wear_mask.show_examine)
		var/descriptor = "on [T.his] face"
		if(istype(wear_mask, /obj/item/grenade) && check_has_mouth())
			descriptor = "in [T.his] mouth"
		. += "[T.He] [T.has] [wear_mask.get_examine_string(user)] [descriptor]."

	//eyes
	if(glasses && !(skip_gear & EXAMINE_SKIPEYEWEAR) && glasses.show_examine)
		. += "[T.He] [T.has] [glasses.get_examine_string(user)] covering [T.his] eyes."

	//left ear
	if(l_ear && !(skip_gear & EXAMINE_SKIPEARS) && l_ear.show_examine)
		. += "[T.He] [T.has] [l_ear.get_examine_string(user)] on [T.his] left ear."

	//right ear
	if(r_ear && !(skip_gear & EXAMINE_SKIPEARS) && r_ear.show_examine)
		. += "[T.He] [T.has] [r_ear.get_examine_string(user)] on [T.his] right ear."

	//ID
	if(wear_id && wear_id.show_examine)
		. += "[T.He] [T.is] wearing [wear_id.get_examine_string(user)]."
	//something something attemp_vr can reutrn null or 0
	var/cursed_stuff = attempt_vr(src,"examine_weight",args)
	if(cursed_stuff)
		. += cursed_stuff
	cursed_stuff = attempt_vr(src,"examine_nutrition",args)
	if(cursed_stuff)
		. += cursed_stuff
	cursed_stuff = attempt_vr(src,"examine_bellies",args)
	if(cursed_stuff)
		. += cursed_stuff
	cursed_stuff = attempt_vr(src,"examine_pickup_size",args)
	if(cursed_stuff)
		. += cursed_stuff
	cursed_stuff = attempt_vr(src,"examine_step_size",args)
	if(cursed_stuff)
		. += cursed_stuff
	cursed_stuff = attempt_vr(src,"examine_nif",args)
	if(cursed_stuff)
		. += cursed_stuff
	cursed_stuff = attempt_vr(src,"examine_chimera",args)
	if(cursed_stuff)
		. += cursed_stuff

	if(mSmallsize in mutations)
		. += "[T.He] [T.is] very short!"

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			. += "<span class='warning'><B>[T.He] [T.is] convulsing violently!</B></span>"
		if(200 to 300)
			. += "<span class='warning'>[T.He] [T.is] extremely jittery.</span>"
		if(100 to 200)
			. += "<span class='warning'>[T.He] [T.is] twitching ever so slightly.</span>"

	var/appears_dead = FALSE
	if(stat == DEAD)// || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE
		if(suiciding)
			. += "<span class='warning'>[T.He] appear[T.s] to have committed suicide... there is no hope of recovery.</span>"
		//if(hellbound)
		//	. += "<span class='warning'>[t_His] soul seems to have been ripped out of [t_his] body.  Revival is impossible.</span>"
		if((should_have_organ("brain") || !has_brain()) && !key && !src.client)//!get_ghost(FALSE, TRUE))
			. += "<span class='deadsay'>[T.He] [T.is] limp and unresponsive; there are no signs of life and [T.his] soul has departed...</span>"
		else
			. += "<span class='deadsay'>[T.He] [T.is] limp and unresponsive; there are no signs of life...</span>"

	//if(get_bodypart(BODY_ZONE_HEAD) && !getorgan(/obj/item/organ/brain))
	//	. += "<span class='deadsay'>It appears that [t_his] brain is missing...</span>"

	var/list/msg = list()
	//splints
	for(var/organ in BP_ALL)
		var/obj/item/organ/external/o = get_organ(organ)
		if(o?.splinted && o.splinted.loc == o)
			msg += "<span class='warning'>[T.He] [T.has] \a [o.splinted] on [T.his] [o.name]!</span>\n"

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()
	var/applying_pressure = ""

	for(var/organ_tag in species.has_limbs)
		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.is] missing [T.his] [organ_descriptor].</b></span>\n"
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.</b></span>\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			if((temp.organ_tag in hidden) && hidden[temp.organ_tag])
				continue //Organ is hidden, don't talk about it
			if(temp.status & ORGAN_DESTROYED)
				wound_flavor_text["[temp.name]"] = "<span class='warning'><b>[T.He] [T.is] missing [T.his] [temp.name].</b></span>\n"
				continue

			if(!looks_synth && temp.robotic == ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					wound_flavor_text["[temp.name]"] = "[T.He] [T.has] a [temp.name].\n"
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] a [temp.name] with [temp.get_wounds_desc()]!</span>\n"
				continue
			else if(temp.wounds.len > 0 || temp.open)
				if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
					var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] has [temp.get_wounds_desc()] on [T.his] [parent.name].</span>\n"
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] has [temp.get_wounds_desc()] on [T.his] [temp.name].</span>\n"
			else
				wound_flavor_text["[temp.name]"] = ""
			if(temp.dislocated == 2)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.joint] is dislocated!</span>\n"
			if(temp.brute_dam > temp.min_broken_damage || (temp.status & (ORGAN_BROKEN | ORGAN_MUTATED)))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] is dented and swollen!</span>\n"

			if(temp.germ_level > INFECTION_LEVEL_TWO && !(temp.status & ORGAN_DEAD))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] looks very infected!</span>\n"
			else if(temp.status & ORGAN_DEAD)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] looks rotten!</span>\n"

			if(temp.status & ORGAN_BLEEDING)
				is_bleeding["[temp.name]"] += "<span class='danger'>[T.His] [temp.name] is bleeding!</span>\n"

			if(temp.applied_pressure == src)
				applying_pressure = "<span class='info'>[T.He] is applying pressure to [T.his] [temp.name].</span>\n"

	for(var/limb in wound_flavor_text) //this is fucking bad aaaaaa, why aren't we just punching it directly!
		msg += wound_flavor_text[limb]
	for(var/limb in is_bleeding)
		msg += is_bleeding[limb]
	for(var/implant in get_visible_implants(0))
		msg += "<span class='danger'>[src] [T.has] \a [implant] sticking out of [T.his] flesh!</span>\n"

	if(fire_stacks > 0)
		msg += "[T.He] [T.is] covered in something flammable.\n"
	if(fire_stacks < 0)
		msg += "[T.He] look[T.s] a little soaked.\n"
	if(on_fire)
		msg += "<span class='warning'>[T.He] [T.is] on fire!.</span>\n"

	if(!appears_dead)
		if(stat == UNCONSCIOUS)
			msg += "[T.He] [T.is]n't responding to anything around [T.him] and seem[T.s] to be asleep.\n"
		//else
		//	if(HAS_TRAIT(src, TRAIT_DUMB))
		//		msg += "[T.He] [t_has] a stupid expression on [t_his] face.\n"
		//	if(InCritical())
		//		msg += "[T.He] [T.is] barely conscious.\n"
		var/ssd_msg = species.get_ssd(src)
		if(!should_have_organ("brain") || has_brain()) //getorgan(/obj/item/organ/brain))
			if(!key)
				if(ssd_msg)
					msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.</span>\n"
				else
					msg += "<span class='deadsay'>[T.He] [T.is] totally catatonic. The stresses of life in deep-space must have been too much for [T.him]. Any recovery is unlikely.</span>\n"
			else if(!client)
				if(ssd_msg)
					msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg].</span>\n"
				else
					msg += "[T.He] [T.has] a blank, absent-minded stare and appears completely unresponsive to anything. [T.He] may snap out of it soon.\n"
			//VOREStation Add Start
			if(client && ((client.inactivity / 10) / 60 > 10)) //10 Minutes
				msg += "\[Inactive for [round((client.inactivity/10)/60)] minutes\]\n"
			else if(disconnect_time)
				msg += "\[Disconnected/ghosted [round(((world.realtime - disconnect_time)/10)/60)] minutes ago\]\n"
			//VOREStation Add End
		if(digitalcamo)
			msg += "[T.He] [T.is] moving [T.his] body in an unnatural and blatantly inhuman manner.\n"
	if(applying_pressure)
		msg += applying_pressure
	if (length(msg))
		. += "<span class='warning'>[msg.Join("")]</span>"


	if(hasHUD(user,"security"))
		var/perpname = name
		var/criminal = "None"

		if(wear_id)
			if(istype(wear_id, /obj/item/card/id))
				var/obj/item/card/id/I = wear_id
				perpname = I.registered_name
			else if(istype(wear_id, /obj/item/pda))
				var/obj/item/pda/P = wear_id
				perpname = P.owner

		for (var/datum/data/record/R in data_core.security)
			if(R.fields["name"] == perpname)
				criminal = R.fields["criminal"]

		msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=[REF(src)];criminal=1'>\[[criminal]\]</a><br>"
		msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=[REF(src)];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a><br>"

	if(hasHUD(user,"medical"))
		var/perpname = name
		var/medical = "None"

		if(wear_id)
			if(istype(wear_id, /obj/item/card/id))
				var/obj/item/card/id/I = wear_id
				perpname = I.registered_name
			else if(istype(wear_id, /obj/item/pda))
				var/obj/item/pda/P = wear_id
				perpname = P.owner

		for (var/datum/data/record/R in data_core.medical)
			if (R.fields["name"] == perpname)
				medical = R.fields["p_stat"]

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a><br>"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a><br>"


	if(print_flavor_text())
		msg += "[print_flavor_text()]<br>"

	// VOREStation Start
	if(ooc_notes)
		. += "<span class='deptradio'>OOC Notes:</span> <a href='?src=[REF(src)];ooc_notes=1'>\[View\]</a>\n"

	. += "<span class='deptradio'><a href='?src=[REF(src)];vore_prefs=1'>\[Mechanical Vore Preferences\]</a></span>\n"

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		. += "<span class='notice'>[jointext(show_descs, "<br>")]</span>"

	if(pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>[T.He] [pose]"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) //This also handles flavor texts no(t yet)w

	// VOREStation End
	. += "*---------*</span><br>"

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(hasHUD_vr(H,hudtype)) return 1 //VOREStation Add - Added records access for certain modes of omni-hud glasses
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
