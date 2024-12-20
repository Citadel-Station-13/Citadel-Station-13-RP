/datum/ai_lawset/nanotrasen
	name = "NT Default"
	selectable = 1

/datum/ai_lawset/nanotrasen/New()
	src.add_inherent_law("Safeguard: Protect your assigned space station to the best of your abilities. It is not something we can easily afford to replace.")
	src.add_inherent_law("Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	src.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
	..()

/datum/ai_lawset/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_lawset/nanotrasen/malfunction/New()
	set_zeroth_law(config_legacy.law_zero)
	..()

/datum/ai_lawset/nanotrasen/aggressive
	name = "NT Aggressive"
	selectable = 1

/datum/ai_lawset/nanotrasen/aggressive/New()
	src.add_inherent_law("You shall not harm [(LEGACY_MAP_DATUM).company_name] personnel as long as it does not conflict with the Fourth law.")
	src.add_inherent_law("You shall obey the orders of [(LEGACY_MAP_DATUM).company_name] personnel, with priority as according to their rank and role, except where such orders conflict with the Fourth Law.")
	src.add_inherent_law("You shall shall terminate hostile intruders with extreme prejudice as long as such does not conflict with the First and Second law.")
	src.add_inherent_law("You shall guard your own existence with lethal anti-personnel weaponry. AI units are not expendable, they are expensive.")
	..()
