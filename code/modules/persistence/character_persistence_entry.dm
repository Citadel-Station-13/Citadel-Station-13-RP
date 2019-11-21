//Character persistence works on 1. ckey and 2. slot
//This datum is meant to represent "cached" operations.
#define DEFAULT_VALUE "some_persistence_bullshit"
/proc/get_character_persistence_entry(ckey, slot)
	return locate("CHARPERSISTENTRY_[ckey(ckey)]_[slot]") || new /datum/character_persistence_entry(ckey, slot)

/datum/character_persistence_entry
	var/ckey
	var/slot
	var/original_real_name

	//Vars below are written to disk if they are NOT DEFAULT VARIABLE.
	var/nif_path = DEFAULT_VALUE
	var/nif_durability = DEFAULT_VALUE
	var/nif_savedata = DEFAULT_VALUE

/datum/character_persistence_entry/New(ckey, slot)
	SSpersistence.character_persistence_entries += src
	tag = "CHARPERSISTENTRY_[ckey(ckey)]_[slot]"
	src.ckey = ckey(ckey)
	src.slot = slot
	Initialize()

/datum/character_persistence_entry/Initialize()
	var/datum/preferences/prefs = preferences_datums[ckey]
	if(!prefs)
		CRASH("WARNING: Invalid prefs in char persistence Init!")
	var/current_slot = prefs.default_slot
	prefs.load_character(slot, TRUE)
	original_real_name = prefs.real_name
	prefs.load_character(current_slot, TRUE)

/datum/character_persistence_entry/Destroy()
	SSpersistence.character_persistence_entries -= src
	return ..()

//Assumes everything is right.
/datum/character_persistence_entry/proc/write_to_disk()
	if(!ckey || !slot)
		CRASH("Invalid ckey or slot.")
	var/datum/preferences/prefs = preferences_datums[ckey]
	if(!prefs)
		CRASH("No prefs datum found.")
	prefs.load_character(slot, TRUE)
	do_write(prefs)
	prefs.save_character(TRUE)

//Does the actual modification of the slot.
/datum/character_persistence_entry/proc/do_write(datum/preferences/prefs)
	//NIFs
	if(nif_path != DEFAULT_VALUE)
		prefs.nif_path = nif_path
	if(nif_durability != DEFAULT_VALUE)
		prefs.nif_durability = nif_durability
	if(nif_savedata != DEFAULT_VALUE)
		prefs.nif_savedata = nif_saveadta
