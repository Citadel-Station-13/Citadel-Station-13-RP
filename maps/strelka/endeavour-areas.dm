
/area/strelka/surfacebase
	name = "Surface Base"

/area/strelka/surfacebase/outside
	name = "Outside - Surface"
	sound_env = MOUNTAINS
	is_outside = OUTSIDE_YES

/area/strelka/surfacebase/outside/outside1
	icon_state = "outside1"

/area/strelka/surfacebase/outside/outside2
	icon_state = "outside2"

/area/strelka/surfacebase/outside/outside3
	icon_state = "outside3"

/area/strelka/surfacebase/outside/empty
	name = "Outside - Empty Area"

/area/strelka/surfacebase/outside/wilderness
	name = "Outside - Wilderness"
	icon_state = "invi"

/area/strelka/surfacebase/temple
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "red"
/area/strelka/surfacebase/crash
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "yellow"
/area/strelka/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"
	area_flags = AREA_FLAG_ERODING
/area/strelka/surfacebase/atrium_one
	name = "\improper Atrium First Floor"
	icon_state = "dk_yellow"
/area/strelka/surfacebase/atrium_two
	name = "\improper Atrium Second Floor"
	icon_state = "dk_yellow"
/area/strelka/surfacebase/atrium_three
	name = "\improper Atrium Third Floor"
	icon_state = "dk_yellow"
/area/strelka/surfacebase/north_stairs_one
	name = "\improper North Stairwell First Floor"
	icon_state = "dk_yellow"
/area/strelka/surfacebase/north_stairs_two
	name = "\improper North Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/strelka/surfacebase/north_stairs_three
	name = "\improper North Stairwell Third Floor"
	icon_state = "dk_yellow"
/area/strelka/surfacebase/public_garden_one
	name = "\improper Public Garden First Floor"
	icon_state = "green"
/area/strelka/surfacebase/public_garden_two
	name = "\improper Public Garden Second Floor"
	icon_state = "green"
/area/strelka/surfacebase/public_garden_three
	name = "\improper Public Garden Third Floor"
	icon_state = "green"
/area/strelka/surfacebase/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
/area/strelka/surfacebase/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR
/area/strelka/surfacebase/fishing_garden
	name = "\improper Fish Pond"
	icon_state = "blue"
/area/strelka/surfacebase/sauna
	name = "\improper Public Sauna"
	icon_state = "green"
/area/strelka/surfacebase/lounge
	name = "\improper Station Lounge"
	icon_state = "purple"
// /area/strelka/surfacebase/east_stairs_one //This is just part of a lower hallway
/area/strelka/surfacebase/east_stairs_two
	name = "\improper East Stairwell Second Floor"
	icon_state = "dk_yellow"
// /area/strelka/surfacebase/east_stairs_three //This is just part of an upper hallway
/area/strelka/surfacebase/emergency_storage
	icon_state = "emergencystorage"
/area/strelka/surfacebase/emergency_storage/panic_shelter
	name = "\improper Panic Shelter Emergency Storage"
/area/strelka/surfacebase/emergency_storage/rnd
	name = "\improper RnD Emergency Storage"
/area/strelka/surfacebase/emergency_storage/atmos
	name = "\improper Atmospherics Emergency Storage"
/area/strelka/surfacebase/emergency_storage/atrium
	name = "\improper Atrium Emergency Storage"
// Main mining area
/area/strelka/surfacebase/mining_main
	icon_state = "outpost_mine_main"
/area/strelka/surfacebase/mining_main/airlock
	name = "\improper Mining Airlock"
/area/strelka/surfacebase/mining_main/storage
	name = "\improper Mining Gear Storage"
/area/strelka/surfacebase/mining_main/uxstorage
	name = "\improper Mining Secondary Storage"
/area/strelka/surfacebase/mining_main/ore
	name = "\improper Mining Ore Storage"
/area/strelka/surfacebase/mining_main/eva
	name = "\improper Mining EVA"
/area/strelka/surfacebase/mining_main/break_room
	name = "\improper Mining Crew Area"
/area/strelka/surfacebase/mining_main/refinery
	name = "\improper Mining Refinery"
/area/strelka/surfacebase/mining_main/external
	name = "\improper Mining Refinery"
/area/strelka/surfacebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/strelka/surfacebase/mining_main/lobby
	name = "\improper Mining Lobby"
// Solars map areas
/area/strelka/outpost/solars_outside
	name = "\improper Solar Farm"
	is_outside = OUTSIDE_YES
/area/strelka/outpost/solars_shed
	name = "\improper Solar Farm Shed"
//Surface med
/area/strelka/surfacebase/medical
	icon_state = "medical"
/area/strelka/surfacebase/medical/lobby
	name = "\improper Surface Medical Lobby"
/area/strelka/surfacebase/medical/triage
	name = "\improper Surface Triage"
/area/strelka/surfacebase/medical/first_aid_west
	name = "\improper First Aid West"
//Surface sec
/area/strelka/surfacebase/security
	icon_state = "security"
/area/strelka/surfacebase/security/breakroom
	name = "\improper Surface Security Break Room"
/area/strelka/surfacebase/security/lobby
	name = "\improper Surface Security Lobby"
/area/strelka/surfacebase/security/common
	name = "\improper Surface Security Room"
/area/strelka/surfacebase/security/armory
	name = "\improper Surface Armory"
/area/strelka/surfacebase/security/checkpoint
	name = "\improper Surface Checkpoint Office"
/area/strelka/surfacebase/security/hallway
	name = "\improper Surface Checkpoint Hallway"
//Misc
/area/strelka/surfacebase/shuttle_pad
	name = "\improper Victory Shuttle Pad"
/area/strelka/surfacebase/reading_room
	name = "\improper Reading Room"
/area/strelka/surfacebase/vacant_site
	name = "\improper Vacant Site"

/area/strelka/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/strelka/surfacebase
	name = "Victory Debug Surface"

/area/strelka/transit
	name = "Victory Debug Transit"
	requires_power = 0

/area/strelka/space
	name = "Victory Debug Space"
	requires_power = 0

/area/strelka/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"

/area/strelka/station/stairs_four
	name = "\improper Station Stairwell Fourth Floor"
	icon_state = "dk_yellow"
/area/strelka/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/strelka/station/dock_two
	name = "\improper Dock Two"
	icon_state = "dk_yellow"
