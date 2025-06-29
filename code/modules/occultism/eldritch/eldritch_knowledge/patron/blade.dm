//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_knowledge/patron/blade
	abstract_type = /datum/prototype/eldritch_knowledge/patron/blade
	category = "The Granite Thorn"
	#warn icon

/datum/prototype/eldritch_knowledge/patron/blade/entrypoint
	name = "The Granite Thorn"
	desc = "Become the path of the Blade."
	// TODO: lore

#warn impl

/datum/prototype/eldritch_knowledge/patron/blade/fracturing_blasts
	name = "Fracturing Blasts"
	desc = "Your eldritch blasts now brutally fracture anything nearby upon impact."
	// TODO: icon
	// TODO: lore

	require_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/blade/entrypoint::id,
	)

	grant_eldritch_passive_ids = list(
		/datum/prototype/eldritch_passive/eldritch_blast_modifier/eldritch_blast_fracturing_impact::id,
	)

/datum/prototype/eldritch_knowledge/patron/blade/sword_enhancement
	name = "Blade Enhancement"
	desc = "Your blade is now significantly better at crowd control, \
	and has gained the ability to parry incoming attacks."
	// TODO: icon
	// TODO: lore

	require_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/blade/entrypoint::id,
	)

	grant_eldritch_passive_ids = list(
		/datum/prototype/eldritch_passive/eldritch_blade_modifier/bladeskill_cleave::id,
		/datum/prototype/eldritch_passive/eldritch_blade_modifier/bladeskill_parry::id,
	)

/datum/prototype/eldritch_knowledge/realignment
	name = "Realignment"
	desc = "Gains access to Realignment - a powerful combat ability allowing your body to push \
	on through pain and duress."
	// TODO: icon
	// TODO: lore

	require_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/blade/entrypoint,
	)

	grant_eldritch_ability_ids = list(
		/datum/prototype/eldritch_ability/realignment::id,
	)
