var/list/admin_datums = list()

GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

// todo: /datum/admin_holder
/datum/admins
	var/rank			= "Temporary Admin"
	var/client/owner	= null
	var/rights = 0
	// todo: rework
	/// If set, we are under stealth-mode with this as our public ckey.
	var/fakekey = null

	var/datum/marked_datum

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

	var/href_token

	var/datum/filter_editor/filteriffic

	/// lazy list of active admin modals
	///
	/// todo: re-open these on reconnect.
	var/list/datum/admin_modal/admin_modals

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey)
	if(!ckey)
		log_world("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	rank = initial_rank
	rights = initial_rights
	admin_datums[ckey] = src
	if(rights & R_DEBUG) //grant profile access
		world.SetConfig("APP/admin", ckey, "role=admin")

	spawn(-1)
		UNTIL(SSmapping.loaded_station)
		admincaster_signature = "[(LEGACY_MAP_DATUM).company_name] Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"

/datum/admins/Destroy()
	QDEL_LIST(admin_modals)
	return ..()

// todo: assertions on this are too weak
/datum/admins/proc/associate(client/C)
	if(owner == C)
		return
	if(owner)
		disassociate()
	if(!istype(C))
		return
	owner = C
	owner.holder = src
	GLOB.admins |= C
	// add verbs
	add_admin_verbs()

// todo: assertions on this are too weak
/datum/admins/proc/disassociate()
	if(!owner)
		return
	GLOB.admins -= owner
	owner.deadmin_holder = owner.holder
	owner.holder = null
	// for now, destroy all modals
	QDEL_LIST(admin_modals)
	// obliterate verbs
	remove_admin_verbs()

/datum/admins/proc/reassociate()
	associate(owner)

/datum/admins/proc/add_admin_verbs()
	if(!owner)
		return
	var/list/verbs_to_add = list()
	for(var/datum/admin_verb_descriptor/descriptor in global.admin_verb_descriptors)
		if((rights & descriptor.required_rights) != descriptor.required_rights)
			continue
		verbs_to_add += descriptor.verb_path
	verbs_to_add += admin_verbs_default
	if(holder.rights & R_BUILDMODE)
		verbs_to_add += /client/proc/togglebuildmodeself
	if(holder.rights & R_ADMIN)
		verbs_to_add += admin_verbs_admin
	if(holder.rights & R_BAN)
		verbs_to_add += admin_verbs_ban
	if(holder.rights & R_FUN)
		verbs_to_add += admin_verbs_fun
	if(holder.rights & R_SERVER)
		verbs_to_add += admin_verbs_server
	if(holder.rights & R_DEBUG)
		verbs_to_add += admin_verbs_debug
	if(holder.rights & R_POSSESS)
		verbs_to_add += admin_verbs_possess
	if(holder.rights & R_PERMISSIONS)
		verbs_to_add += admin_verbs_permissions
	if(holder.rights & R_STEALTH)
		verbs_to_add += /client/proc/stealth
	if(holder.rights & R_REJUVINATE)
		verbs_to_add += admin_verbs_rejuv
	if(holder.rights & R_SOUNDS)
		verbs_to_add += admin_verbs_sound
	if(holder.rights & R_SPAWN)
		verbs_to_add += admin_verbs_spawn
	if(holder.rights & R_MOD)
		verbs_to_add += admin_verbs_mod
	if(holder.rights & R_EVENT)
		verbs_to_add += admin_verbs_event_manager
	add_verb(
		owner,
		verbs_to_add,
	)

/datum/admins/proc/remove_admin_verbs()
	if(!owner)
		return
	var/list/verbs_to_remove = list()
	for(var/datum/admin_verb_descriptor/descriptor in global.admin_verb_descriptors)
		verbs_to_remove += descriptor.verb_path
	remove_verb(
		owner,
		list(
			admin_verbs_default,
			/client/proc/togglebuildmodeself,
			admin_verbs_admin,
			admin_verbs_ban,
			admin_verbs_fun,
			admin_verbs_server,
			admin_verbs_debug,
			admin_verbs_possess,
			admin_verbs_permissions,
			/client/proc/stealth,
			admin_verbs_rejuv,
			admin_verbs_sounds,
			admin_verbs_spawn,
			debug_verbs,
		),
	)

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

proc/admin_proc()
	if(!check_rights(R_ADMIN)) return
	to_chat(world, "you have enough rights!")

NOTE: It checks usr by default. Supply the "user" argument if you wish to check for a specific mob.
*/
/proc/check_rights(rights_required, show_msg = TRUE, var/client/C = usr)
	if(ismob(C))
		var/mob/M = C
		C = M.client
	if(!C)
		return FALSE
	if(!(istype(C, /client))) // If we still didn't find a client, something is wrong.
		return FALSE
	if(!C.holder)
		if(show_msg)
			to_chat(C, "<span class='warning'>Error: You are not an admin.</span>")
		return FALSE

	if(rights_required)
		if(rights_required & C.holder.rights)
			return TRUE
		else
			if(show_msg)
				to_chat(C, "<span class='warning'>Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")].</span>")
			return FALSE
	else
		return TRUE

/datum/admins/proc/check_for_rights(rights_required)
	if(rights_required && !(rights_required & rights))
		return FALSE
	return TRUE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return 1
			if(usr.client.holder.rights != other.holder.rights)
				if( (usr.client.holder.rights & other.holder.rights) == other.holder.rights )
					return 1	//we have all the rights they have and more
		to_chat(usr, "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>")
	return 0

//This proc checks whether subject has at least ONE of the rights specified in rights_required.
/proc/check_rights_for(client/subject, rights_required)
	if(subject?.holder)
		return subject.holder.check_for_rights(rights_required)
	return FALSE

/client/proc/deadmin()
	if(holder)
		holder.disassociate()
		//qdel(holder)
	return 1

/proc/GenerateToken()
	. = ""
	for(var/I in 1 to 32)
		. += "[rand(10)]"

/proc/RawHrefToken(forceGlobal = FALSE)
	var/tok = GLOB.href_token
	if(!forceGlobal && usr)
		var/client/C = usr.client
		if(!C)
			CRASH("No client for HrefToken()!")
		var/datum/admins/holder = C.holder
		if(holder)
			tok = holder.href_token
	return tok

/proc/HrefToken(forceGlobal = FALSE)
	return "admin_token=[RawHrefToken(forceGlobal)]"

/proc/HrefTokenFormField(forceGlobal = FALSE)
	return "<input type='hidden' name='admin_token' value='[RawHrefToken(forceGlobal)]'>"

/datum/admins/proc/CheckAdminHref(href, href_list)
	return TRUE
	/*			Disabled
	var/auth = href_list["admin_token"]
	. = auth && (auth == href_token || auth == GLOB.href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] clicked an href with [msg] authorization key!")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("Debug mode enabled, call not blocked. Please ask your coders to review this round's logs.")
		log_world("UAH: [href]")
		return TRUE
	log_admin_private("[key_name(usr)] clicked an href with [msg] authorization key! [href]")
	*/

/datum/admins/vv_edit_var(var_name, var_value)
#ifdef TESTING
	return ..()
#else
	if(var_name == NAMEOF(src, rank) || var_name == NAMEOF(src, rights))
		return FALSE
	return ..()
#endif

//* Admin Modals *//

/datum/admins/proc/open_admin_modal(path)
	ASSERT(ispath(path, /datum/admin_modal))
	var/datum/admin_modal/modal = new path(src)
	if(!modal.Initialize())
		qdel(modal)
		return null
	modal.open()
	return modal
