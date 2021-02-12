/*
/////////////////////////////////////////////////////////////////
//This file exists for collating and organising non-space areas//
//that aren't on station or in away missions. Such as planets.///
/////////////////////////////////////////////////////////////////
*/

//Triumph specific Areas

/area/triumph/surfacebase
	icon = 'icons/turf/areas.dmi'
/area/triumph/surfacebase/outside
	name = "Outside - Surface"
	sound_env = MOUNTAINS
/area/triumph/surfacebase/outside/outside1
	icon_state = "outside1"
/area/triumph/surfacebase/outside/outside2
	icon_state = "outside2"
/area/triumph/surfacebase/outside/outside3
	icon_state = "outside3"
/area/triumph/surfacebase/outside/empty
	name = "Outside - Empty Area"
/area/triumph/surfacebase/outside/wilderness
	name = "Outside - Wilderness"
	icon_state = "invi"
	forced_ambience = list('sound/music/Sacred_Grove.ogg')
/area/triumph/surfacebase/temple
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "red"
/area/triumph/surfacebase/crash
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "yellow"
/area/triumph/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/atrium_one
	name = "\improper Atrium First Floor"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/atrium_two
	name = "\improper Atrium Second Floor"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/atrium_three
	name = "\improper Atrium Third Floor"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/north_stairs_one
	name = "\improper North Stairwell First Floor"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/north_staires_two
	name = "\improper North Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/north_stairs_three
	name = "\improper North Stairwell Third Floor"
	icon_state = "dk_yellow"
/area/triumph/surfacebase/public_garden_one
	name = "\improper Public Garden First Floor"
	icon_state = "green"
/area/triumph/surfacebase/public_garden_two
	name = "\improper Public Garden Second Floor"
	icon_state = "green"
/area/triumph/surfacebase/public_garden_three
	name = "\improper Public Garden Third Floor"
	icon_state = "green"
/area/triumph/surfacebase/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
/area/triumph/surfacebase/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR
/area/triumph/surfacebase/fishing_garden
	name = "\improper Fish Pond"
	icon_state = "blue"
/area/triumph/surfacebase/sauna
	name = "\improper Public Sauna"
	icon_state = "green"
/area/triumph/surfacebase/lounge
	name = "\improper Station Lounge"
	icon_state = "purple"
// /area/triumph/surfacebase/east_stairs_one //This is just part of a lower hallway
/area/triumph/surfacebase/east_stairs_two
	name = "\improper East Stairwell Second Floor"
	icon_state = "dk_yellow"
// /area/triumph/surfacebase/east_stairs_three //This is just part of an upper hallway
/area/triumph/surfacebase/emergency_storage
	icon_state = "emergencystorage"
/area/triumph/surfacebase/emergency_storage/panic_shelter
	name = "\improper Panic Shelter Emergency Storage"
/area/triumph/surfacebase/emergency_storage/rnd
	name = "\improper RnD Emergency Storage"
/area/triumph/surfacebase/emergency_storage/atmos
	name = "\improper Atmospherics Emergency Storage"
/area/triumph/surfacebase/emergency_storage/atrium
	name = "\improper Atrium Emergency Storage"
// Main mining area
/area/triumph/surfacebase/mining_main
	icon_state = "outpost_mine_main"
/area/triumph/surfacebase/mining_main/airlock
	name = "\improper Mining Airlock"
/area/triumph/surfacebase/mining_main/storage
	name = "\improper Mining Gear Storage"
/area/triumph/surfacebase/mining_main/uxstorage
	name = "\improper Mining Secondary Storage"
/area/triumph/surfacebase/mining_main/ore
	name = "\improper Mining Ore Storage"
/area/triumph/surfacebase/mining_main/eva
	name = "\improper Mining EVA"
/area/triumph/surfacebase/mining_main/break_room
	name = "\improper Mining Crew Area"
/area/triumph/surfacebase/mining_main/refinery
	name = "\improper Mining Refinery"
/area/triumph/surfacebase/mining_main/external
	name = "\improper Mining Refinery"
/area/triumph/surfacebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/triumph/surfacebase/mining_main/lobby
	name = "\improper Mining Lobby"
// Solars map areas
/area/triumph/outpost/solars_outside
	name = "\improper Solar Farm"
/area/triumph/outpost/solars_shed
	name = "\improper Solar Farm Shed"
//Surface med
/area/triumph/surfacebase/medical
	icon_state = "medical"
/area/triumph/surfacebase/medical/lobby
	name = "\improper Surface Medical Lobby"
/area/triumph/surfacebase/medical/triage
	name = "\improper Surface Triage"
/area/triumph/surfacebase/medical/first_aid_west
	name = "\improper First Aid West"
//Surface sec
/area/triumph/surfacebase/security
	icon_state = "security"
/area/triumph/surfacebase/security/breakroom
	name = "\improper Surface Security Break Room"
/area/triumph/surfacebase/security/lobby
	name = "\improper Surface Security Lobby"
/area/triumph/surfacebase/security/common
	name = "\improper Surface Security Room"
/area/triumph/surfacebase/security/armory
	name = "\improper Surface Armory"
