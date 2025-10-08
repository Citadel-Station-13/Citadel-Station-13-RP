//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admins
	/// lazy list of active admin modals
	///
	/// todo: re-open these on reconnect.
	var/list/datum/admin_modal/admin_modals

	/// owning ckey
	var/ckey

/datum/admins/Destroy()
	QDEL_LIST(admin_modals)
	return ..()

/datum/admins/New(initial_rank, initial_rights, ckey)
	src.ckey = ckey
	..()

/datum/admins/proc/add_admin_verbs()
	if(!owner)
		return
	var/list/verbs_to_add = list()
	for(var/datum/admin_verb_descriptor/descriptor in global.admin_verb_descriptors)
		if((rights & descriptor.required_rights) != descriptor.required_rights)
			continue
		verbs_to_add += descriptor.verb_path
	add_verb(
		owner,
		verbs_to_add,
	)
	world.SetConfig("APP/admin", ckey, "role=admin")

/datum/admins/proc/remove_admin_verbs()
	var/list/verbs_to_remove = list()
	for(var/datum/admin_verb_descriptor/descriptor in global.admin_verb_descriptors)
		verbs_to_remove += descriptor.verb_path
	remove_verb(
		owner,
		verbs_to_remove,
	)
	world.SetConfig("APP/admin", ckey, "null")

//* Admin Modals *//

/datum/admins/proc/open_admin_modal(path, ...)
	ASSERT(ispath(path, /datum/admin_modal))
	var/datum/admin_modal/modal = new path(src)
	if(!modal.Initialize(arglist(args.Copy(2))))
		qdel(modal)
		message_admins("Failed to initialize an admin modal. Check runtimes for more details.")
		stack_trace("failed to initialize an admin modal; this means someone passed in bad args.")
		return null
	modal.open()
	return modal

//*                      -- SECURITY --                           *//
//* Do not touch this section unless you know what you are doing. *//

/datum/admins/vv_edit_var(var_name, var_value)
#ifdef TESTING
	return ..()
#else
	if(var_name == NAMEOF(src, rank) || var_name == NAMEOF(src, rights))
		return FALSE
	return ..()
#endif

/datum/admins/CanProcCall(procname)
	switch(procname)
		if(NAMEOF_PROC(src, open_admin_modal))
			return FALSE
	if(findtext(procname, "verb__") == 1)
		return FALSE
	return ..()
