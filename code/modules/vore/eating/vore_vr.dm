///This is a Define so you don't have to worry about magic numbers.
#define VORE_VERSION	2
//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//
/datum/configuration_legacy
	var/items_survive_digestion = TRUE		//For configuring if the important_items survive digestion

//
// The datum type bolted onto normal preferences datums for storing Virgo stuff
//
/client
	var/datum/vore_preferences/prefs_vr

/hook/client_new/proc/add_prefs_vr(client/C)
	C.prefs_vr = new/datum/vore_preferences(C)
	if(C.prefs_vr)
		return TRUE

	return FALSE

/datum/vore_preferences
	//Actual preferences
	var/digestable = FALSE
	var/devourable = FALSE
	var/feeding = FALSE
	var/digest_leave_remains = FALSE
	var/allowmobvore = FALSE
	var/list/belly_prefs = list()
	var/vore_taste = "nothing in particular"
	var/vore_smell = "nothing in particular"
	var/permit_healbelly = FALSE
	var/can_be_drop_prey = FALSE
	var/can_be_drop_pred = FALSE
	var/permit_sizegun = TRUE
	var/permit_size_trample = TRUE
	var/permit_size_pickup = TRUE
	var/permit_stripped = TRUE

	//Mechanically required
	var/path
	var/slot
	var/client/client
	var/client_ckey

/datum/vore_preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		load_vore()

//
//	Check if an object is capable of eating things, based on vore_organs
//
/proc/is_vore_predator(var/mob/living/O)
	if(istype(O,/mob/living))
		if(O.vore_organs.len > 0)
			return TRUE

	return FALSE

//
//	Belly searching for simplifying other procs
//  Mostly redundant now with belly-objects and isbelly(loc)
//
/proc/check_belly(atom/movable/A)
	return isbelly(A.loc)

//
// Save/Load Vore Preferences
//
/datum/vore_preferences/proc/load_path(ckey,slot,filename="character",ext="json")
	if(!ckey || !slot)	return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/vore/[filename][slot].[ext]"


/datum/vore_preferences/proc/load_vore()
	if(!client || !client_ckey)
		return FALSE //No client, how can we save?
	if(!client.prefs || !client.prefs.default_slot)
		return FALSE //Need to know what character to load!

	slot = client.prefs.default_slot

	load_path(client_ckey,slot)

	if(!path) return FALSE //Path couldn't be set?
	if(!fexists(path)) //Never saved before
		save_vore() //Make the file first
		return TRUE

	var/list/json_FROM_FILE = json_decode(file2text(path))
	if(!json_FROM_FILE)
		return FALSE //My concern grows

	var/version = json_FROM_FILE["version"]
	json_FROM_FILE = patch_version(json_FROM_FILE,version)

	digestable = json_FROM_FILE["digestable"]
	devourable = json_FROM_FILE["devourable"]
	feeding = json_FROM_FILE["feeding"]
	digest_leave_remains = json_FROM_FILE["digest_leave_remains"]
	allowmobvore = json_FROM_FILE["allowmobvore"]
	vore_taste = json_FROM_FILE["vore_taste"]
	vore_smell = json_FROM_FILE["vore_smell"]
	permit_healbelly = json_FROM_FILE["permit_healbelly"]
	can_be_drop_prey = json_FROM_FILE["can_be_drop_prey"]
	can_be_drop_pred = json_FROM_FILE["can_be_drop_pred"]
	belly_prefs = json_FROM_FILE["belly_prefs"]
	permit_sizegun = json_FROM_FILE["permit_sizegun"]
	permit_size_trample = json_FROM_FILE["permit_size_trample"]
	permit_size_pickup = json_FROM_FILE["permit_size_pickup"]
	permit_stripped = json_FROM_FILE["permit_stripped"]

	//Quick sanitize
	if(isnull(digestable))
		digestable = TRUE
	if(isnull(devourable))
		devourable = TRUE
	if(isnull(feeding))
		feeding = TRUE
	if(isnull(digest_leave_remains))
		digest_leave_remains = FALSE
	if(isnull(allowmobvore))
		allowmobvore = TRUE
	if(isnull(permit_healbelly))
		permit_healbelly = TRUE
	if(isnull(can_be_drop_prey))
		can_be_drop_prey = FALSE
	if(isnull(can_be_drop_pred))
		can_be_drop_pred = FALSE
	if(isnull(permit_sizegun))
		permit_sizegun = TRUE
	if(isnull(permit_size_trample))
		permit_size_trample = TRUE
	if(isnull(permit_size_pickup))
		permit_size_pickup = TRUE
	if(isnull(permit_stripped))
		permit_stripped = TRUE
	if(isnull(belly_prefs))
		belly_prefs = list()

	return TRUE

/datum/vore_preferences/proc/save_vore()
	if(!path)				return FALSE

	var/version = VORE_VERSION	//For "good times" use in the future
	var/list/settings_list = list(
			"version"				= version,
			"digestable"			= digestable,
			"devourable"			= devourable,
			"feeding"				= feeding,
			"digest_leave_remains"	= digest_leave_remains,
			"allowmobvore"			= allowmobvore,
			"vore_taste"			= vore_taste,
			"vore_smell"			= vore_smell,
			"permit_healbelly"		= permit_healbelly,
			"can_be_drop_prey"		= can_be_drop_prey,
			"can_be_drop_pred"		= can_be_drop_pred,
			"belly_prefs"			= belly_prefs,
			"permit_size_trample"	= permit_size_trample,
			"permit_size_pickup"	= permit_size_pickup,
			"permit_sizegun"		= permit_sizegun,
			"permit_stripped"		= permit_stripped
		)

	//List to JSON
	var/json_TO_FILE = json_encode(settings_list)
	if(!json_TO_FILE)
		log_debug(SPAN_DEBUG("Saving: [path] failed jsonencode"))
		return FALSE

	//Write it out
	// Fall back to using old format if we are not using rust-g
	if(fexists(path))
		fdel(path) //Byond only supports APPENDING to files, not replacing.
	text2file(json_TO_FILE, path)
	if(!fexists(path))
		log_debug(SPAN_DEBUG("Saving: [path] failed file write"))
		return FALSE

	return TRUE

//Can do conversions here
/datum/vore_preferences/proc/patch_version(var/list/json_FROM_FILE,var/version)
	return json_FROM_FILE
