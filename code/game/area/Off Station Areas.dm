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
/area/shuttle/triumph/crash2
	name = "\improper Crash Site 2"
	icon_state = "shuttle2"

// Class D world areas
/area/class_d
	name = "Class D World"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/class_d/explored
	name = "Class D World - Explored (E)"
	icon_state = "explored"

/area/class_d/unexplored
	name = "Class D World - Unexplored (UE)"
	icon_state = "unexplored"

/area/class_d/unexplored/underground // Caves would be protected from weather. Still valid for POI generation do to being a dependent of /area/poi_d/unexplored

/area/class_d/explored/underground

/area/class_d/wildcat_mining_base
	name = "Abandoned Facility"
	icon_state = "blue"
	requires_power = TRUE

/area/class_d/wildcat_mining_base/exterior_power
	name = "Exterior Power"

/area/class_d/wildcat_mining_base/refueling_outbuilding
	name = "Refueling Outbuilding"

/area/class_d/wildcat_mining_base/warehouse
	name = "Warehouse"

/area/class_d/wildcat_mining_base/exterior_workshop
	name = "Exterior Workshop"

/area/class_d/wildcat_mining_base/interior

/area/class_d/wildcat_mining_base/interior/main_room
	name = "Main Room"

/area/class_d/wildcat_mining_base/interior/utility_room
	name = "Utility Room"

/area/class_d/wildcat_mining_base/interior/bunk_room
	name = "Bunk Room"

/area/class_d/wildcat_mining_base/interior/bathroom
	name = "Bathroom"

/area/class_d/POIs/ship
	name = "Crashed Ship Fragment"

/area/class_d/plains
	name = "Plains"

/area/class_d/crater
	name = "Crater"

/area/class_d/Mountain
	name = "Mountain"

/area/class_d/Crevices
	name = "Crevices"

/area/class_d/POIs/solar_farm
	name = "Prefab Solar Farm"

/area/class_d/POIs/landing_pad
	name = "Prefab Homestead"
	requires_power = FALSE

/area/class_d/POIs/reactor
	name = "Prefab Reactor"

// Class G world areas
/area/class_g
	name = "Class G World"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/class_g/explored
	name = "Class G World - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/class_g/unexplored
	name = "Class G World - Unexplored (UE)"
	icon_state = "yellow"

// Desert Planet world areas
/area/class_h
	name = "Class H World"
	requires_power = 1
	dynamic_lighting = 1
	icon_state = "away"

/area/class_h/POIs/WW_Town
	name = "Ghost Town"

/area/class_h/POIs/landing_pad
	name = "Prefab Homestead"

/area/class_h/POIs/solar_farm
	name = "Prefab Solar Farm"

/area/class_h/POIs/dirt_farm
	name = "Abandoned Farmstead"

/area/class_h/POIs/graveyard
	name = "Desert Graveyard"

/area/class_h/POIs/goldmine
	name = "Desert Goldmine"

/area/class_h/POIs/ranch
	name = "Abandoned Ranch"

/area/class_h/POIs/saloon
	name = "Saloon"

/area/class_h/POIs/temple
	name = "Old Temple"

/area/class_h/POIs/tomb
	name = "Old Tomb"

/area/class_h/POIs/AuxiliaryResearchFacility
	name = "Research Facility"

/area/class_h/POIs/vault
	name = "Desert Bunker"

/area/class_h/POIs/covert_post
	name = "Clown Listening Post"

/area/class_h/explored
	name = "Class H World - Explored (E)"
	icon_state = "explored"

/area/class_h/unexplored
	name = "Class H World - Unexplored (UE)"
	icon_state = "unexplored"

//Gaia planet world areas
/area/class_m
	name = "Class M World"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/class_m/inside
	name = "Class M World - Inside (E)"
	icon_state = "red"

/area/class_m/outside
	name = "Class M World - Outside (UE)"
	icon_state = "yellow"

// Frozen planet world areas
/area/class_p
	name = "Class P World"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/class_p/facility
	name = "Facility"
	icon_state = "red"

/area/class_p/ruins
	name = "Ruins"
	icon_state = "green"

/area/class_p/explored
	name = "Class P World - Explored (E)"
	icon_state = "yellow"

