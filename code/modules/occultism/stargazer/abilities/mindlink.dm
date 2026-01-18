//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/mindlink
	id = "mindlink"
	name = "Mindlink"
	/// much like MMIs, the description hides the horrors of what this actually is.
	desc = "Imprint your neural patterns on this mind, creating a more lasting attunement."

	// pretty much requires a full grab
	attunement_cooperative_threshold = 60
	enforce_reachability = TRUE

	default_do_after = 8 SECONDS
	default_do_after_flags = DO_AFTER_IGNORE_MOVEMENT | DO_AFTER_IGNORE_ACTIVE_ITEM

#warn impl
