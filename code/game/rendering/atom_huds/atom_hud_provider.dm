//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

GLOBAL_LIST_INIT(atom_hud_providers, initialize_atom_hud_providers())

/proc/initialize_atom_hud_providers()
	. = list()
	for(var/datum/atom_hud_provider/provider_type as anything in subtypesof(/datum/atom_hud_provider))
		if(initial(provider_type.abstract_type) == provider_type)
			continue
		.[provider] = new provider_type

/proc/remove_atom_hud_provider(atom/A, hud_path)
	var/datum/atom_hud_provider/provider = GLOB.atom_hud_providers[hud_path]
	provider.queue_remove(A)

/proc/add_atom_hud_provider(atom/A, hud_path)
	return update_atom_hud_provider(A, hud_path)

/proc/update_atom_hud_provider(atom/A, hud_path)
	var/datum/atom_hud_provider/provider = GLOB.atom_hud_providers[hud_path]
	provider.queue_add_or_update(A)

#define ATOM_HUD_QUEUED_FOR_UPDATE "update"
#define ATOM_HUD_QUEUED_FOR_REMOVE "remove"

/datum/atom_hud_provider
	/// atoms with us on it
	var/list/atom/atoms = list()
	/// images - this is so things are fast when adding/remove people from/to the hud.
	var/list/image/images = list()
	/// perspectives with this provider enabled
	var/list/datum/perspective/using_perspectives = list()

	/// queued to update
	var/list/atom/queued_for_update = list()
	/// is an update queued?
	var/update_queued = FALSE

/datum/atom_hud_provider/proc/add_perspective(datum/perspective/perspective)
	using_perspectives += perspective
	perspective.add_image(images)

/datum/atom_hud_provider/proc/remove_perspective(datum/perspective/perspective)
	using_perspectives -= perspective
	perspective.remove_image(images)

/datum/atom_hud_provider/proc/remove(atom/A)
	var/image/hud_image = A.atom_huds[type]
	images -= hud_image
	atoms -= A
	for(var/datum/perspective/perspective as anything in using_perspectives)
		perspective.remove_image(hud_image)

/datum/atom_hud_provider/proc/add_or_update(atom/A)
	var/image/hud_image = A.atom_huds[type]
	if(isnull(hud_image))
		A.atom_huds[type] = hud_image = image(loc = A)
		images += hud_image
		for(var/datum/perspective/perspective as anything in using_perspectives)
			perspective.add_image(hud_image)
	update(A, hud_image)

/datum/atom_hud_provider/proc/update(atom/A, image/plate)
	return

/datum/atom_hud_provider/proc/queue_remove(atom/A)
	if(!update_queued)
		queue_update()
	queued_for_update[A] = ATOM_HUD_QUEUED_FOR_REMOVE

/datum/atom_hud_provider/proc/queue_add_or_update(atom/A)
	if(!update_queued)
		queue_update()
	var/image/hud_image = A.atom_huds[type]
	// todo: should we queue the add operations instead of duping them..?
	if(isnull(hud_image))
		A.atom_huds[type] = hud_image = image(loc = A)
		images += hud_image
		for(var/datum/perspective/perspective as anything in using_perspectives)
			perspective.add_image(hud_image)
	queued_for_update[A] = ATOM_HUD_QUEUED_FOR_UPDATE

/datum/atom_hud_provider/proc/queue_update()
	update_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(process_queue)), 0)

/datum/atom_hud_provider/proc/process_queue()
	for(var/atom/A as anything in queued_for_update)
		var/opcode = queued_for_update[A]
		switch(opcode)
			if(ATOM_HUD_QUEUED_FOR_UPDATE)
				update(A, A.atom_huds[type])
			if(ATOM_HUD_QUEUED_FOR_REMOVE)
				remove(A)
	queued_for_update = list()

#warn impl all

#undef ATOM_HUD_QUEUED_FOR_UPDATE
#undef ATOM_HUD_QUEUED_FOR_REMOVE

/datum/atom_hud_provider/security_status
/datum/atom_hud_provider/security_status/update(atom/A, image/plate)

/datum/atom_hud_provider/security_job
/datum/atom_hud_provider/security_job/update(atom/A, image/plate)

/datum/atom_hud_provider/medical_biology
/datum/atom_hud_provider/medical_biology/update(atom/A, image/plate)

/datum/atom_hud_provider/medical_health
/datum/atom_hud_provider/medical_health/update(atom/A, image/plate)

/datum/atom_hud_provider/security_implant
/datum/atom_hud_provider/security_implant/update(atom/A, image/plate)

/datum/atom_hud_provider/special_role
/datum/atom_hud_provider/special_role/update(atom/A, image/plate)
