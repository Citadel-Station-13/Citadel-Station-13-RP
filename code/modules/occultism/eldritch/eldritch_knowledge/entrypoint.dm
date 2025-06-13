//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_knowledge/entrypoint
	name = "The Room Beyond"
	desc = "Peek behind the curtains of reality."
	#warn icon
	// TODO: lore
	category = "Reality"

	give_eldritch_ability_ids = list(
		/datum/eldritch_ability/eldritch_blast::id,
		// -- Unimplemented --
		// /datum/eldritch_ability/eldritch_escape::id,
	)

	give_eldritch_ability_ids = list(
		// -- Remove once other classes have proper stealth, give to Void only --
		/datum/crafting_recipe/eldritch_recipe/void_cloak::id,
	)