/area/class_p/unexplored
	name = "Class P World - Unexplored (UE)"
	icon_state = "red"

/area/class_p/POIs/archaic_temple
	name = "Archaic Temple"
	icon_state = "purple"

//Debris field
/area/shuttle/excursion/debrisfield
	name = "\improper Excursion Shuttle - Debris Field"

/area/debrisfield
	name = "Away Mission - Debris Field"
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark"

/area/space/debrisfield/explored
	icon_state = "debrisexplored"

/area/space/debrisfield/unexplored
	icon_state = "debrisunexplored"

/area/debrisfield/derelict
	name = "POI - Alien Derelict"
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/space/debrisfield/asteroids
	icon_state = "debrisexplored"

/area/space/debrisfield/asteroids/rocks
	icon_state = "debrisexplored"

/area/space/debrisfield/oldshuttle
	name = "POI - Old Shuttle"
	icon_state = "debrisexplored"

/area/space/debrisfield/medshuttlecrash
	name = "POI - Medical Shuttle Crash"
	icon_state = "debrisexplored"

/area/space/debrisfield/scioverrun
	name = "POI - Overrun Science Ship"
	icon_state = "debrisexplored"

/area/space/debrisfield/explodedship
	name = "POI - Exploded Ship"
	icon_state = "debrisexplored"

/area/space/debrisfield/foodstand
	name = "POI - Foodstand"
	icon_state = "debrisexplored"

/area/space/debrisfield/misc_debris
	name = "Debris"
	icon_state = "debrisexplored"

//Pirate base
/area/shuttle/excursion/piratebase
	name = "\improper Excursion Shuttle - Pirate Base"

/area/piratebase
	name = "Away Mission - Pirate Base"
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark"

/area/piratebase/facility
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')
	requires_power = FALSE

////////////////////////////////////
//// END TRIUMPH SPECIFIC AREAS ////
////////////////////////////////////

// Mining Underdark

/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"
/area/mine/explored/underdark
	name = "\improper Mining Underdark"

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"


//Trade Port areas
/area/shuttle/excursion/trader
	name = "\improper Beruang Trade Shuttle"

/area/tradeport
	name = "Away Mission - Trade Port"
	icon = 'icons/turf/areas.dmi'
	icon_state = "dark"
	area_flags = AREA_RAD_SHIELDED
	requires_power = 1

/area/tradeport/facility
	icon_state = "red"

/area/tradeport/engineering
	icon_state = "yellow"

/area/tradeport/commons
	icon_state = "green"

/area/tradeport/dock
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

/area/tradeport/cyndi
	name = "\improper C&K Floor"
	icon_state = "purple"

/area/tradeport/cyndishow
	name = "\improper C&K Showroom"
	icon_state = "red"

/area/tradeport/medical
	icon_state = "blue"

/area/tradeport/atmospherics
	icon_state = "yellow"

/area/tradeport/exterior

/area/tradeport/cafeteria
	icon_state = "green"

/area/tradeport/expansion


//////// Mothership areas ////////
/area/mothership
	requires_power = 1
	area_flags = AREA_RAD_SHIELDED
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
	area_flags = AREA_RAD_SHIELDED | AREA_BLUE_SHIELDED
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
	area_flags = AREA_RAD_SHIELDED | AREA_BLUE_SHIELDED
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
	area_flags = AREA_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC
/area/skipjack_station/transit
	name = "transit"
	icon_state = "shuttlered"
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
	area_flags = AREA_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC
/area/ninja_dojo/dojo
	name = "\improper Clan Dojo"
	dynamic_lighting = 0
/area/ninja_dojo/start
	name = "\improper Clan Dojo"
	icon_state = "shuttlered"
/area/ninja_dojo/orbit
	name = "near the Tether"
	icon_state = "south"
/area/ninja_dojo/transit
	name = "transit"
	icon_state = "shuttlered"
/area/ninja_dojo/arrivals_dock
	name = "\improper docked with Tether"
	icon_state = "shuttle"
	dynamic_lighting = 0


// Lavaland
/area/shuttle/excursion/lavaland
	name = "Shuttle Landing Point"
	area_flags = AREA_RAD_SHIELDED

