
/area/endeavour/surfacebase
	name = "Surface Base"

/area/endeavour/surfacebase/outside
	name = "Outside - Surface"
	sound_env = MOUNTAINS
	is_outside = OUTSIDE_YES

/area/endeavour/surfacebase/outside/outside1
	icon_state = "outside1"

/area/endeavour/surfacebase/outside/outside2
	icon_state = "outside2"

/area/endeavour/surfacebase/outside/outside3
	icon_state = "outside3"

/area/endeavour/surfacebase/outside/empty
	name = "Outside - Empty Area"

/area/endeavour/surfacebase/outside/wilderness
	name = "Outside - Wilderness"
	icon_state = "invi"

/area/endeavour/surfacebase/temple
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "red"
/area/endeavour/surfacebase/crash
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "yellow"
/area/endeavour/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"
	area_flags = AREA_FLAG_ERODING
/area/endeavour/surfacebase/atrium_one
	name = "\improper Atrium First Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/endeavour/surfacebase/atrium_two
	name = "\improper Atrium Second Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/endeavour/surfacebase/atrium_three
	name = "\improper Atrium Third Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/endeavour/surfacebase/north_stairs_one
	name = "\improper North Stairwell First Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/endeavour/surfacebase/north_stairs_two
	name = "\improper North Stairwell Second Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/endeavour/surfacebase/north_stairs_three
	name = "\improper North Stairwell Third Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/endeavour/surfacebase/public_garden_one
	name = "\improper Public Garden First Floor"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/endeavour/surfacebase/public_garden_two
	name = "\improper Public Garden Second Floor"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/endeavour/surfacebase/public_garden_three
	name = "\improper Public Garden Third Floor"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES
	
/area/endeavour/surfacebase/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES
	
/area/endeavour/surfacebase/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR
/area/endeavour/surfacebase/fishing_garden
	name = "\improper Fish Pond"
	icon_state = "blue"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/endeavour/surfacebase/sauna
	name = "\improper Public Sauna"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/endeavour/surfacebase/lounge
	name = "\improper Station Lounge"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

// /area/endeavour/surfacebase/east_stairs_one //This is just part of a lower hallway
/area/endeavour/surfacebase/east_stairs_two
	name = "\improper East Stairwell Second Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

// /area/endeavour/surfacebase/east_stairs_three //This is just part of an upper hallway
/area/endeavour/surfacebase/emergency_storage
	icon_state = "emergencystorage"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/endeavour/surfacebase/emergency_storage/panic_shelter
	name = "\improper Panic Shelter Emergency Storage"
/area/endeavour/surfacebase/emergency_storage/rnd
	name = "\improper RnD Emergency Storage"
/area/endeavour/surfacebase/emergency_storage/atmos
	name = "\improper Atmospherics Emergency Storage"
/area/endeavour/surfacebase/emergency_storage/atrium
	name = "\improper Atrium Emergency Storage"
// Main mining area
/area/endeavour/surfacebase/mining_main
	icon_state = "outpost_mine_main"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS
/area/endeavour/surfacebase/mining_main/airlock
	name = "\improper Mining Airlock"
/area/endeavour/surfacebase/mining_main/storage
	name = "\improper Mining Gear Storage"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
/area/endeavour/surfacebase/mining_main/uxstorage
	name = "\improper Mining Secondary Storage"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
/area/endeavour/surfacebase/mining_main/ore
	name = "\improper Mining Ore Storage"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
/area/endeavour/surfacebase/mining_main/eva
	name = "\improper Mining EVA"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
/area/endeavour/surfacebase/mining_main/break_room
	name = "\improper Mining Crew Area"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE
/area/endeavour/surfacebase/mining_main/refinery
	name = "\improper Mining Refinery"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
/area/endeavour/surfacebase/mining_main/external
	name = "\improper Mining Refinery"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
/area/endeavour/surfacebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/endeavour/surfacebase/mining_main/lobby
	name = "\improper Mining Lobby"
// Solars map areas
/area/endeavour/outpost/solars_outside
	name = "\improper Solar Farm"
	is_outside = OUTSIDE_YES
/area/endeavour/outpost/solars_shed
	name = "\improper Solar Farm Shed"
//Surface med
/area/endeavour/surfacebase/medical
	icon_state = "medical"
/area/endeavour/surfacebase/medical/lobby
	name = "\improper Surface Medical Lobby"
/area/endeavour/surfacebase/medical/triage
	name = "\improper Surface Triage"
/area/endeavour/surfacebase/medical/first_aid_west
	name = "\improper First Aid West"
//Surface sec
/area/endeavour/surfacebase/security
	icon_state = "security"
/area/endeavour/surfacebase/security/breakroom
	name = "\improper Surface Security Break Room"
/area/endeavour/surfacebase/security/lobby
	name = "\improper Surface Security Lobby"
/area/endeavour/surfacebase/security/common
	name = "\improper Surface Security Room"
/area/endeavour/surfacebase/security/armory
	name = "\improper Surface Armory"
/area/endeavour/surfacebase/security/checkpoint
	name = "\improper Surface Checkpoint Office"
/area/endeavour/surfacebase/security/hallway
	name = "\improper Surface Checkpoint Hallway"
//Misc
/area/endeavour/surfacebase/shuttle_pad
	name = "\improper Victory Shuttle Pad"
/area/endeavour/surfacebase/reading_room
	name = "\improper Reading Room"
/area/endeavour/surfacebase/vacant_site
	name = "\improper Vacant Site"

/area/endeavour/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/endeavour/surfacebase
	name = "Victory Debug Surface"

/area/endeavour/transit
	name = "Victory Debug Transit"
	requires_power = 0

/area/endeavour/space
	name = "Victory Debug Space"
	requires_power = 0

/area/endeavour/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"

/area/endeavour/station/stairs_four
	name = "\improper Station Stairwell Fourth Floor"
	icon_state = "dk_yellow"
/area/endeavour/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/endeavour/station/dock_two
	name = "\improper Dock Two"
	icon_state = "dk_yellow"
