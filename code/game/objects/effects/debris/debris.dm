/**
 * debris
 *
 * eventually going to be auto-collating objects for things like
 * * blood
 * * gibs
 * * dirt
 * * etc
 *
 * * Always define your own initialization procedures BEFORE calling parent, or Collate() won't run at the right time.
 * * serialize() and deserialize() is used by persistence.
 */
/obj/effect/debris
	/// collate?
	var/collate = TRUE
	/// lazy check for amount of stuff within turf that's our type or subtype
	var/collate_type_limit = 10
	/// type to check for, defaults to our type
	var/collate_type
	/// automatic collation kills other instead of self
	var/collate_type_annihilate_other = TRUE
	/// lazy check for amount of stuff within turf at all
	var/collate_turf_limit
	/// used by persistence serialization as a temp var for speed
	var/tmp/debris_serialization_temporary
	/// this is considered valuable and uses a % clean chance instead of being entirely based off of zones
	var/relatively_important = FALSE

/obj/effect/debris/Initialize(mapload)
	. = ..()
	if(collate && Collate())
		return INITIALIZE_HINT_QDEL
	if(mapload)
		obj_persist_status |= OBJ_PERSIST_STATUS_NO_THANK_YOU

/**
 * return true to qdel on init instead
 *
 * this proc should kick our date into other matching thing son this turf.
 */
/obj/effect/debris/proc/Collate()
	if(!isnull(collate_type_limit))
		var/check_type = collate_type || type
		var/found = 0
		if(!isnull(collate_turf_limit) && length(loc.contents) > collate_turf_limit)
			return TRUE
		for(var/obj/enemy in loc)
			if(enemy == src)
				continue
			if(istype(enemy, check_type))
				found++
				if(found > collate_type_limit)
					if(collate_type_annihilate_other)
						qdel(enemy)
						return FALSE
					return TRUE
	else if(!isnull(collate_turf_limit))
		return length(loc.contents) > collate_turf_limit
	return FALSE

//* Atom Color - we don't use the expensive system. *//

/obj/effect/debris/get_atom_color()
	return color

/obj/effect/debris/add_atom_color(coloration, colour_priority)
	color = coloration

/obj/effect/debris/remove_atom_color(colour_priority, coloration)
	color = null

/obj/effect/debris/update_atom_color()
	return

/obj/effect/debris/copy_atom_color(atom/other, colour_priority)
	if(isnull(other.color))
		return
	color = other.color

//* Interaction *//

/obj/effect/debris/tool_interaction(obj/item/I, datum/event_args/actor/clickchain/e_args, clickchain_flags, function, hint, datum/callback/reachability_check)
	// redirect all clicks to turf
	if(!isturf(loc))
		// how moment
		return ..()
	clickchain_flags |= CLICKCHAIN_REDIRECTED
	return loc.tool_interaction(arglist(args))

/obj/effect/debris/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	// redirect all clicks to turf
	if(!isturf(loc))
		// how moment
		return ..()
	clickchain_flags |= CLICKCHAIN_REDIRECTED
	return loc.attackby(arglist(args))
