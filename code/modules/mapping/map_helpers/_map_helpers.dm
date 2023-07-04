//Landmarks and other helpers which speed up the mapping process and reduce the number of unique instances/subtypes of items/turf/ect
/obj/map_helper
	icon = 'icons/mapping/helpers/mapping_helpers.dmi'
	icon_state = ""

	/// overrides [late]
	/// makes us register as a map initialization hook, which fires before atom init.
	/// you have to qdel self if you use this! it will not be automatically done if so.
	var/early = FALSE
	/// use LateInitialize instead of Initialize
	/// this gets rid of the automatic qdel self behavior so you have to do it yourself.
	var/late = FALSE

/obj/map_helper/New()
	if(early)
		hook_map_initializations()
	return ..()

/obj/map_helper/Initialize(mapload)
	. = ..()
	if(late)
		return INITIALIZE_HINT_LATELOAD // fire LateInitialize()
	else if(early)
		return INITIALIZE_HINT_NORMAL // let the callback fire without being qdel'd
	return INITIALIZE_HINT_QDEL

/**
 * hooks us to SSmapping initializations; this should be called during New() for atoms.
 *
 * if no maploading can be hooked, we init immediately
 * if Initialize() is in SSatoms, this crashes for safety as that should not happen.
 */
/obj/map_helper/proc/hook_map_initializations()
	if(isnull(SSmapping.map_initialization_hooked))
		// postpone to after init
		if(SSatoms.initialized == INITIALIZATION_INSSATOMS)
			CRASH("undefined behavior: initialization is currently in SSatoms but we tried to hook map init.")
		message_admins("a datum with map initializations was created. if this was you, you are in charge of invoking map_initializations() on it. this is not called by default outside of mapload as many things using the hook are highly destructive.")
	else
		SSmapping.map_initialization_hooked += src

/**
 * called if we're on SSmapping's map_initializations_hooked list.
 * called after level on_loaded_immediate
 * called before atom init
 * called before level on_loaded_finalize
 *
 * @params
 * * bounds - (optional) bounds list of loaded level. can be null if we were invoked without a level load.
 */
/obj/map_helper/proc/map_initializations(list/bounds)
	return
