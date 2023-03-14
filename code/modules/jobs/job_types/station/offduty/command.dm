/datum/role/job/station/off_duty/command
	id = JOB_ID_OFFDUTY_COMMAND
	title = "Off-duty Command"
	timeoff_factor = -1
	total_positions = -1
	departments = list(DEPARTMENT_OFFDUTY, DEPARTMENT_COMMAND)
	selection_color = "#9b633e"
	additional_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	minimal_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	outfit_type = /datum/outfit/job/station/assistant
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_COMMAND
