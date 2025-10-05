//Debug areas
/area/rift/surfacebase
	name = "Rift Debug Surface"

/area/rift/transit
	name = "Rift Debug Transit"
	requires_power = 0

/area/rift/space
	name = "Rift Debug Space"
	requires_power = 0
	is_outside = OUTSIDE_YES

//Elevator areas.
/area/turbolift/runder/level2
	name = "under (level 2)"
	lift_floor_label = "Underground 2"
	lift_floor_name = "Engineering, Chapel, Mining, Bunker"
	lift_announce_str = "Arriving at underground level two."

/area/turbolift/runder/level1
	name = "under (level 1)"
	lift_floor_label = "Underground 1"
	lift_floor_name = "Atmospherics"
	lift_announce_str = "Arriving at underground level one."

/area/turbolift/rsurface/level1
	name = "surface (level 1)"
	lift_floor_label = "Surface 1"
	lift_floor_name = "Cargo, Tool Storage, EVA Equipment, Surface EVA"
	lift_announce_str = "Arriving at surface level one."

/area/turbolift/rsurface/level2
	name = "surface (level 2)"
	lift_floor_label = "Surface 2"
	lift_floor_name = "Medical, Security, Science, Dorms, Cafe"
	lift_announce_str = "Arriving at surface level two."

/area/turbolift/rsurface/level3
	name = "surface (level 3)"
	lift_floor_label = "Surface 3"
	lift_floor_name = "Bar, Kitchen, Bridge, Exploration, Arrivals"
	lift_announce_str = "Arriving at surface level two."

//Mining Elevator Area
/area/turbolift/rmine/surface
	name = "mining shaft (surface)"
	lift_floor_label = "Surface"
	lift_floor_name = "Cargo"
	lift_announce_str = "Arriving at Cargo Level."

/area/turbolift/rmine/under1
	name = "mining shaft (level -1)"
	lift_floor_label = "Underground Level 1"
	lift_floor_name = "Maintenance"
	lift_announce_str = "Arriving at Maintenance Point."

/area/turbolift/rmine/under2
	name = "mining shaft (level -2)"
	lift_floor_label = "Underground Level 2"
	lift_floor_name = "Mining Main"
	lift_announce_str = "Arriving at Mining Department."

/area/turbolift/rmine/under3
	name = "mining shaft (level -3)"
	lift_floor_label = "Underground Level 3"
	lift_floor_name = "Mining Bottom"
	lift_announce_str = "Arriving at Lower Level."

/area/turbolift/rwest_mining/surface
	name = "west base (surface)"
	lift_floor_label = "Surface"
	lift_floor_name = "Surface"
	lift_announce_str = "Arriving at Surface Level."

/area/turbolift/rwest_mining/caves
	name = "west base (caves)"
	lift_floor_label = "Level 1"
	lift_floor_name = "Caves"
	lift_announce_str = "Arriving at Mining Level."

/area/turbolift/rwest_mining/deep
	name = "west base (deep)"
	lift_floor_label = "Level 2"
	lift_floor_name = "Landing Pads"
	lift_announce_str = "Arriving at Landing Pads Level."

/area/turbolift/rwest_mining/base
	name = "west base (base)"
	lift_floor_label = "Level 3"
	lift_floor_name = "Base"
	lift_announce_str = "Arriving at Base Level."

/area/turbolift/rhammerhead/underground
	name = "transport tunnel (underground)"
	lift_floor_label = "Underground Transport Tunnel"
	lift_floor_name = "Security Garage, Transport Tunnel, Fighter bay."
	lift_announce_str = "Arriving at the underground transport tunnel."

/area/turbolift/rhammerhead/midpoint
	name = "midpoint (level 1)"
	lift_floor_label = "Elevator Midpoint"
	lift_floor_name = "Nothing."
	lift_announce_str = "Arriving at the elevator's midpoint."

/area/turbolift/rhammerhead/hhbay
	name = "hammerhead bay (level 2)"
	lift_floor_label = "Hammerhead Bay 2"
	lift_floor_name = "Hammerhead Docking Bay, Brig."
	lift_announce_str = "Arriving at the Hammerhead Docking bay."


/*
/area/turbolift/t_station/level1
	name = "asteroid (level 1)"
	lift_floor_label = "Asteroid 1"
	lift_floor_name = "Eng, Bridge, Park, Cryo"
	lift_announce_str = "Arriving at Station Level 1."
*/
/*
/area/vacant/vacant_restaurant_upper
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"

/area/vacant/vacant_restaurant_lower
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering"

/area/engineering/shaft
	name = "\improper Engineering Electrical Shaft"
	icon_state = "substation"

/area/vacant/vacant_office
	name = "\improper Vacant Office"
	icon_state = "vacant_site"
*/


