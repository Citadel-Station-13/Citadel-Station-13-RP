/mob/living/carbon/human/examine(mob/user)
	var/skip_gear = 0
	var/skip_body = 0

	if(alpha <= EFFECTIVE_INVIS)
		return loc.examine(user)

	var/looks_synth = looksSynthetic()

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		if(wear_suit.inv_hide_flags & HIDESUITSTORAGE)
			skip_gear |= EXAMINE_SKIPSUITSTORAGE

		if(wear_suit.inv_hide_flags & HIDEJUMPSUIT)
			skip_body |= EXAMINE_SKIPARMS | EXAMINE_SKIPLEGS | EXAMINE_SKIPBODY | EXAMINE_SKIPGROIN
			skip_gear |= EXAMINE_SKIPJUMPSUIT | EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER

		else if(wear_suit.inv_hide_flags & HIDETIE)
			skip_gear |= EXAMINE_SKIPTIE | EXAMINE_SKIPHOLSTER

		else if(wear_suit.inv_hide_flags & HIDEHOLSTER)
			skip_gear |= EXAMINE_SKIPHOLSTER

		if(wear_suit.inv_hide_flags & HIDESHOES)
			skip_gear |= EXAMINE_SKIPSHOES
			skip_body |= EXAMINE_SKIPFEET

		if(wear_suit.inv_hide_flags & HIDEGLOVES)
			skip_gear |= EXAMINE_SKIPGLOVES
			skip_body |= EXAMINE_SKIPHANDS

	if(w_uniform)
		if(w_uniform.body_cover_flags & LEGS)
			skip_body |= EXAMINE_SKIPLEGS
		if(w_uniform.body_cover_flags & ARMS)
			skip_body |= EXAMINE_SKIPARMS
		if(w_uniform.body_cover_flags & UPPER_TORSO)
			skip_body |= EXAMINE_SKIPBODY
		if(w_uniform.body_cover_flags & LOWER_TORSO)
			skip_body |= EXAMINE_SKIPGROIN

	if(gloves && (gloves.body_cover_flags & HANDS))
		skip_body |= EXAMINE_SKIPHANDS

	if(shoes && (shoes.body_cover_flags & FEET))
		skip_body |= EXAMINE_SKIPFEET

	if(head)
		if(head.inv_hide_flags & HIDEMASK)
			skip_gear |= EXAMINE_SKIPMASK
		if(head.inv_hide_flags & HIDEEYES)
			skip_gear |= EXAMINE_SKIPEYEWEAR
			skip_body |= EXAMINE_SKIPEYES
		if(head.inv_hide_flags & HIDEEARS)
			skip_gear |= EXAMINE_SKIPEARS
		if(head.inv_hide_flags & HIDEFACE)
			skip_body |= EXAMINE_SKIPFACE

	if(wear_mask && (wear_mask.inv_hide_flags & HIDEFACE))
		skip_body |= EXAMINE_SKIPFACE

	//This is what hides what
	var/list/hidden = list(
		BP_GROIN  = skip_body & EXAMINE_SKIPGROIN,
		BP_TORSO  = skip_body & EXAMINE_SKIPBODY,
		BP_HEAD   = skip_body & EXAMINE_SKIPHEAD,
		BP_L_ARM  = skip_body & EXAMINE_SKIPARMS,
		BP_R_ARM  = skip_body & EXAMINE_SKIPARMS,
		BP_L_HAND = skip_body & EXAMINE_SKIPHANDS,
		BP_R_HAND = skip_body & EXAMINE_SKIPHANDS,
		BP_L_FOOT = skip_body & EXAMINE_SKIPFEET,
		BP_R_FOOT = skip_body & EXAMINE_SKIPFEET,
		BP_L_LEG  = skip_body & EXAMINE_SKIPLEGS,
		BP_R_LEG  = skip_body & EXAMINE_SKIPLEGS,
	)

	. = list()

	var/skipface = (wear_mask && (wear_mask.inv_hide_flags & HIDEFACE)) || (head && (head.inv_hide_flags & HIDEFACE))

	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]

	if((skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)) //big suits/masks/helmets make it hard to tell their gender
		T = GLOB.gender_datums[PLURAL]

	else if(species && species.ambiguous_genders)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species && !istype(species, H.species))
				T = GLOB.gender_datums[PLURAL]// Species with ambiguous_genders will not show their true gender upon examine if the examiner is not also the same species.
		if(!(issilicon(user) || isobserver(user))) // Ghosts and borgs are all knowing
			T = GLOB.gender_datums[PLURAL]

	//! Just in case someone VVs the gender to something strange.
	//! It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
	if(!T)
		CRASH("Gender datum was null; key was '[((skip_gear & EXAMINE_SKIPJUMPSUIT) && (skip_body & EXAMINE_SKIPFACE)) ? PLURAL : gender]'")

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

	//head
	if(head && !(skip_gear & EXAMINE_SKIPHELMET) && head.show_examine)
		if(head.blood_DNA)
			. += SPAN_WARNING("[icon2html(head, user)] [T.He] [T.is] wearing [head.gender == PLURAL ? "some" : "a"] [(head.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(head)] on [T.his] head!")
		else
			. += SPAN_INFO("[icon2html(head, user)] [T.He] [T.is] wearing \a [FORMAT_TEXT_LOOKITEM(head)] on [T.his] head.")

	//suit/armour
	if(wear_suit)
		var/tie_msg
		if(istype(wear_suit,/obj/item/clothing/suit))
			var/obj/item/clothing/suit/U = wear_suit
			if(LAZYLEN(U.accessories))
				var/list/assembled = list()
				for(var/obj/item/clothing/accessory/A in U.accessories)
					assembled += FORMAT_TEXT_LOOKITEM(A)
				tie_msg += SPAN_INFO(" Attached to it is [english_list(assembled)].")

		if(wear_suit.blood_DNA)
			. += SPAN_WARNING("[T.He] [T.is] wearing [icon2html(thing = wear_suit, target = user)] [wear_suit.gender == PLURAL ? "some" : "a"] [(wear_suit.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(wear_suit)][tie_msg]!")
		else
			. += SPAN_INFO("[icon2html(wear_suit, user)] [T.He] [T.is] wearing \a [FORMAT_TEXT_LOOKITEM(wear_suit)].[tie_msg]")

		//suit/armour storage
		if(s_store && !(skip_gear & EXAMINE_SKIPSUITSTORAGE) && s_store.show_examine)
			if(s_store.blood_DNA)
				. += SPAN_WARNING("[icon2html(s_store, user)] [T.He] [T.is] carrying [s_store.gender == PLURAL ? "some" : "a"] [(s_store.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(s_store)] on [T.his] [FORMAT_TEXT_LOOKITEM(wear_suit)]!")
			else
				. += SPAN_INFO("[icon2html(s_store, user)] [T.He] [T.is] carrying \a [FORMAT_TEXT_LOOKITEM(s_store)] on [T.his] [FORMAT_TEXT_LOOKITEM(wear_suit)].")

	//back
	if(back && !(skip_gear & EXAMINE_SKIPBACKPACK) && back.show_examine)
		if(back.blood_DNA)
			. += SPAN_WARNING("[icon2html(back, user)] [T.He] [T.has] [back.gender == PLURAL ? "some" : "a"] [(back.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(back)] on [T.his] back.")
		else
			. += SPAN_INFO("[icon2html(back, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(back)] on [T.his] back.")

	//left hand
	if(l_hand && l_hand.show_examine)
		if(l_hand.blood_DNA)
			. += SPAN_WARNING("[icon2html(l_hand, user)] [T.He] [T.is] holding [l_hand.gender == PLURAL ? "some" : "a"] [(l_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(l_hand)] in [T.his] left hand!")
		else
			. += SPAN_INFO("[icon2html(l_hand, user)] [T.He] [T.is] holding \a [FORMAT_TEXT_LOOKITEM(l_hand)] in [T.his] left hand.")

	//right hand
	if(r_hand && r_hand.show_examine)
		if(r_hand.blood_DNA)
			. += SPAN_WARNING("[icon2html(r_hand, user)] [T.He] [T.is] holding [r_hand.gender == PLURAL ? "some" : "a"] [(r_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(r_hand)] in [T.his] right hand!")
		else
			. += SPAN_INFO("[icon2html(r_hand, user)] [T.He] [T.is] holding \a [FORMAT_TEXT_LOOKITEM(r_hand)] in [T.his] right hand.")

	//gloves
	if(gloves && !(skip_gear & EXAMINE_SKIPGLOVES) && gloves.show_examine)
		if(gloves.blood_DNA)
			. += SPAN_WARNING("[icon2html(gloves, user)] [T.He] [T.has] [gloves.gender == PLURAL ? "some" : "a"] [(gloves.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(gloves)] on [T.his] hands!")
		else
			. += SPAN_INFO("[icon2html(gloves, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(gloves)] on [T.his] hands.")

	else if(blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		. += SPAN_WARNING("[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!")

	//handcuffed?
	if(handcuffed && handcuffed.show_examine)
		if(istype(handcuffed, /obj/item/handcuffs/cable))
			. += SPAN_WARNING("[icon2html(handcuffed, user)] [T.He] [T.is] restrained with cable!")
		else
			. += SPAN_WARNING("[icon2html(handcuffed, user)] [T.He] [T.is] handcuffed!")

	//buckled
	if(buckled)
		. += SPAN_WARNING("[icon2html(buckled, user)] [T.He] [T.is] buckled to [FORMAT_TEXT_LOOKITEM(buckled)]!")

	//belt
	if(belt && !(skip_gear & EXAMINE_SKIPBELT) && belt.show_examine)
		if(belt.blood_DNA)
			. += SPAN_WARNING("[icon2html(belt, user)] [T.He] [T.has] [belt.gender == PLURAL ? "some" : "a"] [(belt.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(belt)] about [T.his] waist!")
		else
			. += SPAN_INFO("[icon2html(belt, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(belt)] about [T.his] waist.")

	//shoes
	if(shoes && !(skip_gear & EXAMINE_SKIPSHOES) && shoes.show_examine)
		if(shoes.blood_DNA)
			. += SPAN_WARNING("[icon2html(shoes, user)] [T.He] [T.is] wearing [shoes.gender == PLURAL ? "some" : "a"] [(shoes.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(shoes)] on [T.his] feet!")
		else
			. += SPAN_INFO("[icon2html(shoes, user)] [T.He] [T.is] wearing \a [FORMAT_TEXT_LOOKITEM(shoes)] on [T.his] feet.")

	else if(feet_blood_DNA && !(skip_body & EXAMINE_SKIPHANDS))
		. += SPAN_WARNING("[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!")

	//mask
	if(wear_mask && !(skip_gear & EXAMINE_SKIPMASK) && wear_mask.show_examine)
		var/descriptor = "on [T.his] face"
		if(istype(wear_mask, /obj/item/grenade) && check_has_mouth())
			descriptor = "in [T.his] mouth"

		if(wear_mask.blood_DNA)
			. += SPAN_WARNING("[icon2html(wear_mask, user)] [T.He] [T.has] [wear_mask.gender == PLURAL ? "some" : "a"] [(wear_mask.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(wear_mask)] [descriptor]!")
		else
			. += SPAN_INFO("[icon2html(wear_mask, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(wear_mask)] [descriptor].")

	//eyes
	if(glasses && !(skip_gear & EXAMINE_SKIPEYEWEAR) && glasses.show_examine)
		if(glasses.blood_DNA)
			. += SPAN_WARNING("[icon2html(glasses, user)] [T.He] [T.has] [glasses.gender == PLURAL ? "some" : "a"] [(glasses.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [FORMAT_TEXT_LOOKITEM(glasses)] covering [T.his] eyes!")
		else
			. += SPAN_INFO("[icon2html(glasses, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(glasses)] covering [T.his] eyes.")

	//left ear
	if(l_ear && !(skip_gear & EXAMINE_SKIPEARS) && l_ear.show_examine)
		. += SPAN_INFO("[icon2html(l_ear, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(l_ear)] on [T.his] left ear.")

	//right ear
	if(r_ear && !(skip_gear & EXAMINE_SKIPEARS) && r_ear.show_examine)
		. += SPAN_INFO("[icon2html(r_ear, user)] [T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(r_ear)] on [T.his] right ear.")

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
			. += "<span class='warning'>[T.He] [T.is] wearing [icon2html(thing = wear_id, target = user)] \a [wear_id] yet something doesn't seem right...</span>"
		else*/
		. += SPAN_INFO("[icon2html(wear_id, user)] [T.He] [T.is] wearing \a [FORMAT_TEXT_LOOKITEM(wear_id)].")

	if(istype(src, /mob/living/carbon/human/dummy))
		. += SPAN_INFO("[T.He] [T.is] strangely life like. You feel uneasy staring at [T.him] for too long.")

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			. += SPAN_DANGER("[T.He] [T.is] convulsing violently!")
		else if(jitteriness >= 200)
			. += SPAN_WARNING("[T.He] [T.is] extremely jittery.")
		else if(jitteriness >= 100)
			. += SPAN_WARNING("[T.He] [T.is] twitching ever so slightly.")

	//splints
	for(var/organ in BP_ALL)
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			. += SPAN_WARNING("[T.He] [T.has] \a [FORMAT_TEXT_LOOKITEM(o.splinted)] on [T.his] [o.name]!")

	if(suiciding)
		. += SPAN_WARNING("[T.He] appears to have commited suicide...  There is no hope of recovery.")


//! I hate this. Though it's better than what it was before. -Zandario
	var/message = FALSE
	var/weight_examine = round(weight)
	if(show_pudge()) //Some clothing or equipment can hide this.
		var/t_heavy = "heavy"
		if(gender == MALE)
			t_heavy = "bulky"
		else if(gender == FEMALE)
			t_heavy = "curvy"

		switch(weight_examine)
			if(0 to 74)
				message = SPAN_WARNING("[T.He] [T.is] terribly lithe and frail!")
			if(75 to 99)
				message = SPAN_INFO("[T.He] [T.has] a very slender frame.")
			if(100 to 124)
				message = SPAN_INFO("[T.He] [T.has] a lightweight, athletic build.")
			if(125 to 174)
				message = SPAN_INFO("[T.He] [T.has] a healthy, average body.")
			if(175 to 224)
				message = SPAN_INFO("[T.He] [T.has] a thick, [t_heavy] physique.")
			if(225 to 274)
				message = SPAN_INFO("[T.He] [T.has] a plush, chubby figure.")
			if(275 to 325)
				message = SPAN_INFO("[T.He] [T.has] an especially plump body with a round potbelly and large hips.")
			if(325 to 374)
				message = SPAN_INFO("[T.He] [T.has] a very fat frame with a bulging potbelly, squishy rolls of pudge, very wide hips, and plump set of jiggling thighs.")
			if(375 to 474)
				message = SPAN_WARNING("[T.He] [T.is] incredibly obese. [T.His] massive potbelly sags over [T.his] waistline while [T.his] fat ass would probably require two chairs to sit down comfortably!")
			else
				message = SPAN_DANGER("[T.He] [T.is] so morbidly obese, you wonder how [T.he] can even stand, let alone waddle around the station.  [T.He] can't get any fatter without being immobilized.")
		. += message
//! End of the bs

	if(attempt_vr(src,"examine_bellies",args))
		. += attempt_vr(src,"examine_bellies",args)
	if(attempt_vr(src,"examine_pickup_size",args))
		. += attempt_vr(src,"examine_pickup_size",args)
	if(attempt_vr(src,"examine_step_size",args))
		. += attempt_vr(src,"examine_step_size",args)
	if(attempt_vr(src,"examine_nif",args))
		. += attempt_vr(src,"examine_nif",args)
	if(attempt_vr(src,"examine_chimera",args))
		. += attempt_vr(src,"examine_chimera",args)

	if(MUTATION_DWARFISM in mutations)
		. += SPAN_WARNING("[T.He] [T.is] very short!")

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

	if(fire_stacks)
		. += SPAN_WARNING("[T.He] [T.is] soaking wet.")
	if(on_fire)
		. += SPAN_DANGER("[T.He] [T.is] on fire!.")

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ("brain") || has_brain()) && stat != DEAD)
		if(istype(src, /mob/living/carbon/human/dummy)) // mannequins arent asleep
			return
		if(!key)
			. += SPAN_DEADSAY("[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.")
		else if(!client)
			. += SPAN_DEADSAY("[T.He] [T.is] [ssd_msg].")
		if(client && ((client.inactivity / 10) / 60 > 10)) //10 Minutes
			. += SPAN_INFO("\[Inactive for [round((client.inactivity/10)/60)] minutes\]")
		else if(disconnect_time)
			. += SPAN_INFO("\[Disconnected/ghosted [round(((world.realtime - disconnect_time)/10)/60)] minutes ago\]")

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()
	var/applying_pressure = ""

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = SPAN_BOLDWARNING("[T.He] [T.is] missing [T.his] [organ_descriptor].")
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = SPAN_BOLDWARNING("[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.")
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			if((temp.organ_tag in hidden) && hidden[temp.organ_tag])
				continue //Organ is hidden, don't talk about it
			if(temp.status & ORGAN_DESTROYED)
				wound_flavor_text["[temp.name]"] = SPAN_BOLDWARNING("[T.He] [T.is] missing [T.his] [temp.name].")
				continue
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

	for(var/limb in wound_flavor_text)
		. += wound_flavor_text[limb]
	for(var/limb in is_bleeding)
		. += is_bleeding[limb]
	for(var/implant in get_visible_implants(0))
		. += SPAN_DANGER("[src] [T.has] \a [FORMAT_TEXT_LOOKITEM(implant)] sticking out of [T.his] flesh!")
	if(digitalcamo)
		. += SPAN_WARNING("[T.He] [T.is] repulsively uncanny!")

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

		. += SPAN_BOLDNOTICE("Criminal status: <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>")
		. += SPAN_BOLDNOTICE("Security records: <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>")

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

		. += SPAN_BOLDNOTICE("Physical status: <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>")
		. += SPAN_BOLDNOTICE("Medical records: <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>")

	if(hasHUD(user,"best"))
		. += SPAN_BOLDNOTICE("Employment records: <a href='?src=\ref[src];emprecord=`'>\[View\]</a>")

	if(print_flavor_text())
		. += "[print_flavor_text()]"

	if(ooc_notes)
		. += SPAN_BOLDNOTICE("OOC Notes: <a href='?src=\ref[src];ooc_notes=1'>\[View\]</a>")

	. += SPAN_BOLDNOTICE("<a href='?src=\ref[src];vore_prefs=1'>\[Mechanical Vore Preferences\]</a>")

	. += applying_pressure

	var/show_descs = show_descriptors_to(user)
	if(show_descs)
		. += SPAN_NOTICE("[jointext(show_descs, "\n")]")

	if(pose)
		if(!findtext(pose, regex("\[.?!]$"))) // Will be zero if the last character is not a member of [.?!]
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		. += SPAN_INFO("[T.He] [pose]")

	// if(LAZYLEN(.) > 1) //Want this to appear after species text, aka the second line
	// 	.[2] = "<hr>[.[2]]"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) //This also handles flavor texts now


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
/*
/mob/living/carbon/human/proc/examine_nutrition()
	if(!show_pudge()) //Some clothing or equipment can hide this.
		return null
	var/message = FALSE
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
			message = "<span class='warning'>[t_He] [t_is] starving! You can hear [t_his] stomach snarling from across the room!</span>"
		if(50 to 99)
			message = "<span class='warning'>[t_He] [t_is] extremely hungry. A deep growl occasionally rumbles from [t_his] empty stomach.</span>"
		if(100 to 499)
			return null //Well that's pretty normal, really.
		if(500 to 999) // range that vampires hit nutrition wise, best to not have vore kink messages forced on them.
			message = "[t_He] appears to be well-hydrated and invigorated."
		if(1000 to 1399)
			message = "[t_He] [t_has] a rotund, thick gut. It bulges from their body obscenely, close to sagging under its own weight."
		if(1400 to 1934) // One person fully digested.
			message = "<span class='warning'>[t_He] [t_is] sporting a large, round, sagging stomach. It's contains at least their body weight worth of glorping slush.</span>"
		if(1935 to 3004) // Two people.
			message = "<span class='warning'>[t_He] [t_is] engorged with a huge stomach that sags and wobbles as they move. [t_He] must have consumed at least twice their body weight. It looks incredibly soft.</span>"
		if(3005 to 4074) // Three people.
			message = "<span class='warning'>[t_His] stomach is firmly packed with digesting slop. [t_He] must have eaten at least a few times worth their body weight! It looks hard for them to stand, and [t_his] gut jiggles when they move.</span>"
		if(4075 to INFINITY) // Four or more people.
			message = "<span class='warning'>[t_He] [t_is] so absolutely stuffed that you aren't sure how it's possible to move. [t_He] can't seem to swell any bigger. The surface of [t_his] belly looks sorely strained!</span>"
	return message
*/

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

