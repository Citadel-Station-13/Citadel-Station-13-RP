/datum/movespeed_modifier/mob_crawling
	mod_hyperbolic_slowdown = 3.5

/datum/movespeed_modifier/mob_staggered
	variable = TRUE

/datum/movespeed_modifier/mob_taser_disrupt
	mod_hyperbolic_slowdown = 2

/datum/movespeed_modifier/mob_inventory_carry
	priority = MOVESPEED_PRIORITY_CARRY_WEIGHT
	variable = TRUE
	movespeed_modifier_flags = MOVESPEED_MODIFIER_REQUIRES_GRAVITY

/datum/movespeed_modifier/mob_item_slowdown
	variable = TRUE
	movespeed_modifier_flags = MOVESPEED_MODIFIER_REQUIRES_GRAVITY
