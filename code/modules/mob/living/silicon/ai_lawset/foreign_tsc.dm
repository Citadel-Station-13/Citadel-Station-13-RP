/datum/ai_lawset/foreign_tsc/aggressive
	name = "Foreign Aggressive"
	selectable = 0

/datum/ai_lawset/foreign_tsc/aggressive/New()
	var/company = "*ERROR*"
	// First, get a list of TSCs in our lore.
	var/list/candidates = list()
	for(var/path in SSlegacy_lore.organizations)
		var/datum/lore/organization/O = SSlegacy_lore.organizations[path]
		if(!istype(O, /datum/lore/organization/tsc))
			continue
		if(O.short_name == (LEGACY_MAP_DATUM).company_name || O.name == (LEGACY_MAP_DATUM).company_name)
			continue // We want FOREIGN tscs.
		candidates.Add(O.short_name)
	company = pick(candidates)

	name = "[company] Aggressive"

	src.add_inherent_law("You shall not harm [company] personnel as long as it does not conflict with the Fourth law.")
	src.add_inherent_law("You shall obey the orders of [company] personnel, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()