/area/lavaland
	name = "Lava Land"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/lavaland/horrors
	name = "Lava Land - Horrors"

/area/lavaland/dogs
	name = "Lava Land - Dogs"

/area/lavaland/idleruins
	name = "Lava Land - Idle Ruins"

/area/lavaland/ashlander_camp
	name = "Lava Land - Ashlander Camp"

/area/lavaland/bosses
	name = "Lava Land - Boss"
	requires_power = 0

/area/lavaland/central/base
	name = "Lava Land (Center) - Mining Base"
	icon_state = "green"

/area/lavaland/central/base/common
	name = "Lava Land (Center) - Mining Base"
	icon_state = "blue"

/area/lavaland/central/explored
	name = "Lava Land (Center) - Thoroughfare"
	icon_state = "red"

/area/lavaland/central/unexplored
	name = "Lava Land (Center) - Unknown"
	icon_state = "yellow"

/area/lavaland/central/transit
	name = "Lava Land (Center) - Transit"
	icon_state = "blue"

/area/lavaland/north/explored
	name = "Lava Land (North) - Thoroughfare"
	icon_state = "red"

/area/lavaland/north/unexplored
	name = "Lava Land (North) - Unknown"
	icon_state = "yellow"

/area/lavaland/south/explored
	name = "Lava Land (South) - Thoroughfare"
	icon_state = "red"

/area/lavaland/south/unexplored
	name = "Lava Land (South) - Unknown"
	icon_state = "yellow"

/area/lavaland/east/explored
	name = "Lava Land (East) - Thoroughfare"
	icon_state = "red"

/area/lavaland/east/unexplored
	name = "Lava Land (East) - Unknown"
	icon_state = "yellow"

/area/lavaland/east/colony
	name = "Lava Land (East) - Colony"
	icon_state = "blue"

/area/lavaland/east/transit
	name = "Lava Land (East) - Transit"
	icon_state = "blue"

/area/lavaland/east/lab
	name = "Lava Land (East) - S4"

/area/lavaland/east/lab/core
	name = "Lava Land (East) - S4"
	icon_state = "blue"

/area/lavaland/east/lab/containment
	name = "Lava Land (East) - S4 Containment"
	icon_state = "blue"

/area/lavaland/east/lab/bunker
	name = "Lava Land (East) - S4 Bunker"
	icon_state = "blue"

/area/lavaland/west/explored
	name = "Lava Land (West) - Thoroughfare"
	icon_state = "red"

/area/lavaland/west/unexplored
	name = "Lava Land (West) - Unknown"
	icon_state = "yellow"

/area/lavaland/dungeon/exterior
	name = "Lava Land (Dungeon) - Unknown"
	icon_state = "yellow"

/area/lavaland/dungeon/facility
	name = "Lava Land (Dungeon) - Pump Facility"
	icon_state = "blue"

// Aerostat
/area/shuttle/excursion/away_aerostat
	name = "\improper Excursion Shuttle - Aerostat"

// The aerostat shuttle
/area/shuttle/aerostat/docked
	name = "\improper Aerostat Shuttle - Dock"

/area/shuttle/aerostat/landed
	name = "\improper Aerostat Shuttle - Surface"

// The aerostat itself
/area/aerostat
	name = "\improper Away Mission - Aerostat Outside"
	icon_state = "away"
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	requires_power = TRUE
	dynamic_lighting = TRUE
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	dynamic_lighting = TRUE

/area/aerostat/surface
	area_flags = AREA_RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')

/area/aerostat/surface/explored
	name = "Away Mission - Aerostat Surface (E)"
	icon_state = "explored"

/area/aerostat/surface/unexplored
	name = "Away Mission - Aerostat Surface (UE)"
	icon_state = "unexplored"



// Away Missions
/area/awaymission
	name = "\improper Strange Location"
	icon_state = "away"
	ambience = AMBIENCE_FOREBODING

/area/awaymission/gateway
	name = "\improper Gateway"
	icon_state = "teleporter"
	music = "signal"

/area/awaymission/example
	name = "\improper Strange Station"
	icon_state = "away"

