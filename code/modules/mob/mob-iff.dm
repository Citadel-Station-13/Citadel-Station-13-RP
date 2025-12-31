//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//*                    Basic mob-level IFF system.                    *//
//*                                                                   *//
//* This is not on mob AI holder so non-AI holders can access it too. *//

// todo: typelist them where possible

//* Init *//

/mob/proc/init_iff()
	// null is the only 'no faction' state of the var
	if(isnull(iff_factions))
		return
	set_iff_factions(iff_factions)

/**
 * * descriptor can be a string or a list
 *
 * @return string faction
 */
/mob/proc/process_iff_faction(descriptor)
	if(islist(descriptor))
		switch(descriptor[1])
			if(MOB_IFF_FACTION_BIND_TO_LEVEL)
				if(!loc)
					return null
				// if get z returns null it works as an assoc lookup returning null
				var/prepend = SSmapping.ordered_levels[get_z(src)]?.id || "unkw"
				return "[prepend]-[descriptor[descriptor[1]]]"
			if(MOB_IFF_FACTION_BIND_TO_MAP)
				// if get z returns null it works as an assoc lookup returning null
				if(!loc)
					return null
				var/datum/map_level/level = SSmapping.ordered_levels[get_z(src)]
				var/prepend = level?.parent_map?.id || level?.id || "unkw"
				return "bind-[prepend]-[descriptor[descriptor[1]]]"
	switch(descriptor)
		if(MOB_IFF_FACTION_BIND_TO_LEVEL)
			// if get z returns null it works as an assoc lookup returning null
			if(!loc)
				return null
			var/prepend = SSmapping.ordered_levels[get_z(src)]?.id || "unkw"
			return "bind-[prepend]"
		if(MOB_IFF_FACTION_BIND_TO_MAP)
			// if get z returns null it works as an assoc lookup returning null
			if(!loc)
				return null
			var/datum/map_level/level = SSmapping.ordered_levels[get_z(src)]
			var/prepend = level?.parent_map?.id || level?.id || "unkw"
			return "bind-[prepend]"
		else
			return descriptor

//* Direct Operations *//

/mob/proc/add_iff_faction(string)
	// the null faction is not a real faction, it's the lack of one
	if(isnull(string))
		return
	if(islist(iff_factions))
		iff_factions |= string
	else if(iff_factions)
		iff_factions = list(iff_factions, string)
	else
		iff_factions = string

/mob/proc/remove_iff_faction(string)
	// the null faction is not a real faction, it's the lack of one
	if(isnull(string))
		return
	if(islist(iff_factions))
		iff_factions -= string
		if(!length(iff_factions))
			iff_factions = null
	else if(iff_factions == string)
		iff_factions = null

/mob/proc/clear_iff_factions()
	iff_factions = null

/mob/proc/set_iff_factions(new_factions)
	if(islist(new_factions))
		for(var/i in 1 to length(new_factions))
			var/faction = new_factions[i]
			if(islist(faction) || ispath(faction) || faction[1] == "!")
				faction = process_iff_faction(faction)
				new_factions[i] = faction
			continue // nothing otherwise to do yet
	else if(islist(new_factions) || ispath(new_factions) || new_factions[1] == "!")
		new_factions = process_iff_faction(new_factions)

	iff_factions = new_factions

/mob/proc/has_iff_faction(string)
	// the null faction is not a real faction, it's the lack of one
	if(isnull(string))
		return FALSE
	return islist(iff_factions) ? (string in iff_factions) : (iff_factions == string)

//* Generation / Resolution *//

/**
 * Gets, or generates an unique IFF faction for ourselves.
 *
 * * Behavior depends on DF_USE_TAG being in use for us.
 */
/mob/proc/unique_iff_faction()
	var/unique_faction = "mob-[tag]"
	if(!has_iff_faction(unique_faction))
		add_iff_faction(unique_faction)
	return unique_faction

//* Operations - With Other Mob *//

/mob/proc/copy_iff_factions(mob/other)
	iff_factions = islist(other.iff_factions)? other.iff_factions:Copy() : other.iff_factions

/**
 * Returns a truthy value if we share atleast one IFF faction string with another mob, falsy otherwise.
 *
 * * does not necessarily return TRUE or FALSE!
 */
/mob/proc/shares_iff_faction(mob/other)
	if(islist(iff_factions))
		if(islist(other.iff_factions))
			return length(iff_factions & other.iff_factions)
		else if(other.iff_factions)
			return other.iff_factions in iff_factions
	else if(iff_factions)
		if(islist(other.iff_factions))
			return iff_factions in other.iff_factions
		else if(other.iff_factions)
			return iff_factions == other.iff_factions

//* Notes *//

/**
 * A "add factions from other mob" helper is intentionally not provided because the system's semantics
 * is usually not as simple as just adding factions from another mob.
 */
