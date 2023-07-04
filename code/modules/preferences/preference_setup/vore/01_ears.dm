// Global stuff that will put us on the map
/datum/category_group/player_setup_category/vore
	name = "Species Customization"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/vore

// Define a place to save appearance in character setup
/datum/preferences
	var/ear_style_id    // Type of selected ear style
	var/r_ears = 30  // Ear color.
	var/g_ears = 30  // Ear color
	var/b_ears = 30  // Ear color
	var/r_ears2 = 30 // Ear extra color.
	var/g_ears2 = 30 // Ear extra color
	var/b_ears2 = 30 // Ear extra color
	var/r_ears3 = 30 // Ear tertiary color.
	var/g_ears3 = 30 // Ear tertiary color
	var/b_ears3 = 30 // Ear tertiary color
	var/horn_style_id    // Type of selected horn style
	var/r_horn = 30  // Horn color.
	var/g_horn = 30  // Horn color
	var/b_horn = 30  // Horn color
	var/r_horn2 = 30 // Horn extra color.
	var/g_horn2 = 30 // Horn extra color
	var/b_horn2 = 30 // Horn extra color
	var/r_horn3 = 30 // Horn tertiary color.
	var/g_horn3 = 30 // Horn tertiary color
	var/b_horn3 = 30 // Horn tertiary color
	var/tail_style_id   // Type of selected tail style
	var/r_tail = 30  // Tail/Taur color
	var/g_tail = 30  // Tail/Taur color
	var/b_tail = 30  // Tail/Taur color
	var/r_tail2 = 30 // For extra overlay.
	var/g_tail2 = 30 // For extra overlay.
	var/b_tail2 = 30 // For extra overlay.
	var/r_tail3 = 30 // For tertiary overlay.
	var/g_tail3 = 30 // For tertiary overlay.
	var/b_tail3 = 30 // For tertiary overlay.
	var/wing_style_id   // Type of selected wing style
	var/r_wing = 30  // Wing color
	var/g_wing = 30  // Wing color
	var/b_wing = 30  // Wing color
	var/r_wing2 = 30 // Wing extra color
	var/g_wing2 = 30 // Wing extra color
	var/b_wing2 = 30 // Wing extra color
	var/r_wing3 = 30 // Wing tertiary color
	var/g_wing3 = 30 // Wing tertiary color
	var/b_wing3 = 30 // Wing tertiary color
	var/r_gradwing = 30
	var/g_gradwing = 30
	var/b_gradwing = 30

// Definition of the stuff for Ears
/datum/category_item/player_setup_item/vore/ears
	name = "Appearance"
	sort_order = 1

/datum/category_item/player_setup_item/vore/ears/load_character(var/savefile/S)
	S["ear_style_id"]	>> pref.ear_style_id
	S["r_ears"]			>> pref.r_ears
	S["g_ears"]			>> pref.g_ears
	S["b_ears"]			>> pref.b_ears
	S["r_ears2"]		>> pref.r_ears2
	S["g_ears2"]		>> pref.g_ears2
	S["b_ears2"]		>> pref.b_ears2
	S["r_ears3"]		>> pref.r_ears3
	S["g_ears3"]		>> pref.g_ears3
	S["b_ears3"]		>> pref.b_ears3
	S["horn_style_id"]		>> pref.horn_style_id
	S["r_horn"]			>> pref.r_horn
	S["g_horn"]			>> pref.g_horn
	S["b_horn"]			>> pref.b_horn
	S["r_horn2"]		>> pref.r_horn2
	S["g_horn2"]		>> pref.g_horn2
	S["b_horn2"]		>> pref.b_horn2
	S["r_horn3"]		>> pref.r_horn3
	S["g_horn3"]		>> pref.g_horn3
	S["b_horn3"]		>> pref.b_horn3
	S["tail_style_id"]		>> pref.tail_style_id
	S["r_tail"]			>> pref.r_tail
	S["g_tail"]			>> pref.g_tail
	S["b_tail"]			>> pref.b_tail
	S["r_tail2"]		>> pref.r_tail2
	S["g_tail2"]		>> pref.g_tail2
	S["b_tail2"]		>> pref.b_tail2
	S["r_tail3"]		>> pref.r_tail3
	S["g_tail3"]		>> pref.g_tail3
	S["b_tail3"]		>> pref.b_tail3
	S["wing_style_id"]		>> pref.wing_style_id
	S["r_wing"]			>> pref.r_wing
	S["g_wing"]			>> pref.g_wing
	S["b_wing"]			>> pref.b_wing
	S["r_wing2"]		>> pref.r_wing2
	S["g_wing2"]		>> pref.g_wing2
	S["b_wing2"]		>> pref.b_wing2
	S["r_wing3"]		>> pref.r_wing3
	S["g_wing3"]		>> pref.g_wing3
	S["b_wing3"]		>> pref.b_wing3
	S["r_gradwing"]		>> pref.r_gradwing
	S["g_gradwing"]		>> pref.g_gradwing
	S["b_gradwing"]		>> pref.b_gradwing

