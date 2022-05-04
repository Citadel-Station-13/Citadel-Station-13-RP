/datum/job/station/offduty/exploration
	title = "Off-duty Explorer"
	selection_color = "#999440"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /datum/outfit/job/station/assistant/explorer
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_EXPLORATION
	economic_modifier = 5
