#define Z_LEVEL_1_BALL					1
#define Z_LEVEL_2_BALL					2


/datum/map/ball
	name = "The Ball"
	full_name = "The Citadel Ball"
	path = "ball"
	allowed_jobs = list(/datum/job/chef, /datum/job/janitor, /datum/job/doctor, /datum/job/assistant, /datum/job/engineer)

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00")

	zlevel_datum_type = /datum/map_z_level/ball

	station_name  = "The Upper Eschalon"
	station_short = "Eschalon"
	dock_name     = "Eschalon Entry"
	boss_name     = "Ty Clarke"
	boss_short    = "Clarke"
	company_name  = "Eschalon Industries"
	company_short = "EI"
	starsys_name  = "Xiron"

	shuttle_docked_message = "The departure cruiser has arrived at the entrance, please finish your festivities and move there at your earliest convenience. It will depart in approximately %ETD%"
	shuttle_leaving_dock = "The departure cruiser has left. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "The departure cruiser has been called to take the guests home. Please finish your festivities and move there at your earliest convenience, it will arrive in %ETA%."
	shuttle_recall_message = "The departure cruiser has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

/datum/map_z_level/ball/first
	z = Z_LEVEL_1_BALL
	name = "First Floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 100


/datum/map_z_level/ball/second
	z = Z_LEVEL_2_BALL
	name = "Second Floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 100