/**
 * holds cached, invertible lists
 * allows all using null values and non-inverted
 * allows none using null values and yes-inverted
 *
 * total *must* be provided/known for compare to make it fast.
 * compare will check for this.
 */
/datum/invertible_list
	/// entries - null for inverted = none, null for non-inverted = all
	var/list/values
	/// inverted?
	var/inverted

/datum/invertible_list/New(list/values, inverted = FALSE)
	src.values = values
	src.inverted = inverted

/**
 * compares if we contain anything in common with another list
 *
 * @params
 * * other - other list
 * * total - total values possible; this MUST be known for anything involving inversions, so we can do quick comparisons.
 */
/datum/invertible_list/proc/compare(datum/invertible_list/other, total)
	if(inverted)
		// ensure total is set as inversions are present
		if(!total)
			CRASH("cannot quickly compare with inversions without being given total")
		if(other.inverted)
			// we are inverted & they are inverted
			if(!values || !other.values)
				// one or other is none, no.
				return FALSE
			// check if we inverted all values compared to total
			return length(values | other.values) != total
		else
			// we are inverted and they are not
			if(!values)
				// we are none
				return FALSE
			else if(!other.values)
				// they are all; check if we contain anything else
				return length(values) != total
			return !!length(other.values - values) // l2 has something not excluded from l1
	else
		if(other.inverted)
			// we are not inverted and they are inverted
			// ensure total is set as inversions are present
			if(!total)
				CRASH("cannot quickly compare with inversions without being given total")
			if(!other.values)
				// they are none
				return FALSE
			else if(!values)
				// we are all; make sure they don't contain all values
				return length(other.values) != total
			return !!length(values - other.values) // l1 has something not excluded from l2
		else
			// neither of us are inverted :)
			if(!values || !other.values)
				// either of us are all
				return TRUE
			return !!length(values - other.values) // l1 has something in l2
	CRASH("unexpected end of proc")

/**
 * checks if we contain an element
 */
/datum/invertible_list/proc/contains(elem)
	return values? (inverted? !(elem in values) : (elem in values)) : (inverted? TRUE : FALSE)

/datum/invertible_list/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(raw_edit)
		// allow
		return ..()
	switch(var_name)
		if(NAMEOF(src, inverted), NAMEOF(src, values))
			if(!mass_edit)
				to_chat(usr, SPAN_DANGER("VV: /datum/invertible_list cannot have its contents edited. Create a new one with a proccall, please!"))
			return FALSE
	return ..()

//! implementations

GLOBAL_LIST_EMPTY(struct_bodytypes)

/proc/fetch_bodytypes_struct(encoded)
	var/list/original
	if(islist(encoded))
		original = encoded
		encoded = jointext(encoded, "-")
	if(GLOB.struct_bodytypes[encoded])
		return GLOB.struct_bodytypes[encoded]
	// not found, create
	var/datum/invertible_list/struct
	if(encoded == BODYTYPES_ALL)
		struct = new(null, FALSE)
		GLOB.struct_bodytypes[encoded] = struct
		return struct
	if(encoded == BODYTYPES_NONE)
		struct = new(null, TRUE)
		GLOB.struct_bodytypes[encoded] = struct
		return struct
	var/inverted = BODYTYPE_EXCEPT in original
	if(inverted)
		original = original - BODYTYPE_EXCEPT
	struct = new(original, inverted)
	GLOB.struct_bodytypes[encoded] = struct
	return struct
