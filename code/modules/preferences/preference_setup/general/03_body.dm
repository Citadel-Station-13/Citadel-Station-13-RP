var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["hair_red"]			>> pref.r_hair
	S["hair_green"]			>> pref.g_hair
	S["hair_blue"]			>> pref.b_hair
	S["grad_red"]			>> pref.r_grad
	S["grad_green"]			>> pref.g_grad
	S["grad_blue"]			>> pref.b_grad
	S["facial_red"]			>> pref.r_facial
	S["facial_green"]		>> pref.g_facial
	S["facial_blue"]		>> pref.b_facial
	S["skin_tone"]			>> pref.s_tone
	S["skin_red"]			>> pref.r_skin
	S["skin_green"]			>> pref.g_skin
	S["skin_blue"]			>> pref.b_skin
	S["hair_style"]			>> pref.h_style_id
	S["facial_style"]		>> pref.f_style_id
	S["grad_style_name"]	>> pref.grad_style
	S["grad_wingstyle_name"]>> pref.grad_wingstyle
	S["eyes_red"]			>> pref.r_eyes
	S["eyes_green"]			>> pref.g_eyes
	S["eyes_blue"]			>> pref.b_eyes
	S["b_type"]				>> pref.b_type
	S["disabilities"]		>> pref.disabilities
	S["mirror"]				>> pref.mirror
	S["organ_data"]			>> pref.organ_data
	S["rlimb_data"]			>> pref.rlimb_data
	S["body_marking_ids"]		>> pref.body_marking_ids
	S["synth_color"]		>> pref.synth_color
	S["synth_red"]			>> pref.r_synth
	S["synth_green"]		>> pref.g_synth
	S["synth_blue"]			>> pref.b_synth
	S["synth_markings"]		>> pref.synth_markings
	pref.regen_limbs = 1
	S["bgstate"]			>> pref.bgstate
	S["body_descriptors"]	>> pref.body_descriptors
	S["s_base"]				>> pref.s_base

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["hair_red"]			<< pref.r_hair
	S["hair_green"]			<< pref.g_hair
	S["hair_blue"]			<< pref.b_hair
	S["grad_red"]			<< pref.r_grad
	S["grad_green"]			<< pref.g_grad
	S["grad_blue"]			<< pref.b_grad
	S["facial_red"]			<< pref.r_facial
	S["facial_green"]		<< pref.g_facial
	S["facial_blue"]		<< pref.b_facial
	S["skin_tone"]			<< pref.s_tone
	S["skin_red"]			<< pref.r_skin
	S["skin_green"]			<< pref.g_skin
	S["skin_blue"]			<< pref.b_skin
	S["hair_style"]	<< pref.h_style_id
	S["facial_style"]	<< pref.f_style_id
	S["grad_style_name"]	<< pref.grad_style
	S["grad_wingstyle_name"]<< pref.grad_wingstyle
	S["eyes_red"]			<< pref.r_eyes
	S["eyes_green"]			<< pref.g_eyes
	S["eyes_blue"]			<< pref.b_eyes
	S["b_type"]				<< pref.b_type
	S["disabilities"]		<< pref.disabilities
	S["mirror"]				<< pref.mirror
	S["organ_data"]			<< pref.organ_data
	S["rlimb_data"]			<< pref.rlimb_data
	S["body_marking_ids"]		<< pref.body_marking_ids
	S["synth_color"]		<< pref.synth_color
	S["synth_red"]			<< pref.r_synth
	S["synth_green"]		<< pref.g_synth
	S["synth_blue"]			<< pref.b_synth
	S["synth_markings"]		<< pref.synth_markings
	S["bgstate"]			<< pref.bgstate
	S["body_descriptors"]	<< pref.body_descriptors
	S["s_base"]				<< pref.s_base

