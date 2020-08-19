
//
// Surface Base Z Levels
//

/area/triumph/surfacebase
	icon = 'icons/turf/areas_vr.dmi'


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
/area/vacant/vacant_site/east
	name = "\improper East Base Vacant Site"
/area/vacant/vacant_library
	name = "\improper Atrium Construction Site"
/area/vacant/vacant_bar
	name = "\improper Vacant Bar"
/area/vacant/vacant_bar_upper
	name = "\improper Upper Vacant Bar"

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

// Mining Underdark
/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/triumph
/area/mine/explored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/triumph

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"

// Solars map areas
/area/triumph/outpost/solars_outside
	name = "\improper Solar Farm"
/area/triumph/outpost/solars_shed
	name = "\improper Solar Farm Shed"


/area/maintenance/substation/medsec
	name = "\improper MedSec Substation"
/area/maintenance/substation/mining
	name = "\improper Mining Substation"
/area/maintenance/substation/bar
	name = "\improper Bar Substation"
/area/maintenance/substation/surface_atmos
	name = "\improper Surface Atmos Substation"
/area/maintenance/substation/civ_west
	name = "\improper Civilian West Substation"
/area/maintenance/triumph_midpoint
	name = "\improper triumph Midpoint Maint"


/area/triumph/surfacebase/medical
	icon_state = "medical"
/area/triumph/surfacebase/medical/lobby
	name = "\improper Surface Medical Lobby"
/area/triumph/surfacebase/medical/triage
	name = "\improper Surface Triage"
/area/triumph/surfacebase/medical/first_aid_west
	name = "\improper First Aid West"


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


/area/engineering/atmos/processing
	name = "Atmospherics Processing"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED

/area/engineering/atmos/intake
	name = "\improper Atmospherics Intake"
	icon_state = "atmos"
	sound_env = MOUNTAINS

/area/engineering/atmos/hallway
	name = "\improper Atmospherics Main Hallway"
/area/engineering/lower/lobby
	name = "\improper Enginering Surface Lobby"
/area/engineering/lower/breakroom
	name = "\improper Enginering Surface Break Room"
/area/engineering/lower/corridor
	name = "\improper triumph Lower Service Corridor"
/area/engineering/lower/atmos_lockers
	name = "\improper Engineering Atmos Locker Room"
/area/engineering/lower/atmos_eva
	name = "\improper Engineering Atmos EVA"

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

// Research Outpost
/area/outpost/research/hallway/resarch_outpost_northern_hallway
	name = "\improper Outpost - Northern Hallway"
	icon_state = "dk_yellow"

/area/outpost/research/hallway/resarch_outpost_eastern_hallway
	name = "\improper Outpost - Eastern Hallway"
	icon_state = "dk_yellow"

/area/outpost/research/hallway/resarch_outpost_southern_hallway
	name = "\improper Outpost - Southern Hallway"
	icon_state = "dk_yellow"

/area/outpost/research/hallway/resarch_outpost_western_hallway
	name = "\improper Outpost - Western Hallway"
	icon_state = "dk_yellow"

/area/outpost/research/hallway/resarch_outpost_storage_hallway
	name = "\improper Outpost - Hallway Storage"
	icon_state = "dk_yellow"

/area/outpost/research/crew_quarters/sleep/Dorm_1
	name = "\improper Outpost - Dorms 1"
	icon_state = "Sleep"

/area/outpost/research/crew_quarters/sleep/Dorm_2
	name = "\improper Outpost - Dorms 2"
	icon_state = "Sleep"

/area/outpost/research/crew_quarters/sleep/Dorm_3
	name = "\improper Outpost - Dorms 3"
	icon_state = "Sleep"

/area/outpost/research/medical/first_aid_south_west
	name = "\improper Outpost - First Aid South West"
	icon_state = "blue"

/area/outpost/research/storage/tools
	name = "\improper Outpost - Tool Storage"
	icon_state = "storage"

/area/outpost/research/toxins_canister_icyhoot
	name = "\improper Toxins Lab - Canister Heating and Cooling"
	icon_state = "research"

/area/outpost/research/simulator
	name = "\improper Toxins Lab - Explosive Effect Simulator"
	icon_state = "research"

/area/outpost/research/toxins_burn_chamber
	name = "\improper Toxins Lab - Burn Chamber"
	icon_state = "research"

/area/outpost/research/engineering/eva_atmospherics
	name = "\improper Outpost - EVA-Atmospherics"
	icon_state = "green"

/area/outpost/research/storage/surface_eva
	name = "\improper Outpost - Surface EVA"
	icon_state = "green"

