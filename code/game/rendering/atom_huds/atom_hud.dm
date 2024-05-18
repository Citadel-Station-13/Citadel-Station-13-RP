//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

GLOBAL_LIST_INIT(atom_huds, initialize_atom_huds())

/proc/initialize_atom_huds()
	. = list()
	for(var/datum/atom_hud/hud_type as anything in subtypesof(/datum/atom_hud))
		if(initial(hud_type.abstract_type) == hud_type)
			continue
		var/datum/atom_hud/hud = new hud_type
		.[hud_type] = hud
		if(hud.id)
			.[hud.id] = hud

/**
 * instantiate a custom hud
 */
/proc/initialize_atom_hud(path, list/hud_providers, id)
	ASSERT(!GLOB.atom_huds[id])
	var/datum/atom_hud/hud = new path
	hud.providers = hud_providers
	hud.id = id
	GLOB.atom_huds[id] = hud

/datum/atom_hud
	/// id; if exists, we register with id too
	var/id
	/// list of typepaths of providers
	var/list/providers = list()

/datum/atom_hud/data/human/medical
	providers = list(
		/datum/atom_hud_provider/medical_biology,
		/datum/atom_hud_provider/medical_health,
	)

/datum/atom_hud/data/human/job_id
	providers = list(
		/datum/atom_hud_provider/security_job,
	)

/datum/atom_hud/data/human/security

/datum/atom_hud/data/human/security/basic
	providers = list(
		/datum/atom_hud_provider/security_job,
		/datum/atom_hud_provider/security_status,
	)

/datum/atom_hud/data/human/security/advanced
	providers = list(
		/datum/atom_hud_provider/security_job,
		/datum/atom_hud_provider/security_status,
		/datum/atom_hud_provider/security_implant,
	)

/datum/atom_hud/antag
	providers = list(
		/datum/atom_hud_provider/special_role,
	)

#warn below

/* HUD DATUMS */

GLOBAL_LIST_EMPTY(all_huds)
w

/proc/get_atom_hud(id)
	RETURN_TYPE(/datum/atom_hud)
	return GLOB.huds[id]

// TODO: atom_huds on mob with hud sources
// TODO: /datum/hud_supplier for image metadata/hud list metadata
// TODO: atom huds using hud supplier id lists, more id usage in general for dynamic gen

/datum/atom_hud
	/// list of typepaths

	var/list/atom/hudatoms = list() //list of all atoms which display this hud
	var/list/hudusers = list() //list with all mobs who can see the hud
	var/list/hud_icons = list() //these will be the indexes for the atom's hud_list

	var/list/next_time_allowed = list() //mobs associated with the next time this hud can be added to them
	var/list/queued_to_see = list() //mobs that have triggered the cooldown and are queued to see the hud, but do not yet

/datum/atom_hud/New()
	GLOB.all_huds += src

/datum/atom_hud/Destroy()
	for(var/v in hudusers)
		remove_hud_from(v)
	for(var/v in hudatoms)
		remove_from_hud(v)
	GLOB.all_huds -= src
	return ..()

/datum/atom_hud/proc/remove_hud_from(mob/M)
	if(!M || !hudusers[M])
		return
	if (!--hudusers[M])
		hudusers -= M
		if(queued_to_see[M])
			queued_to_see -= M
		else
			for(var/atom/A in hudatoms)
				remove_from_single_hud(M, A)

/datum/atom_hud/proc/remove_from_hud(atom/A)
	if(!A)
		return FALSE
	for(var/mob/M in hudusers)
		remove_from_single_hud(M, A)
	hudatoms -= A
	return TRUE

/datum/atom_hud/proc/remove_from_single_hud(mob/M, atom/A) //unsafe, no sanity apart from client
	if(!M || !M.client || !A)
		return
	for(var/i in hud_icons)
		M.client.images -= A.hud_list[i]

/datum/atom_hud/proc/add_hud_to(mob/M)
	if(!M)
		return
	if(!hudusers[M])
		hudusers[M] = 1
		if(next_time_allowed[M] > world.time)
			if(!queued_to_see[M])
				addtimer(CALLBACK(src, PROC_REF(show_hud_images_after_cooldown), M), next_time_allowed[M] - world.time)
				queued_to_see[M] = TRUE
		else
			next_time_allowed[M] = world.time + ADD_HUD_TO_COOLDOWN
			for(var/atom/A in hudatoms)
				add_to_single_hud(M, A)
	else
		hudusers[M]++

/datum/atom_hud/proc/show_hud_images_after_cooldown(M)
	if(queued_to_see[M])
		queued_to_see -= M
		next_time_allowed[M] = world.time + ADD_HUD_TO_COOLDOWN
		for(var/atom/A in hudatoms)
			add_to_single_hud(M, A)

/datum/atom_hud/proc/add_to_hud(atom/A)
	if(!A)
		return FALSE
	hudatoms |= A
	for(var/mob/M in hudusers)
		if(!queued_to_see[M])
			add_to_single_hud(M, A)
	return TRUE

/datum/atom_hud/proc/add_to_single_hud(mob/M, atom/A) //unsafe, no sanity apart from client
	if(!M || !M.client || !A)
		return
	for(var/i in hud_icons)
		if(A.hud_list[i])
			M.client.images |= A.hud_list[i]

//MOB PROCS
/mob/proc/reload_huds()
	for(var/datum/atom_hud/hud in GLOB.all_huds)
		if(hud && hud.hudusers[src])
			for(var/atom/A in hud.hudatoms)
				hud.add_to_single_hud(src, A)

/mob/new_player/reload_huds()
	return