/datum/category_item/player_setup_item/general/body/sanitize_character(var/savefile/S)
	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_grad			= sanitize_integer(pref.r_grad, 0, 255, initial(pref.r_grad))
	pref.g_grad			= sanitize_integer(pref.g_grad, 0, 255, initial(pref.g_grad))
	pref.b_grad			= sanitize_integer(pref.b_grad, 0, 255, initial(pref.b_grad))
	pref.r_facial		= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial		= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial		= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style_id		= sanitize_inlist(pref.h_style_id, GLOB.sprite_accessory_hair)
	pref.f_style_id		= sanitize_inlist(pref.f_style_id, GLOB.sprite_accessory_facial_hair)
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.grad_wingstyle	= sanitize_inlist(pref.grad_wingstyle, GLOB.hair_gradients, initial(pref.grad_wingstyle))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type			= sanitize_istext(pref.b_type, initial(pref.b_type))
	if(pref.mirror == null)
		pref.mirror = TRUE
	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!pref.organ_data)
		pref.organ_data = list()
	if(!pref.rlimb_data)
		pref.rlimb_data = list()
	pref.body_marking_ids = sanitize_islist(pref.body_marking_ids)
	pref.body_marking_ids &= GLOB.sprite_accessory_markings
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	// Copy basic values
	character.r_eyes			= pref.r_eyes
	character.g_eyes			= pref.g_eyes
	character.b_eyes			= pref.b_eyes
	character.r_hair			= pref.r_hair
	character.g_hair			= pref.g_hair
	character.b_hair			= pref.b_hair
	character.r_grad			= pref.r_grad
	character.g_grad			= pref.g_grad
	character.b_grad			= pref.b_grad
	character.r_gradwing		= pref.r_gradwing
	character.g_gradwing		= pref.g_gradwing
	character.b_gradwing		= pref.b_gradwing
	character.r_facial			= pref.r_facial
	character.g_facial			= pref.g_facial
	character.b_facial			= pref.b_facial
	character.r_skin			= pref.r_skin
	character.g_skin			= pref.g_skin
	character.b_skin			= pref.b_skin
	character.s_tone			= pref.s_tone
	var/datum/sprite_accessory/S = GLOB.sprite_accessory_hair[pref.h_style_id]
	character.h_style = S.name
	S = GLOB.sprite_accessory_facial_hair[pref.f_style_id]
	character.f_style = S.name
	character.grad_style		= pref.grad_style
	character.grad_wingstyle	= pref.grad_wingstyle
	character.b_type			= pref.b_type
	character.synth_color 		= pref.synth_color
	character.r_synth			= pref.r_synth
	character.g_synth			= pref.g_synth
	character.b_synth			= pref.b_synth
	character.synth_markings 	= pref.synth_markings
	character.s_base			= pref.s_base

	// Destroy/cyborgize organs and limbs.
	character.synthetic = null
	// todo: refactor organs/limbs to not need this
	//! COMPATIBILITY PATCH
	// we must robotize going from the logical root to the extremities
	// so auto-robotize-nested doesn't break things by overwriting their prefs
	//! EDIT
	// it seems the protean shitcode makes this break if we use the prior order for proteans
	// but it'll break for **EVERYONE ELSE** if we don't
	// because said protean shitcode uses dangerous snowflake variable changes to
	// make things work
	// the current order is going to work for now
	// but keep in mind touching this list can be relatively dangerous
	// because as of right now this only works due to some further shimming
	// that makes it force changes even when already robotized
	for(var/name in list(
		BP_TORSO,
		BP_GROIN,
		BP_HEAD,
		BP_L_ARM,
		BP_L_HAND,
		BP_R_ARM,
		BP_R_HAND,
		BP_L_LEG,
		BP_L_FOOT,
		BP_R_LEG,
		BP_R_FOOT
	))
		var/status = pref.organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.remove_rejuv()
			else if(status == "cyborg")
				if(pref.rlimb_data[name])
					// use force to override prior robotizations oh god THIS IS BAD
					O.robotize(pref.rlimb_data[name], null, null, TRUE)
				else
					O.robotize()

	for(var/name in list(O_HEART,O_EYES,O_VOICE,O_LUNGS,O_LIVER,O_KIDNEYS,O_SPLEEN,O_STOMACH,O_INTESTINE,O_BRAIN))
		var/status = pref.organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(istype(I, /obj/item/organ/internal/brain))
			var/obj/item/organ/external/E = character.get_organ(I.parent_organ)
			if(E.robotic < ORGAN_ASSISTED)
				continue
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()
			else if(status == "digital")
				I.digitize()


	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		if(!istype(O))
			continue
		O.markings.Cut()

	for(var/id in pref.body_marking_ids)
		var/datum/sprite_accessory/marking/mark_datum = GLOB.sprite_accessory_markings[id]
		var/mark_color = "[pref.body_marking_ids[id]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[id] = list("color" = mark_color, "datum" = mark_datum)

	var/list/last_descriptors = list()
	if(islist(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	var/datum/species/mob_species = pref.real_species_datum()
	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = clamp(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))

	return TRUE

/datum/category_item/player_setup_item/general/body/content(datum/preferences/prefs, mob/user, data)
	. = list()

	var/datum/species/mob_species = pref.real_species_datum()
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"
	. += "Species: <a href='?src=\ref[src];show_species=1'>[mob_species.name]</a><br>"
	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	if(has_flag(mob_species, HAS_BASE_SKIN_COLOR))
		. += "Base Colour: <a href='?src=\ref[src];base_skin=1'>[pref.s_base]</a><br>"
	. += "Needs Glasses: <a href='?src=\ref[src];disabilities=[DISABILITY_NEARSIGHTED]'><b>[pref.disabilities & DISABILITY_NEARSIGHTED ? "Yes" : "No"]</b></a><br>"
	. += "Limbs: <a href='?src=\ref[src];limbs=1'>Adjust</a> <a href='?src=\ref[src];reset_limbs=1'>Reset</a><br>"
	. += "Internal Organs: <a href='?src=\ref[src];organs=1'>Adjust</a><br>"
	. += "Respawn Method: <a href='?src=\ref[src];mirror=1'><b>[pref.mirror ? "Mirror" : "Off-Site Cloning"]</b></a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = null

		switch(name)
			if(BP_TORSO)
				organ_name = "torso"
			if(BP_GROIN)
				organ_name = "groin"
			if(BP_HEAD)
				organ_name = "head"
			if(BP_L_ARM)
				organ_name = "left arm"
			if(BP_R_ARM)
				organ_name = "right arm"
			if(BP_L_LEG)
				organ_name = "left leg"
			if(BP_R_LEG)
				organ_name = "right leg"
			if(BP_L_FOOT)
				organ_name = "left foot"
			if(BP_R_FOOT)
				organ_name = "right foot"
			if(BP_L_HAND)
				organ_name = "left hand"
			if(BP_R_HAND)
				organ_name = "right hand"
			if(O_HEART)
				organ_name = "heart"
			if(O_EYES)
				organ_name = "eyes"
			if(O_VOICE)
				organ_name = "larynx"
			if(O_BRAIN)
				organ_name = "brain"
			if(O_LUNGS)
				organ_name = "lungs"
			if(O_LIVER)
				organ_name = "liver"
			if(O_KIDNEYS)
				organ_name = "kidneys"
			if(O_SPLEEN)
				organ_name = "spleen"
			if(O_STOMACH)
				organ_name = "stomach"
			if(O_INTESTINE)
				organ_name = "intestines"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				. += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && GLOB.all_robolimbs[pref.rlimb_data[name]])
				R = GLOB.all_robolimbs[pref.rlimb_data[name]]
			else
				R = GLOB.basic_robolimb
			. += "\t[R.company] [organ_name] prosthesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if ("brain")
					. += "\tPositronic [organ_name]"
				else
					. += "\tSynthetic [organ_name]"
		else if(status == "digital")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tDigital [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if("heart")
					. += "\tPacemaker-assisted [organ_name]"
				if("lungs")
					. += "\tAssisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					. += "\tSurgically altered [organ_name]"
				if("eyes")
					. += "\tRetinal overlayed [organ_name]"
				if("brain")
					. += "\tAssisted-interface [organ_name]"
				else
					. += "\tMechanically assisted [organ_name]"
	if(!ind)
		. += "\[...\]<br><br>"
	else
		. += "<br><br>"

	if(LAZYLEN(pref.body_descriptors))
		. += "<table>"
		for(var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='?src=\ref[src];change_descriptor=[entry]'>Change</a><br/></td></tr>"
		. += "</table><br>"

	. += "</td><td><b>Preview</b><br>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "</td></tr></table>"

	. += "<b>Hair</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> [color_square(pref.r_hair, pref.g_hair, pref.b_hair)] "
	var/datum/sprite_accessory/current_hair = GLOB.sprite_accessory_hair[pref.h_style_id]
	. += " Style: <a href='?src=\ref[src];hair_style_left=1'><</a> <a href='?src=\ref[src];hair_style_right=1'>></a> <a href='?src=\ref[src];hair_style=1'>[current_hair.name]</a><br>" //The <</a> & ></a> in this line is correct-- those extra characters are the arrows you click to switch between styles.

	. += "<b>Gradient</b><br>"
	. += "<a href='?src=\ref[src];grad_color=1'>Change Color</a> [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] "
	. += " Style: <a href='?src=\ref[src];grad_style_left=1'><</a> <a href='?src=\ref[src];grad_style_right=1'>></a> <a href='?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> [color_square(pref.r_facial, pref.g_facial, pref.b_facial)] "
	var/datum/sprite_accessory/current_face_hair = GLOB.sprite_accessory_facial_hair[pref.f_style_id]
	. += " Style: <a href='?src=\ref[src];facial_style_left=1'><</a> <a href='?src=\ref[src];facial_style_right=1'>></a> <a href='?src=\ref[src];facial_style=1'>[current_face_hair.name]</a><br>" //Same as above with the extra > & < characters

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes</b><br>"
		. += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> [color_square(pref.r_eyes, pref.g_eyes, pref.b_eyes)]<br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color</b><br>"
		. += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> [color_square(pref.r_skin, pref.g_skin, pref.b_skin)]<br>"

	. += "<br><a href='?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	. += "<table>"
	for(var/M in pref.body_marking_ids)
		var/datum/sprite_accessory/S = GLOB.sprite_accessory_markings[M]
		. += "<tr><td>[S.name]</td><td>[pref.body_marking_ids.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> <a href='?src=\ref[src];marking_move=[M]'>mv</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Color</a>[color_square(hex = pref.body_marking_ids[M])]</td></tr>"

	. += "</table>"
	. += "<br>"
	. += "<b>Allow Synth markings:</b> <a href='?src=\ref[src];synth_markings=1'><b>[pref.synth_markings ? "Yes" : "No"]</b></a><br>"
	. += "<b>Allow Synth color:</b> <a href='?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Yes" : "No"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='?src=\ref[src];synth2_color=1'>Change Color</a> [color_square(pref.r_synth, pref.g_synth, pref.b_synth)]"

	. = jointext(.,null)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.species_appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = pref.real_species_datum()

	if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
				var/choice = tgui_input_list(user,"Please select a descriptor.", "Descriptor", descriptor.chargen_value_descriptors)
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return PREFERENCES_REFRESH

	else if(href_list["blood_type"])
		var/new_b_type = tgui_input_list(user, "Choose your character's blood-type:", "Character Preference", valid_bloodtypes)
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return PREFERENCES_REFRESH

	else if(href_list["show_species"])
		pref.species_pick(usr)
		return PREFERENCES_HANDLED

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return PREFERENCES_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return PREFERENCES_NOACTION
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = hex2num(copytext(new_grad, 2, 4))
			pref.g_grad = hex2num(copytext(new_grad, 4, 6))
			pref.b_grad = hex2num(copytext(new_grad, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = pref.get_valid_hairstyles()
		var/datum/sprite_accessory/current = GLOB.sprite_accessory_hair[pref.h_style_id]
		var/new_h_style = tgui_input_list(user, "Choose your character's hair style:", "Character Preference", valid_hairstyles, current.name)
		if(new_h_style && CanUseTopic(user))
			var/datum/sprite_accessory/S = valid_hairstyles[new_h_style]
			pref.h_style_id = S.id
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_left"])
		pref.h_style_id = previous_list_item_safe(pref.h_style_id, GLOB.sprite_accessory_hair) || GLOB.sprite_accessory_hair[1]
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style_right"])
		pref.h_style_id = next_list_item_safe(pref.h_style_id, GLOB.sprite_accessory_hair) || GLOB.sprite_accessory_hair[1]
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style"])
		var/list/valid_gradients = GLOB.hair_gradients

		var/new_grad_style = tgui_input_list(user, "Choose a color pattern for your hair:", "Character Preference", valid_gradients, pref.grad_style)
		if(new_grad_style && CanUseTopic(user))
			pref.grad_style = new_grad_style
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style_left"])
		pref.grad_style = previous_list_item_safe(pref.grad_style, GLOB.hair_gradients) || GLOB.hair_gradients[1]
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style_right"])
		pref.grad_style = next_list_item_safe(pref.grad_style, GLOB.hair_gradients) || GLOB.hair_gradients[1]
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return PREFERENCES_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return PREFERENCES_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35)  as num|null
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return PREFERENCES_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["base_skin"])
		if(!has_flag(mob_species, HAS_BASE_SKIN_COLOR))
			return PREFERENCES_NOACTION
		var/new_s_base = tgui_input_list(user, "Choose your character's base colour:", "Character preference", mob_species.base_skin_colours)
		if(new_s_base && CanUseTopic(user))
			pref.s_base = new_s_base
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return PREFERENCES_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = pref.get_valid_facialhairstyles()
		var/datum/sprite_accessory/current = GLOB.sprite_accessory_facial_hair[pref.f_style_id]
		var/new_f_style = tgui_input_list(user, "Choose your character's facial-hair style:", "Character Preference", valid_facialhairstyles, current.name)
		if(new_f_style && CanUseTopic(user))
			var/datum/sprite_accessory/S = valid_facialhairstyles[new_f_style]
			pref.f_style_id = S.id
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_left"])
		pref.f_style_id = previous_list_item_safe(pref.f_style_id, GLOB.sprite_accessory_facial_hair) || GLOB.sprite_accessory_facial_hair[1]
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style_right"])
		pref.f_style_id = next_list_item_safe(pref.f_style_id, GLOB.sprite_accessory_facial_hair) || GLOB.sprite_accessory_facial_hair[1]
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_marking_ids ^ GLOB.sprite_accessory_markings
		var/list/translated = list()
		for(var/id in usable_markings)
			var/datum/sprite_accessory/S = GLOB.sprite_accessory_markings[id]
			translated[S.name] = id
		var/new_marking = tgui_input_list(user, "Choose a body marking:", "Character Preference", translated)
		if(new_marking && CanUseTopic(user))
			pref.body_marking_ids[translated[new_marking]] = "#000000" //New markings start black
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_up"])
		var/M = href_list["marking_up"]
		var/start = pref.body_marking_ids.Find(M)
		if(start != 1) //If we're not the beginning of the list, swap with the previous element.
			move_element(pref.body_marking_ids, start, start-1)
		else //But if we ARE, become the final element -ahead- of everything else.
			move_element(pref.body_marking_ids, start, pref.body_marking_ids.len+1)
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_down"])
		var/M = href_list["marking_down"]
		var/start = pref.body_marking_ids.Find(M)
		if(start != pref.body_marking_ids.len) //If we're not the end of the list, swap with the next element.
			move_element(pref.body_marking_ids, start, start+2)
		else //But if we ARE, become the first element -behind- everything else.
			move_element(pref.body_marking_ids, start, 1)
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_move"])
		var/M = href_list["marking_move"]
		var/start = pref.body_marking_ids.Find(M)
		var/list/move_locs = pref.body_marking_ids - M
		if(start != 1)
			move_locs -= pref.body_marking_ids[start-1]
		var/list/translated = list()
		for(var/id in move_locs)
			var/datum/sprite_accessory/S = GLOB.sprite_accessory_markings[id]
			translated[S.name] = id
		var/inject_after = tgui_input_list(user, "Move [M] behind of...", "Character Preference", translated)//Move ahead of any marking that isn't the current or previous one.
		var/newpos = pref.body_marking_ids.Find(translated[inject_after])
		if(newpos)
			move_element(pref.body_marking_ids, start, newpos+1)
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_marking_ids -= M
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/datum/sprite_accessory/S = GLOB.sprite_accessory_markings[M]
		var/mark_color = input(user, "Choose the [S.name]'s color: ", "Character Preference", pref.body_marking_ids[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_marking_ids[M] = "[mark_color]"
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		pref.reset_limbs()
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = pref.real_species_datum()
		if(!current_species.has_organ["brain"])
			limb_selection_list -= "Full Body"
		else if(pref.organ_data[BP_TORSO] == "cyborg")
			limb_selection_list |= "Head"

		var/organ_tag = tgui_input_list(user, "Which limb do you want to change?","Character Preference", limb_selection_list)

		if(!organ_tag || !CanUseTopic(user)) return PREFERENCES_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Normal","Amputated","Prosthesis")
		switch(organ_tag)
			if("Left Leg")
				limb =        BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb =        BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb =        BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb =        BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb =        BP_L_FOOT
				third_limb =  BP_L_LEG
			if("Right Foot")
				limb =        BP_R_FOOT
				third_limb =  BP_R_LEG
			if("Left Hand")
				limb =        BP_L_HAND
				third_limb =  BP_L_ARM
			if("Right Hand")
				limb =        BP_R_HAND
				third_limb =  BP_R_ARM
			if("Head")
				limb =        BP_HEAD
				choice_options = list("Prosthesis")
			if("Full Body")
				limb =        BP_TORSO
				second_limb = BP_HEAD
				third_limb =  BP_GROIN
				choice_options = list("Normal","Prosthesis")

		var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?","Character Preference", choice_options)
		if(!new_state || !CanUseTopic(user)) return PREFERENCES_NOACTION

		pref.regen_limbs = 1

		switch(new_state)
			if("Normal")
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
						for(var/internal in O_ALL_STANDARD)
							pref.organ_data[internal] = null
							pref.rlimb_data[internal] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null

			if("Amputated")
				if(limb == BP_TORSO)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = pref.real_species_name()
				var/list/usable_manufacturers = list()
				for(var/company in GLOB.chargen_robolimbs)
					var/datum/robolimb/M = GLOB.chargen_robolimbs[company]
					if(!(limb in M.parts))
						continue
					if(tmp_species in M.species_cannot_use)
						continue
					// Cyberlimb whitelisting.
					if(M.whitelisted_to && !(user.ckey in M.whitelisted_to))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = tgui_input_list(user, "Which manufacturer do you wish to use for this limb?", "Character Setup", usable_manufacturers)
				if(!choice)
					return

				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"

				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						if(pref.organ_data[other_limb])
							continue
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[O_BRAIN])
						pref.organ_data[O_BRAIN] = "assisted"
					for(var/internal_organ in list(O_HEART,O_EYES))
						pref.organ_data[internal_organ] = "mechanical"

		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])

		var/organ = tgui_input_list(user, "Which internal function do you want to change?", "Character Preference", O_ALL_STANDARD)
		if(!organ)
			return

		if(organ == "brain")
			if(pref.organ_data[BP_HEAD] != "cyborg")
				to_chat(user, "<span class='warning'>You may only select a cybernetic or synthetic brain if you have a full prosthetic body.</span>")
				return

		var/list/organ_choices = list("Normal", "Assisted", "Mechanical")
		if(pref.organ_data[BP_TORSO] == "cyborg")
			organ_choices -= "Normal"
			if(organ == "brain")
				organ_choices += "Cybernetic"
				organ_choices += "Positronic"
				organ_choices += "Drone"
				organ_choices -= "Assisted"
				organ_choices -= "Mechanical"

		var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "Character Setup", organ_choices)
		if(!new_state) return

		pref.regen_limbs = 1

		switch(new_state)
			if("Normal")
				pref.organ_data[organ] = null
			if("Assisted")
				pref.organ_data[organ] = "assisted"
			if("Cybernetic")
				pref.organ_data[organ] = "assisted"
			if ("Mechanical")
				pref.organ_data[organ] = "mechanical"
			if("Drone")
				pref.organ_data[organ] = "digital"
			if("Positronic")
				pref.organ_data[organ] = "mechanical"

		return PREFERENCES_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["mirror"])
		if(pref.mirror)
			pref.mirror = FALSE
			to_chat(usr, "Off-Site Cloning means you cannot rejoin a round as the same character if you are killed and cannot be recovered.")
		else
			pref.mirror = TRUE
			to_chat(usr, "A mirror is an implant that, if recovered, will allow you to be resleeved.")
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_color"])
		pref.synth_color = !pref.synth_color
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth2_color"])
		var/new_color = input(user, "Choose your character's synth colour: ", "Character Preference", rgb(pref.r_synth, pref.g_synth, pref.b_synth)) as color|null
		if(new_color && CanUseTopic(user))
			pref.r_synth = hex2num(copytext(new_color, 2, 4))
			pref.g_synth = hex2num(copytext(new_color, 4, 6))
			pref.b_synth = hex2num(copytext(new_color, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_markings"])
		pref.synth_markings = !pref.synth_markings
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_list_item(pref.bgstate, pref.bgstate_options)
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/preferences/proc/reset_limbs()
	for(var/organ in organ_data)
		organ_data[organ] = null
	while(null in organ_data)
		organ_data -= null

	for(var/organ in rlimb_data)
		rlimb_data[organ] = null
	while(null in rlimb_data)
		rlimb_data -= null

	regen_limbs = 1

	// Sanitize the name so that there aren't any numbers sticking around.
	var/species_name = real_species_name()
	real_name          = sanitize_species_name(real_name, species_name)
	if(!real_name)
		real_name      = random_name(identifying_gender, species_name)
