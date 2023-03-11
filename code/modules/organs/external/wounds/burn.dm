/** BURNS **/
/datum/wound/burn
	damage_type = BURN
	max_bleeding_stage = 0

/datum/wound/burn/bleeding()
	return 0

/datum/wound/burn/moderate
	stages = list("ripped burn" = 10, "moderate burn" = 5, "healing moderate burn" = 2, "fresh skin" = 0)

/datum/wound/burn/large
	stages = list("ripped large burn" = 20, "large burn" = 15, "healing large burn" = 5, "fresh skin" = 0)

/datum/wound/burn/severe
	stages = list("ripped severe burn" = 35, "severe burn" = 30, "healing severe burn" = 10, "burn scar" = 0)

/datum/wound/burn/deep
	stages = list("ripped deep burn" = 45, "deep burn" = 40, "healing deep burn" = 15,  "large burn scar" = 0)

/datum/wound/burn/carbonised
	stages = list("carbonised area" = 50, "healing carbonised area" = 20, "massive burn scar" = 0)
