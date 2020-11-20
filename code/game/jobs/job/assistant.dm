/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant
	alt_titles = list("Visitor" = /decl/hierarchy/outfit/job/assistant/visitor, "Tourist")

/datum/job/assistant/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/datum/job/assistant		// Visitor
	title = USELESS_JOB
	supervisors = "nobody! You don't work here"
	timeoff_factor = 0

/datum/job/assistant/New()
	..()
	if(config)
		total_positions = config_legacy.limit_visitors
		spawn_positions = config_legacy.limit_visitors

/datum/job/assistant/get_access()
	return list()

/datum/job/intern
	title = "Intern"
	flag = INTERN
	department = "Civilian"
	department_flag = ENGSEC // Ran out of bits
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the staff from the department you're interning in"
	selection_color = "#555555"
	economic_modifier = 2
	access = list()			//See /datum/job/intern/get_access()
	minimal_access = list()	//See /datum/job/intern/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant/intern
	alt_titles = list("Assistant", "Apprentice Engineer","Medical Intern","Lab Assistant","Security Cadet","Jr. Cargo Tech", "Jr. Explorer", "Server" = /decl/hierarchy/outfit/job/service/server)
	timeoff_factor = 0 // Interns, noh

/datum/job/intern/New()
	..()
	if(config)
		total_positions = config_legacy.limit_interns
		spawn_positions = config_legacy.limit_interns

/datum/job/intern/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

//Sweet test line bro.