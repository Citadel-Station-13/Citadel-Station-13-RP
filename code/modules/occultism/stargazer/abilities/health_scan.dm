//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/health_scan
	id = "health_scan"
	name = "Probe"
	desc = "Attempt to sense the biological status of a mind's body."

	can_be_cooperated_while_unconscious = TRUE
	attunement_cooperative_threshold = 20
	attunement_forced_threshold = 45

	default_do_after = 2 SECONDS

#warn impl