/area/outpost/research/storage/surface_eva_storage
	name = "\improper Outpost - Surface EVA Storage"
	icon_state = "green"

/area/outpost/research/substation
	name = "\improper Outpost - Substation"

/area/outpost/research/breakroom
	name = "\improper Outpost - Breakroom"
	icon_state = "research"

/area/outpost/research/crew_quarters/showers
	name = "\improper Outpost - Crew Showers"
	icon_state = "recreation_area_restroom"

/area/outpost/research/materials_lab
	name = "\improper Outpost - Materials Lab"
	icon_state = "red"

/area/outpost/research/telescience_lab
	name = "\improper Outpost - Telescience Lab"
	icon_state = "yellow"

/area/outpost/research/toxins_mixing_lab
	name = "\improper Outpost - Toxins Lab"
	icon_state = "purple"

/area/outpost/research/atmospherics
	name = "\improper Outpost - Atmospherics"
	icon_state = "research"

/area/outpost/research/materials_chamber
	name = "\improper Materials - Chamber"
	icon_state = "red"

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

/area/triumph/surfacebase/shuttle_pad
	name = "\improper triumph Shuttle Pad"
/area/triumph/surfacebase/reading_room
	name = "\improper Reading Room"
/area/triumph/surfacebase/vacant_site
	name = "\improper Vacant Site"
/area/crew_quarters/freezer
	name = "\improper Kitchen Freezer"
/area/crew_quarters/panic_shelter
	name = "\improper Panic Shelter"



//
// Station Z Levels
//
// Note: Fore is NORTH

/area/triumph/station/stairs_one
	name = "\improper Station Stairwell First Floor"
	icon_state = "dk_yellow"
/area/triumph/station/stairs_two
	name = "\improper Station Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/triumph/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"
/area/triumph/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/triumph/station/dock_two
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

/area/triumph/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR

/area/shuttle/triumph/crash1
	name = "\improper Crash Site 1"
	icon_state = "shuttle2"

/area/shuttle/triumph/crash2
	name = "\improper Crash Site 2"
	icon_state = "shuttle2"

// Exploration Shuttle stuff //
/area/triumph/station/excursion_dock
	name = "\improper Excursion Shuttle Dock"
	icon_state = "hangar"

/area/triumph/station/explorer_prep
	name = "\improper Explorer Prep Room"
	icon_state = "locker"

/area/triumph/station/explorer_entry
	name = "\improper Exploration Foyer"
	icon_state = "green"

/area/triumph/station/explorer_meeting
	name = "\improper Explorer Meeting Room"
	icon_state = "northeast"

/area/triumph/station/explorer_showers
	name = "\improper Explorer Showers"
	icon_state = "restrooms"

/area/triumph/station/explorer_medical
	name = "\improper Exploration Med Station"
	icon_state = "medbay"

/area/triumph/station/pathfinder_office
	name = "\improper Pathfinder's Office"

/area/shuttle/excursion
	name = "\improper Excursion Shuttle"
	icon_state = "shuttle2"
	base_turf = /turf/space

/area/shuttle/excursion/triumph
	name = "\improper Excursion Shuttle - Triumph"
	base_turf = /turf/simulated/floor/reinforced

/area/shuttle/excursion/triumph_nearby
	name = "\improper Excursion Shuttle - Triumph Near"

/area/shuttle/excursion/triumph_dockarm
	name = "\improper Excursion Shuttle - Triumph Arm"

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

/area/shuttle/excursion/virgo3b_sky
	name = "\improper Excursion Shuttle - Virgo3b Sky"
	base_turf = /turf/simulated/sky


/area/triumph/midpoint
	name = "\improper triumph Midpoint"

/area/shuttle/excursion/virgo3b_moving
	name = "\improper Excursion Shuttle - Virgo3b Transit"
	base_turf = /turf/simulated/sky

/area/shuttle/excursion/triumph_surface
	name = "\improper Excursion Shuttle - triumph Surface"
	base_turf = /turf/simulated/floor/reinforced


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
	base_turf = /turf/simulated/floor/outdoors/dirt/triumph
/area/shuttle/antag_ground/mining
	name = "\improper Syndicate LC - Mining"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/triumph



// Exclude some more areas from the atmos leak event so people don't get trapped when spawning.
/datum/event/atmos_leak/setup()
	excluded |= /area/triumph/surfacebase/tram
	excluded |= /area/triumph/surfacebase/atrium_one
	excluded |= /area/triumph/surfacebase/atrium_two
	excluded |= /area/triumph/surfacebase/atrium_three
	excluded |= /area/teleporter/departing
	excluded |= /area/hallway/station/upper
	..()
