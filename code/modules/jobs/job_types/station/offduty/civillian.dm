/datum/job/station/offduty/civilian
	title = "Off-duty Worker"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /datum/outfit/job/assistant/worker
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_CIVILIAN
	economic_modifier = 2