/area/triumph/surfacebase/security/checkpoint
	name = "\improper Surface Checkpoint Office"
/area/triumph/surfacebase/security/hallway
	name = "\improper Surface Checkpoint Hallway"
//Misc
/area/triumph/surfacebase/shuttle_pad
	name = "\improper Triumph Shuttle Pad"
/area/triumph/surfacebase/reading_room
	name = "\improper Reading Room"
/area/triumph/surfacebase/vacant_site
	name = "\improper Vacant Site"
//Shuttle crashes
/area/shuttle/triumph/crash1
	name = "\improper Crash Site 1"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/triumph
/area/shuttle/triumph/crash2
	name = "\improper Crash Site 2"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/triumph


// Mining Underdark

/*	Commented for now until planetary turf generation is consolidated.
Uncomment when these areas can have their respective base turf.
/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/virgo3b
/area/mine/explored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/virgo3b
*/

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"


//Trade Port areas
/area/tradeport
	name = "\improper Trade Port"
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark"
	requires_power = 1

/area/tradeport/facility
	icon_state = "red"

/area/tradeport/engineering
	icon_state = "yellow"

/area/tradeport/commons
	icon_state = "green"

/area/tradeport/dock
	name = "\improper Trade Port Dock"
	icon_state = "blue"

/area/tradeport/pads
	icon_state = "purple"

/area/tradeport/spine
	name = "\improper Commerce Spine"
	icon_state = "red"

/area/tradeport/commhall
	name = "\improper Commerce Hall"
	icon_state = "yellow"

/area/tradeport/safari
	name = "\improper Safari Shop"
	icon_state = "green"

/area/tradeport/safarizoo
	name = "\improper Safari Zone"
	icon_state = "blue"

//////// Mothership areas ////////
/area/mothership
	requires_power = 1
	flags = RAD_SHIELDED
	base_turf = /turf/space
	icon_state = "blue-red2"
/area/mothership/breakroom
	name = "Warship - Breakroom"
/area/mothership/hydroponics
	name = "Warship - Hydroponics"
/area/mothership/kitchen
	name = "Warship - Kitchen"
/area/mothership/eva
	name = "Warship - EVA"
/area/mothership/bathroom1
	name = "Warship - Bathroom 1"
/area/mothership/bathroom2
	name = "Warship - Bathroom 2"
/area/mothership/dorm1
	name = "Warship - Dorm 1"
/area/mothership/dorm2
	name = "Warship - Dorm 2"
/area/mothership/dorm3
	name = "Warship - Dorm 3"
/area/mothership/dorm4
	name = "Warship - Dorm 4"
/area/mothership/dorm5
	name = "Warship - Dorm 5"
/area/mothership/dorm6
	name = "Warship - Dorm 6"
/area/mothership/chemistry
	name = "Warship - Chemistry"
/area/mothership/surgery
	name = "Warship - Surgery"
/area/mothership/vault
	name = "Warship - Vault"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/mothership/teleporter
	name = "Warship - Teleporter Room"
/area/mothership/security
	name = "Warship - Security Equipment"
/area/mothership/treatment
	name = "Warship - Treatment Center"
/area/mothership/medical
	name = "Warship - Medical Equipment"
/area/mothership/resleeving
	name = "Warship - Resleeving"
/area/mothership/morgue
	name = "Warship - Morgue"
/area/mothership/rnd
	name = "Warship - Research"
/area/mothership/robotics
	name = "Warship - Robotics"
/area/mothership/sechallway
	name = "Warship - Security Hallway"
/area/mothership/processing
	name = "Warship - Processing"
/area/mothership/warden
	name = "Warship - Warden"
/area/mothership/armory
	name = "Warship - Armory"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/mothership/bridge
	name = "Warship - Bridge"
/area/mothership/holodeck
	name = "Warship - Holodeck Controls"
/area/mothership/holodeck/holo
	name = "Warship - Holodeck"
	icon_state = "dk_yellow"
/area/mothership/cryotube
	name = "Warship - Cryo chamber"
/area/mothership/engineering
	name = "Warship - Engineering"
/area/mothership/hallway
	name = "Warship - Main Hallway"
/area/mothership/telecomms1
	name = "Warship - Telecommunications Main"
/area/mothership/telecomms2
	name = "Warship - Telecommunications Relay"


// Skipjack
/area/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC
/area/skipjack_station/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north
/area/skipjack_station/orbit
	name = "near the Tether"
	icon_state = "northwest"
/area/skipjack_station/arrivals_dock
	name = "\improper docked with Tether"
	icon_state = "shuttle"


// Ninja areas
/area/ninja_dojo
	name = "\improper Ninja Base"
	icon_state = "green"
	requires_power = 0
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC
/area/ninja_dojo/dojo
	name = "\improper Clan Dojo"
	dynamic_lighting = 0
/area/ninja_dojo/start
	name = "\improper Clan Dojo"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating
/area/ninja_dojo/orbit
	name = "near the Tether"
	icon_state = "south"
/area/ninja_dojo/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north
/area/ninja_dojo/arrivals_dock
	name = "\improper docked with Tether"
	icon_state = "shuttle"
	dynamic_lighting = 0