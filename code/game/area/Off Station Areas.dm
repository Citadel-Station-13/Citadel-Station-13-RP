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

// Frozen planet world areas
/area/frozen_planet
	name = "Frozen Planet"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/dirt
	requires_power = 0
	dynamic_lighting = 1

/area/frozen_planet/facility
	name = "Gaia Planet - Facility"
	requires_power = 1
	icon_state = "red"

/area/frozen_planet/ruins
	name = "Gaia Planet - Ruins"
	icon_state = "green"

/area/frozen_planet/outside
	name = "Gaia Planet - Outside (UE)"
	icon_state = "yellow"

//Gaia planet world areas
/area/gaia_planet
	name = "Gaia Planet"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/dirt
	requires_power = 0
	dynamic_lighting = 1

/area/gaia_planet/inside
	name = "Gaia Planet - Inside (E)"
	icon_state = "red"

/area/gaia_planet/outside
	name = "Gaia Planet - Outside (UE)"
	icon_state = "yellow"

// Mining Planet world areas
/area/mining_planet
	name = "Mining Planet"
	icon_state = "away"
	base_turf = /turf/simulated/mineral/floor/
	dynamic_lighting = 1

/area/mining_planet/explored
	name = "Mining Planet - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/mining_planet/unexplored
	name = "Mining Planet - Unexplored (UE)"
	icon_state = "yellow"

// Class D world areas
/area/poi_d/POIs/ship
	name = "Crashed Ship Fragment"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/poi_d/explored
	name = "Class D World - Explored (E)"
	icon_state = "explored"

/area/poi_d/unexplored
	name = "Class D World - Unexplored (UE)"
	icon_state = "unexplored"

/area/poi_d
	name = "Class D World"
	icon_state = "away"
	base_turf = /turf/simulated/mineral/floor/vacuum
	dynamic_lighting = 1

/area/poi_d/plains
	name = "Class D World Plains"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/poi_d/crater
	name = "Class D World Crater"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/poi_d/Mountain
	name = "Class D World Mountain"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/poi_d/Crevices
	name = "Class D World Crevices"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/poi_d/POIs/solar_farm
	name = "Prefab Solar Farm"
	base_turf = /turf/simulated/mineral/floor/vacuum

/area/poi_d/POIs/landing_pad
	name = "Prefab Homestead"
	base_turf = /turf/simulated/mineral/floor/vacuum
	requires_power = FALSE

/area/poi_d/POIs/reactor
	name = "Prefab Reactor"
	base_turf = /turf/simulated/mineral/floor/vacuum

// Mining Planet world areas
/area/poi_h
	name = "Mining Planet"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh
	requires_power = 0
	dynamic_lighting = 1

/area/poi_h/explored
	name = "Mining Planet - Explored (E)"
	icon_state = "red"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

/area/poi_h/unexplored
	name = "Mining Planet - Unexplored (UE)"
	icon_state = "yellow"

/area/shuttle/excursion/poi_h
	name = "Shuttle Landing Point"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh
	flags = RAD_SHIELDED

/area/poi_h
	name = "Class H World"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/POIs/WW_Town
	name = "Ghost Town"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/POIs/landing_pad
	name = "Prefab Homestead"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/POIs/solar_farm
	name = "Prefab Solar Farm"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/POIs/dirt_farm
	name = "Abandoned Farmstead"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/POIs/graveyard
	name = "Desert Graveyard"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/POIs/goldmine
	name = "Desert Goldmine"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/desert/classh

/area/poi_h/explored
	name = "Class H World - Explored (E)"
	icon_state = "explored"

/area/poi_h/unexplored
	name = "Class H World - Unexplored (UE)"
	icon_state = "unexplored"

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
	icon_state = "debrisexplored"
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/horror.ogg')

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
	base_turf = /turf/simulated/mineral/floor/virgo3b
/area/mine/explored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/virgo3b

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
	flags = RAD_SHIELDED
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


// Lavaland
/area/shuttle/excursion/lavaland
	name = "Shuttle Landing Point"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	flags = RAD_SHIELDED

/area/lavaland
	name = "Lava Land"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/lavaland/horrors
	name = "Lava Land - Horrors"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/lavaland/dogs
	name = "Lava Land - Dogs"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/lavaland/idleruins
	name = "Lava Land - Idle Ruins"
	base_turf = /turf/simulated/floor/outdoors/lavaland

/area/lavaland/bosses
	name = "Lava Land - Boss"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	requires_power = 0

/area/lavaland
	name = "Lava Land"
	icon_state = "away"
	base_turf = /turf/simulated/floor/outdoors/lavaland
	dynamic_lighting = 1

/area/lavaland/base
	name = "Lava Land - Mining Base"
	icon_state = "green"
	requires_power = 0

/area/lavaland/base/common
	name = "Lava Land - Mining Base"
	icon_state = "blue"
	requires_power = 1
/area/lavaland/explored
	name = "Lava Land - Thoroughfare"
	icon_state = "red"

/area/lavaland/unexplored
	name = "Lava Land - Unknown"
	icon_state = "yellow"


// Aerostat
/area/shuttle/excursion/away_aerostat
	name = "\improper Excursion Shuttle - Aerostat"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky

// The aerostat shuttle
/area/shuttle/aerostat/docked
	name = "\improper Aerostat Shuttle - Dock"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky

/area/shuttle/aerostat/landed
	name = "\improper Aerostat Shuttle - Surface"
	base_turf = /turf/simulated/floor/plating/virgo2

// The aerostat itself
/area/aerostat
	name = "\improper Away Mission - Aerostat Outside"
	icon_state = "away"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	requires_power = TRUE
	dynamic_lighting = TRUE
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	dynamic_lighting = TRUE

/area/aerostat/surface
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

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
	base_turf = /turf/snow/snow2
	ambience = list('sound/music/main.ogg', 'sound/ambience/maintenance/maintenance4.ogg', 'sound/ambience/sif/sif1.ogg', 'sound/ambience/ruins/ruins1.ogg')
	base_turf = /turf/simulated/floor/snow/snow2

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
	base_turf = /turf/snow/snow2
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')
	base_turf = /turf/simulated/floor/snow/snow2

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
