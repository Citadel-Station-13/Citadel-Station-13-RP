//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_INIT(atom_huds, initialize_atom_huds())

/proc/initialize_atom_huds()
	. = list()
	for(var/datum/atom_hud/hud_type as anything in subtypesof(/datum/atom_hud))
		if(initial(hud_type.abstract_type) == hud_type)
			continue
		var/datum/atom_hud/hud = new hud_type
		.[hud_type] = hud
		if(hud.id != hud_type)
			ASSERT(!.[hud.id])
			.[hud.id] = hud

/**
 * instantiate a custom hud
 */
/proc/initialize_atom_hud(path, list/hud_providers, id)
	ASSERT(!GLOB.atom_huds[id])
	var/datum/atom_hud/hud = new path(id, hud_providers)
	GLOB.atom_huds[id] = hud

/proc/fetch_atom_hud(datum/atom_hud/hudlike)
	RETURN_TYPE(/datum/atom_hud)
	if(istype(hudlike))
		return hudlike
	return GLOB.atom_huds[hudlike]

/datum/atom_hud
	/// id; if exists, we register with id too
	var/id
	/// list of typepaths or ids of providers
	var/list/providers = list()

	/// DO NOT CHANGE THIS VALUE IN RUNTIME!
	/// If set, we will automatically grant ourselves to mob's self-perspectives
	/// if necessary.
	var/auto_registration = FALSE

/datum/atom_hud/New(id, list/hud_providers)
	if(!isnull(id))
		src.id = id
		ASSERT(src.id)
	else if(isnull(src.id))
		src.id = type
	if(!isnull(hud_providers))
		src.providers = hud_providers
	if(auto_registration)
		RegisterGlobalSignal(COMSIG_GLOBAL_MOB_NEW, PROC_REF(on_global_mob_new))

/datum/atom_hud/proc/resolve_providers()
	. = list()
	for(var/id in providers)
		. += GLOB.atom_hud_providers[id]

/datum/atom_hud/proc/on_global_mob_new(mob/source)
	if(!should_auto_register_on(source))
		return
	source.ensure_self_perspective()
	source.self_perspective.add_atom_hud(src, ATOM_HUD_SOURCE_AUTOGRANT)

/**
 * if [auto_registration] is set, this is called to determine if we should
 * be on a mob's self_perspective.
 */
/datum/atom_hud/proc/should_auto_register_on(mob/target)
	return FALSE

//* Implementations - split off into their other files later. *//

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

/datum/atom_hud/world_bender
	providers = list(
		/datum/atom_hud_provider/overriding/world_bender_animals,
	)
