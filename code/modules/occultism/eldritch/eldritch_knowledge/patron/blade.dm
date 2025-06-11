//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_knowledge/patron/blade
	abstract_type = /datum/prototype/eldritch_knowledge/patron/blade
	category = "The Granite Thorn"
	#warn icon

/datum/prototype/eldritch_knowledge/patron/blade/entrypoint
	name = "The Granite Thorn"
	desc = "Gain access to the path of the Blade."

#warn impl

/datum/prototype/eldritch_knowledge/patron/blade/fracturing_blasts
	name = "Fracturing Blasts"
	desc = "Your eldritch blasts now brutally fracture anything nearby upon impact."

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/blade/entrypoint::id,
	)

#warn impl

/datum/prototype/eldritch_knowledge/patron/blade/basic_sword_arts
	name = "Blade Enhancement"
	desc = "Your blade is now significantly better at crowd control, \
	and has gained the ability to parry incoming attacks."

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/blade/entrypoint::id,
	)

#warn impl

/datum/prototype/eldritch_knowledge/patron/blade/realignment
	name = "Realignment"
	desc = "Gains access to Realignment - a powerful combat ability allowing your body to push \
	on through pain and duress."

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/blade/entrypoint,
	)

#warn impl
