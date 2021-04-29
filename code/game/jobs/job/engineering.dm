//////////////////////////////////
//		Chief Engineer
//////////////////////////////////
/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = CHIEF
	departments_managed = list(DEPARTMENT_ENGINEERING)
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_COMMAND)
	sorting_order = 2
	department_flag = ENGSEC
	disallow_jobhop = TRUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Facility Director"
	selection_color = "#7F6E2C"
	idtype = /obj/item/card/id/engineering/head
	req_admin_notify = 1
	economic_modifier = 10

	minimum_character_age = 25
	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	alt_titles = list("Engineering Director")

	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/engineering/chief_engineer
	job_description = "The Chief Engineer manages the Engineering Department, ensuring that the Engineers work on what needs to be done, handling distribution \
						of manpower as much as they handle hands-on operations and repairs. They are also expected to keep the rest of the station informed of \
						any structural threats to the station that may be hazardous to health or disruptive to work."

//////////////////////////////////
//			Engineer
//////////////////////////////////
/datum/job/engineer
	title = "Station Engineer"
	flag = ENGINEER
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Chief Engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/engineer
	economic_modifier = 5
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
	alt_titles = list("Maintenance Technician","Engine Technician","Electrician","Shipwright","Apprentice Engineer")

	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer
	job_description = "An Engineer keeps the station running. They repair damages, keep the atmosphere stable, and ensure that power is being \
						generated and distributed. On quiet shifts, they may be called upon to make cosmetic alterations to the station."

// Engineer Alt Titles
/datum/alt_title/maint_tech
	title = "Maintenance Technician"
	title_blurb = "A Maintenance Technician is generally a junior Engineer, and can be expected to run the mildly unpleasant or boring tasks that other \
					Engineers don't care to do."

/datum/alt_title/engine_tech
	title = "Engine Technician"
	title_blurb = "An Engine Technician tends to the engine, most commonly a Supermatter crystal. They are expected to be able to keep it stable, and \
					possibly even run it beyond normal tolerances."

/datum/alt_title/electrician
	title = "Electrician"
	title_blurb = "An Electrician's primary duty is making sure power is properly distributed thoughout the station, utilizing solars, substations, and other \
					methods to ensure every department has power in an emergency."

//////////////////////////////////
//			Atmos Tech
//////////////////////////////////
/datum/job/atmos
	title = "Atmospheric Technician"
	flag = ATMOSTECH
	departments = list(DEPARTMENT_ENGINEERING)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief engineer"
	selection_color = "#5B4D20"
	idtype = /obj/item/card/id/engineering/atmos
	economic_modifier = 5
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_external_airlocks)
	minimal_access = list(access_eva, access_engine, access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction, access_external_airlocks)
	alt_titles = list("Firefighter", "Pipe Network Specialist")

	minimal_player_age = 3

	outfit_type = /decl/hierarchy/outfit/job/engineering/atmos
