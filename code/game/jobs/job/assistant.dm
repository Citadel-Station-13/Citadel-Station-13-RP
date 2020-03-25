<<<<<<< HEAD
=======
//VOREStation Edit - Basically this whole file
/datum/job/intern
	title = "Intern"
	flag = INTERN
	department = "Civilian"
	department_flag = ENGSEC // VOREStation Edit - Ran out of bits
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the staff from the departmen you're interning in"
	selection_color = "#555555"
	economic_modifier = 2
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit_type = /decl/hierarchy/outfit/job/assistant/intern
	alt_titles = list("Apprentice Engineer","Medical Intern","Lab Assistant","Security Cadet","Jr. Cargo Tech","Assistant") //VOREStation Edit
	timeoff_factor = 0 //VOREStation Edit - Interns, noh

//VOREStation Add
/datum/job/intern/New()
	..()
	if(config_legacy)
		total_positions = config_legacy.limit_interns
		spawn_positions = config_legacy.limit_interns
//VOREStation Add End

// VOREStation Add
>>>>>>> citrp/master
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
<<<<<<< HEAD
/*	alt_titles = list(
		"Technical Assistant",
		"Medical Intern",
		"Research Assistant",
		"Visitor" = /decl/hierarchy/outfit/job/assistant/visitor
	)	*/	//VOREStation Removal: no alt-titles for visitors

=======
	timeoff_factor = 0
/datum/job/assistant/New()
	..()
	if(config_legacy)
		total_positions = config_legacy.limit_visitors
		spawn_positions = config_legacy.limit_visitors
>>>>>>> citrp/master
/datum/job/assistant/get_access()
	if(config_legacy.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
