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

	. += "<span class='info'>*---------*<br>This is "

	if(icon)
		. += "\icon[icon] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	. += "<EM>[src.name]</EM>"

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

	if(!((skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)))
		//VOREStation Add Start
		if(custom_species)
			. += ", a <b>[src.custom_species]</b>"
		else if(looks_synth)
		//VOREStation Add End
			var/use_gender = "a synthetic"
			if(gender == MALE)
				use_gender = "an android"
			else if(gender == FEMALE)
				use_gender = "a gynoid"

			. += ", <b><font color='#555555'>[use_gender]!</font></b>"

		else if(species.name != "Human")
			. += ", <b><font color='[species.get_flesh_colour(src)]'>\a [species.get_examine_name()]!</font></b>"

	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		. += "[extra_species_text]"

	. += "<br>"

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

		if(w_uniform.blood_DNA)
			. += "<span class='warning'>[T.He] [T.is] wearing \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] [(w_uniform.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [w_uniform.name]![tie_msg]</span><br>"
		else
			. += "[T.He] [T.is] wearing \icon[w_uniform] \a [w_uniform].[tie_msg]<br>"

	//head
	if(head && !(skip_gear & EXAMINE_SKIPHELMET) && head.show_examine)
		if(head.blood_DNA)
			. += "<span class='warning'>[T.He] [T.is] wearing \icon[head] [head.gender==PLURAL?"some":"a"] [(head.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [head.name] on [T.his] head!</span><br>"
		else
			. += "[T.He] [T.is] wearing \icon[head] \a [head] on [T.his] head.<br>"

	//suit/armour
	if(wear_suit)
		var/tie_msg
		if(istype(wear_suit,/obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(LAZYLEN(U.accessories))
				tie_msg += " Attached to it is [english_list(U.accessories)]."

		if(wear_suit.blood_DNA)
			. += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] [(wear_suit.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [wear_suit.name][tie_msg]!</span><br>"
		else
			. += "[T.He] [T.is] wearing \icon[wear_suit] \a [wear_suit].[tie_msg]<br>"

		//suit/armour storage
		if(s_store && !(skip_gear & EXAMINE_SKIPSUITSTORAGE) && s_store.show_examine)
			if(s_store.blood_DNA)
				. += "<span class='warning'>[T.He] [T.is] carrying \icon[s_store] [s_store.gender==PLURAL?"some":"a"] [(s_store.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [s_store.name] on [T.his] [wear_suit.name]!</span><br>"
			else
				. += "[T.He] [T.is] carrying \icon[s_store] \a [s_store] on [T.his] [wear_suit.name].<br>"

	//back
	if(back && !(skip_gear & EXAMINE_SKIPBACKPACK) && back.show_examine)
		if(back.blood_DNA)
			. += "<span class='warning'>[T.He] [T.has] \icon[back] [back.gender==PLURAL?"some":"a"] [(back.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [back] on [T.his] back.</span><br>"
		else
			. += "[T.He] [T.has] \icon[back] \a [back] on [T.his] back.<br>"

	//left hand
	if(l_hand && l_hand.show_examine)
		if(l_hand.blood_DNA)
			. += "<span class='warning'>[T.He] [T.is] holding \icon[l_hand] [l_hand.gender==PLURAL?"some":"a"] [(l_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [l_hand.name] in [T.his] left hand!</span><br>"
		else
			. += "[T.He] [T.is] holding \icon[l_hand] \a [l_hand] in [T.his] left hand.<br>"

	//right hand
	if(r_hand && r_hand.show_examine)
		if(r_hand.blood_DNA)
			. += "<span class='warning'>[T.He] [T.is] holding \icon[r_hand] [r_hand.gender==PLURAL?"some":"a"] [(r_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [r_hand.name] in [T.his] right hand!</span><br>"
		else
			. += "[T.He] [T.is] holding \icon[r_hand] \a [r_hand] in [T.his] right hand.<br>"

	//gloves
	if(gloves && !(skip_gear & EXAMINE_SKIPGLOVES) && gloves.show_examine)
		if(gloves.blood_DNA)
			. += "<span class='warning'>[T.He] [T.has] \icon[gloves] [gloves.gender==PLURAL?"some":"a"] [(gloves.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [gloves.name] on [T.his] hands!</span><br>"
		else
			. += "[T.He] [T.has] \icon[gloves] \a [gloves] on [T.his] hands.<br>"
	else if(blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		. += "<span class='warning'>[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!</span><br>"

	//handcuffed?
	if(handcuffed && handcuffed.show_examine)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			. += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] restrained with cable!</span><br>"
		else
			. += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] handcuffed!</span><br>"

	//buckled
	if(buckled)
		. += "<span class='warning'>[T.He] [T.is] \icon[buckled] buckled to [buckled]!</span><br>"

	//belt
	if(belt && !(skip_gear & EXAMINE_SKIPBELT) && belt.show_examine)
		if(belt.blood_DNA)
			. += "<span class='warning'>[T.He] [T.has] \icon[belt] [belt.gender==PLURAL?"some":"a"] [(belt.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [belt.name] about [T.his] waist!</span><br>"
		else
			. += "[T.He] [T.has] \icon[belt] \a [belt] about [T.his] waist.<br>"

	//shoes
	if(shoes && !(skip_gear & EXAMINE_SKIPSHOES) && shoes.show_examine)
		if(shoes.blood_DNA)
			. += "<span class='warning'>[T.He] [T.is] wearing \icon[shoes] [shoes.gender==PLURAL?"some":"a"] [(shoes.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [shoes.name] on [T.his] feet!</span><br>"
		else
			. += "[T.He] [T.is] wearing \icon[shoes] \a [shoes] on [T.his] feet.<br>"
	else if(feet_blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		. += "<span class='warning'>[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!</span><br>"

	//mask
	if(wear_mask && !(skip_gear & EXAMINE_SKIPMASK) && wear_mask.show_examine)
		var/descriptor = "on [T.his] face"
		if(istype(wear_mask, /obj/item/grenade) && check_has_mouth())
			descriptor = "in [T.his] mouth"

		if(wear_mask.blood_DNA)
			. += "<span class='warning'>[T.He] [T.has] \icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] [(wear_mask.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [wear_mask.name] [descriptor]!</span><br>"
		else
			. += "[T.He] [T.has] \icon[wear_mask] \a [wear_mask] [descriptor].<br>"

	//eyes
	if(glasses && !(skip_gear & EXAMINE_SKIPEYEWEAR) && glasses.show_examine)
		if(glasses.blood_DNA)
			. += "<span class='warning'>[T.He] [T.has] \icon[glasses] [glasses.gender==PLURAL?"some":"a"] [(glasses.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [glasses] covering [T.his] eyes!</span><br>"
		else
			. += "[T.He] [T.has] \icon[glasses] \a [glasses] covering [T.his] eyes.<br>"

	//left ear
	if(l_ear && !(skip_gear & EXAMINE_SKIPEARS) && l_ear.show_examine)
		. += "[T.He] [T.has] \icon[l_ear] \a [l_ear] on [T.his] left ear.<br>"

	//right ear
	if(r_ear && !(skip_gear & EXAMINE_SKIPEARS) && r_ear.show_examine)
		. += "[T.He] [T.has] \icon[r_ear] \a [r_ear] on [T.his] right ear.<br>"

	//ID
	if(wear_id && wear_id.show_examine)
		/*var/id
		if(istype(wear_id, /obj/item/pda))
			var/obj/item/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, usr) <= 1) && prob(10))
			. += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_id] \a [wear_id] yet something doesn't seem right...</span><br>"
		else*/
		. += "[T.He] [T.is] wearing \icon[wear_id] \a [wear_id].<br>"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			. += "<span class='warning'><B>[T.He] [T.is] convulsing violently!</B></span><br>"
		else if(jitteriness >= 200)
			. += "<span class='warning'>[T.He] [T.is] extremely jittery.</span><br>"
		else if(jitteriness >= 100)
			. += "<span class='warning'>[T.He] [T.is] twitching ever so slightly.</span><br>"

	//splints
	for(var/organ in BP_ALL)
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			. += "<span class='warning'>[T.He] [T.has] \a [o.splinted] on [T.his] [o.name]!</span><br>"

	if(suiciding)
		. += "<span class='warning'>[T.He] appears to have commited suicide... there is no hope of recovery.</span><br>"

	. += attempt_vr(src,"examine_weight",args) //VOREStation Code
	. += attempt_vr(src,"examine_nutrition",args) //VOREStation Code
	. += attempt_vr(src,"examine_bellies",args) //VOREStation Code
	. += attempt_vr(src,"examine_pickup_size",args) //VOREStation Code
	. += attempt_vr(src,"examine_step_size",args) //VOREStation Code
	. += attempt_vr(src,"examine_nif",args) //VOREStation Code
	. += attempt_vr(src,"examine_chimera",args) //VOREStation Code

	if(mSmallsize in mutations)
		. += "[T.He] [T.is] very short!<br>"

	if (src.stat)
		. += "<span class='warning'>[T.He] [T.is]n't responding to anything around [T.him] and seems to be asleep.</span><br>"
		if((stat == 2 || src.losebreath) && get_dist(user, src) <= 3)
			. += "<span class='warning'>[T.He] [T.does] not appear to be breathing.</span><br>"
		if(istype(user, /mob/living/carbon/human) && !user.stat && Adjacent(user))
			user.visible_message("<b>[usr]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
		spawn(15)
			if(isobserver(user) || (Adjacent(user) && !user.stat)) // If you're a corpse then you can't exactly check their pulse, but ghosts can see anything
				if(pulse == PULSE_NONE)
					to_chat(user, "<span class='deadsay'>[T.He] [T.has] no pulse[src.client ? "" : " and [T.his] soul has departed"]...</span>")
				else
					to_chat(user, "<span class='deadsay'>[T.He] [T.has] a pulse!</span>")

	if(fire_stacks)
		. += "[T.He] [T.is] covered in some liquid.<br>"
	if(on_fire)
		. += "<span class='warning'>[T.He] [T.is] on fire!.</span><br>"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ("brain") || has_brain()) && stat != DEAD)
		if(!key)
			. += "<span class='deadsay'>[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.</span><br>"
		else if(!client)
			. += "<span class='deadsay'>[T.He] [T.is] [ssd_msg].</span><br>"
		//VOREStation Add Start
		if(client && ((client.inactivity / 10) / 60 > 10)) //10 Minutes
			. += "\[Inactive for [round((client.inactivity/10)/60)] minutes\]\n"
		else if(disconnect_time)
			. += "\[Disconnected/ghosted [round(((world.realtime - disconnect_time)/10)/60)] minutes ago\]\n"
		//VOREStation Add End

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()
	var/applying_pressure = ""

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.is] missing [T.his] [organ_descriptor].</b></span><br>"
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.</b></span><br>"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			if((temp.organ_tag in hidden) && hidden[temp.organ_tag])
				continue //Organ is hidden, don't talk about it
			if(temp.status & ORGAN_DESTROYED)
				wound_flavor_text["[temp.name]"] = "<span class='warning'><b>[T.He] [T.is] missing [T.his] [temp.name].</b></span><br>"
				continue

			if(!looks_synth && temp.robotic == ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					wound_flavor_text["[temp.name]"] = "[T.He] [T.has] a [temp.name].<br>"
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] a [temp.name] with [temp.get_wounds_desc()]!</span><br>"
				continue
			else if(temp.wounds.len > 0 || temp.open)
				if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
					var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] has [temp.get_wounds_desc()] on [T.his] [parent.name].</span><br>"
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] has [temp.get_wounds_desc()] on [T.his] [temp.name].</span><br>"
			else
				wound_flavor_text["[temp.name]"] = ""
			if(temp.dislocated == 2)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.joint] is dislocated!</span><br>"
			if(temp.brute_dam > temp.min_broken_damage || (temp.status & (ORGAN_BROKEN | ORGAN_MUTATED)))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] is dented and swollen!</span><br>"

			if(temp.germ_level > INFECTION_LEVEL_TWO && !(temp.status & ORGAN_DEAD))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] looks very infected!</span><br>"
			else if(temp.status & ORGAN_DEAD)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] looks rotten!</span><br>"

			if(temp.status & ORGAN_BLEEDING)
				is_bleeding["[temp.name]"] += "<span class='danger'>[T.His] [temp.name] is bleeding!</span><br>"

			if(temp.applied_pressure == src)
				applying_pressure = "<span class='info'>[T.He] is applying pressure to [T.his] [temp.name].</span><br>"

	for(var/limb in wound_flavor_text)
		. += wound_flavor_text[limb]
	for(var/limb in is_bleeding)
		. += is_bleeding[limb]
	for(var/implant in get_visible_implants(0))
		. += "<span class='danger'>[src] [T.has] \a [implant] sticking out of [T.his] flesh!</span><br>"
	if(digitalcamo)
		. += "[T.He] [T.is] repulsively uncanny!<br>"

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

		. += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a><br>"
		. += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a><br>"

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

		. += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a><br>"
		. += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a><br>"


	if(print_flavor_text())
		. += "[print_flavor_text()]<br>"

	// VOREStation Start
	if(ooc_notes)
		. += "<span class = 'deptradio'>OOC Notes:</span> <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>\n"

	. += "<span class='deptradio'><a href='?src=\ref[src];vore_prefs=1'>\[Mechanical Vore Preferences\]</a></span>\n"

	// VOREStation End
	. += "*---------*</span><br>"
	. += applying_pressure

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		. += "<span class='notice'>[jointext(show_descs, "<br>")]</span>"

	if(pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += "<br>[T.He] [pose]"


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

/mob/living/carbon/human/proc/examine_weight()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/weight_examine = round(weight)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_he	= "it"
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	var/t_heavy = "heavy"
	switch(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_he 	= "he"
			t_His 	= "His"
			t_his 	= "his"
			t_heavy = "bulky"
		if(FEMALE)
			t_He 	= "She"
			t_he	= "she"
			t_His 	= "Her"
			t_his 	= "her"
			t_heavy = "curvy"
		if(PLURAL)
			t_He	= "They"
			t_he	= "they"
			t_His 	= "Their"
			t_his 	= "their"
			t_is 	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_he	= "it"
			t_His 	= "Its"
			t_his 	= "its"
		if(HERM)
			t_He 	= "Shi"
			t_he	= "shi"
			t_His 	= "Hir"
			t_his 	= "hir"
			t_heavy = "curvy"

	switch(weight_examine)
		if(0 to 74)
			message = "<span class='warning'>[t_He] [t_is] terribly lithe and frail!</span>\n"
		if(75 to 99)
			message = "[t_He] [t_has] a very slender frame.\n"
		if(100 to 124)
			message = "[t_He] [t_has] a lightweight, athletic build.\n"
		if(125 to 174)
			message = "[t_He] [t_has] a healthy, average body.\n"
		if(175 to 224)
			message = "[t_He] [t_has] a thick, [t_heavy] physique.\n"
		if(225 to 274)
			message = "[t_He] [t_has] a plush, chubby figure.\n"
		if(275 to 325)
			message = "[t_He] [t_has] an especially plump body with a round potbelly and large hips.\n"
		if(325 to 374)
			message = "[t_He] [t_has] a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.\n"
		if(375 to 474)
			message = "<span class='warning'>[t_He] [t_is] incredibly obese. [t_His] massive potbelly sags over [t_his] waistline while [t_his] fat ass would probably require two chairs to sit down comfortably!</span>\n"
		else
			message += "<span class='warning'>[t_He] [t_is] so morbidly obese, you wonder how [t_he] can even stand, let alone waddle around the station. [t_He] can't get any fatter without being immobilized.</span>\n"
	return message //Credit to Aronai for helping me actually get this working!

/mob/living/carbon/human/proc/examine_nutrition()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return ""
	var/message = ""
	var/nutrition_examine = round(nutrition)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_His 	= "Its"
	var/t_his 	= "its"
	var/t_is 	= "is"
	var/t_has 	= "has"
	switch(identifying_gender)
		if(MALE)
			t_He 	= "He"
			t_his 	= "his"
			t_His 	= "His"
		if(FEMALE)
			t_He 	= "She"
			t_his 	= "her"
			t_His 	= "Her"
		if(PLURAL)
			t_He  	= "They"
			t_his 	= "their"
			t_His 	= "Their"
			t_is	= "are"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_his 	= "its"
			t_His	= "Its"
		if(HERM)
			t_He 	= "Shi"
			t_his 	= "hir"
			t_His 	= "Hir"
	switch(nutrition_examine)
		if(0 to 49)
			message = "<span class='warning'>[t_He] [t_is] starving! You can hear [t_his] stomach snarling from across the room!</span>\n"
		if(50 to 99)
			message = "<span class='warning'>[t_He] [t_is] extremely hungry. A deep growl occasionally rumbles from [t_his] empty stomach.</span>\n"
		if(100 to 499)
			return message //Well that's pretty normal, really.
		if(500 to 999) // range that vampires hit nutrition wise, best to not have vore kink messages forced on them.
			message = "[t_He] appears to be well-hydrated and invigorated.\n"
		if(1000 to 1399)
			message = "[t_He] [t_has] a rotund, thick gut. It bulges from their body obscenely, close to sagging under its own weight.\n"
		if(1400 to 1934) // One person fully digested.
			message = "<span class='warning'>[t_He] [t_is] sporting a large, round, sagging stomach. It's contains at least their body weight worth of glorping slush.</span>\n"
		if(1935 to 3004) // Two people.
			message = "<span class='warning'>[t_He] [t_is] engorged with a huge stomach that sags and wobbles as they move. [t_He] must have consumed at least twice their body weight. It looks incredibly soft.</span>\n"
		if(3005 to 4074) // Three people.
			message = "<span class='warning'>[t_His] stomach is firmly packed with digesting slop. [t_He] must have eaten at least a few times worth their body weight! It looks hard for them to stand, and [t_his] gut jiggles when they move.</span>\n"
		if(4075 to INFINITY) // Four or more people.
			message = "<span class='warning'>[t_He] [t_is] so absolutely stuffed that you aren't sure how it's possible to move. [t_He] can't seem to swell any bigger. The surface of [t_his] belly looks sorely strained!</span>\n"
	return message

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

	return FALSE

/mob/living/carbon/human/proc/examine_pickup_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.50)
		message = "<font color='blue'>They are small enough that you could easily pick them up!</font>\n"
	return message

/mob/living/carbon/human/proc/examine_step_size(mob/living/H)
	var/message = ""
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.75)
		message = "<font color='red'>They are small enough that you could easily trample them!</font>\n"
	return message

