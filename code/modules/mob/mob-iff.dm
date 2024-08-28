//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//*                    Basic mob-level IFF system.                    *//
//*                                                                   *//
//* This is not on mob AI holder so non-AI holders can access it too. *//

/mob/proc/add_iff_faction(string)
	if(islist(iff_factions))
		iff_factions |= string
	else if(iff_factions)
		iff_factions = list(iff_factions, string)
	else
		iff_factions = string

/mob/proc/remove_iff_faction(string)
	if(islist(iff_factions))
		iff_factions -= string
		if(!length(iff_factions))
			iff_factions = null
	else if(iff_factions == string)
		iff_factions = null

/mob/proc/has_iff_faction(string)
	return islist(iff_factions) ? (string in iff_factions) : (iff_factions == string)

/**
 * Returns a truthy value if we share atleast one IFF faction string with another mob, falsy otherwise.
 *
 * * does not necessarily return TRUE or FALSE!
 */
/mob/proc/truthy_shares_iff_faction_with(mob/other)
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
