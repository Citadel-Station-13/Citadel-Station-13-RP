/** CUTS **/
/datum/wound/cut
	bleed_threshold = 5
	damage_type = CUT

/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	// Minor cuts have max_bleeding_stage set to the stage that bears the wound type's name.
	// The major cut types have the max_bleeding_stage set to the clot stage (which is accordingly given the "blood soaked" descriptor).
	max_bleeding_stage = 3
	stages = list("ugly ripped cut" = 20, "ripped cut" = 10, "cut" = 5, "healing cut" = 2, "small scab" = 0)

/datum/wound/cut/deep
	max_bleeding_stage = 3
	stages = list("ugly deep ripped cut" = 25, "deep ripped cut" = 20, "deep cut" = 15, "clotted cut" = 8, "scab" = 2, "fresh skin" = 0)

/datum/wound/cut/flesh
	max_bleeding_stage = 4
	stages = list("ugly ripped flesh wound" = 35, "ugly flesh wound" = 30, "flesh wound" = 25, "blood soaked clot" = 15, "large scab" = 5, "fresh skin" = 0)

/datum/wound/cut/gaping
	max_bleeding_stage = 3
	stages = list("gaping wound" = 50, "large blood soaked clot" = 25, "blood soaked clot" = 15, "small angry scar" = 5, "small straight scar" = 0)

/datum/wound/cut/gaping_big
	max_bleeding_stage = 3
	stages = list("big gaping wound" = 60, "healing gaping wound" = 40, "large blood soaked clot" = 25, "large angry scar" = 10, "large straight scar" = 0)

/datum/wound/cut/massive
	max_bleeding_stage = 3
	stages = list("massive wound" = 70, "massive healing wound" = 50, "massive blood soaked clot" = 25, "massive angry scar" = 10,  "massive jagged scar" = 0)

/** PUNCTURES **/
/datum/wound/puncture
	bleed_threshold = 5
	damage_type = PIERCE

/datum/wound/puncture/can_worsen(damage_type, damage)
	return 0 //puncture wounds cannot be enlargened

/datum/wound/puncture/small
	max_bleeding_stage = 2
	stages = list("puncture" = 5, "healing puncture" = 2, "small scab" = 0)
	damage_type = PIERCE

/datum/wound/puncture/flesh
	max_bleeding_stage = 2
	stages = list("puncture wound" = 15, "blood soaked clot" = 5, "large scab" = 2, "small round scar" = 0)
	damage_type = PIERCE

/datum/wound/puncture/gaping
	max_bleeding_stage = 3
	stages = list("gaping hole" = 30, "large blood soaked clot" = 15, "blood soaked clot" = 10, "small angry scar" = 5, "small round scar" = 0)
	damage_type = PIERCE

/datum/wound/puncture/gaping_big
	max_bleeding_stage = 3
	stages = list("big gaping hole" = 50, "healing gaping hole" = 20, "large blood soaked clot" = 15, "large angry scar" = 10, "large round scar" = 0)
	damage_type = PIERCE

/datum/wound/puncture/massive
	max_bleeding_stage = 3
	stages = list("massive wound" = 60, "massive healing wound" = 30, "massive blood soaked clot" = 25, "massive angry scar" = 10,  "massive jagged scar" = 0)
	damage_type = PIERCE

/** BRUISES **/
/datum/wound/bruise
	stages = list("monumental bruise" = 80, "huge bruise" = 50, "large bruise" = 30,
				  "moderate bruise" = 20, "small bruise" = 10, "tiny bruise" = 5)
	bleed_threshold = 20
	max_bleeding_stage = 2 //only huge bruise and above can bleed.
	damage_type = BRUISE
