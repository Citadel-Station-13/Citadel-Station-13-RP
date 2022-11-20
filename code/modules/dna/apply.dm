/**
 * sets us from a human
 */
/datum/dna/proc/copy_from_mob(mob/living/carbon/human/template)
	#warn impl

/*

/datum/dna/proc/ResetUIFrom(mob/living/carbon/human/character)
	// INITIALIZE!
	ResetUI(1)
	set_gender(character.gender)
	//! Playerscale (This assumes list is sorted big->small)
	var/size_multiplier = player_sizes_list.len // If fail to find, take smallest
	for(var/N in player_sizes_list)
		if(character.size_multiplier >= player_sizes_list[N])
			size_multiplier = player_sizes_list.Find(N)
			break

	// Technically custom_species is not part of the UI, but this place avoids merge problems.
	src.custom_species = character.custom_species
	src.base_species = character.species.base_species
	src.blood_color = character.species.blood_color
	src.species_traits = character.species.traits.Copy()

	src.custom_say = character.custom_say
	src.custom_ask = character.custom_ask
	src.custom_whisper = character.custom_whisper
	src.custom_exclaim = character.custom_exclaim

	SetUIValueRange(DNA_UI_PLAYERSCALE,  size_multiplier,     player_sizes_list.len,  1)

	body_markings.Cut()
	//s_base = character.s_base //doesn't work, fuck me
	for(var/obj/item/organ/external/E in character.organs)
		E.s_base = s_base
		if(E.markings.len)
			body_markings[E.organ_tag] = E.markings.Copy()

	UpdateUI()
*/

/**
 * sets a human to us
 */
/datum/dna/proc/apply_to_mob(mob/living/carbon/human/applying)
	#warn impl

/*
/**
 * Simpler. Don't specify UI in order for the mob to use its own.
 */
