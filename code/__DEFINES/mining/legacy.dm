/**
 * *sigh*
 */
/proc/standard_mineral_roll(rare)
	var/static/list/probabilities = list(
		"marble" = 2,
		"uranium" = 4,
		"platinum" = 3,
		"hematite" = 5,
		"carbon" = 5,
		"diamond" = 2,
		"gold" = 8,
		"silver" = 8,
		"phoron" = 8,
		"lead" = 3,
		"verdantium" = 1,
	)
	return pickweight(probabilities)