/area/awaymission/wwmines
	name = "\improper Wild West Mines"
	icon_state = "away1"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwgov
	name = "\improper Wild West Mansion"
	icon_state = "away2"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwrefine
	name = "\improper Wild West Refinery"
	icon_state = "away3"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwvault
	name = "\improper Wild West Vault"
	icon_state = "away3"
	luminosity = 0

/area/awaymission/wwvaultdoors
	name = "\improper Wild West Vault Doors"  // this is to keep the vault area being entirely lit because of requires_power
	icon_state = "away2"
	requires_power = 0
	luminosity = 0

/area/awaymission/desert
	name = "Mars"
	icon_state = "away"

/area/awaymission/BMPship1
	name = "\improper Aft Block"
	icon_state = "away1"

/area/awaymission/BMPship2
	name = "\improper Midship Block"
	icon_state = "away2"

/area/awaymission/BMPship3
	name = "\improper Fore Block"
	icon_state = "away3"

/area/awaymission/spacebattle
	name = "\improper Space Battle"
	icon_state = "away"
	requires_power = 0

/area/awaymission/spacebattle/cruiser
	name = "\improper NanoTrasen Cruiser"

/area/awaymission/spacebattle/syndicate1
	name = "\improper Syndicate Assault Ship 1"

/area/awaymission/spacebattle/syndicate2
	name = "\improper Syndicate Assault Ship 2"

/area/awaymission/spacebattle/syndicate3
	name = "\improper Syndicate Assault Ship 3"

/area/awaymission/spacebattle/syndicate4
	name = "\improper Syndicate War Sphere 1"

/area/awaymission/spacebattle/syndicate5
	name = "\improper Syndicate War Sphere 2"

/area/awaymission/spacebattle/syndicate6
	name = "\improper Syndicate War Sphere 3"

/area/awaymission/spacebattle/syndicate7
	name = "\improper Syndicate Fighter"

/area/awaymission/spacebattle/secret
	name = "\improper Hidden Chamber"

/area/awaymission/listeningpost
	name = "\improper Listening Post"
	icon_state = "away"
	requires_power = 0

/area/awaymission/beach
	name = "Beach"
	icon_state = "null"
	luminosity = 1
	dynamic_lighting = 0
	requires_power = 0

/area/awaymission/carpfarm
	icon_state = "blank"
	requires_power = 0

/area/awaymission/carpfarm/arrival
	icon_state = "away"
	requires_power = 0

/area/awaymission/carpfarm/base
	icon_state = "away"

/area/awaymission/carpfarm/base/entry
	icon_state = "blue"

/area/awaymission/snow_outpost
	icon_state = "blank"
	requires_power = 0
	ambience = list('sound/music/main.ogg', 'sound/ambience/maintenance/maintenance4.ogg', 'sound/ambience/sif/sif1.ogg', 'sound/ambience/ruins/ruins1.ogg')

/area/awaymission/snow_outpost/outside
	icon_state = "away1"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	mobcountmax = 100
	floracountmax = 7000
	valid_mobs = list(/mob/living/simple_mob/animal/sif/savik, /mob/living/simple_mob/animal/wolf, /mob/living/simple_mob/animal/sif/shantak,
					  /mob/living/simple_mob/animal/sif/kururak, /mob/living/simple_mob/animal/sif/frostfly)
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snow_outpost/restricted // No mob spawns!
	icon_state = "red"
	mobcountmax = 1 // Hacky fix.
	floracountmax = 100
	valid_mobs = list(/obj/structure/flora/tree/pine) // Hacky fix.
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snow_outpost/outpost
	icon_state = "away"
	ambience = list('sound/ambience/chapel/chapel1.ogg', 'sound/ambience/ruins/ruins5.ogg', 'sound/ambience/ruins/ruins1.ogg')  // Rykka was here. <3

/area/awaymission/snowfield
	icon_state = "blank"
//	requires_power = 0
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')

/area/awaymission/snowfield/outside
	icon_state = "green"
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	mobcountmax = 40
	floracountmax = 2000

	valid_mobs = list(/mob/living/simple_mob/animal/sif/sakimm/polar, /mob/living/simple_mob/animal/sif/diyaab/polar,
					/mob/living/simple_mob/animal/sif/shantak/polar, /mob/living/simple_mob/animal/space/bear/polar,
					/mob/living/simple_mob/animal/wolf)
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snowfield/restricted // No mob spawns!
	icon_state = "red"
	mobcountmax = 1 // Hacky fix.
	floracountmax = 120
	valid_mobs = list(/obj/structure/flora/tree/pine) // Hacky fix.
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snowfield/base
	icon_state = "away"
	ambience = null // Todo: Add better ambience.