/mob/proc/UpdateAppearance(list/UI=null)
	if(istype(src, /mob/living/carbon/human))
		if(UI!=null)
			src.dna.UI=UI
			src.dna.UpdateUI()
		dna.check_integrity()
		var/mob/living/carbon/human/H = src
		H.r_hair   = dna.GetUIValueRange(DNA_UI_HAIR_R,    255)
		H.g_hair   = dna.GetUIValueRange(DNA_UI_HAIR_G,    255)
		H.b_hair   = dna.GetUIValueRange(DNA_UI_HAIR_B,    255)

		H.r_facial = dna.GetUIValueRange(DNA_UI_BEARD_R,   255)
		H.g_facial = dna.GetUIValueRange(DNA_UI_BEARD_G,   255)
		H.b_facial = dna.GetUIValueRange(DNA_UI_BEARD_B,   255)

		H.r_skin   = dna.GetUIValueRange(DNA_UI_SKIN_R,    255)
		H.g_skin   = dna.GetUIValueRange(DNA_UI_SKIN_G,    255)
		H.b_skin   = dna.GetUIValueRange(DNA_UI_SKIN_B,    255)

		H.r_eyes   = dna.GetUIValueRange(DNA_UI_EYES_R,    255)
		H.g_eyes   = dna.GetUIValueRange(DNA_UI_EYES_G,    255)
		H.b_eyes   = dna.GetUIValueRange(DNA_UI_EYES_B,    255)
		H.update_eyes()

		H.s_tone   = 35 - dna.GetUIValueRange(DNA_UI_SKIN_TONE, 220) // Value can be negative.

		if(H.gender != NEUTER)
			if (dna.GetUIState(DNA_UI_GENDER))
				H.gender = FEMALE
			else
				H.gender = MALE

		//! Body markings
		for(var/tag in dna.body_markings)
			var/obj/item/organ/external/E = H.organs_by_name[tag]
			if(E)
				var/list/marklist = dna.body_markings[tag]
				E.markings = marklist.Copy()

		//! Hair
		var/hair = dna.GetUIValueRange(DNA_UI_HAIR_STYLE,hair_styles_list.len)
		if((0 < hair) && (hair <= hair_styles_list.len))
			H.h_style = hair_styles_list[hair]

		//! Facial Hair
		var/beard = dna.GetUIValueRange(DNA_UI_BEARD_STYLE,facial_hair_styles_list.len)
		if((0 < beard) && (beard <= facial_hair_styles_list.len))
			H.f_style = facial_hair_styles_list[beard]

		//! Ears
		var/ears = dna.GetUIValueRange(DNA_UI_EAR_STYLE, ear_styles_list.len + 1) - 1
		if(ears <= 1)
			H.ear_style = null
		else if((0 < ears) && (ears <= ear_styles_list.len))
			H.ear_style = ear_styles_list[ear_styles_list[ears]]

		//! Ear Color
		H.r_ears  = dna.GetUIValueRange(DNA_UI_EARS_R,    255)
		H.g_ears  = dna.GetUIValueRange(DNA_UI_EARS_G,    255)
		H.b_ears  = dna.GetUIValueRange(DNA_UI_EARS_B, 	  255)
		H.r_ears2 = dna.GetUIValueRange(DNA_UI_EARS2_R,   255)
		H.g_ears2 = dna.GetUIValueRange(DNA_UI_EARS2_G,   255)
		H.b_ears2 = dna.GetUIValueRange(DNA_UI_EARS2_B,	  255)
		H.r_ears3 = dna.GetUIValueRange(DNA_UI_EARS3_R,   255)
		H.g_ears3 = dna.GetUIValueRange(DNA_UI_EARS3_G,   255)
		H.b_ears3 = dna.GetUIValueRange(DNA_UI_EARS3_B,	  255)

		//! Tail
		var/tail = dna.GetUIValueRange(DNA_UI_TAIL_STYLE, tail_styles_list.len + 1) - 1
		if(tail <= 1)
			H.tail_style = null
		else if((0 < tail) && (tail <= tail_styles_list.len))
			H.tail_style = tail_styles_list[tail_styles_list[tail]]

		//! Wing
		var/wing = dna.GetUIValueRange(DNA_UI_WING_STYLE, wing_styles_list.len + 1) - 1
		if(wing <= 1)
			H.wing_style = null
		else if((0 < wing) && (wing <= wing_styles_list.len))
			H.wing_style = wing_styles_list[wing_styles_list[wing]]

		//! Wing Color
		H.r_wing   = dna.GetUIValueRange(DNA_UI_WING_R,   255)
		H.g_wing   = dna.GetUIValueRange(DNA_UI_WING_G,   255)
		H.b_wing   = dna.GetUIValueRange(DNA_UI_WING_B,   255)
		H.r_wing2  = dna.GetUIValueRange(DNA_UI_WING2_R,  255)
		H.g_wing2  = dna.GetUIValueRange(DNA_UI_WING2_G,  255)
		H.b_wing2  = dna.GetUIValueRange(DNA_UI_WING2_B,  255)
		H.r_wing3  = dna.GetUIValueRange(DNA_UI_WING3_R,  255)
		H.g_wing3  = dna.GetUIValueRange(DNA_UI_WING3_G,  255)
		H.b_wing3  = dna.GetUIValueRange(DNA_UI_WING3_B,  255)

		//! Playerscale
		var/size = dna.GetUIValueRange(DNA_UI_PLAYERSCALE, player_sizes_list.len)
		if((0 < size) && (size <= player_sizes_list.len))
			H.resize(player_sizes_list[player_sizes_list[size]], FALSE)

		//! Tail/Taur Color
		H.r_tail   = dna.GetUIValueRange(DNA_UI_TAIL_R,   255)
		H.g_tail   = dna.GetUIValueRange(DNA_UI_TAIL_G,   255)
		H.b_tail   = dna.GetUIValueRange(DNA_UI_TAIL_B,   255)
		H.r_tail2  = dna.GetUIValueRange(DNA_UI_TAIL2_R,  255)
		H.g_tail2  = dna.GetUIValueRange(DNA_UI_TAIL2_G,  255)
		H.b_tail2  = dna.GetUIValueRange(DNA_UI_TAIL2_B,  255)
		H.r_tail3  = dna.GetUIValueRange(DNA_UI_TAIL3_R,  255)
		H.g_tail3  = dna.GetUIValueRange(DNA_UI_TAIL3_G,  255)
		H.b_tail3  = dna.GetUIValueRange(DNA_UI_TAIL3_B,  255)

		//! Technically custom_species is not part of the UI, but this place avoids merge problems.
		H.custom_species = dna.custom_species
		H.custom_say = dna.custom_say
		H.custom_ask = dna.custom_ask
		H.custom_whisper = dna.custom_whisper
		H.custom_exclaim = dna.custom_exclaim
		H.species.blood_color = dna.blood_color
		var/datum/species/S = H.species
		S.copy_from(dna.base_species, dna.species_traits, H)

		H.force_update_organs()
		H.force_update_limbs()
		//H.update_icons_body(0) // Done in force_update_limbs already
		H.update_eyes()
		H.update_hair()

		return TRUE
	else
		return FALSE
*/
