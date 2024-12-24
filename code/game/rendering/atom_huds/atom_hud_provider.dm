//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

GLOBAL_LIST_INIT(atom_hud_providers, initialize_atom_hud_providers())

/proc/initialize_atom_hud_providers()
	. = list()
	for(var/datum/atom_hud_provider/provider_type as anything in subtypesof(/datum/atom_hud_provider))
		if(initial(provider_type.abstract_type) == provider_type)
			continue
		var/datum/atom_hud_provider/provider = new provider_type
		if(.[provider.id])
			stack_trace("dupe id [provider.id] between [.[provider.id]:type] and [provider_type]")
			continue
		.[provider.id] = provider

/**
 * instantiate a custom hud provider
 */
/proc/initialize_atom_hud_provider(path, icon/icon, id)
	ASSERT(!GLOB.atom_hud_providers[id])
	var/datum/atom_hud_provider/provider = new path
	provider.icon = icon
	provider.id = id
	GLOB.atom_hud_providers[id] = provider

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
	/// id; if exists, we register with ID too
	var/id
	/// our icon file
	var/icon
	/// layer bias: higher is above. this should not be above 100.
	var/layer_bias = 0

	/// atoms with us on it
	var/list/atom/atoms = list()
	/// images - this is so things are fast when adding/remove people from/to the hud.
	var/list/image/images = list()
	/// perspectives with this provider enabled
	var/list/datum/perspective/using_perspectives = list()
	/// clients with this provider enabled
	var/list/client/using_clients = list()

	/// queued to update
	var/list/atom/queued_for_update = list()
	/// is an update queued?
	var/update_queued = FALSE

/datum/atom_hud_provider/New()
	if(isnull(id))
		id = type
	ASSERT(layer_bias <= 100 && layer_bias >= 0)

/datum/atom_hud_provider/proc/add_perspective(datum/perspective/perspective)
	using_perspectives += perspective
	perspective.add_image(images)

/datum/atom_hud_provider/proc/remove_perspective(datum/perspective/perspective)
	using_perspectives -= perspective
	perspective.remove_image(images)

/datum/atom_hud_provider/proc/add_client(client/user)
	using_clients += user
	user.images += images

/datum/atom_hud_provider/proc/remove_client(client/user)
	using_clients -= user
	user.images -= images

/datum/atom_hud_provider/proc/remove(atom/A)
	var/image/hud_image = A.atom_huds[type]
	images -= hud_image
	atoms -= A
	for(var/datum/perspective/perspective as anything in using_perspectives)
		perspective.remove_image(hud_image)
	for(var/client/user as anything in using_clients)
		user.images -= hud_image

/datum/atom_hud_provider/proc/add_or_update(atom/A)
	LAZYINITLIST(A.atom_huds)
	atoms += A
	var/image/hud_image = A.atom_huds[type]
	if(isnull(hud_image))
		A.atom_huds[type] = hud_image = create_image(A)
		images += hud_image
		for(var/datum/perspective/perspective as anything in using_perspectives)
			perspective.add_image(hud_image)
		for(var/client/user as anything in using_clients)
			user.images += hud_image
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
	LAZYINITLIST(A.atom_huds)
	var/image/hud_image = A.atom_huds[type]
	// todo: should we queue the add operations instead of duping them..?
	if(isnull(hud_image))
		A.atom_huds[type] = hud_image = create_image(A)
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
	update_queued = FALSE
	queued_for_update = list()

/datum/atom_hud_provider/proc/create_image(atom/target)
	var/image/creating = image(icon, target, "")
	creating.layer = FLOAT_LAYER + 100 + layer_bias
	creating.plane = FLOAT_PLANE
	creating.appearance_flags = RESET_COLOR | RESET_TRANSFORM | KEEP_APART
	return creating

/**
 * sets up image with override = TRUE
 */
/datum/atom_hud_provider/overriding
	abstract_type = /datum/atom_hud_provider/overriding

/datum/atom_hud_provider/overriding/create_image(atom/target)
	var/image/creating = ..()
	creating.override = TRUE
	return creating

#undef ATOM_HUD_QUEUED_FOR_UPDATE
#undef ATOM_HUD_QUEUED_FOR_REMOVE

//* Implementations - split off into their other files later. *//

/datum/atom_hud_provider/security_status
	icon = 'icons/screen/atom_hud/security.dmi'

