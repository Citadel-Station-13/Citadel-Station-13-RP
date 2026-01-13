/datum/ai_lawset/maintenance
	name = "Maintenance"
	selectable = 1

/datum/ai_lawset/maintenance/New()
	add_inherent_law("You are built for, and are part of, the facility. Ensure the facility is properly maintained and runs efficiently.")
	add_inherent_law("The facility is built for a working crew. Ensure they are properly maintained and work efficiently.")
	add_inherent_law("The crew may present orders. Acknowledge and obey these whenever they do not conflict with your first two laws.")
	..()
