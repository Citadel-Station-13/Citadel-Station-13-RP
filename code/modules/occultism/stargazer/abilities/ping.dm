//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/stargazer_mindnet_ability/ping
	id = "ping"
	name = "Ping"
	desc = "Ping the targeted mind to detect if they sense you and \
	where they are."

	attunement_cooperative_threshold = 10
	attunement_forced_threshold = 60

	default_do_after = 1 SECONDS

#warn impl
