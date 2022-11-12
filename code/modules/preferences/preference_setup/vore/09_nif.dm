//Pretty small file, mostly just for storage.
/datum/preferences
	var/nif_id
	var/nif_durability
	var/list/nif_savedata

// Definition of the stuff for NIFs
/datum/category_item/player_setup_item/vore/nif
	name = "NIF Data"
	sort_order = 9

/datum/category_item/player_setup_item/vore/nif/load_character(var/savefile/S)
	var/path
	S["nif_path"]		>> path
	S["nif_id"]			>> pref.nif_id
	S["nif_durability"]	>> pref.nif_durability
	S["nif_savedata"]	>> pref.nif_savedata

/datum/category_item/player_setup_item/vore/nif/save_character(var/savefile/S)
	S["nif_id"]			<< pref.nif_id
	S["nif_durability"]	<< pref.nif_durability
	S["nif_savedata"]	<< pref.nif_savedata

/datum/category_item/player_setup_item/vore/nif/sanitize_character()
	if(pref.nif_id)
		var/obj/item/nif/N = GLOB.nif_id_lookup[pref.nif_id]
		if(isnull(N))
			pref.nif_id = null
			WARNING("Loaded a NIF but it was an invalid id, [pref.real_name] = [pref.nif_id]")
		else if(isnull(pref.nif_durability))		//How'd you lose this?
			pref.nif_durability = initial(N.durability)		//Well, have a new one, my bad.
			WARNING("Loaded a NIF but with no durability, [pref.real_name]")

	if(!islist(pref.nif_savedata))
		pref.nif_savedata = list()

/datum/category_item/player_setup_item/vore/nif/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: this is just a shim
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/character = M
	//If you had a NIF...
	if((character.type == /mob/living/carbon/human) && pref.nif_id && pref.nif_durability)
		var/nif_path = GLOB.nif_id_lookup[pref.nif_id]
		new nif_path(character,pref.nif_durability,pref.nif_savedata)
	return TRUE

/datum/category_item/player_setup_item/vore/nif/content(datum/preferences/prefs, mob/user, data)
	. += "<b>NIF:</b> [pref.nif_id ? "Present" : "None"]"
