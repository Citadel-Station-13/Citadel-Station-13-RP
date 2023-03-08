/** INTERNAL BLEEDING **/
/datum/wound/internal_bleeding
	internal = TRUE
	stages = list("severed artery" = 30, "cut artery" = 20, "damaged artery" = 10, "bruised artery" = 5)
	autoheal_cutoff = 5
	max_bleeding_stage = 4	//all stages bleed. It's called internal bleeding after all.
