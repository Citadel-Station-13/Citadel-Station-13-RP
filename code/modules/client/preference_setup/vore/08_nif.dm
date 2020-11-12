//Pretty small file, mostly just for storage.
/datum/preferences
	var/nif_id
	var/nif_durability
	var/list/nif_savedata

// Definition of the stuff for NIFs
/datum/category_item/player_setup_item/vore/nif
	name = "NIF Data"
	sort_order = 8

/datum/category_item/player_setup_item/vore/nif/load_character(var/savefile/S)
	var/path
	S["nif_path"]		>> path
	S["nif_id"]			>> pref.nif_id
	if(ispath(path, /obj/item/device/nif))		//migration until we get proper savefile migrations ugh never ever use typepaths ever again...
		// overwrite
		var/obj/item/device/nif/N = path
		pref.nif_id = initial(N.id)
		S["nif_path"]	<< null		//erase
		S["nif_id"]		<< pref.nif_id
	else if(ispath(path, /obj/item/nif))		//migration until we get proper savefile migrations ugh never ever use typepaths ever again...
		// overwrite
		var/obj/item/nif/N = path
		pref.nif_id = initial(N.id)
		S["nif_path"]	<< null		//erase
		S["nif_id"]		<< pref.nif_id	
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

/datum/category_item/player_setup_item/vore/nif/copy_to_mob(var/mob/living/carbon/human/character)
	//If you had a NIF...
	if((character.type == /mob/living/carbon/human) && pref.nif_id && pref.nif_durability)
		var/nif_path = GLOB.nif_id_lookup[pref.nif_id]
		new nif_path(character,pref.nif_durability,pref.nif_savedata, pref.real_name)

		//And now here's the trick. We wipe these so that if they die, they lose the NIF.
		//Backup implants will start saving this again periodically, and so will cryo'ing out.
		pref.nif_id = null
		pref.nif_durability = null
		pref.nif_savedata = null
		var/savefile/S = new /savefile(pref.path)
		if(!S)
			WARNING ("Couldn't load NIF save savefile? [pref.real_name]")
		S.cd = "/character[pref.default_slot]"
		save_character(S)

/datum/category_item/player_setup_item/vore/nif/content(var/mob/user)
	. += "<b>NIF:</b> [pref.nif_id ? "Present" : "None"]"

/obj/item/device/nif
	var/id = NIF_ID_BASIC

/obj/item/device/nif/authentic
	id = NIF_ID_VEYMED

/obj/item/device/nif/bioadap
	id = NIF_ID_BIOADAPTIVE

/obj/item/device/nif/bad
	id = NIF_ID_BOOTLEG
