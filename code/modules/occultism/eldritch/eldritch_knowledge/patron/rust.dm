//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_knowledge/patron/rust
	abstract_type = /datum/prototype/eldritch_knowledge/patron/rust
	category = "The Unmaker"
	#warn icon

/datum/prototype/eldritch_knowledge/patron/rust/entrypoint
	name = "The Unmaker"
	desc = "Become a disciple of the Unmaker."
	// TODO: icon

#warn impl

/datum/prototype/eldritch_knowledge/patron/rust/rust_spread
	name = ""
	desc = "Gain the ability to spread rust to things around you, weakening them in the process."
	// TODO: icon
	// TODO: lore

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/rust/entrypoint::id,
	)

/datum/prototype/eldritch_knowledge/patron/rust/rust_attack_enhancement
	name = ""
	desc = "Your eldritch bolts now corrode the creations of man, and your blade can be used to parry, \
	spreading a cloud of damaging rust in the process."
	// TODO: icon
	// TODO: lore

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/rust/entrypoint::id,
	)

/datum/prototype/eldritch_knowledge/patron/rust/improvised_weaponry
	name = "Improvised Weaponry"
	desc = "Gain access to several recipes for improvised weaponry enhanced by your Patron."
	// TODO: icon
	// TODO: lore

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/rust/entrypoint::id,
	)

	give_eldritch_recipe_ids = list(
		/datum/crafting_recipe/eldritch_recipe/rust_flask::id,
	)

/datum/prototype/eldritch_knowledge/patron/rust/rust_shielding
	name = "Dermal Shielding"
	desc = "You now passively build a thin layer of protective rust on your skin. \
	Be wary, as said protection will be evident if you are struck in combat."
	// TODO: icon
	// TODO: lore

	req_eldritch_knowledge_ids = list(
		/datum/prototype/eldritch_knowledge/patron/rust/entrypoint::id,
	)

#warn impl
