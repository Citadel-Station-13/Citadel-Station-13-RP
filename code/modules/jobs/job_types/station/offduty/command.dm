/datum/job/offduty/command
	title = "Off-duty Command"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_COMMAND)
	selection_color = "#9b633e"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /datum/outfit/job/assistant
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_COMMAND
	economic_modifier = 5
