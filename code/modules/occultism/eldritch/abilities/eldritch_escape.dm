//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/ability/eldritch_ability/eldritch_escape
	name = ""
	desc = ""
	#warn category
	#warn sprite

	/// default cooldown is short, successful escape applies the real one
	cooldown = 3 SECONDS
	/// applied on successful escape
	var/cooldown_on_successful_escape = 5 MINUTES


#warn impl partial