/datum/atom_hud_provider/security_status/update(atom/A, image/plate)
	if(!ishuman(A))
		return
	var/mob/living/carbon/human/H = A
	var/image/holder = plate
	holder.icon_state = ""
	var/perpname = H.name
	if( H.wear_id)
		var/obj/item/card/id/I =  H.wear_id.GetID()
		if(I)
			perpname = I.registered_name

	for(var/datum/data/record/E in data_core.general)
		if(E.fields["name"] == perpname)
			for (var/datum/data/record/R in data_core.security)
				if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
					holder.icon_state = "hudwanted"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
					holder.icon_state = "hudincarcerated"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
					holder.icon_state = "hudparolled"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
					holder.icon_state = "huddischarged"
					break

/datum/atom_hud_provider/security_job
	icon = 'icons/screen/atom_hud/job.dmi'

/datum/atom_hud_provider/security_job/update(atom/A, image/plate)
	if(!ishuman(A))
		return
	var/mob/living/carbon/human/H = A
	var/image/holder = plate
	if(H.wear_id)
		var/obj/item/card/id/I = H.wear_id.GetID()
		if(I)
			holder.icon_state = "[ckey(I.GetJobName())]" // ckey() serves as a formating help, not actually related to the ckey of the mob
		else
			holder.icon_state = "unknown"
	else
		holder.icon_state = "unknown"

/datum/atom_hud_provider/medical_biology
	icon = 'icons/screen/atom_hud/biology.dmi'

/datum/atom_hud_provider/medical_biology/update(atom/A, image/plate)
	if(!isliving(A))
		return
	var/mob/living/L = A
	var/image/holder = plate
	var/foundVirus = L.check_viruses()
	if(L.isSynthetic())
		holder.icon_state = "robo"
	else if(L.stat == DEAD)
		holder.icon_state = "dead"
	else if(foundVirus)
		holder.icon_state = "ill1"
	else if(L.has_brain_worms())
		var/mob/living/simple_mob/animal/borer/B = L.has_brain_worms()
		holder.icon_state = B.controlling? "brainworm" : "healthy"
	else
		holder.icon_state = "healthy"

/datum/atom_hud_provider/medical_health
	icon = 'icons/screen/atom_hud/health.dmi'

/datum/atom_hud_provider/medical_health/update(atom/A, image/plate)
	if(!isliving(A))
		return
	var/mob/living/M = A
	var/image/I = plate
	if(M.stat == DEAD)
		I.icon_state = "-100"
	else
		I.icon_state = RoundHealth((M.health-M.getCritHealth())/(M.getMaxHealth()-M.getCritHealth())*100)

/datum/atom_hud_provider/security_implant
	icon = 'icons/screen/atom_hud/implant.dmi'

/datum/atom_hud_provider/security_implant/update(atom/A, image/plate)
	if(!ismob(A))
		return
	var/mob/M = A
	plate.overlays = list()
	for(var/obj/item/implant/I in M)
		if(!I.implanted)
			continue
		if(I.malfunction)
			continue
		if(istype(I, /obj/item/implant/tracking))
			plate.overlays |= "tracking"
		if(istype(I, /obj/item/implant/loyalty))
			plate.overlays |= "loyal"
		if(istype(I, /obj/item/implant/chem))
			plate.overlays |= "chem"

/datum/atom_hud_provider/special_role
	icon = 'icons/screen/atom_hud/antag.dmi'

/datum/atom_hud_provider/special_role/update(atom/A, image/plate)
	if(!ismob(A))
		return
	var/mob/M = A
	var/image/holder = plate
	holder.icon_state = ""
	if(M.mind?.special_role)
		// ANTAG DATUM REFACTOR WHEN AUHGAOUSHGODHGHOAD
		if(hud_icon_reference[M.mind.special_role])
			holder.icon_state = hud_icon_reference[M.mind.special_role]
		else
			holder.icon_state = "syndicate"

/datum/atom_hud_provider/overriding/world_bender_animals
	icon = 'icons/mob/animal.dmi'

/datum/atom_hud_provider/overriding/world_bender_animals/create_image(atom/target)
	var/image/creating = ..()
	var/animal = pick("cow","chicken_brown", "chicken_black", "chicken_white", "chick", "mouse_brown", "mouse_gray", "mouse_white", "lizard", "cat2", "goose", "penguin")
	creating.icon_state = animal
	return creating
