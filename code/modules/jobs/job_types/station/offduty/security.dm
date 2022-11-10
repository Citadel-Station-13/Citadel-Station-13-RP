/datum/job/station/off_duty/security
	id = JOB_ID_OFFDUTY_SECURITY
	title = "Off-duty Officer"
	selection_color = "#601C1C"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /datum/outfit/job/station/assistant/officer
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_SECURITY
	economic_modifier = 4
