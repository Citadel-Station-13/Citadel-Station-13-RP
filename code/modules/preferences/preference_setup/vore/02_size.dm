// Body weight limits on a character.
#define WEIGHT_MIN 70
#define WEIGHT_MAX 500
#define WEIGHT_CHANGE_MIN 0
#define WEIGHT_CHANGE_MAX 100

// Define a place to save in character setup
/datum/preferences
	var/size_multiplier = RESIZE_NORMAL
	// Body weight stuff.
	var/weight_vr = 137		// bodyweight of character (pounds, because I'm not doing the math again -Spades)
	var/fuzzy = 0			// Preference toggle for sharp/fuzzy icon. Default sharp.

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/size
	name = "Size"
	sort_order = 2

/datum/category_item/player_setup_item/vore/size/load_character(var/savefile/S)
	S["size_multiplier"]	>> pref.size_multiplier
	S["weight_vr"]			>> pref.weight_vr
	S["fuzzy"]				>> pref.fuzzy

/datum/category_item/player_setup_item/vore/size/save_character(var/savefile/S)
	S["size_multiplier"]	<< pref.size_multiplier
	S["weight_vr"]			<< pref.weight_vr
	S["fuzzy"]				<< pref.fuzzy

/datum/category_item/player_setup_item/vore/size/sanitize_character()
	pref.weight_vr			= isnum(pref.weight_vr) ? round(clamp(pref.weight_vr, WEIGHT_MIN, WEIGHT_MAX)) : initial(pref.weight_vr)
	pref.fuzzy				= sanitize_integer(pref.fuzzy, 0, 1, initial(pref.fuzzy))
	if(pref.size_multiplier == null || pref.size_multiplier < RESIZE_TINY || pref.size_multiplier > RESIZE_HUGE)
		pref.size_multiplier = initial(pref.size_multiplier)

/datum/category_item/player_setup_item/vore/size/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	character.weight			= pref.weight_vr
	character.fuzzy				= pref.fuzzy
	character.resize(pref.size_multiplier, animate = FALSE)
	return TRUE

/datum/category_item/player_setup_item/vore/size/content(datum/preferences/prefs, mob/user, data)
	. += "<br>"
	. += "<b>Scale:</b> <a href='?src=\ref[src];size_multiplier=1'>[round(pref.size_multiplier*100)]%</a><br>"
	. += "<b>Scaled Appearance:</b> <a [pref.fuzzy ? "" : ""] href='?src=\ref[src];toggle_fuzzy=1'><b>[pref.fuzzy ? "Fuzzy" : "Sharp"]</b></a><br>"
	. += "<br>"
	. += "<b>Relative Weight:</b>  <a href='?src=\ref[src];weight=1'>[pref.weight_vr]</a><br>"

/datum/category_item/player_setup_item/vore/size/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["size_multiplier"])
		var/new_size = input(user, "Choose your character's size, ranging from 25% to 200%", "Set Size") as num|null
		if (!ISINRANGE(new_size,25,200))
			pref.size_multiplier = 1
			to_chat(user, "<span class='notice'>Invalid size.</span>")
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
		else if(new_size)
			pref.size_multiplier = (new_size/100)
			return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_fuzzy"])
		pref.fuzzy = pref.fuzzy ? 0 : 1;
		return PREFERENCES_REFRESH_UPDATE_PREVIEW

	else if(href_list["weight"])
		var/new_weight = input(user, "Choose your character's relative body weight.\n\
			This measurement should be set relative to a normal 5'10'' person's body and not the actual size of your character.\n\
			If you set your weight to 500 because you're a naga or have metal implants then complain that you're a blob I\n\
			swear to god I will find you and I will punch you for not reading these directions!\n\
			([WEIGHT_MIN]-[WEIGHT_MAX])", "Character Preference") as num|null
		if(new_weight)
			var/unit_of_measurement = alert(user, "Is that number in pounds (lb) or kilograms (kg)?", "Confirmation", "Pounds", "Kilograms")
			if(unit_of_measurement == "Pounds")
				new_weight = round(text2num(new_weight),4)
			if(unit_of_measurement == "Kilograms")
				new_weight = round(2.20462*text2num(new_weight),4)
			pref.weight_vr = sanitize_integer(new_weight, WEIGHT_MIN, WEIGHT_MAX, pref.weight_vr)
			return PREFERENCES_REFRESH

	return ..();
