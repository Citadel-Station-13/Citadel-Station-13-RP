
/area/victory/surfacebase
	name = "Surface Base"

/area/victory/surfacebase/outside
	name = "Outside - Surface"
	sound_env = MOUNTAINS
	is_outside = OUTSIDE_YES

/area/victory/surfacebase/outside/outside1
	icon_state = "outside1"

/area/victory/surfacebase/outside/outside2
	icon_state = "outside2"

/area/victory/surfacebase/outside/outside3
	icon_state = "outside3"

/area/victory/surfacebase/outside/empty
	name = "Outside - Empty Area"

/area/victory/surfacebase/outside/wilderness
	name = "Outside - Wilderness"
	icon_state = "invi"

/area/victory/surfacebase/temple
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "red"
/area/victory/surfacebase/crash
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "yellow"
/area/victory/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"
	area_flags = AREA_FLAG_ERODING
/area/victory/surfacebase/atrium_one
	name = "\improper Atrium First Floor"
	icon_state = "dk_yellow"
/area/victory/surfacebase/atrium_two
	name = "\improper Atrium Second Floor"
	icon_state = "dk_yellow"
/area/victory/surfacebase/atrium_three
	name = "\improper Atrium Third Floor"
	icon_state = "dk_yellow"
/area/victory/surfacebase/north_stairs_one
	name = "\improper North Stairwell First Floor"
	icon_state = "dk_yellow"
/area/victory/surfacebase/north_stairs_two
	name = "\improper North Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/victory/surfacebase/north_stairs_three
	name = "\improper North Stairwell Third Floor"
	icon_state = "dk_yellow"
/area/victory/surfacebase/public_garden_one
	name = "\improper Public Garden First Floor"
	icon_state = "green"
/area/victory/surfacebase/public_garden_two
	name = "\improper Public Garden Second Floor"
	icon_state = "green"
/area/victory/surfacebase/public_garden_three
	name = "\improper Public Garden Third Floor"
	icon_state = "green"
/area/victory/surfacebase/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
/area/victory/surfacebase/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR
/area/victory/surfacebase/fishing_garden
	name = "\improper Fish Pond"
	icon_state = "blue"
/area/victory/surfacebase/sauna
	name = "\improper Public Sauna"
	icon_state = "green"
/area/victory/surfacebase/lounge
	name = "\improper Station Lounge"
	icon_state = "purple"
// /area/victory/surfacebase/east_stairs_one //This is just part of a lower hallway
/area/victory/surfacebase/east_stairs_two
	name = "\improper East Stairwell Second Floor"
	icon_state = "dk_yellow"
// /area/victory/surfacebase/east_stairs_three //This is just part of an upper hallway
/area/victory/surfacebase/emergency_storage
	icon_state = "emergencystorage"
/area/victory/surfacebase/emergency_storage/panic_shelter
	name = "\improper Panic Shelter Emergency Storage"
/area/victory/surfacebase/emergency_storage/rnd
	name = "\improper RnD Emergency Storage"
/area/victory/surfacebase/emergency_storage/atmos
	name = "\improper Atmospherics Emergency Storage"
/area/victory/surfacebase/emergency_storage/atrium
	name = "\improper Atrium Emergency Storage"
// Main mining area
/area/victory/surfacebase/mining_main
	icon_state = "outpost_mine_main"
/area/victory/surfacebase/mining_main/airlock
	name = "\improper Mining Airlock"
/area/victory/surfacebase/mining_main/storage
	name = "\improper Mining Gear Storage"
/area/victory/surfacebase/mining_main/uxstorage
	name = "\improper Mining Secondary Storage"
/area/victory/surfacebase/mining_main/ore
	name = "\improper Mining Ore Storage"
/area/victory/surfacebase/mining_main/eva
	name = "\improper Mining EVA"
/area/victory/surfacebase/mining_main/break_room
	name = "\improper Mining Crew Area"
/area/victory/surfacebase/mining_main/refinery
	name = "\improper Mining Refinery"
/area/victory/surfacebase/mining_main/external
	name = "\improper Mining Refinery"
/area/victory/surfacebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/victory/surfacebase/mining_main/lobby
	name = "\improper Mining Lobby"
// Solars map areas
/area/victory/outpost/solars_outside
	name = "\improper Solar Farm"
	is_outside = OUTSIDE_YES
/area/victory/outpost/solars_shed
	name = "\improper Solar Farm Shed"
//Surface med
/area/victory/surfacebase/medical
	icon_state = "medical"
/area/victory/surfacebase/medical/lobby
	name = "\improper Surface Medical Lobby"
/area/victory/surfacebase/medical/triage
	name = "\improper Surface Triage"
/area/victory/surfacebase/medical/first_aid_west
	name = "\improper First Aid West"
//Surface sec
/area/victory/surfacebase/security
	icon_state = "security"
/area/victory/surfacebase/security/breakroom
	name = "\improper Surface Security Break Room"
/area/victory/surfacebase/security/lobby
	name = "\improper Surface Security Lobby"
/area/victory/surfacebase/security/common
	name = "\improper Surface Security Room"
/area/victory/surfacebase/security/armory
	name = "\improper Surface Armory"
/area/victory/surfacebase/security/checkpoint
	name = "\improper Surface Checkpoint Office"
/area/victory/surfacebase/security/hallway
	name = "\improper Surface Checkpoint Hallway"
//Misc
/area/victory/surfacebase/shuttle_pad
	name = "\improper Victory Shuttle Pad"
/area/victory/surfacebase/reading_room
	name = "\improper Reading Room"
/area/victory/surfacebase/vacant_site
	name = "\improper Vacant Site"

/area/victory/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/victory/surfacebase
	name = "Victory Debug Surface"

/area/victory/transit
	name = "Victory Debug Transit"
	requires_power = 0

/area/victory/space
	name = "Victory Debug Space"
	requires_power = 0

/area/victory/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"

/area/victory/station/stairs_four
	name = "\improper Station Stairwell Fourth Floor"
	icon_state = "dk_yellow"
/area/victory/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/victory/station/dock_two
	name = "\improper Dock Two"
	icon_state = "dk_yellow"
