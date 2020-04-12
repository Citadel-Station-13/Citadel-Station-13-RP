/datum/event_manager/New()
	..()
	allEvents = typesof(/datum/event) - /datum/event
	report_at_round_end = 1 //So people can see what admins have been up to regarding events. Can be disabled by admins for a round.
