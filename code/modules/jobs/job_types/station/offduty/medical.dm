/datum/role/job/station/off_duty/medical
	id = JOB_ID_OFFDUTY_MEDBAY
	title = "Off-duty Medic"
	selection_color = "#013D3B"
	additional_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	minimal_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_ENGINEERING_AIRLOCK)
	outfit_type = /datum/outfit/job/station/assistant/medic
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_MEDICAL
