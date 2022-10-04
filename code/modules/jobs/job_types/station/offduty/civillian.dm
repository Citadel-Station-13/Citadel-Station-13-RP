/datum/job/station/off_duty/civilian
	id = JOB_ID_OFFDUTY_CIVILLIAN
	title = "Off-duty Worker"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /datum/outfit/job/station/assistant/worker
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_CIVILIAN
	economic_modifier = 2