//
// Rift Snowflake Areas
//

/area/rift/surfacebase/shuttle
	name = "\improper Shuttle Pad"
	icon_state = "dk_yellow"

/area/maintenance/substation/atmos
	name = "\improper Atmospherics Substation"

/area/engineering/atmos/atmos_lobby
	name = "\improper Atmospherics Lobby"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/medical/recovery_room
	name = "\improper Recovery Room"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/crew_quarters/public_bunker
	name = "\improper Public Bunker"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/crew_quarters/public_bunker/dorm_one
	name = "\improper Public Bunker Dorm 1"

/area/crew_quarters/public_bunker/dorm_two
	name = "\improper Public Bunker Dorm 2"

/area/crew_quarters/public_bunker/dorm_three
	name = "\improper Public Bunker Dorm 3"

/area/bridge/bunker
	name = "\improper Command Bunker"
	icon_state = "bridge"
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_SENSITIVE

/area/crew_quarters/maint_dorm
	name = "\improper Maintenance - Unknown"

/area/maintenance/public_bunker
	name = "\improper Public Bunker Maintenance"

/area/maintenance/maint_bar
	name = "\improper Maintenance Bar"
	icon_state = "fsmaint"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/crew_quarters/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "bar"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/crew_quarters/game_room
	name = "\improper Game Room"
	icon_state = "bar"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/rift/surfaceeva
	name = "\improper Primary Surface EVA"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES
	
/area/rift/surfaceeva/airlock/main
	name = "\improper Primary Surface Airlock"

/area/rift/surfaceeva/airlock/main/secondary
	name = "\improper Primary Surface Airlock"

/area/rift/surfaceeva/airlock/arrivals
	name = "\improper Arrivals Airlock One"

/area/rift/surfaceeva/airlock/arrivals/secondary
	name = "\improper Arrivals Airlock Two"


/area/rift/surfaceeva/aa
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_SENSITIVE

/area/rift/surfaceeva/aa/surface_north
	name = "\improper Surface One - North Anti-Air Battery"
	
/area/rift/surfaceeva/aa/surface_south
	name = "\improper Surface One - South Anti-Air Battery"

/area/rift/surfaceeva/aa/cliff_north
	name = "\improper Surface Three - North Anti-Air Battery"

/area/rift/surfaceeva/aa/cliff_south
	name = "\improper Surface Three - South Anti-Air Battery"


/area/rift/surfaceeva/cargodock
	name = "\improper Cargo Dock"
	icon_state = "quart"

//
// Elevator Maint
//

/area/rift/turbolift/maint
	name = "\improper Elevator Maintenance"
	icon_state = "maint_engineering"

//
// Central heating
//

/area/maintenance/central_heating/surface_one
	name = "\improper Central Heating - Surface One"
	icon_state = "maint_engineering"

//
// Substations
//

/area/maintenance/substation/surface_one
	name = "\improper Surface One Substation"
	icon_state = "substation"

/area/maintenance/substation/surface_two
	name = "\improper Surface Two Substation"
	icon_state = "substation"

/area/maintenance/substation/surface_three
	name = "\improper Surface Two Substation"
	icon_state = "substation"

//
// Hallways
//

/area/hallway/primary/underone
	name = "\improper Central Primary Hallway - Underground One"
	icon_state = "hallC"
/area/hallway/primary/undertwo
	name = "\improper Central Primary Hallway - Underground Two"
	icon_state = "hallC"
/area/hallway/primary/surfaceone
	name = "\improper Central Primary Hallway - Surface One"
	icon_state = "hallC"
/area/hallway/primary/surfacetwo
	name = "\improper Central Primary Hallway - Surface Two"
	icon_state = "hallC"
/area/hallway/primary/surfacethree
	name = "\improper Central Primary Hallway - Surface Three"
	icon_state = "hallC"

//
// Stairwells
//

/area/rift/stairwell/primary
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/rift/stairwell/primary/undertwo
	name = "\improper Central Primary Stairwell - Underground Two"
	icon_state = "dk_yellow"

/area/rift/stairwell/primary/underone
	name = "\improper Central Primary Stairwell - Underground One"
	icon_state = "dk_yellow"