/datum/category_item/player_setup_item/vore/ears/save_character(var/savefile/S)
	S["ear_style_id"]		<< pref.ear_style_id
	S["r_ears"]			<< pref.r_ears
	S["g_ears"]			<< pref.g_ears
	S["b_ears"]			<< pref.b_ears
	S["r_ears2"]		<< pref.r_ears2
	S["g_ears2"]		<< pref.g_ears2
	S["b_ears2"]		<< pref.b_ears2
	S["r_ears3"]		<< pref.r_ears3
	S["g_ears3"]		<< pref.g_ears3
	S["b_ears3"]		<< pref.b_ears3
	S["horn_style_id"]		<< pref.horn_style_id
	S["r_horn"]			<< pref.r_horn
	S["g_horn"]			<< pref.g_horn
	S["b_horn"]			<< pref.b_horn
	S["r_horn2"]		<< pref.r_horn2
	S["g_horn2"]		<< pref.g_horn2
	S["b_horn2"]		<< pref.b_horn2
	S["r_horn3"]		<< pref.r_horn3
	S["g_horn3"]		<< pref.g_horn3
	S["b_horn3"]		<< pref.b_horn3
	S["tail_style_id"]		<< pref.tail_style_id
	S["r_tail"]			<< pref.r_tail
	S["g_tail"]			<< pref.g_tail
	S["b_tail"]			<< pref.b_tail
	S["r_tail2"]		<< pref.r_tail2
	S["g_tail2"]		<< pref.g_tail2
	S["b_tail2"]		<< pref.b_tail2
	S["r_tail3"]		<< pref.r_tail3
	S["g_tail3"]		<< pref.g_tail3
	S["b_tail3"]		<< pref.b_tail3
	S["wing_style_id"]		<< pref.wing_style_id
	S["r_wing"]			<< pref.r_wing
	S["g_wing"]			<< pref.g_wing
	S["b_wing"]			<< pref.b_wing
	S["r_wing2"]		<< pref.r_wing2
	S["g_wing2"]		<< pref.g_wing2
	S["b_wing2"]		<< pref.b_wing2
	S["r_wing3"]		<< pref.r_wing3
	S["g_wing3"]		<< pref.g_wing3
	S["b_wing3"]		<< pref.b_wing3
	S["r_gradwing"]		<< pref.r_gradwing
	S["g_gradwing"]		<< pref.g_gradwing
	S["b_gradwing"]		<< pref.b_gradwing

