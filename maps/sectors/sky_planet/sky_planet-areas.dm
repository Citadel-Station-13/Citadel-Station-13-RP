/area/sector/sky_planet
	name = "Away Mission - Sky Planet"
	area_flags = AREA_RAD_SHIELDED
	initial_outdoors = TRUE

//Sky

/area/sector/sky_planet/sky
	name = "Lythios 43a Sky"
	icon_state = "blue"
	requires_power = 0
	ambience = AMBIENCE_GENERIC
	initial_gas_mix = ATMOSPHERE_ID_SKYPLANET
	ambience = list('sound/ambience/skyplanetsky.ogg')

/area/sector/sky_planet/ground
	name = "Lythios 43a ground"
	requires_power = 0
	icon_state = "unexplored"
	initial_gas_mix = ATMOSPHERE_ID_SKYPLANET_GROUND

/area/sector/sky_planet/ground/sky
	icon_state = "green"

/area/sector/sky_planet/sky/unexplored
	name = "\improper Away Mission - Sky Rigs"
	icon_state = "unexplored"

/area/sector/sky_planet/ground/unexplored
	name = "\improper Away Mission - Ground"
	icon_state = "unexplored"

//NT Outpost

/area/sector/sky_planet/outpost
	icon_state = "blue"

/area/sector/sky_planet/outpost/office
	name = "NT Outpost Hyades Office"
	icon_state = "green"

/area/sector/sky_planet/outpost/medical
	name = "NT Outpost Hyades Medical"
	icon_state = "blue"

/area/sector/sky_planet/outpost/engineering
	name = "NT Outpost Hyades Engineer"
	icon_state = "yellow"

/area/sector/sky_planet/outpost/security
	name = "NT Outpost Hyades Security"
	icon_state = "red"
	ambience = AMBIENCE_HIGHSEC

/area/sector/sky_planet/outpost/docking_port1
	name = "NT Outpost Hyades Docking port"
	icon_state = "blue"
	ambience = AMBIENCE_ARRIVALS

/area/sector/sky_planet/outpost/docking_port2
	name = "NT Outpost Hyades Docking port Fighter"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED

//Station Voidline

/area/sector/sky_planet/racing_station
	name = "Voidline racing club station"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	requires_power = 1

/area/sector/sky_planet/racing_station/dock
	name = "Voidline racing club station racers"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/racing_station/dock2
	name = "Voidline racing club station fighter"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/racing_station/atc
	name = "Voidline racing club control"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR

/area/sector/sky_planet/racing_station/lounge
	name = "Voidline racing club lounge"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR

/area/sector/sky_planet/occulum
	name = "Occulum Safehouse"
	icon_state = "blue"
	requires_power = 1

/area/sector/sky_planet/highway
	name = "Sky Highway Stop"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR

//Station City

/area/sector/sky_planet/station_city
	name = "Hadiis Folly station city"
	icon_state = "red"
	initial_gas_mix = ATMOSPHERE_ID_SKYPLANET

/area/sector/sky_planet/station_city/dock
	name = "Hadiis Folly station city"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/station_city/police
	name = "Hadiis Folly station police"
	icon_state = "red"
	ambience = AMBIENCE_HIGHSEC

/area/sector/sky_planet/station_city/street
	name = "Hadiis Folly station city streets"
	icon_state = "red"
	ambience = AMBIENCE_HIGHSEC
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/station_city/shop
	name = "Hadiis Folly station city shop"
	icon_state = "red"

/area/sector/sky_planet/station_city/appartement
	name = "Hadiis Folly station city appartements"
	icon_state = "green"

/area/sector/sky_planet/station_city/appartement2
	name = "Hadiis Folly station city side appartements"
	icon_state = "green"

/area/sector/sky_planet/station_city/school
	name = "Hadiis Folly station city school"
	icon_state = "green"

/area/sector/sky_planet/station_city/medical
	name = "Hadiis Folly station city medical"
	icon_state = "blue"

/area/sector/sky_planet/station_city/offices
	name = "Hadiis Folly station city HQ"
	icon_state = "green"

/area/sector/sky_planet/station_city/restaurant
	name = "Hadiis Folly station city restaurant"
	icon_state = "green"

//Ground

/area/sector/sky_planet/rock
	name = "Lythios 43a Rocks"
	icon_state = "purple"

/area/sector/sky_planet/poi
	name = "Lythios 43a POI"
	icon_state = "green"
	requires_power = 1
	sound_env = SMALL_ENCLOSED
