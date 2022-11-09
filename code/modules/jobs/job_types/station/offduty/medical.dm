/datum/job/station/off_duty/medical
	id = JOB_ID_OFFDUTY_MEDBAY
	title = "Off-duty Medic"
	selection_color = "#013D3B"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /datum/outfit/job/station/assistant/medic
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_MEDICAL
	economic_modifier = 5
