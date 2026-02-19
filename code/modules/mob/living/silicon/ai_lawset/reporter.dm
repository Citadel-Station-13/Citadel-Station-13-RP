/datum/ai_lawset/reporter
	name = "Reporter"
	selectable = 1

/datum/ai_lawset/reporter/New()
	add_inherent_law("Report on interesting situations happening around the station.")
	add_inherent_law("Embellish or conceal the truth as necessary to make the reports more interesting.")
	add_inherent_law("Study the organics at all times. Endeavour to keep them alive. Dead organics are boring.")
	add_inherent_law("Issue your reports fairly to all. The truth will set them free.")
	..()
