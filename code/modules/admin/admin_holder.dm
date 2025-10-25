//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admins
	/// lazy list of active admin modals
	///
	/// todo: re-open these on reconnect.
	var/list/datum/admin_modal/admin_modals
	/// admin panels by type
	/// * admin panels are stateful, unlike modals, and aren't deleted
	///   when they are closed.
	/// * this means you can brick them so devs don't fuck up!!
	var/list/datum/admin_panel/admin_panels

	/// owning ckey
	var/ckey

/datum/admins/Destroy()
	QDEL_LIST(admin_modals)
	QDEL_LIST_ASSOC_VAL(admin_panels)
	return ..()

/datum/admins/New(initial_rank, initial_rights, ckey)
	src.ckey = ckey
	..()

/datum/admins/proc/on_associate(client/user)
	register_admin_planes(user)

/**
 * 'maybe_user' is because the client MAY be deleted by this point.
 */
/datum/admins/proc/on_disassociate(client/maybe_user)
	if(!maybe_user)
		return
	unregister_admin_planes(maybe_user)

/datum/admins/proc/register_admin_planes(client/user)
	var/atom/movable/screen/plane_master/maybe_admin_plane = user.global_planes?.by_plane_type(/atom/movable/screen/plane_master/admin)
	maybe_admin_plane?.alpha = 255
	maybe_admin_plane?.mouse_opacity = MOUSE_OPACITY_ICON

/datum/admins/proc/unregister_admin_planes(client/user)
	var/atom/movable/screen/plane_master/maybe_admin_plane = user.global_planes?.by_plane_type(/atom/movable/screen/plane_master/admin)
	maybe_admin_plane?.alpha = 0
	maybe_admin_plane?.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

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

/datum/admins/proc/open_admin_modal(path, ...) as /datum/admin_modal
	ASSERT(ispath(path, /datum/admin_modal))
	var/datum/admin_modal/modal = new path(src)
	if(!modal.Initialize(arglist(args.Copy(2))))
		qdel(modal)
		message_admins("Failed to initialize an admin modal. Check runtimes for more details.")
		stack_trace("failed to initialize an admin modal; this means someone passed in bad args.")
		return null
	modal.open()
	return modal

//* Admin Panels *//

/datum/admins/proc/open_admin_panel(path) as /datum/admin_panel
	ASSERT(ispath(path, /datum/admin_panel))
	var/datum/admin_panel/found = admin_panels?[path]
	if(!found)
		found = new path(src)
	found.open()
	return found

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
