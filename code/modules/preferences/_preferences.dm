#define SAVE_RESET -1

GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	//! Intrinsics
	/// did we load yet?
	var/initialized = FALSE

	//! Error Handling
	/// queued error messages to display
	var/list/io_error_queue

//! ## Doohickeys For Savefiles
	var/path
	/// Holder so it doesn't default to slot 1, rather the last one used.
	var/default_slot = 1
	var/savefile_version = 0

// todo: kick this out of prefs
//! ## Non-Preference Stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

//! ## Cooldowns for saving/loading.
//? ## These are four are all separate due to loading code calling these one after another.
	var/saveprefcooldown
	var/loadprefcooldown
	var/savecharcooldown
	var/loadcharcooldown

	//? Someday everything'll be in these lists.
	//? These lists may only ever contain associative key-values, where
	//? values MUST be string, number, or null.
	//? Savefiles do not play nice with typepaths.
	//! Loaded data
	/// character data
	var/list/character
	/// global data
	var/list/options
	/// data for byond skin - checkboxes and whatnot; this is ENTIRELY synchronized by the skin system.
	var/list/skin

//! ## Game Preferences
	var/tgui_fancy = TRUE
	var/tgui_lock = TRUE
	/// Saved changlog filesize to detect if there was a change.
	var/lastchangelog = ""
	/// Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color.
	var/ooccolor = "#010000"
	/// Special role selection.
	var/be_special = 0
	/// Event role prefs flag.
	var/be_event_role = NONE
	var/UI_style = UI_STYLE_DEFAULT
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	/// Style for popup tooltips.
	var/tooltipstyle = "Midnight"
	var/client_fps = 0

//! ## Character Preferences
	/// Our character's name
	var/real_name
	/// Whether we are a random name every round
	var/be_random_name = 0
	/// Our character's nickname
	var/nickname
	/// Age of character
	var/age = 30
	/// Where this character will spawn. (0-2)
	var/spawnpoint = "Arrivals Shuttle"
	/// Blood type. (not-chooseable)
	var/b_type = "A+"
	/// Backpack type.
	var/backbag = 2
	/// PDA type.
	var/pdachoice = 1
	/// Hair type.
	var/h_style_id
	/// Hair color.
	var/r_hair = 0
	/// Hair color.
	var/g_hair = 0
	/// Hair color.
	var/b_hair = 0
	/// Gradient style.
	var/grad_style = "None"
	/// Gradient color.
	var/r_grad = 0
	/// Gradient color.
	var/g_grad = 0
	/// Gradient color.
	var/b_grad = 0
	/// Gradient style.
	var/grad_wingstyle = "None"
	/// Face hair type.
	var/f_style_id
	/// Face hair color.
	var/r_facial = 0
	/// Face hair color.
	var/g_facial = 0
	/// Face hair color.
	var/b_facial = 0
	/// Skin tone.
	var/s_tone = 0
	/// Skin color.
	var/r_skin = 238
	/// Skin color.
	var/g_skin = 206
	/// Skin color.
	var/b_skin = 179
	/// For Adherent.
	var/s_base = ""
	/// Eye color.
	var/r_eyes = 0
	/// Eye color.
	var/g_eyes = 0
	/// Eye color.
	var/b_eyes = 0
	/// Left in for Legacy reasons, will no longer save.
	var/list/gear
	/// Custom/fluff item loadouts.
	var/list/gear_list = list()
	/// The current gear save slot.
	var/gear_slot = 1
	/// Traits which modifier characters for better or worse (mostly worse).
	var/list/traits
	/// Lets normally uncolorable synth parts be colorable.
	var/synth_color	= 0
	/// Used with synth_color to color synth parts that normaly can't be colored.
	var/r_synth
	/// Used with synth_color to color synth parts that normaly can't be colored.
	var/g_synth
	/// Used with synth_color to color synth parts that normaly can't be colored.
	var/b_synth
	/// Enable/disable markings on synth parts.
	var/synth_markings = 1

//! ## Background Preferences
	///Antag associated faction.
	var/antag_faction = "None"
	///How visible antag association is to others.
	var/antag_vis = "Hidden"

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/disabilities = 0
	var/mirror = TRUE

	var/economic_status = CLASS_MIDDLE

	var/uplinklocation = "PDA"

//! ## Mob Preview
	/// Should only be a key-value list of north/south/east/west = atom/movable/screen.
	var/list/char_render_holders
	var/static/list/preview_screen_locs = list(
		"1" = "character_preview_map:2,7",
		"2" = "character_preview_map:2,5",
		"4"  = "character_preview_map:2,3",
		"8"  = "character_preview_map:2,1",
		"BG" = "character_preview_map:1,1 to 3,8"
	)

//! ## Skills Preferences - Depricated.
	var/used_skillpoints = 0
	var/skill_specialization = null
	/// Skills can range from 0 to 3.
	var/list/skills = list()

//! ## Body Preferences
	/// Maps each organ to either null(intact), "cyborg" or "amputated"
	/// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	/// Set to 1 when altering limb states. fix for prosthetic > normal changes not working on preview.
	var/regen_limbs = 0

	var/list/body_marking_ids = list() //? "id" = "#rgbcolor"

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()

	var/list/body_descriptors = list()

//! ## OOC Metadata
	var/metadata = ""
	var/list/ignored_players = list()

	var/client/client = null
	var/client_ckey = null

	/// Communicator identity data.
	var/communicator_visibility = 0

	/// Default ringtone for character; if blank, use job default.
	var/ringtone = null

	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

	/// Hash of last seen lobby news content.
	var/lastnews