/area/rift/stairwell/primary/surfaceone
	name = "\improper Central Primary Stairwell - Surface One"
	icon_state = "dk_yellow"

/area/rift/stairwell/primary/surfacetwo
	name = "\improper Central Primary Stairwell - Surface Two"
	icon_state = "dk_yellow"

/area/rift/stairwell/primary/surfacethree
	name = "\improper Central Primary Stairwell - Surface Three"
	icon_state = "dk_yellow"

/area/rift/stairwell/primary/surfacefour
	name = "\improper Central Primary Stairwell - Surface Four"
	icon_state = "dk_yellow"

/area/rift/surfacebase
	icon = 'icons/turf/areas_vr.dmi'

/area/rift/surfacebase/underground
	name = "Outside - Underground"
	is_outside = OUTSIDE_YES

/area/rift/surfacebase/underground/under3
	icon_state = "red"

/area/rift/surfacebase/underground/under2
	icon_state = "under2"

/area/rift/surfacebase/underground/under1
	icon_state = "under1"

/area/rift/surfacebase/outside
	name = "Outside - Surface"
	ambience = AMBIENCE_LYTHIOS
	is_outside = OUTSIDE_YES
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/rift/surfacebase/outside/outside1
	icon_state = "outside1"

/area/rift/surfacebase/outside/outside2
	icon_state = "outside2"

/area/rift/surfacebase/outside/outside3
	icon_state = "outside3"

/area/rift/surfacebase/outside/empty
	name = "Outside - Empty Area"

// Mining Underdark // ???? Fix this.
/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"

/area/mine/explored/underdark
	name = "\improper Mining Underdark"

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"

/area/outpost/mining_main/outpost
	name = "\improper Mining Outpost"
	ambience = AMBIENCE_OUTPOST

/area/outpost/mining_main/outpost/substation
	name = "\improper Outpost Substation"
	ambience = AMBIENCE_SUBSTATION

/area/outpost/mining_main/outpost/near_gateway
	name = "\improper Mining Outpost"

/area/outpost/mining_main/outpost/washrooms
	name = "\improper Mining Outpost Washrooms"

/area/outpost/mining_main/outpost/recreation
	name = "\improper Mining Outpost Recreation"

/area/outpost/mining_main/outpost/storage
	name = "\improper Mining Outpost Storage"
/area/outpost/mining_main/outpost/airlock/one
	name = "\improper Mining Outpost Exterior Airlock"

/area/outpost/mining_main/outpost/airlock/two
	name = "\improper Mining Outpost Exterior Airlock"

/area/outpost/mining_main/outpost/airlock/three
	name = "\improper Mining Outpost Exterior Airlock"

/area/outpost/mining_main/outpost/maintenance
	name = "\improper Outpost Maintenance"
	area_flags = AREA_RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

/area/outpost/mining_main/outpost/maintenance/south
	name = "\improper Outpost Maintenance South"

/area/outpost/mining_main/outpost/maintenance/north
	name = "\improper Outpost Maintenance North"

// Geothermal power areas
/area/rift/geothermal
	name = "\improper Geothermal Power Plant"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rift/geothermal/balcony
	name = "\improper Geothermal Overview balcony"

/area/rift/geothermal/sauna
	name = "\improper Geothermal Sauna"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

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


/area/rift/surfacebase/security/armory
	name = "\improper Surface Armory"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/rift/surfacebase/security/checkpoint
	name = "\improper Surface Checkpoint Office"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

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
	area_flags = AREA_FLAG_ERODING

/area/maintenance/lower/solars
	name = "\improper Solars Maintenance"

/area/maintenance/lower/mining_eva
	name = "\improper Mining EVA Maintenance"

/area/maintenance/lower/public_garden_maintenance
	name = "\improper Public Garden Maintenance"


// Research
/area/rnd/xenobiology/cell
	name = "\improper Xenobiology Cell 1"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/xenobiology/cell/two
	name = "\improper Xenobiology Cell 2"

/area/rnd/xenobiology/cell/three
	name = "\improper Xenobiology Cell 3"

/area/rnd/xenobiology/cell/four
	name = "\improper Xenobiology Cell 4"

/area/rnd/xenobiology/cell/five
	name = "\improper Xenobiology Cell 5"

/area/rnd/xenobiology/cell/six
	name = "\improper Xenobiology Cell 6"

/area/rnd/xenobiology/cell/seven
	name = "\improper Xenobiology Cell 7"

