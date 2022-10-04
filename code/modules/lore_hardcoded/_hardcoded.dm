/datum/lore

/datum/lore/character_background
	/// name
	var/name = "Unknown"
	/// description/what the player sees
	var/desc = "What is this?"
	/// allowed species ids - if is list, only these species can have them; these are species uids, not normal species ids, subspecies do count
	var/list/allow_species_ids
	/// forbidden species ids - overridden by allowed
	var/list/forbid_species_ids
