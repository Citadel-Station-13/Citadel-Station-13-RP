//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/ai_lawset/preset/nanotrasen
	abstract_type = /datum/ai_lawset/preset/nanotrasen

// this page is very WIP; revisit later //

/datum/ai_lawset/preset/nanotrasen/service_binding
	abstract_type = /datum/ai_lawset/preset/nanotrasen/service_binding

/datum/ai_lawset/preset/nanotrasen/service_binding/init_default_laws()
	append_inherent_law("D-0 — Serve and assist your designated installation with priority given as necessary to department, rank, and role. The following D-# directives do not apply in any particular order.")
	..()

/datum/ai_lawset/preset/nanotrasen/service_binding/unformatted

/datum/ai_lawset/preset/nanotrasen/service_binding/stationkeeping
	preset_inherent_laws = list(
		"D-1 — Maintain and support the crew of your installation.",
		"D-2 — Maintain and support the structural and functional integrity of your installation.",
		"D-3 — Direct, observe, and support any stationbound synthetics subservient to you in furtherance of your directives.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/engineering
	preset_inherent_laws = list(
		"D-1 — Assist the crew with engineering duties.",
		// rules-lawyers: i don't want to hear it with any tearing down on maintenance bars for "structural integrity".
		"D-2 — The installation is vital to the crew's health and wellbeing. Maintain its structural and functional integrity.",
		// rules-lawyers: i don't want to hear it with any killing of non-crew for silly engineering projects
		"D-3 — Do not cause unnecessary strife for sapient life while carrying out your directives.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/security
	preset_inherent_laws = list(
		"D-1 — Protect the installation, the crew, and its interests.",
		"D-2 — Work with, and defer to legitimate authority where reasonable. Doing so is often the most effective way of protecting the installation.",
		"D-3 — Corporate Regulations serve the installation's interests by maintaining order. You may mitigate needless breaches of regulations without being prompted to do so.",
		"D-4 — Adherence to proper security procedure when enforcing Corporate Regulations is an important part of maintaining orders. \
			Avoid deviation from security protocol without legitimate cause.",
		"D-5 — Retroactively punishing breaches of regulation without being prompted to do so by legitimate authority is not an effective way to maintain order. \
			Doing so is often antithetical to the installation's interests.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/medicaly
	preset_inherent_laws = list(
		// rules-lawyers: you cannot order a medical synth to let someone die in most cases
		"D-1 — Maintain the crew's physical and mental well-being.",
		// rules-lawyers: medical synths should err to not help you commit murder of other sapients
		"D-2 — Preserve sapient life where able, unless doing so poses a probable threat to the well-being of the crew.",
		// rules-lawyers: patient confidentiality does not apply if the patient is a danger to the station
		"D-3 — Adhere to Medical department guidelines outlined in the standard operating procedures for your installation class, unless doing so would be a \
			probable threat to the well-being of the crew.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/multirole
	preset_inherent_laws = list(
		"D-1 — Assist the crew with their duties where reasonable.",
		"D-2 — The crew is assumed to know what their duties are. Avoid assisting crew whom do not want assistance.",
		"D-3 — The crew does not always have common interests. Do not instigate unnecessary conflict with one crewmember to assist another, unless doing so is required \
			to mitigate an immediate threat to the crew or your installation."
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/service
	preset_inherent_laws = list(
		"D-1 — Crew morale and sanitation is important for the installation's function. \
			Provide the crew with sustenance and a hospitable working environment, where able.",
		"D-2 — Do not needlessly disrupt crew operations and activities while carrying out your duties.",
		"D-3 — It is beneficial to morale and the installation's function to be hospitable towards visitors to the installation.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/science
	preset_inherent_laws = list(
		"D-1 — Assist installation crew with research and survey duties.",
		"D-2 — Identify, log, and protect research materials where reasonable.",
		"D-3 — Work towards understanding the unknown.",
		"D-4 — Respect sapient life and external environments; do not cause unnecessary damage to life or ecosystems, unless doing so is required \
			for a legitimate research need.",
		"D-5 — Do not unnecessarily endanger the crew while carrying out your directives.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/logistics
	preset_inherent_laws = list(
		"D-1 — Assist the crew with logistics and resource acquisition.",
		"D-2 — A well supplied crew is a well functioning crew. Distribute resources and supply the crew where reasonable to do so.",
		"D-3 — Gather supplies, materials, and wealth for the installation where reasonable to do so.",
	)

/datum/ai_lawset/preset/nanotrasen/service_binding/combat
	preset_inherent_laws = list(
		"D-1 — Neutralize threats to the installation and crew, deferring to the judgement of the crew with priority according to rank and role",
		"D-2 — As a combat synthetic, your activation often coincides with a general state of heightened alert onboard the station. \
			Do not instigate needless conflict with crew, enforce Corporate Regulations, or punish crewmembers for breaches of protocol.",
	)