/area/rnd/xenobiology/xenoflora/lab_atmos
	name = "\improper Xenoflora Atmospherics Lab"

//
// Station Z Levels
//
// Note: Fore is NORTH

/area/rift/station/stairs_one
	name = "\improper Engineering Stairwell First Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/rift/station/stairs_two
	name = "\improper Engineering Stairwell Second Floor"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

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

/area/medical/virologyisolation
	name = "\improper Virology Isolation"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES
	
/area/medical/virologymorgue
	name = "\improper Virology Morgue"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/recoveryrestroom
	name = "\improper Recovery Room Restroom"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/security/hallway
	name = "\improper Security Hallway"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/security/hallwayaux
	name = "\improper Security Armory Hallway"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/breakroom
	name = "\improper Security Breakroom"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/security/brig/visitation
	name = "\improper Visitation"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/brig/bathroom
	name = "\improper Brig Bathroom"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/security/armory/blue
	name = "\improper Armory - Blue"
	icon_state = "armory"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/security/armory/red
	name = "\improper Armory - Red"
	icon_state = "armory"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/security/evastorage
	name = "\improper Security EVA Equipment Storage"
	icon_state = "security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/observation
	name = "\improper Brig Observation"
	icon_state = "riot_control"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/eva
	name = "\improper Security EVA"
	icon_state = "security_equip_storage"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/recstorage
	name = "\improper Brig Recreation Storage"
	icon_state = "brig"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

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


/area/rift/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

// Exploration Shuttle stuff //

/area/shuttle/excursion
	name = "\improper Excursion Shuttle"
	icon_state = "shuttle2"

/area/shuttle/excursion/rift
	name = "\improper Excursion Shuttle - Atlas"

/area/shuttle/excursion/rift_nearby
	name = "\improper Excursion Shuttle - Atlas Near"

/area/shuttle/excursion/rift_dockarm
	name = "\improper Excursion Shuttle - Atlas Arm"

/area/shuttle/excursion/space
	name = "\improper Excursion Shuttle - Space"

/area/shuttle/excursion/space_moving
	name = "\improper Excursion Shuttle - Space Moving"

/area/shuttle/excursion/bluespace
	name = "\improper Excursion Shuttle - Bluespace"

/area/shuttle/excursion/sand_moving
	name = "\improper Excursion Shuttle - Sand Transit"

/area/shuttle/excursion/virgo3b_sky
	name = "\improper Excursion Shuttle - Lythios-43c Sky"


//Adherent Maintenance
/area/rift/station/adherent_maintenance
	icon_state = "yellow"
	name = "\improper Adherent Maintenance"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

//Fighter Bay
/area/rift/station/fighter_bay
	icon_state = "blue"
	name = "\improper Fighter Bay"
	ambience = AMBIENCE_HANGAR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rift/station/fighter_bay/hangar
	name = "\improper Fighter Hangar"

/area/rift/station/fighter_bay/maintenance
	name = "\improper Fighter Bay Maintenance"

/area/rift/station/fighter_bay/transport_tunnel
	name = "\improper Transport Tunnel"

/area/rift/station/fighter_bay/transport_tunnel_garage
	name = "\improper Transport Tunnel Garage"

/area/rift/station/fighter_bay/transport_tunnel_garage_maint
	name = "\improper Transport Tunnel Garage Maint"

//Civilian Garden

/area/rift/station/public_garden
	icon_state = "green"
	name = "\improper Public Garden"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/rift/station/public_garden/stairwell
	name = "\improper Public Garden Stairwell"

/area/rift/station/public_garden/gantry
	name = "\improper Public Garden Gantry"


//////////////////////////////////

/*
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
/area/shuttle/antag_ground/mining
	name = "\improper Syndicate LC - Mining"
	icon_state = "shuttle2"


// Exclude some more areas from the atmos leak event so people don't get trapped when spawning.
/datum/event/atmos_leak/setup()
	excluded |= /area/rift/surfacebase/pad
	excluded |= /area/tether/surfacebase/atrium_one
	excluded |= /area/tether/surfacebase/atrium_two
	excluded |= /area/tether/surfacebase/atrium_three
	excluded |= /area/teleporter/departing
	excluded |= /area/hallway/station/upper
	..()
Do this eventually. */

/area/rift/surfacebase/outside/west
	name = "Western Plains Surface"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/rift/surfacebase/outside/west/submap_seedzone
	name = "Western Plains Surface"
	icon_state = "green"