/datum/category_item/player_setup_item/vore/ears/sanitize_character()
	pref.r_ears		= sanitize_integer(pref.r_ears, 0, 255, initial(pref.r_ears))
	pref.g_ears		= sanitize_integer(pref.g_ears, 0, 255, initial(pref.g_ears))
	pref.b_ears		= sanitize_integer(pref.b_ears, 0, 255, initial(pref.b_ears))
	pref.r_ears2	= sanitize_integer(pref.r_ears2, 0, 255, initial(pref.r_ears2))
	pref.g_ears2	= sanitize_integer(pref.g_ears2, 0, 255, initial(pref.g_ears2))
	pref.b_ears2	= sanitize_integer(pref.b_ears2, 0, 255, initial(pref.b_ears2))
	pref.r_ears3	= sanitize_integer(pref.r_ears3, 0, 255, initial(pref.r_ears3))
	pref.g_ears3	= sanitize_integer(pref.g_ears3, 0, 255, initial(pref.g_ears3))
	pref.b_ears3	= sanitize_integer(pref.b_ears3, 0, 255, initial(pref.b_ears3))
	pref.r_horn		= sanitize_integer(pref.r_horn, 0, 255, initial(pref.r_horn))
	pref.g_horn		= sanitize_integer(pref.g_horn, 0, 255, initial(pref.g_horn))
	pref.b_horn		= sanitize_integer(pref.b_horn, 0, 255, initial(pref.b_horn))
	pref.r_horn2	= sanitize_integer(pref.r_horn2, 0, 255, initial(pref.r_horn2))
	pref.g_horn2	= sanitize_integer(pref.g_horn2, 0, 255, initial(pref.g_horn2))
	pref.b_horn2	= sanitize_integer(pref.b_horn2, 0, 255, initial(pref.b_horn2))
	pref.r_horn3	= sanitize_integer(pref.r_horn3, 0, 255, initial(pref.r_horn3))
	pref.g_horn3	= sanitize_integer(pref.g_horn3, 0, 255, initial(pref.g_horn3))
	pref.b_horn3	= sanitize_integer(pref.b_horn3, 0, 255, initial(pref.b_horn3))
	pref.r_tail		= sanitize_integer(pref.r_tail, 0, 255, initial(pref.r_tail))
	pref.g_tail		= sanitize_integer(pref.g_tail, 0, 255, initial(pref.g_tail))
	pref.b_tail		= sanitize_integer(pref.b_tail, 0, 255, initial(pref.b_tail))
	pref.r_tail2	= sanitize_integer(pref.r_tail2, 0, 255, initial(pref.r_tail2))
	pref.g_tail2	= sanitize_integer(pref.g_tail2, 0, 255, initial(pref.g_tail2))
	pref.b_tail2	= sanitize_integer(pref.b_tail2, 0, 255, initial(pref.b_tail2))
	pref.r_tail3	= sanitize_integer(pref.r_tail3, 0, 255, initial(pref.r_tail3))
	pref.g_tail3	= sanitize_integer(pref.g_tail3, 0, 255, initial(pref.g_tail3))
	pref.b_tail3	= sanitize_integer(pref.b_tail3, 0, 255, initial(pref.b_tail3))
	pref.r_wing		= sanitize_integer(pref.r_wing, 0, 255, initial(pref.r_wing))
	pref.g_wing		= sanitize_integer(pref.g_wing, 0, 255, initial(pref.g_wing))
	pref.b_wing		= sanitize_integer(pref.b_wing, 0, 255, initial(pref.b_wing))
	pref.r_wing2	= sanitize_integer(pref.r_wing2, 0, 255, initial(pref.r_wing2))
	pref.g_wing2	= sanitize_integer(pref.g_wing2, 0, 255, initial(pref.g_wing2))
	pref.b_wing2	= sanitize_integer(pref.b_wing2, 0, 255, initial(pref.b_wing2))
	pref.r_wing3	= sanitize_integer(pref.r_wing3, 0, 255, initial(pref.r_wing3))
	pref.g_wing3	= sanitize_integer(pref.g_wing3, 0, 255, initial(pref.g_wing3))
	pref.b_wing3	= sanitize_integer(pref.b_wing3, 0, 255, initial(pref.b_wing3))
	pref.r_gradwing = sanitize_integer(pref.r_gradwing, 0, 255, initial(pref.r_gradwing))
	pref.g_gradwing = sanitize_integer(pref.g_gradwing, 0, 255, initial(pref.g_gradwing))
	pref.b_gradwing = sanitize_integer(pref.b_gradwing, 0, 255, initial(pref.b_gradwing))

	var/datum/species/S = pref.real_species_datum()
	var/species_name = S.name

	if(pref.ear_style_id)
		pref.ear_style_id	= sanitize_inlist(pref.ear_style_id, GLOB.sprite_accessory_ears, initial(pref.ear_style_id))
		var/datum/sprite_accessory/temp_ear_style_id =  GLOB.sprite_accessory_ears[pref.ear_style_id]
		if(temp_ear_style_id.apply_restrictions && (!(species_name in temp_ear_style_id.species_allowed)))
			pref.ear_style_id = initial(pref.ear_style_id)
	if(pref.horn_style_id)
		pref.horn_style_id	= sanitize_inlist(pref.horn_style_id,  GLOB.sprite_accessory_ears, initial(pref.horn_style_id))
		var/datum/sprite_accessory/temp_horn_style_id =  GLOB.sprite_accessory_ears[pref.horn_style_id]
		if(temp_horn_style_id.apply_restrictions && (!(species_name in temp_horn_style_id.species_allowed)))
			pref.horn_style_id = initial(pref.horn_style_id)
	if(pref.tail_style_id)
		pref.tail_style_id	= sanitize_inlist(pref.tail_style_id,  GLOB.sprite_accessory_tails, initial(pref.tail_style_id))
		var/datum/sprite_accessory/temp_tail_style_id = GLOB.sprite_accessory_tails[pref.tail_style_id]
		if(temp_tail_style_id.apply_restrictions && (!(species_name in temp_tail_style_id.species_allowed)))
			pref.tail_style_id = initial(pref.tail_style_id)
	if(pref.wing_style_id)
		pref.wing_style_id	= sanitize_inlist(pref.wing_style_id, GLOB.sprite_accessory_wings, initial(pref.wing_style_id))
		var/datum/sprite_accessory/temp_wing_style_id = GLOB.sprite_accessory_wings[pref.wing_style_id]
		if(temp_wing_style_id.apply_restrictions && (!(species_name in temp_wing_style_id.species_allowed)))
			pref.wing_style_id = initial(pref.wing_style_id)

