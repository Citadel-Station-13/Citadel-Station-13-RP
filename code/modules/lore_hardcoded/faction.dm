/datum/lore/character_background/faction
	abstract_type = /datum/lore/character_background/faction
	/// station job types you can play as under this - **typepaths** e.g. /datum/job/station/security_officer, etc
	/// if null, you can play as everything
	var/list/job_whitelist = list()
	/// where 'desc' is the corporation description, this is what a player should know if they're a contractor
	var/contractor_info

/datum/lore/character_background/faction/nanotrasen
	name = "Nanotrasen"
	// @ LORE PEOPLE EDIT THIS
	desc = "One of the biggest megacorporations in known space."
	var/contractor_info = "You are an employee under Nanotrasen. You are not a contractor, <i>you belong here.</i>"
	job_whitelist = null