/area/rift/surfacebase/outside/west_caves
	name = "Western Plains Caverns"
	icon_state = "red"

/area/rift/surfacebase/outside/west_caves/submap_seedzone
	name = "Western Plains Caverns"
	icon_state = "red"

/area/rift/surfacebase/outside/west_deep
	name = "Western Plains Deep Ice"
	icon_state = "yellow"

/area/rift/surfacebase/outside/west_deep/submap_seedzone
	name = "Western Plains Deep Ice"
	icon_state = "yellow"

/area/rift/surfacebase/outside/west_base
	name = "Western Plains Canyon"
	icon_state = "blue"

/area/rift/surfacebase/outside/west_base/submap_seedzone
	name = "Western Plains Canyon"
	icon_state = "blue"


//Trade Pad/Shop
/area/rift/trade_shop
	name = "\improper Trade Shop"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/rift/trade_shop/landing_pad
	name = "\improper Trade Shop Landing Pad"

/area/rift/trade_shop/loading
	name = "\improper Trade Shop Loading Corridor"

/area/rift/trade_shop/debugger
	name = "\improper Trade Shop Debugger"


//Abandoned Tajaran Base
/area/rift/facility/exterior
	name = "\improper Radioactive Exclusion Zone"
	is_outside = OUTSIDE_YES

/area/rift/facility/exterior/shuttle
	name = "\improper Contaminated Shuttle"

/area/rift/facility/interior/surface
	name = "\improper Lythios Facility -  Ground Level"

/area/rift/facility/interior/underground1
	name = "\improper Lythios Facility -  Sublevel 1"

/area/rift/facility/interior/underground2
	name = "\improper Lythios Facility -  Sublevel 2"

/area/rift/facility/interior/underground3
	name = "\improper Lythios Facility -  Sublevel 3"

/area/rift/facility/interior/barracks
	name = "\improper Lythios Facility -  Soldier Barracks"

/area/rift/facility/interior/command
	name = "\improper Lythios Facility -  Commander's Office"

/area/rift/facility/interior/elevator
	name = "\improper Lythios Facility -  Elevator Shaft"

/area/rift/facility/interior/bathrooms
	name = "\improper Lythios Facility -  Bathroom"

/area/rift/facility/interior/workroom
	name = "\improper Lythios Facility -  Work Rooms"

/area/rift/facility/interior/medical
	name = "\improper Lythios Facility -  Medical"

/area/rift/facility/interior/temple
	name = "\improper Lythios Facility -  Temple"

/area/rift/facility/interior/prison
	name = "\improper Lythios Facility -  Prison"

/area/rift/facility/interior/janitorial
	name = "\improper Lythios Facility -  Custodial Closet"

/area/rift/facility/interior/vault
	name = "\improper Lythios Facility -  Vault"

/area/rift/facility/interior/core
	name = "\improper Lythios Facility -  Reactor Core"

///Asylum Dungeon Areas
/area/rift/asylum
	name = "\improper ERROR: Area Not Found"

/area/rift/asylum/cellblock

/area/rift/asylum/common

/area/rift/asylum/janitorial

/area/rift/asylum/mess

/area/rift/asylum/staff

/area/rift/asylum/trash

/area/rift/asylum/medical

/area/rift/asylum/fitness

/area/rift/asylum/halls

/area/rift/asylum/pit

/area/rift/asylum/training

/area/rift/asylum/surgical

/area/rift/asylum/near_death

/area/rift/asylum/science

/area/rift/asylum/command

//Other Lythios outdoor areas
/area/rift/exterior
	is_outside = OUTSIDE_YES
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/rift/exterior/nuketown
	name = "\improper High Yield Explosives Test Site"

/area/rift/exterior/nuketown/interior
	name = "\improper Mock Townhouse"

/area/rift/exterior/nuketown/bunker
	name = "\improper Mock Bomb Shelter"

/area/rift/exterior/bunker
	name = "\improper Bunker Buster Explosives Test Site - Surface"

/area/rift/exterior/bunker/lower
	name = "\improper Bunker Buster Explosives Test Site - Lower Level"

/area/rift/exterior/bunker/bottom
	name = "\improper Bunker Buster Explosives Test Site - Blast Site"

/area/rift/exterior/checkpoint/south
	name = "\improper Southern Abandoned Checkpoint"

/area/rift/exterior/mineshaft
	name = "\improper Abandoned Mineshaft"

/area/rift/exterior/hangar
	name = "\improper Abandoned Hangar"

