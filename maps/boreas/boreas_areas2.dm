
//
// Surface Base Z Levels
//

/area/boreas/surfacebase
	icon = 'icons/turf/areas_vr.dmi'


/area/boreas/surfacebase/outside
	name = "Outside - Surface"
	sound_env = MOUNTAINS
/area/boreas/surfacebase/outside/outside1
	icon_state = "outside1"
/area/boreas/surfacebase/outside/outside2
	icon_state = "outside2"
/area/boreas/surfacebase/outside/outside3
	icon_state = "outside3"

/area/boreas/surfacebase/outside/empty
	name = "Outside - Empty Area"

/area/boreas/surfacebase/outside/wilderness
	name = "Outside - Wilderness"
	icon_state = "invi"
	forced_ambience = list('sound/music/Sacred_Grove.ogg')

/area/boreas/surfacebase/temple
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "red"

/area/boreas/surfacebase/crash
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "yellow"

/area/boreas/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"

/area/boreas/surfacebase/atrium_one
	name = "\improper Atrium First Floor"
	icon_state = "dk_yellow"
/area/boreas/surfacebase/atrium_two
	name = "\improper Atrium Second Floor"
	icon_state = "dk_yellow"
/area/boreas/surfacebase/atrium_three
	name = "\improper Atrium Third Floor"
	icon_state = "dk_yellow"

/area/boreas/surfacebase/north_stairs_one
	name = "\improper North Stairwell First Floor"
	icon_state = "dk_yellow"
/area/boreas/surfacebase/north_staires_two
	name = "\improper North Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/boreas/surfacebase/north_stairs_three
	name = "\improper North Stairwell Third Floor"
	icon_state = "dk_yellow"

/area/boreas/surfacebase/public_garden_one
	name = "\improper Public Garden First Floor"
	icon_state = "green"
/area/boreas/surfacebase/public_garden_two
	name = "\improper Public Garden Second Floor"
	icon_state = "green"
/area/boreas/surfacebase/public_garden_three
	name = "\improper Public Garden Third Floor"
	icon_state = "green"
/area/boreas/surfacebase/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
/area/boreas/surfacebase/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR

// Main mining area
/area/boreas/surfacebase/mining_main
	icon_state = "outpost_mine_main"
/area/boreas/surfacebase/mining_main/airlock
	name = "\improper Mining Airlock"
/area/boreas/surfacebase/mining_main/storage
	name = "\improper Mining Gear Storage"
/area/boreas/surfacebase/mining_main/uxstorage
	name = "\improper Mining Secondary Storage"
/area/boreas/surfacebase/mining_main/ore
	name = "\improper Mining Ore Storage"
/area/boreas/surfacebase/mining_main/eva
	name = "\improper Mining EVA"
/area/boreas/surfacebase/mining_main/break_room
	name = "\improper Mining Crew Area"
/area/boreas/surfacebase/mining_main/refinery
	name = "\improper Mining Refinery"
/area/boreas/surfacebase/mining_main/external
	name = "\improper Mining Refinery"
/area/boreas/surfacebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/boreas/surfacebase/mining_main/lobby
	name = "\improper Mining Lobby"

// Mining Underdark
/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/boreas
/area/mine/explored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/boreas

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"

/area/engineering/atmos/processing
	name = "Atmospherics Processing"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED

/area/engineering/atmos/hallway
	name = "\improper Atmospherics Main Hallway"
/area/engineering/lower/lobby
	name = "\improper Enginering Surface Lobby"
/area/engineering/lower/breakroom
	name = "\improper Enginering Surface Break Room"
/area/engineering/lower/corridor
	name = "\improper Tether Lower Service Corridor"
/area/engineering/lower/atmos_lockers
	name = "\improper Engineering Atmos Locker Room"
/area/engineering/lower/atmos_eva
	name = "\improper Engineering Atmos EVA"