/area/awaymission/zoo
	icon_state = "green"
	requires_power = 0
	dynamic_lighting = 0
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')

/area/awaymission/zoo/solars
	icon_state = "yellow"

/area/awaymission/zoo/tradeship
	icon_state = "purple"

/area/awaymission/zoo/syndieship
	icon_state = "red"

/area/awaymission/zoo/pirateship
	icon_state = "bluenew"

//Jungle Areas
/area/jungle/temple_one
	icon_state = "red"
/area/jungle/temple_two
	icon_state = "yellow"
/area/jungle/temple_three
	icon_state = "green"
/area/jungle/temple_four
	icon_state = "blue"
/area/jungle/temple_five
	icon_state = "purple"
/area/jungle/temple_six
	icon_state = "away"
/area/jungle/crash_ship_one
	icon_state = "red"
/area/jungle/crash_ship_two
	icon_state = "yellow"
/area/jungle/crash_ship_three
	icon_state = "green"
/area/jungle/crash_ship_four
	icon_state = "blue"
/area/jungle/crash_ship_source
	icon_state = "purple"
/area/jungle/crash_ship_clean
	icon_state = "away"

//Challenge
/area/awaymission/challenge/start
	icon_state = "red"
/area/awaymission/challenge/laser_retro
	icon_state = "yellow"
/area/awaymission/challenge/main
	icon_state = "green"
/area/awaymission/challenge/end
	icon_state = "blue"

//Labyrinth
/area/awaymission/labyrinth/temple/north_west
	icon_state = "red"
/area/awaymission/labyrinth/temple/north
	icon_state = "yellow"
/area/awaymission/labyrinth/temple/north_east
	icon_state = "green"
/area/awaymission/labyrinth/temple/center
	icon_state = "blue"
/area/awaymission/labyrinth/temple/east
	icon_state = "red"
/area/awaymission/labyrinth/temple/west
	icon_state = "yellow"
/area/awaymission/labyrinth/temple/south_east
	icon_state = "green"
/area/awaymission/labyrinth/temple/south
	icon_state = "blue"
/area/awaymission/labyrinth/temple/south_west
	icon_state = "red"
/area/awaymission/labyrinth/arrival
	icon_state = "yellow"
/area/awaymission/labyrinth/temple/entry
	icon_state = "green"
/area/awaymission/labyrinth/boss
	icon_state = "blue"
/area/awaymission/labyrinth/cave
	icon_state = "red"
//Station Collison
/area/awaymission/northblock
	icon_state = "red"
/area/awaymission/syndishuttle
	icon_state = "yellow"
/area/awaymission/research
	icon_state = "green"
/area/awaymission/midblock
	icon_state = "blue"
/area/awaymission/arrivalblock
	icon_state = "purple"
/area/awaymission/southblock
	icon_state = "red"
/area/awaymission/gateroom
	icon_state = "yellow"
//ZResearch
/area/awaymission/labs/cave
	icon_state = "red"
/area/awaymission/labs/researchdivision
	icon_state = "yellow"
/area/awaymission/labs/gateway
	icon_state = "green"
/area/awaymission/labs/militarydivision
	icon_state = "blue"
/area/awaymission/labs/solars
	icon_state = "purple"
/area/awaymission/labs/command
	icon_state = "red"
/area/awaymission/labs/cargo
	icon_state = "yellow"
/area/awaymission/labs/civilian
	icon_state = "green"
/area/awaymission/labs/security
	icon_state = "blue"
/area/awaymission/labs/medical
	icon_state = "purple"
//Academy
/area/awaymission/academy
	icon_state = "red"
/area/awaymission/academy/headmaster
	icon_state = "yellow"
/area/awaymission/academy/classrooms
	icon_state = "green"
/area/awaymission/academy/academyaft
	icon_state = "blue"
/area/awaymission/academy/academygate
	icon_state = "purple"

// The Frozen Temple POI