//! ## Character Directory Stuff
	/// Should we show in Character Directory.
	var/show_in_directory = 1
	/// Sorting tag to use for vore-prefs.
	var/directory_tag = "Unset"
	/// Sorting tag to use for erp-prefs.
	var/directory_erptag = "Unset"
	/// Advertisement stuff to show in character directory.
	var/directory_ad = ""

	/// Set character's suit sensor level.
	var/sensorpref = 5

	/// Should we automatically fit the viewport?
	var/auto_fit_viewport = TRUE

	/// Should we be in the widescreen mode set by the config?
	var/widescreenpref = TRUE	// Exists now...

/datum/preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
	if(SScharacters.initialized)
		Initialize()

/datum/preferences/proc/Initialize()
	// todo: refactor
	player_setup = new(src)
	tim_sort(preference_by_key, /proc/cmp_preference_load_order, TRUE)
	tim_sort(preference_by_type, /proc/cmp_preference_load_order, TRUE)
	// set defaults before load
	reset_everything_to_default()

	set_biological_gender(pick(MALE, FEMALE))
	real_name = random_name(identifying_gender, real_species_name())
	b_type = RANDOM_BLOOD_TYPE

	gear = list()
	gear_list = list()
	gear_slot = 1

	if(client)
		if(!IsGuestKey(client.key))
			if(load_path(client.ckey))
				if(load_preferences())
					if(load_character())
						load_skin()
						sanitize_everything()
						player_setup.sanitize_setup()
						client.update_movement_keys()
						initialized = TRUE
						return

	key_bindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds and update their movement keys
	client?.update_movement_keys(src)
	LAZYINITLIST(character)
	LAZYINITLIST(options)
	LAZYINITLIST(skin)
	initialized = TRUE

/datum/preferences/proc/block_until_initialized()
	UNTIL(initialized)

/datum/preferences/Destroy()
	. = ..()
	QDEL_LIST_ASSOC_VAL(char_render_holders)

/datum/preferences/proc/ZeroSkills(var/forced = 0)
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		if(!skills.Find(S.ID) || forced)
			skills[S.ID] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		var/multiplier = 1
		switch(skills[S.ID])
			if(SKILL_NONE)
				used_skillpoints += 0 * multiplier
			if(SKILL_BASIC)
				used_skillpoints += 1 * multiplier
			if(SKILL_ADEPT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 1 * multiplier
				else
					used_skillpoints += 3 * multiplier
			if(SKILL_EXPERT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 3 * multiplier
				else
					used_skillpoints += 6 * multiplier

/datum/preferences/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/preferences/proc/update_character_previews(mutable_appearance/MA)
	if(!client)
		return

	var/atom/movable/screen/setup_preview/bg/BG= LAZYACCESS(char_render_holders, "BG")
	if(!BG)
		BG = new
		BG.plane = TURF_PLANE
		BG.icon = 'icons/effects/setup_backgrounds_vr.dmi'
		BG.pref = src
		LAZYSET(char_render_holders, "BG", BG)
		client.screen |= BG
	BG.icon_state = bgstate
	BG.screen_loc = preview_screen_locs["BG"]

	for(var/D in GLOB.cardinal)
		var/atom/movable/screen/setup_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			O.pref = src
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		O.appearance = MA
		O.dir = D
		O.screen_loc = preview_screen_locs["[D]"]

/datum/preferences/proc/show_character_previews()
	if(!client || !char_render_holders)
		return
	for(var/render_holder in char_render_holders)
		client.screen |= char_render_holders[render_holder]

/datum/preferences/proc/clear_character_previews()
	for(var/index in char_render_holders)
		var/atom/movable/screen/S = char_render_holders[index]
		client?.screen -= S
		qdel(S)
	char_render_holders = null

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config_legacy.forumurl)
			user << link(config_legacy.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		attempt_vr(client.prefs_vr,"load_vore","")
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		attempt_vr(client.prefs_vr,"load_vore","")
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if("No" == alert("This will reset the current slot. Continue?", "Reset current slot?", "No", "Yes"))
			return 0
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["copy"])
		if(!IsGuestKey(usr.key))
			open_copy_dialog(usr)
			return 1
	else if(href_list["overwrite"])
		overwrite_character(text2num(href_list["overwrite"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["close"])
		// User closed preferences window, cleanup anything we need to.
		clear_character_previews()
		return 1
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config_legacy.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	//user << browse(dat, "window=saves;size=300x390")
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(dat)
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	//user << browse(null, "window=saves")
	panel.close()

/datum/preferences/proc/open_copy_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to overwrite</b><br>"
		dat += "<b>You will then need to save to confirm</b><hr>"
		var/name
		for(var/i=1, i<= config_legacy.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];overwrite=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(dat)
	panel.open()

//Vore noises.
/client/verb/toggle_eating_noises()
	set name = "Eating Noises"
	set category = "Vore"
	set desc = "Toggles Vore Eating noises."

	var/pref_path = /datum/client_preference/eating_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear eating related vore noises.")

	SScharacters.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TEatNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/verb/toggle_digestion_noises()
	set name = "Digestion Noises"
	set category = "Vore"
	set desc = "Toggles Vore Digestion noises."

	var/pref_path = /datum/client_preference/digestion_noises

	toggle_preference(pref_path)

	to_chat(src, "You will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] hear digestion related vore noises.")

	SScharacters.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TDigestNoise") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