/mob/living/carbon/human/proc/examine_nif(mob/living/carbon/human/H)
	if(nif && nif.examine_msg) //If you have one set, anyway.
		return "<span class='notice'>[nif.examine_msg]</span>\n"

/mob/living/carbon/human/proc/examine_chimera(mob/living/carbon/human/H)
	var/t_He 	= "It" //capitalised for use at the start of each line.
	var/t_his 	= "its"
	var/t_His 	= "Its"
	var/t_appear 	= "appears"
	var/t_has 	= "has"
	switch(identifying_gender) //Gender is their "real" gender. Identifying_gender is their "chosen" gender.
		if(MALE)
			t_He 	= "He"
			t_His 	= "His"
			t_his 	= "his"
		if(FEMALE)
			t_He 	= "She"
			t_His 	= "Her"
			t_his 	= "her"
		if(PLURAL)
			t_He	= "They"
			t_His 	= "Their"
			t_his 	= "their"
			t_appear 	= "appear"
			t_has 	= "have"
		if(NEUTER)
			t_He 	= "It"
			t_His 	= "Its"
			t_his 	= "its"
		if(HERM)
			t_He 	= "Shi"
			t_His 	= "Hir"
			t_his 	= "hir"
	if(revive_ready == REVIVING_NOW || revive_ready == REVIVING_DONE)
		if(stat == DEAD)
			return "<span class='warning'>[t_His] body is twitching subtly.</span>\n"
		else
			return "<span class='notice'>[t_He] [t_appear] to be in some sort of torpor.</span>\n"
	if(feral)
		return "<span class='warning'>[t_He] [t_has] a crazed, wild look in [t_his] eyes!</span>\n"
	if(bitten)
		return "<span class='notice'>[t_He] [t_appear] to have two fresh puncture marks on [t_his] neck.</span>\n"
