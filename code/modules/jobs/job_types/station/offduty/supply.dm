/datum/job/station/off_duty/cargo
	title = "Off-duty Cargo"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /datum/outfit/job/station/assistant/cargo
	desc = "Off-duty crew has no responsibilities or authority and is just there to spend their \"well-deserved\" time off."
	pto_type = PTO_CARGO
	economic_modifier = 2