/datum/category_item/player_setup_item/vore/ears/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	var/datum/sprite_accessory/S = GLOB.sprite_accessory_ears[pref.ear_style_id]
	character.ear_style = S
	S = GLOB.sprite_accessory_tails[pref.tail_style_id]
	character.tail_style = S
	S = GLOB.sprite_accessory_wings[pref.wing_style_id]
	character.wing_style = S
	S = GLOB.sprite_accessory_ears[pref.horn_style_id]
	character.horn_style = S

	character.r_ears			= pref.r_ears
	character.b_ears			= pref.b_ears
	character.g_ears			= pref.g_ears
	character.r_ears2			= pref.r_ears2
	character.b_ears2			= pref.b_ears2
	character.g_ears2			= pref.g_ears2
	character.r_ears3			= pref.r_ears3
	character.b_ears3			= pref.b_ears3
	character.g_ears3			= pref.g_ears3

	character.r_horn			= pref.r_horn
	character.b_horn			= pref.b_horn
	character.g_horn			= pref.g_horn
	character.r_horn2			= pref.r_horn2
	character.b_horn2			= pref.b_horn2
	character.g_horn2			= pref.g_horn2
	character.r_horn3			= pref.r_horn3
	character.b_horn3			= pref.b_horn3
	character.g_horn3			= pref.g_horn3

	character.r_tail			= pref.r_tail
	character.b_tail			= pref.b_tail
	character.g_tail			= pref.g_tail
	character.r_tail2			= pref.r_tail2
	character.b_tail2			= pref.b_tail2
	character.g_tail2			= pref.g_tail2
	character.r_tail3			= pref.r_tail3
	character.b_tail3			= pref.b_tail3
	character.g_tail3			= pref.g_tail3

	character.r_wing			= pref.r_wing
	character.b_wing			= pref.b_wing
	character.g_wing			= pref.g_wing
	character.r_wing2			= pref.r_wing2
	character.b_wing2			= pref.b_wing2
	character.g_wing2			= pref.g_wing2
	character.r_wing3			= pref.r_wing3
	character.b_wing3			= pref.b_wing3
	character.g_wing3			= pref.g_wing3
	character.r_gradwing		= pref.r_gradwing
	character.g_gradwing		= pref.g_gradwing
	character.b_gradwing		= pref.b_gradwing
	return TRUE

