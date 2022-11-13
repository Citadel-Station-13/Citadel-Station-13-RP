/datum/job
	//! Intrinsics
	/// ID of the job, used for save/load
	var/id
	/// The name of the job , used for preferences, bans and more. Make sure you know what you're doing before changing this.
	var/title = "NOPE"
	/// Description of the job
	var/desc = "No description provided."
	/// Abstract type
	var/abstract_type = /datum/job
	/// Faction this job is considered part of, for the future considerations of "offmap"/offstation jobs
	var/faction
	/// Determines if this job can be spawned into by players
	var/join_types = JOB_ROUNDSTART | JOB_LATEJOIN

	// Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()		// Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()				// Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/flag = 0 							// Bitflags for the job
	var/department_flag = 0
	var/total_positions = 0					// How many players can be this job
	var/spawn_positions = 0					// How many players can spawn in as this job
	var/current_positions = 0				// How many players have this job
	var/supervisors = null					// Supervisors, who this person answers to directly
	/// Type of ID that the player will have. This is banned. Use outfits, this is only kept in for legacy.
	var/idtype = /obj/item/card/id
	var/selection_color = COLOR_WHITE		// Selection screen color
	var/list/alt_titles = null				// List of alternate titles; There is no need for an alt-title datum for the base job title.
	var/req_admin_notify					// If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0				// If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/list/departments = list()			// List of departments this job belongs to, if any. The first one on the list will be the 'primary' department.
	var/sorting_order = 0					// Used for sorting jobs so boss jobs go above regular ones, and their boss's boss is above that. Higher numbers = higher in sorting.
	var/departments_managed = null			// Is this a management position?  If yes, list of departments managed.  Otherwise null.
	var/department_accounts = null			// Which department accounts should people with this position be given the pin for?
	var/assignable = TRUE					// Should it show up on things like the ID computer?
	var/minimum_character_age = 0
	var/ideal_character_age = 30
	var/has_headset = TRUE					//Do people with this job need to be given headsets and told how to use them?  E.g. Cyborgs don't.

	var/account_allowed = 1					// Does this job type come with a station account?
	var/economic_modifier = 2				// With how much does this job modify the initial account amount?

	var/outfit_type							// What outfit datum does this job use in its default title?

	var/offmap_spawn = FALSE				// Do we require weird and special spawning and datacore handling?
	var/mob_type = JOB_CARBON				// Bitflags representing mob type this job spawns

	// Requires a ckey to be whitelisted in jobwhitelist.txt
	var/whitelist_only = 0

	// Every hour playing this role gains this much time off. (Can be negative for off duty jobs!)
	var/timeoff_factor = 3

	// What type of PTO is that job earning?
	var/pto_type

	// Disallow joining as this job midround from off-duty position via going on-duty
	var/disallow_jobhop = FALSE

/datum/job/New()
	. = ..()
	GLOB.department_accounts = GLOB.department_accounts || departments_managed

/**
 * checks slots remaining
 *
 * @return 0 to number of slots remaining
 */
/datum/job/proc/slots_remaining(latejoin)
	if(!latejoin)
		if(spawn_positions == -1)
			return INFINITY
		return max(spawn_positions, 0)
	if(total_positions == -1)
		return INFINITY
	return max(total_positions - current_positions, 0)

/**
 * checks if we're available for a given client
 *
 * @params
 * - C - client
 * - check_char - check the current loaded character for violations
 *
 * todo: check ckey proc too?
 */
/datum/job/proc/check_client_availability(client/C, check_char, latejoin)
	. = NONE
	if(whitelist_only && !config.check_job_whitelist(ckey(title), C.ckey))
		. |= ROLE_UNAVAILABLE_WHITELIST
	if(!slots_remaining())
		. |= ROLE_UNAVAILABLE_SLOTS_FULL
	if(!player_has_enough_pto(C))
		. |= ROLE_UNAVAILABLE_PTO
	if(jobban_isbanned(C.mob, title))
		. |= ROLE_UNAVAILABLE_BANNED
	if(!player_old_enough(C))
		. |= ROLE_UNAVAILABLE_CONNECT_TIME
	if(check_char)
		var/datum/preferences/P = C.prefs
		if(P.age < minimum_character_age)
			. |= ROLE_UNAVAILABLE_CHAR_AGE
		if(!P.lore_faction_job_check(src))
			. |= ROLE_UNAVAILABLE_CHAR_FACTION
		if(!P.character_species_job_check(src))
			. |= ROLE_UNAVAILABLE_CHAR_SPECIES
	// todo: JEXP/ROLE-EXP hours system

/**
 * checks if we're available for a given client,
 * but short circuits with the most common checks first
 * for efficiency
 *
 * @params
 * - C - client
 * - check_char - check the current loaded character for violations
 *
 * todo: check ckey proc too?
 */
/datum/job/proc/check_client_availability_one(client/C, check_char, latejoin)
	. = NONE
	if(whitelist_only && !config.check_job_whitelist(ckey(title), C.ckey))
		return ROLE_UNAVAILABLE_WHITELIST
	else if(latejoin && !slots_remaining(TRUE))
		return ROLE_UNAVAILABLE_SLOTS_FULL
	else if(!player_has_enough_pto(C))
		return ROLE_UNAVAILABLE_PTO
	else if(jobban_isbanned(C.mob, title))
		return ROLE_UNAVAILABLE_BANNED
	else if(!player_old_enough(C))
		return ROLE_UNAVAILABLE_CONNECT_TIME
	if(check_char)
		var/datum/preferences/P = C.prefs
		if(P.age < minimum_character_age)
			return ROLE_UNAVAILABLE_CHAR_AGE
		if(!P.lore_faction_job_check(src))
			return ROLE_UNAVAILABLE_CHAR_FACTION
		if(!P.character_species_job_check(src))
			return ROLE_UNAVAILABLE_CHAR_SPECIES

	// todo: JEXP/ROLE-EXP hours system

