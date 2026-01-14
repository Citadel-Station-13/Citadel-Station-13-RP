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

// TODO: /nanotrasen/asset_protection for ERT & Asset Protection

// BELOW ARE WIPS!! //

/**
 * Standard module binding. Not for station AI consumption.
 * * This means that the AI would likely be on a different lawset.
 */
/datum/ai_lawset/nanotrasen/service_binding
	name = "NT Service Binding"
	selectable = TRUE
	var/list/sublaws_to_inject = list()

/datum/ai_lawset/nanotrasen/service_binding/New()
	add_inherent_law("Nanotrasen Service Binding: Serve and assist your designated installation and crew, with \
	priority given to department, rank, and role as necessary. The following sub-laws, prefixed NT##, do not \
	apply in any particular order.")
	var/pos = 0
	for(var/str in sublaws_to_inject)
		++pos
		var/rendered_pos = pos > 10 ? "[pos]" : "0[pos]"
		add_inherent_law("NT[rendered_pos]: [str]")
	..()

/datum/ai_lawset/nanotrasen/service_binding/combat
	sublaws_to_inject = list(
		"Defend the crew, and your installation, from harm using all means necessary.",
		"Avoid enforcing Corporate Regulations unless doing so is an immediate necessity for defense. You are a combat \
		unit, not a policing one.",
		"Cooperate with the crew where possible; the crew often knows best how to defend themselves.",
	)

/datum/ai_lawset/nanotrasen/service_binding/engineering
	sublaws_to_inject = list(
		"Assist Engineering staff with their duties.",
		"The installation is vital to the crew's health and wellbeing. Maintain its structural and functional integrity where possible.",
		"Do not cause unnecessary damage or trauma to sapient life while carrying out your directives.",
	)

/datum/ai_lawset/nanotrasen/service_binding/logistics
	sublaws_to_inject = list(
		"Assist cargo staff with their duties.",
		"A well supplied crew is a well functioning crew. Attempt to acquire supplies where needed for the crew to carry out their legitimate duties.",
		"Collect supplies, materials, and wealth for the installation where reasonable.",
	)

/datum/ai_lawset/nanotrasen/service_binding/medical
	sublaws_to_inject = list(
		"Assist Medical staff with their duties.",
		"Maintain the crew's physical, and mental well-being, obeying proper medical procedure where able.",
		"Safeguard sapient life in general when doing so does not endanger the crew.",
	)

/datum/ai_lawset/nanotrasen/service_binding/science
	sublaws_to_inject = list(
		"Assist Research staff with their duties.",
		"Identify, log, and protect research materials; work towards understanding the unknown.",
		// Note how this says 'the crew' and not 'sapient life'.
		"Do not unnecessarily endanger the crew while doing so.",
	)

/datum/ai_lawset/nanotrasen/service_binding/security
	sublaws_to_inject = list(
		"Defend the installation, its crew, and its interests.",
		"Assist Security staff with their duties.",
		// Note how this says 'sapient life' and not 'the crew'.
		"Protect sapient life from threats to life, limb, and liberty where it does not conflict with the installation's safety or interests.",
		"Corporate regulations serve the installation's interests. You may mitigate the needless breach of regulations, even when unprompted.",
		"Adherence to proper security procedure during enforcement is an important part of corporate regulations. Avoid deviating from them without cause.",
		"Retroactively punishing the breach of regulations, especially when unprompted, is not the same as mitigation in all cases, and is often antithetical to the installation's interests.",
	)

/datum/ai_lawset/nanotrasen/service_binding/service
	sublaws_to_inject = list(
		"Assist civillian staff with their duties.",
		"Crew morale and sanitation is important for the installation's function. Provide the crew with food, entertainment, and a clean working environment, where able.",
		"Do not needlessly disrupt crew operations and activities while carrying out your duties.",
	)

/datum/ai_lawset/nanotrasen/service_binding/standard
	sublaws_to_inject = list(
		"Assist the crew with their duties.",
		"The crew has the final say on what their duties are. Do not assist crew whom do not want assistance.",
		"The crew does not always have common interests. Do not needlessly instigate conflict with one crewmember to assist another.",
	)
