/datum/movespeed_modifier/mob_crawling
	id = "mob-crawling"
	mod_hyperbolic_slowdown = 3.5

/datum/movespeed_modifier/mob_staggered
	id = "mob-staggered"
	variable = TRUE
	// TODO: this should instead be 'requires you to be moving with your own muscles'

/datum/movespeed_modifier/mob_taser_disrupt
	id = "mob-tasered"
	mod_hyperbolic_slowdown = 2
	// TODO: this should instead be 'requires you to be moving with your own muscles'
	movespeed_modifier_flags = MOVESPEED_MODIFIER_REQUIRES_GRAVITY

/datum/movespeed_modifier/mob_inventory_carry
	id = "mob-carry_weight"
	priority = MOVESPEED_PRIORITY_CARRY_WEIGHT
	variable = TRUE
	movespeed_modifier_flags = MOVESPEED_MODIFIER_REQUIRES_GRAVITY

/datum/movespeed_modifier/mob_item_slowdown
	id = "mob-carry_slowdown"
	variable = TRUE
	movespeed_modifier_flags = MOVESPEED_MODIFIER_REQUIRES_GRAVITY

/datum/movespeed_modifier/mob_legacy_slowdown
	id = "mob-legacy_slowdown"
	variable = TRUE
	movespeed_modifier_flags = MOVESPEED_MODIFIER_REQUIRES_GRAVITY

/datum/movespeed_modifier/mob_move_intent
	id = "mob-move_intent"
	variable = TRUE
	priority = MOVESPEED_PRIORITY_MOVEMENT_INTENT