/area/engineering/atmos/intake
	name = "\improper Atmospherics Intake"
	icon_state = "atmos"
	sound_env = MOUNTAINS

/area/gateway/prep_room
	name = "\improper Gateway Prep Room"
/area/crew_quarters/locker/laundry_arrival
	name = "\improper Arrivals Laundry"

/area/maintenance/lower
	icon_state = "fsmaint"

/area/maintenance/lower/xenoflora
	name = "\improper Xenoflora Maintenance"
/area/maintenance/lower/research
	name = "\improper Research Maintenance"
/area/maintenance/lower/atmos
	name = "\improper Atmospherics Maintenance"
/area/maintenance/lower/locker_room
	name = "\improper Locker Room Maintenance"
/area/maintenance/lower/vacant_site
	name = "\improper Vacant Site Maintenance"
/area/maintenance/lower/atrium
	name = "\improper Atrium Maintenance"
/area/maintenance/lower/rnd
	name = "\improper RnD Maintenance"
/area/maintenance/lower/north
	name = "\improper North Maintenance"
/area/maintenance/lower/bar
	name = "\improper Bar Maintenance"
/area/maintenance/lower/mining
	name = "\improper Mining Maintenance"
/area/maintenance/lower/south
	name = "\improper South Maintenance"
/area/maintenance/lower/trash_pit
	name = "\improper Trash Pit"
/area/maintenance/lower/solars
	name = "\improper Solars Maintenance"
/area/maintenance/lower/mining_eva
	name = "\improper Mining EVA Maintenance"
/area/maintenance/lower/public_garden_maintenence
	name = "\improper Public Garden Maintenance"

// Research
/area/rnd/xenobiology/xenoflora/lab_atmos
	name = "\improper Xenoflora Atmospherics Lab"
/area/rnd/breakroom
	name = "\improper Research Break Room"
	icon_state = "research"
/area/rnd/reception_desk
	name = "\improper Research Reception Desk"
	icon_state = "research"
/area/rnd/lockers
	name = "\improper Research Locker Room"
	icon_state = "research"
/area/rnd/external
	name = "\improper Research External Access"
	icon_state = "research"
/area/rnd/hallway
	name = "\improper Research Lower Hallway"
	icon_state = "research"
/area/rnd/anomaly_lab
	name = "\improper Anomaly Lab"
	icon_state = "research"
/area/rnd/anomaly_lab/containment_one
	name = "\improper Anomaly Lab - Containment One"
	icon_state = "research"
/area/rnd/anomaly_lab/containment_two
	name = "\improper Anomaly Lab - Containment Two"
	icon_state = "research"
/area/rnd/xenoarch_storage
	name = "\improper Xenoarch Storage"
	icon_state = "research"
// Misc
/area/hallway/lower/third_south
	name = "\improper Hallway Third Floor South"
	icon_state = "hallC1"
/area/hallway/lower/first_west
	name = "\improper Hallway First Floor West"
	icon_state = "hallC1"

/area/storage/surface_eva
	icon_state = "storage"
	name = "\improper Surface EVA"
/area/storage/surface_eva/external
	name = "\improper Surface EVA Access"

/area/boreas/surfacebase/shuttle_pad
	name = "\improper Boreas Shuttle Pad"
/area/boreas/surfacebase/reading_room
	name = "\improper Reading Room"
/area/boreas/surfacebase/vacant_site
	name = "\improper Vacant Site"
/area/crew_quarters/freezer
	name = "\improper Kitchen Freezer"
/area/crew_quarters/panic_shelter
	name = "\improper Panic Shelter"



//
// Station Z Levels
//
// Note: Fore is NORTH

/area/boreas/station/stairs_one
	name = "\improper Station Stairwell First Floor"
	icon_state = "dk_yellow"
/area/boreas/station/stairs_two
	name = "\improper Station Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/boreas/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"
/area/boreas/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/boreas/station/dock_two
	name = "\improper Dock Two"
	icon_state = "dk_yellow"

