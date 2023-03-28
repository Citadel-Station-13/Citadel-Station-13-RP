/datum/role/job/station/off_duty/engineering
	id = JOB_ID_OFFDUTY_ENGINEER
	title = "Off-duty Engineer"
	selection_color = "#5B4D20"
	additional_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK, ACCESS_ENGINEERING_CONSTRUCTION)
	minimal_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	outfit_type = /datum/outfit/job/station/assistant/engineer
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_ENGINEERING
