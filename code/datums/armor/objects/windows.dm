/**
 * window armor
 *
 * * not randomized as a cheap / lazy fix to fists breaking them with randomization as fists are just under the threshold
 */
/datum/armor/window
	randomization_percent = 0
	melee = 0.1
	melee_tier = 2
	bomb = -1

/datum/armor/window/reinforced
	melee_deflect = 6
	melee_soak = 0
	melee_tier = 3
	melee = 0.3
