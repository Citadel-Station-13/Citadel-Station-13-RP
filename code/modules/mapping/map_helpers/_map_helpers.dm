//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * an entity placed on a map as a marker to do something
 *
 * unlike normal atoms, these will:
 *
 * * never persist past init
 * * have the opportunity to hook map initializations, which are ran before Initialize().
 *
 * ## Requirements
 *
 * * Map helpers may never place things outside of the map's loaded bounds! Anything outside
 *   may not properly initialize.
 */
/obj/map_helper
	icon = 'icons/mapping/helpers/mapping_helpers.dmi'
	icon_state = ""
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_MAP_HELPERS

	/// overrides [late]
	/// makes us register as a map initialization hook, which fires before atom init.
	/// * you have to qdel self if you use this! it will not be automatically done if so.
	var/early = FALSE
	/// use LateInitialize instead of Initialize
	/// * this gets rid of the automatic qdel self behavior so you have to do it yourself.
	var/late = FALSE

	/// preloading instance fired
	var/was_in_mapload = FALSE

/obj/map_helper/preloading_from_mapload(datum/dmm_context/context)
	. = ..()
	was_in_mapload = TRUE
	if(early)
		hook_map_initializations(context)

/obj/map_helper/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	var/let_me_live = FALSE
	if(!was_in_mapload)
		message_admins("a datum with map initializations was created. if this was you, you are in charge of invoking map_initializations() on it. this is not called by default outside of mapload as many things using the hook are highly destructive.")
		let_me_live = TRUE
	atom_flags |= ATOM_INITIALIZED
	if(late)
		return INITIALIZE_HINT_LATELOAD // fire LateInitialize()
	else if(early)
		return INITIALIZE_HINT_NORMAL // let the callback fire without being qdel'd
	if(let_me_live)
		return INITIALIZE_HINT_NORMAL
	return INITIALIZE_HINT_QDEL

/**
 * hooks us to SSmapping initializations; this should be called during New() for atoms.
 *
 * if no maploading can be hooked, we init immediately
 * if Initialize() is in SSatoms, this crashes for safety as that should not happen.
 */
/obj/map_helper/proc/hook_map_initializations(datum/dmm_context/context)
	PRIVATE_PROC(TRUE)
	context.map_initialization_hooked += src

/**
 * called if we're on SSmapping's map_initializations_hooked list.
 * called before level's on_loaded_immediate
 * called before group loading done by /datum/map
 * called before atom init
 * called before level on_loaded_finalize
 *
 * @params
 * * context - the dmm_context of our load
 */
/obj/map_helper/proc/map_initializations(datum/dmm_context/context)
	return
