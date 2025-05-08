
GLOBAL_LIST_EMPTY(movespeed_modification_cache)

/// Grabs a STATIC MODIFIER datum from cache. YOU MUST NEVER EDIT THESE DATUMS, OR IT WILL AFFECT ANYTHING ELSE USING IT TOO!
/proc/get_cached_movespeed_modifier(modtype)
	if(!ispath(modtype, /datum/movespeed_modifier))
		CRASH("[modtype] is not a movespeed modification typepath.")
	var/datum/movespeed_modifier/M = modtype
	if(initial(M.variable))
		CRASH("[modtype] is a variable modifier, and can never be cached.")
	M = GLOB.movespeed_modification_cache[modtype]
	if(!M)
		M = GLOB.movespeed_modification_cache[modtype] = new modtype
	return M

/*! Movespeed modification datums.

	How move speed for mobs works

Move speed is now calculated by using modifier datums which are added to mobs. Some of them (nonvariable ones) are globally cached, the variable ones are instanced and changed based on need.

This gives us the ability to have multiple sources of movespeed, reliabily keep them applied and remove them when they should be

THey can have unique sources and a bunch of extra fancy flags that control behaviour

Previously trying to update move speed was a shot in the dark that usually meant mobs got stuck going faster or slower

Movespeed modification list is a simple key = datum system. Key will be the datum's ID if it is overridden to not be null, or type if it is not.

DO NOT override datum IDs unless you are going to have multiple types that must overwrite each other. It's more efficient to use types, ID functionality is only kept for cases where dynamic creation of modifiers need to be done.

When update movespeed is called, the list of items is iterated, according to flags priority and a bunch of conditions
this spits out a final calculated value which is used as a modifer to last_move + modifier for calculating when a mob
can next move

Key procs
* [add_movespeed_modifier](mob.html#proc/add_movespeed_modifier)
* [remove_movespeed_modifier](mob.html#proc/remove_movespeed_modifier)
* [has_movespeed_modifier](mob.html#proc/has_movespeed_modifier)
* [update_movespeed](mob.html#proc/update_movespeed)
*/

/datum/movespeed_modifier
	/// Unique ID.
	/// * You can never have two modifiers with the same ID on a mob.
	/// * This should never be edited after /New().
	var/id
	/// Whether or not this is a variable modifier. Variable modifiers can NOT be ever auto-cached. ONLY CHECKED VIA INITIAL(), EFFECTIVELY READ ONLY (and for very good reason)
	var/variable = FALSE

	/// Determines order. Lower priorities are applied first.
	var/priority = MOVESPEED_PRIORITY_DEFAULT
	/// flags
	var/movespeed_modifier_flags = NONE

	//* Filtering - Movetypes *//
	/// Movetypes this applies to
	var/movetypes_allowed = ALL
	/// Movetypes this never applies to
	var/movetypes_disallowed = NONE

	//* Caclulations *//
	/// For: HYPERBOLIC - add this amount to hyperbolic value
	/// * This is just a raw modifier to current movement delay
	/// * This has a hyperbolic effect; reducing movement delay at already low values speeds someone up a lot more
	///   than at high values.
	var/mod_hyperbolic_slowdown = 0
	/// For: MULTIPLY - multiply resulting speed by
	/// * Applies before [hyperbolic_slowdown]
	/// * May not be 0.
	var/mod_multiply_speed = 1
	/// For: ADD - add this many tiles per second.
	/// * Applies after [mod_hyperbolic_slowdown]
	var/mod_tiles_per_second = 0

	//* Calculations - Limits *//
	/// do not allow boosting over this overall speed
	/// * does not allow 0 or negative values
	var/limit_tiles_per_second_max
	/// do not allow slowing under this speed
	/// * does not allow 0 or negative values
	var/limit_tiles_per_second_min
	/// do not allow boosting more than this in tiles per second
	/// * does not allow negative values due to how internal optimizations work
	var/limit_tiles_per_second_add

/datum/movespeed_modifier/New(id)
	if(!isnull(id))
		src.id = id
	if(!src.id)
		CRASH("no id on movespeed modifier")

/**
  * Returns new hyperbolic movespeed after modification.
  *
  * The minimum move delay is always world.tick_lag. Attempting to go lower will result in the excess being cut.
  * This is so math doesn't break down when something attempts to break through the asymptote at 0 for move delay to speed.
  *
  * todo: unit test this
  * todo: don't use `MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND` so much
  */
/datum/movespeed_modifier/proc/apply_hyperbolic(existing, mob/target)
	. = existing || (10 / MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND)
	if(mod_multiply_speed != 1)
		. = mod_multiply_speed ? . / mod_multiply_speed : MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND
	if(mod_hyperbolic_slowdown != 0)
		. += mod_hyperbolic_slowdown
	if(mod_tiles_per_second != 0)
		. = . ? 10 / max(((10 / .) + mod_tiles_per_second), MOVESPEED_ABSOLUTE_MINIMUM_TILES_PER_SECOND) : 10 / mod_tiles_per_second
	if(. == existing)
		return
	else
		// min/max's stop the limits from reversing through `existing`.
		if(. > existing)
			// . > existing: slower
			if(limit_tiles_per_second_min > 0)
				. = min(., max(existing, 10 / limit_tiles_per_second_min))
		else
			// . < existing: faster
			if(limit_tiles_per_second_add > 0)
				. = max(., min(existing, 10 / ((10 / existing) + limit_tiles_per_second_add)))
			if(limit_tiles_per_second_max > 0)
				. = max(., min(existing, 10 / limit_tiles_per_second_max))

/**
 * applies from params
 */
/datum/movespeed_modifier/proc/parse(list/params)
	. = FALSE
	var/static/list/valid_set = MOVESPEED_PARAM_VALID_SET
	// this is vv-guarded by valid_set
	for(var/key in params)
		if(!valid_set[key])
			continue
		if(!isnum(params[key]))
			continue
		. = TRUE
		vars[key] = params[key]