/datum/category_item/player_setup_item/vore/ears/content(datum/preferences/prefs, mob/user, data)
	. += "<h2>Appearance and Custom Species Settings</h2>"

	var/datum/sprite_accessory/rendering

	var/ear_display = "Normal"
	if(pref.ear_style_id)
		rendering = GLOB.sprite_accessory_ears[pref.ear_style_id]
		if(rendering)
			ear_display = rendering.name
		else
			ear_display = "REQUIRES UPDATE"
	. += "<b>Ears</b><br>"
	. += " Style: <a href='?src=\ref[src];ear_style=1'>[ear_display]</a><br>"
	if(rendering)
		if(rendering.do_colouration)
			. += "<a href='?src=\ref[src];ear_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_ears, 2)][num2hex(pref.g_ears, 2)][num2hex(pref.b_ears, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_ears, 2)][num2hex(pref.g_ears, 2)][num2hex(pref.b_ears, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay)
			. += "<a href='?src=\ref[src];ear_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_ears2, 2)][num2hex(pref.g_ears2, 2)][num2hex(pref.b_ears2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_ears2, 2)][num2hex(pref.g_ears2, 2)][num2hex(pref.b_ears2, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay2)
			. += "<a href='?src=\ref[src];ear_color3=1'>Change Tertiary Color</a> [color_square(pref.r_ears3, pref.g_ears3, pref.b_ears3)]<br>"
	rendering = null

	var/horn_display = "Normal"
	if(pref.horn_style_id)
		rendering = GLOB.sprite_accessory_ears[pref.horn_style_id]
		if(rendering)
			horn_display = rendering.name
		else
			horn_display = "REQUIRES UPDATE"
	. += "<b>Secondary Ears</b><br>"
	. += " Style: <a href='?src=\ref[src];horn_style=1'>[horn_display]</a><br>"
	if(rendering)
		if(rendering.do_colouration)
			. += "<a href='?src=\ref[src];horn_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_horn, 2)][num2hex(pref.g_horn, 2)][num2hex(pref.b_horn, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_horn, 2)][num2hex(pref.g_horn, 2)][num2hex(pref.b_horn, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay)
			. += "<a href='?src=\ref[src];horn_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_horn2, 2)][num2hex(pref.g_horn2, 2)][num2hex(pref.b_horn2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_horn2, 2)][num2hex(pref.g_horn2, 2)][num2hex(pref.b_horn, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay2)
			. += "<a href='?src=\ref[src];horn_color3=1'>Change Tertiary Color</a> [color_square(pref.r_horn3, pref.g_horn3, pref.b_horn3)]<br>"
	rendering = null

	var/tail_display = "Normal"
	if(pref.tail_style_id)
		rendering = GLOB.sprite_accessory_tails[pref.tail_style_id]
		if(rendering)
			tail_display = rendering.name
		else
			tail_display = "REQUIRES UPDATE"
	. += "<b>Tail</b><br>"
	. += " Style: <a href='?src=\ref[src];tail_style=1'>[tail_display]</a><br>"
	if(rendering)
		if(rendering.do_colouration)
			. += "<a href='?src=\ref[src];tail_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail, 2)][num2hex(pref.g_tail, 2)][num2hex(pref.b_tail, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay)
			. += "<a href='?src=\ref[src];tail_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_tail2, 2)][num2hex(pref.g_tail2, 2)][num2hex(pref.b_tail2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_tail2, 2)][num2hex(pref.g_tail2, 2)][num2hex(pref.b_tail2, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay2)
			. += "<a href='?src=\ref[src];tail_color3=1'>Change Tertiary Color</a> [color_square(pref.r_tail3, pref.g_tail3, pref.b_tail3)]<br>"
	rendering = null

	var/wing_display = "Normal"
	if(pref.wing_style_id)
		rendering = GLOB.sprite_accessory_wings[pref.wing_style_id]
		if(rendering)
			wing_display = rendering.name
		else
			wing_display = "REQUIRES UPDATE"
	. += "<b>Wing</b><br>"
	. += " Style: <a href='?src=\ref[src];wing_style=1'>[wing_display]</a><br>"
	if(rendering)
		if(rendering.do_colouration)
			. += "<a href='?src=\ref[src];wing_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_wing, 2)][num2hex(pref.g_wing, 2)][num2hex(pref.b_wing, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_wing, 2)][num2hex(pref.g_wing, 2)][num2hex(pref.b_wing, 2)]'><tr><td>__</td></tr></table> </font><br>"
			. += "<b>Gradient</b><br>"
			. += "<a href='?src=\ref[src];grad_wingcolor=1'>Change Color</a> [color_square(pref.r_gradwing, pref.g_gradwing, pref.b_gradwing)] "
			. += " Style: <a href='?src=\ref[src];grad_wingstyle=1'>[pref.grad_wingstyle]</a><br>"
		if(rendering.extra_overlay)
			. += "<a href='?src=\ref[src];wing_color2=1'>Change Secondary Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_wing2, 2)][num2hex(pref.g_wing2, 2)][num2hex(pref.b_wing2, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_wing2, 2)][num2hex(pref.g_wing2, 2)][num2hex(pref.b_wing2, 2)]'><tr><td>__</td></tr></table> </font><br>"
		if(rendering.extra_overlay2)
			. += "<a href='?src=\ref[src];wing_color3=1'>Change Secondary Color</a> [color_square(pref.r_wing3, pref.g_wing3, pref.b_wing3)]<br>"
	rendering = null