/mob/living/carbon/human/proc/examine_pickup_size(mob/living/H)
	var/message
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.50)
		message = SPAN_NOTICE("They are small enough that you could easily pick them up!")
		return message
	return FALSE

/mob/living/carbon/human/proc/examine_step_size(mob/living/H)
	var/message
	if(istype(H) && (H.get_effective_size() - src.get_effective_size()) >= 0.75)
		message = SPAN_WARNING("They are small enough that you could easily trample them!")
		return message
	else
		return FALSE

/mob/living/carbon/human/proc/examine_nif(mob/living/carbon/human/H)
	if(nif && nif.examine_msg) //If you have one set, anyway.
		return SPAN_NOTICE("[nif.examine_msg]")

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
			return "<span class='warning'>[t_His] body is twitching subtly.</span>"
		else
			return "<span class='notice'>[t_He] [t_appear] to be in some sort of torpor.</span>"
	if(feral)
		return "<span class='warning'>[t_He] [t_has] a crazed, wild look in [t_his] eyes!</span>"
	if(bitten)
		return "<span class='notice'>[t_He] [t_appear] to have two fresh puncture marks on [t_his] neck.</span>"

/*
/// You can include this in any mob's examine() to show the examine texts of status effects!
/mob/living/proc/status_effect_examines(pronoun_replacement)
	var/list/dat = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext(E.examine_text, "SUBJECTPRONOUN", pronoun_replacement)
			new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
			dat += "[new_text]\n" //dat.Join("\n") doesn't work here, for some reason
	if(dat.len)
		return dat.Join()
*/
/**
 * Shows any and all examine text related to any status effects the user has.
 */
/mob/living/proc/get_status_effect_examinations()
	var/list/examine_list = list()

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text()
		if(!effect_text)
			continue

		examine_list += effect_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")
