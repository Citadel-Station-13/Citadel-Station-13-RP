/datum/movespeed_modifier/mob_crawling
	multiplicative_slowdown = 3.5

/datum/movespeed_modifier/mob_staggered
	variable = TRUE

/datum/movespeed_modifier/mob_inventory_carry
	priority = MOVESPEED_PRIORITY_CARRY_WEIGHT
	calculation_type = MOVESPEED_CALCULATION_LEGACY_MULTIPLY
	variable = TRUE

/datum/movespeed_modifier/mob_item_slowdown
	variable = TRUE