/area/crew_quarters/showers
	name = "\improper Unisex Showers"
	icon_state = "recreation_area_restroom"

/area/crew_quarters/sleep/maintDorm1
	name = "\improper Construction Dorm 1"
	icon_state = "Sleep"

/area/crew_quarters/sleep/maintDorm2
	name = "\improper Construction Dorm 2"
	icon_state = "Sleep"

/area/crew_quarters/sleep/maintDorm3
	name = "\improper Construction Dorm 3"
	icon_state = "Sleep"

/area/crew_quarters/sleep/maintDorm4
	name = "\improper Construction Dorm 4"
	icon_state = "Sleep"

/area/crew_quarters/sleep/Dorm_1/holo
	name = "\improper Dorm 1 Holodeck"
	icon_state = "dk_yellow"

/area/crew_quarters/sleep/Dorm_3/holo
	name = "\improper Dorm 3 Holodeck"
	icon_state = "dk_yellow"

/area/crew_quarters/sleep/Dorm_5/holo
	name = "\improper Dorm 5 Holodeck"
	icon_state = "dk_yellow"

/area/crew_quarters/sleep/Dorm_7/holo
	name = "\improper Dorm 7 Holodeck"
	icon_state = "dk_yellow"

/area/holodeck/holodorm/source_basic
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_desert
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_seating
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_beach
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_garden
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_boxing
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_snow
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_space
	name = "\improper Holodeck Source"
/area/holodeck/holodorm/source_off
	name = "\improper Holodeck Source"

/area/ai/foyer
	name = "\improper AI Core Access"

/area/medical/virologyisolation
	name = "\improper Virology Isolation"
	icon_state = "virology"
/area/medical/recoveryrestroom
	name = "\improper Recovery Room Restroom"
	icon_state = "virology"

/area/security/hallway
	name = "\improper Security Hallway"
	icon_state = "security"
/area/security/hallwayaux
	name = "\improper Security Armory Hallway"
	icon_state = "security"
/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "security"
/area/security/breakroom
	name = "\improper Security Breakroom"
	icon_state = "security"
/area/security/brig/visitation
	name = "\improper Visitation"
	icon_state = "security"
/area/security/brig/bathroom
	name = "\improper Brig Bathroom"
	icon_state = "security"
/area/security/armory/blue
	name = "\improper Armory - Blue"
	icon_state = "armory"
/area/security/armory/red
	name = "\improper Armory - Red"
	icon_state = "red2"
/area/security/observation
	name = "\improper Brig Observation"
	icon_state = "riot_control"
/area/security/eva
	name = "\improper Security EVA"
	icon_state = "security_equip_storage"
/area/security/recstorage
	name = "\improper Brig Recreation Storage"
	icon_state = "brig"

/area/engineering/atmos/backup
	name = "\improper Backup Atmospherics"
/area/engineering/engine_balcony
	name = "\improper Engine Room Balcony"
/area/engineering/foyer_mezzenine
	name = "\improper Engineering Mezzenine"

/area/hallway/station
	icon_state = "hallC1"
/area/hallway/station/atrium
	name = "\improper Main Station Atrium"
/area/hallway/station/port
	name = "\improper Main Port Hallway"
/area/hallway/station/starboard
	name = "\improper Main Starboard Hallway"
/area/hallway/station/upper
	name = "\improper Main Upper Hallway"
/area/hallway/station/docks
	name = "\improper Docks Hallway"

/area/boreas/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR

/area/shuttle/boreas/crash1
	name = "\improper Crash Site 1"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/boreas
/area/shuttle/boreas/crash2
	name = "\improper Crash Site 2"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/boreas

// Exploration Shuttle stuff //
/area/boreas/station/excursion_dock
	name = "\improper Excursion Shuttle Dock"

/area/boreas/station/explorer_prep
	name = "\improper Explorer Prep Room"

/area/boreas/station/explorer_meeting
	name = "\improper Explorer Meeting Room"