/datum/category_item/player_setup_item/vore/ears/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/S = pref.real_species_datum()
	var/species_name = S.name

	if(!CanUseTopic(user))
		return PREFERENCES_NOACTION

	else if(href_list["ear_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_ear_styles = list("Normal" = null)
		var/datum/sprite_accessory/ears/current = pref.ear_style_id && GLOB.sprite_accessory_ears[pref.ear_style_id]
		for(var/id in GLOB.sprite_accessory_ears)
			var/datum/sprite_accessory/ears/instance = GLOB.sprite_accessory_ears[id]
			if(((!instance.ckeys_allowed) || (usr.ckey in instance.ckeys_allowed)) && ((!instance.apply_restrictions) || (species_name in instance.species_allowed)))
				pretty_ear_styles[instance.name] = id

		// Present choice to user
		var/new_ear_style = tgui_input_list(user, "Pick ears", "Character Preference", pretty_ear_styles, current?.name)
		if(new_ear_style)
			pref.ear_style_id = pretty_ear_styles[new_ear_style]

		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color"])
		var/new_earc = input(user, "Choose your character's ear colour:", "Character Preference",
			rgb(pref.r_ears, pref.g_ears, pref.b_ears)) as color|null
		if(new_earc)
			pref.r_ears = hex2num(copytext(new_earc, 2, 4))
			pref.g_ears = hex2num(copytext(new_earc, 4, 6))
			pref.b_ears = hex2num(copytext(new_earc, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color2"])
		var/new_earc2 = input(user, "Choose your character's secondary ear colour:", "Character Preference",
			rgb(pref.r_ears2, pref.g_ears2, pref.b_ears2)) as color|null
		if(new_earc2)
			pref.r_ears2 = hex2num(copytext(new_earc2, 2, 4))
			pref.g_ears2 = hex2num(copytext(new_earc2, 4, 6))
			pref.b_ears2 = hex2num(copytext(new_earc2, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["ear_color3"])
		var/new_earc3 = input(user, "Choose your character's tertiary ear colour:", "Character Preference",
			rgb(pref.r_ears3, pref.g_ears3, pref.b_ears3)) as color|null
		if(new_earc3)
			pref.r_ears3 = hex2num(copytext(new_earc3, 2, 4))
			pref.g_ears3 = hex2num(copytext(new_earc3, 4, 6))
			pref.b_ears3 = hex2num(copytext(new_earc3, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["horn_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_horn_styles = list("Normal" = null)
		var/datum/sprite_accessory/ears/current = pref.horn_style_id && GLOB.sprite_accessory_ears[pref.horn_style_id]
		for(var/id in GLOB.sprite_accessory_ears)
			var/datum/sprite_accessory/ears/instance = GLOB.sprite_accessory_ears[id]
			if(((!instance.ckeys_allowed) || (usr.ckey in instance.ckeys_allowed)) && ((!instance.apply_restrictions) || (species_name in instance.species_allowed)))
				pretty_horn_styles[instance.name] = id

		// Present choice to user
		var/new_horn_style = tgui_input_list(user, "Pick Secondary Ears", "Character Preference",pretty_horn_styles ,current?.name)
		if(new_horn_style)
			pref.horn_style_id = pretty_horn_styles[new_horn_style]

		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["horn_color"])
		var/new_hornc = input(user, "Choose your character's horn colour:", "Character Preference",
			rgb(pref.r_horn, pref.g_horn, pref.b_horn)) as color|null
		if(new_hornc)
			pref.r_horn = hex2num(copytext(new_hornc, 2, 4))
			pref.g_horn = hex2num(copytext(new_hornc, 4, 6))
			pref.b_horn = hex2num(copytext(new_hornc, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["horn_color2"])
		var/new_hornc2 = input(user, "Choose your character's secondary horn colour:", "Character Preference",
			rgb(pref.r_horn2, pref.g_horn2, pref.b_horn2)) as color|null
		if(new_hornc2)
			pref.r_horn2 = hex2num(copytext(new_hornc2, 2, 4))
			pref.g_horn2 = hex2num(copytext(new_hornc2, 4, 6))
			pref.b_horn2 = hex2num(copytext(new_hornc2, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["horn_color3"])
		var/new_hornc3 = input(user, "Choose your character's tertiary horn colour:", "Character Preference",
			rgb(pref.r_horn3, pref.g_horn3, pref.b_horn3)) as color|null
		if(new_hornc3)
			pref.r_horn3 = hex2num(copytext(new_hornc3, 2, 4))
			pref.g_horn3 = hex2num(copytext(new_hornc3, 4, 6))
			pref.b_horn3 = hex2num(copytext(new_hornc3, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_tail_styles = list("Normal" = null)
		var/datum/sprite_accessory/tail/current = pref.tail_style_id && GLOB.sprite_accessory_tails[pref.tail_style_id]
		for(var/id in GLOB.sprite_accessory_tails)
			var/datum/sprite_accessory/tail/instance = GLOB.sprite_accessory_tails[id]
			if(((!instance.ckeys_allowed) || (usr.ckey in instance.ckeys_allowed)) && ((!instance.apply_restrictions) || (species_name in instance.species_allowed)))
				pretty_tail_styles[instance.name] = id

		// Present choice to user
		var/new_tail_style = tgui_input_list(user, "Pick tails", "Character Preference", pretty_tail_styles, current?.name)
		if(new_tail_style)
			pref.tail_style_id = pretty_tail_styles[new_tail_style]

		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color"])
		var/new_tailc = input(user, "Choose your character's tail/taur colour:", "Character Preference",
			rgb(pref.r_tail, pref.g_tail, pref.b_tail)) as color|null
		if(new_tailc)
			pref.r_tail = hex2num(copytext(new_tailc, 2, 4))
			pref.g_tail = hex2num(copytext(new_tailc, 4, 6))
			pref.b_tail = hex2num(copytext(new_tailc, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color2"])
		var/new_tailc2 = input(user, "Choose your character's secondary tail/taur colour:", "Character Preference",
			rgb(pref.r_tail2, pref.g_tail2, pref.b_tail2)) as color|null
		if(new_tailc2)
			pref.r_tail2 = hex2num(copytext(new_tailc2, 2, 4))
			pref.g_tail2 = hex2num(copytext(new_tailc2, 4, 6))
			pref.b_tail2 = hex2num(copytext(new_tailc2, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_color3"])
		var/new_tailc3 = input(user, "Choose your character's tertiary tail/taur colour:", "Character Preference",
			rgb(pref.r_tail3, pref.g_tail3, pref.b_tail3)) as color|null
		if(new_tailc3)
			pref.r_tail3 = hex2num(copytext(new_tailc3, 2, 4))
			pref.g_tail3 = hex2num(copytext(new_tailc3, 4, 6))
			pref.b_tail3 = hex2num(copytext(new_tailc3, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_style"])
		// Construct the list of names allowed for this user.
		var/list/pretty_wing_styles = list("Normal" = null)
		var/datum/sprite_accessory/wing/current = pref.wing_style_id && GLOB.sprite_accessory_wings[pref.wing_style_id]
		for(var/id in GLOB.sprite_accessory_wings)
			var/datum/sprite_accessory/wing/instance = GLOB.sprite_accessory_wings[id]
			if(((!instance.ckeys_allowed) || (usr.ckey in instance.ckeys_allowed)) && ((!instance.apply_restrictions) || (species_name in instance.species_allowed)))
				pretty_wing_styles[instance.name] = id

		// Present choice to user
		var/new_wing_style = tgui_input_list(user, "Pick wings", "Character Preference", pretty_wing_styles, current?.name)
		if(new_wing_style)
			pref.wing_style_id = pretty_wing_styles[new_wing_style]

		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color"])
		var/new_wingc = input(user, "Choose your character's wing colour:", "Character Preference",
			rgb(pref.r_wing, pref.g_wing, pref.b_wing)) as color|null
		if(new_wingc)
			pref.r_wing = hex2num(copytext(new_wingc, 2, 4))
			pref.g_wing = hex2num(copytext(new_wingc, 4, 6))
			pref.b_wing = hex2num(copytext(new_wingc, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color2"])
		var/new_wingc2 = input(user, "Choose your character's secondary wing colour:", "Character Preference",
			rgb(pref.r_wing2, pref.g_wing2, pref.b_wing2)) as color|null
		if(new_wingc2)
			pref.r_wing2 = hex2num(copytext(new_wingc2, 2, 4))
			pref.g_wing2 = hex2num(copytext(new_wingc2, 4, 6))
			pref.b_wing2 = hex2num(copytext(new_wingc2, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["wing_color3"])
		var/new_wingc3 = input(user, "Choose your character's tertiary wing colour:", "Character Preference",
			rgb(pref.r_wing3, pref.g_wing3, pref.b_wing3)) as color|null
		if(new_wingc3)
			pref.r_wing3 = hex2num(copytext(new_wingc3, 2, 4))
			pref.g_wing3 = hex2num(copytext(new_wingc3, 4, 6))
			pref.b_wing3 = hex2num(copytext(new_wingc3, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_wingcolor"])
		var/new_gradwing = input(user, "Choose your character's wing gradiant color:", "Character Preference", rgb(pref.r_gradwing, pref.g_gradwing, pref.b_gradwing)) as color|null
		if(new_gradwing && CanUseTopic(user))
			pref.r_gradwing = hex2num(copytext(new_gradwing, 2, 4))
			pref.g_gradwing = hex2num(copytext(new_gradwing, 4, 6))
			pref.b_gradwing = hex2num(copytext(new_gradwing, 6, 8))
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_wingstyle"])
		var/list/valid_gradients = GLOB.hair_gradients

		var/new_grad_wingstyle = input(user, "Choose a color pattern for your wings:", "Character Preference", pref.grad_wingstyle)  as null|anything in valid_gradients
		if(new_grad_wingstyle && CanUseTopic(user))
			pref.grad_wingstyle = new_grad_wingstyle
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	return ..()