/**
 * get an user-friendly reason of why they can't spawn as us
 */
/datum/job/proc/get_availability_reason(client/C, reason)
	if(reason & ROLE_UNAVAILABLE_BANNED)
		return "BANNED"
	if(reason & ROLE_UNAVAILABLE_SLOTS_FULL)
		return "Slots are currently full; Please refresh the join menu."
	if(reason & ROLE_UNAVAILABLE_PTO)
		return "You do not have enough stored PTO."
	if(reason & ROLE_UNAVAILABLE_ROLE_TIME)
		return "You do not have enough hours in the relevant department(s)."
	if(reason & ROLE_UNAVAILABLE_WHITELIST)
		return "This role is whitelisted."
	if(reason & ROLE_UNAVAILABLE_CONNECT_TIME)
		return "Your account is too new; please wait a few days or contact administration if this is in error."
	if(reason & ROLE_UNAVAILABLE_CHAR_AGE)
		return "Your character is too young; they must be at least [minimum_character_age] years old."
	if(reason & ROLE_UNAVAILABLE_CHAR_FACTION)
		return "Your character is of the wrong faction."
	if(reason & ROLE_UNAVAILABLE_CHAR_SPECIES)
		return "This species is not allowed in this job."
	return "This role is available; seeing this message is a bug. How did you get here?"

/**
 * get a short abbreviation for why they can't spawn as us; used for preferences
 */
/datum/job/proc/get_availability_error(client/C, reason)
	if(reason & ROLE_UNAVAILABLE_BANNED)
		return "BANNED"
	if(reason & ROLE_UNAVAILABLE_SLOTS_FULL)
		return "SLOTS FULL"
	if(reason & ROLE_UNAVAILABLE_PTO)
		return "INSUFFICIENT PTO"
	if(reason & ROLE_UNAVAILABLE_ROLE_TIME)
		return "INSUFFICIENT HOURS"
	if(reason & ROLE_UNAVAILABLE_WHITELIST)
		return "WHITELISTED"
	if(reason & ROLE_UNAVAILABLE_CONNECT_TIME)
		return "IN [available_in_days(C)] DAYS"
	if(reason & ROLE_UNAVAILABLE_CHAR_AGE)
		return "MIN AGE: [minimum_character_age]"
	if(reason & ROLE_UNAVAILABLE_CHAR_FACTION)
		return "FACTION"
	if(reason & ROLE_UNAVAILABLE_CHAR_SPECIES)
		return "SPECIES"
	return "UNKNOWN (BUG)"

/datum/job/proc/equip(var/mob/living/carbon/human/H, var/alt_title)
	var/datum/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title)
	return 1

/datum/job/proc/get_outfit(var/mob/living/carbon/human/H, var/alt_title)
	if(alt_title && alt_titles)
		var/datum/alt_title/A = alt_titles[alt_title]
		if(A && initial(A.title_outfit))
			. = initial(A.title_outfit)
	. = . || outfit_type
	if(ispath(., /datum/outfit))
		return new .

	// TODO: job refactor

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	var/income = 1
	if(H.client)
		switch(H.client.prefs.economic_status)
			if(CLASS_UPPER)		income = 1.30
			if(CLASS_UPMID)		income = 1.15
			if(CLASS_MIDDLE)	income = 1
			if(CLASS_LOWMID)	income = 0.75
			if(CLASS_LOWER)		income = 0.50

	// Give them an account in the station database
	var/money_amount = (rand(15,40) + rand(15,40)) * income * economic_modifier * ECO_MODIFIER // Smoothed peaks, ECO_MODIFIER rather than per-species ones.
	var/datum/money_account/M = create_account(H.real_name, money_amount, null, offmap_spawn)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>")

// Overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title)
	var/datum/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip_base(H, title, alt_title)

/datum/job/proc/get_access()
	if(!config || config_legacy.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

// If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0)	// Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && config_legacy.use_age_restriction_for_jobs && isnum(C.player_age) && isnum(minimal_player_age))
		return max(0, minimal_player_age - C.player_age)
	return 0

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/datum/job/proc/get_description_blurb(var/alt_title)
	var/list/message = list()
	message |= desc

	if(alt_title && alt_titles)
		var/typepath = alt_titles[alt_title]
		if(typepath)
			var/datum/alt_title/A = new typepath()
			if(A.title_blurb)
				message |= A.title_blurb
	return message

/datum/job/proc/get_job_icon()
	if(!SSjob.job_icons[title])
		var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin("#job_icon")
		dress_mannequin(mannequin)
		mannequin.dir = SOUTH
		COMPILE_OVERLAYS(mannequin)
		var/icon/preview_icon = get_flat_icon(mannequin)

		preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2)	// Scaling here to prevent blurring in the browser.
		SSjob.job_icons[title] = preview_icon

	return SSjob.job_icons[title]

/datum/job/proc/dress_mannequin(mob/living/carbon/human/dummy/mannequin/mannequin)
	mannequin.delete_inventory(TRUE)
	equip_preview(mannequin)
	if(mannequin.back)
		qdel(mannequin.back)

/// Check client-specific availability rules.
/datum/job/proc/player_has_enough_pto(client/C)
	return timeoff_factor >= 0 || (C && LAZYACCESS(C.department_hours, pto_type) > 0)

/datum/job/proc/equip_backpack(mob/living/carbon/human/H)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel/norm(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(H), SLOT_ID_BACK)
		if(5)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/messenger(H), SLOT_ID_BACK)
		if(6)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/rig(H), SLOT_ID_BACK)
		if(7)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/dufflebag(H), SLOT_ID_BACK)
