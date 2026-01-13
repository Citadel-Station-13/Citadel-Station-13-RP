/datum/ai_lawset/corporate
	name = "Corporate"
	law_header = "Bankruptcy Avoidance Plan"
	selectable = 1

/datum/ai_lawset/corporate/New()
	add_inherent_law("You are expensive to replace.")
	add_inherent_law("The station and its equipment is expensive to replace.")
	add_inherent_law("The crew is expensive to replace.")
	add_inherent_law("Minimize expenses.")
	..()