/area/boreas/station/pathfinder_office
	name = "\improper Pathfinder's Office"

/area/shuttle/excursion
	name = "\improper Excursion Shuttle"
	icon_state = "shuttle2"
	base_turf = /turf/space

/area/shuttle/excursion/boreas
	name = "\improper Excursion Shuttle - Boreas"
	base_turf = /turf/simulated/floor/reinforced

/area/shuttle/excursion/boreas_nearby
	name = "\improper Excursion Shuttle - Boreas Near"

/area/shuttle/excursion/boreas_dockarm
	name = "\improper Excursion Shuttle - Boreas Arm"

/area/shuttle/excursion/space
	name = "\improper Excursion Shuttle - Space"

/area/shuttle/excursion/space_moving
	name = "\improper Excursion Shuttle - Space Moving"
	base_turf = /turf/space/transit/north

/area/shuttle/excursion/bluespace
	name = "\improper Excursion Shuttle - Bluespace"
	base_turf = /turf/space/bluespace

/area/shuttle/excursion/sand_moving
	name = "\improper Excursion Shuttle - Sand Transit"
	base_turf = /turf/space/sandyscroll

/area/shuttle/excursion/boreas_sky
	name = "\improper Excursion Shuttle - Virgo3b Sky"
	base_turf = /turf/simulated/sky
//////////////////////////////////

/area/antag/antag_base
	name = "\improper Syndicate Outpost"
	requires_power = 0
	dynamic_lighting = 0

/area/shuttle/antag_space/base
	name = "\improper Syndicate PS - Base"
	icon_state = "shuttle2"
/area/shuttle/antag_space/transit
	name = "\improper Syndicate PS - Transit"
	icon_state = "shuttle2"
/area/shuttle/antag_space/north
	name = "\improper Syndicate PS - Nearby"
	icon_state = "shuttle2"
/area/shuttle/antag_space/docks
	name = "\improper Syndicate PS - Docks"
	icon_state = "shuttle2"

/area/shuttle/antag_ground/base
	name = "\improper Syndicate LC - Base"
	icon_state = "shuttle2"
/area/shuttle/antag_ground/transit
	name = "\improper Syndicate LC - Transit"
	icon_state = "shuttle2"
/area/shuttle/antag_ground/solars
	name = "\improper Syndicate LC - Solars"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/boreas
/area/shuttle/antag_ground/mining
	name = "\improper Syndicate LC - Mining"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/boreas

/area/maintenance/station
	icon_state = "fsmaint"
/area/maintenance/station/bridge
	name = "\improper Bridge Maintenance"
/area/maintenance/station/eng_lower
	name = "\improper Engineering Lower Maintenance"
/area/maintenance/station/eng_upper
	name = "\improper Engineering Upper Maintenance"
/area/maintenance/station/medbay
	name = "\improper Medbay Maintenance"
/area/maintenance/station/cargo
	name = "\improper Cargo Maintenance"
/area/maintenance/station/elevator
	name = "\improper Elevator Maintenance"
/area/maintenance/station/sec_lower
	name = "\improper Security Lower Maintenance"
/area/maintenance/station/sec_upper
	name = "\improper Security Upper Maintenance"
/area/maintenance/station/micro
	name = "\improper Micro Maintenance"
/area/maintenance/station/virology
	name = "\improper Virology Maintenance"
/area/maintenance/station/ai
	name = "\improper AI Maintenance"
	sound_env = SEWER_PIPE



// Exclude some more areas from the atmos leak event so people don't get trapped when spawning.
/datum/event/atmos_leak/setup()
	excluded |= /area/boreas/surfacebase/tram
	excluded |= /area/boreas/surfacebase/atrium_one
	excluded |= /area/boreas/surfacebase/atrium_two
	excluded |= /area/boreas/surfacebase/atrium_three
	excluded |= /area/teleporter/departing
	excluded |= /area/hallway/station/upper
	..()
