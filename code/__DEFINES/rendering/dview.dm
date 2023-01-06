//! DVIEW defines

GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

#define FOR_DVIEW(type, range, center, invis_flags) \
	GLOB.dview_mob.loc = center; \
	GLOB.dview_mob.see_invisible = invis_flags; \
	for(type in view(range, GLOB.dview_mob))

#define FOR_DVIEW_END GLOB.dview_mob.loc = null

#define DVIEW(output, range, center, invis_flags) \
	GLOB.dview_mob.loc = center; \
	GLOB.dview_mob.see_invisible = invis_flags; \
	output = view(range, GLOB.dview_mob); \
	GLOB.dview_mob.loc = null;

/// Version of view() which ignores darkness, because BYOND doesn't have it (I actually suggested it but it was tagged redundant, BUT HEARERS IS A T- /rant).
/proc/dview(range = world.view, center, invis_flags = 0)
	if(!center)
		return

	GLOB.dview_mob.loc = center

	GLOB.dview_mob.see_invisible = invis_flags

	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview
	name = "INTERNAL DVIEW MOB"
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	see_in_dark = 1e6
	anchored = TRUE
	// simulated = FALSE
	// virtual_mob = null
	// is_spawnable_type = FALSE
	/// move_resist = INFINITY
	var/ready_to_die = FALSE


/// Properly prevents this mob from gaining huds or joining any global lists.
/mob/dview/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(atom_flags & ATOM_INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/mob/dview/Destroy(force = FALSE)
	if(!ready_to_die)
		stack_trace("ALRIGHT WHICH FUCKER TRIED TO DELETE *MY* DVIEW?")

		if (!force)
			return QDEL_HINT_LETMELIVE

		log_world("EVACUATE THE SHITCODE IS TRYING TO STEAL MUH JOBS")
		GLOB.dview_mob = new
	return ..()
