/area/sector/sky_planet
	name = "Away Mission - Sky Planet"
	area_flags = AREA_RAD_SHIELDED
	initial_outdoors = TRUE

//Sky

/area/sector/sky_planet/sky
	name = "Motov'maal Sky"
	icon_state = "blue"
	requires_power = 0
	ambience = AMBIENCE_GENERIC
	initial_gas_mix = ATMOSPHERE_ID_SKYPLANET
	ambience = list('sound/ambience/skyplanetsky.ogg')

/area/sector/sky_planet/ground
	name = "Motov'maal Surface"
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
	name = "Motov'arna City"
	icon_state = "red"
	initial_gas_mix = ATMOSPHERE_ID_SKYPLANET

/area/sector/sky_planet/station_city/dock
	name = "Motov'arna Spaceport"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/station_city/dock2
	name = "Motov'arna Secondary Dock"
	icon_state = "blue"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/station_city/police
	name = "Motov'arna Port Authority"
	icon_state = "red"
	ambience = AMBIENCE_HIGHSEC

/area/sector/sky_planet/station_city/prison
	name = "Motov'arna Prison"
	icon_state = "red"
	ambience = AMBIENCE_HIGHSEC

/area/sector/sky_planet/station_city/street
	name = "Motov'arna Streets"
	icon_state = "red"
	ambience = AMBIENCE_HIGHSEC
	sound_env = LARGE_ENCLOSED

/area/sector/sky_planet/station_city/shop
	name = "Motov'arna Grocery"
	icon_state = "red"

/area/sector/sky_planet/station_city/appartement
	name = "Motov'arna Manager's Quarters"
	icon_state = "green"

/area/sector/sky_planet/station_city/appartement2
	name = "Motov'arna Professional's Quarters"
	icon_state = "green"

/area/sector/sky_planet/station_city/appartement3
	name = "Motov'arna Worker's Quarters"
	icon_state = "green"

/area/sector/sky_planet/station_city/school
	name = "Motov'arna School"
	icon_state = "green"

/area/sector/sky_planet/station_city/medical
	name = "Motov'arna Clinic"
	icon_state = "white"

/area/sector/sky_planet/station_city/offices
	name = "Motov'arna Admistration Building"
	icon_state = "green"

/area/sector/sky_planet/station_city/restaurant
	name = "Motov'arna Bar"
	icon_state = "green"

/area/sector/sky_planet/station_city/construction
	name = "Motov'arna Construction Site"
	icon_state = "orange"

/area/sector/sky_planet/station_city/garrison
	name = "Motov'arna Garrison"
	icon_state = "red"

/area/sector/sky_planet/station_city/fighters
	name = "Motov'arna Fighter Hangar"
	icon_state = "red"

/area/sector/sky_planet/station_city/range
	name = "Motov'arna Firing Range"
	icon_state = "red"

/area/sector/sky_planet/station_city/commander
	name = "Motov'arna Commander's Quarters"
	icon_state = "blue"

/area/sector/sky_planet/station_city/officers
	name = "Motov'arna Officer's Quarters"
	icon_state = "blue"

/area/sector/sky_planet/station_city/enlisted
	name = "Motov'arna Enlisted Barracks"
	icon_state = "red"

/area/sector/sky_planet/station_city/power
	name = "Motov'arna Power Station"
	icon_state = "yellow"

/area/sector/sky_planet/station_city/garage
	name = "Motov'arna Military Airlock"
	icon_state = "yellow"

//Ground

/area/sector/sky_planet/rock
	name = "Motov'maal Rocks"
	icon_state = "purple"

/area/sector/sky_planet/poi
	name = "Motov'maal POI"
	icon_state = "green"
	requires_power = 1
	sound_env = SMALL_ENCLOSED

//Elevators
/area/turbolift/skyplanet_outpost/lower
	name = "Ground Level (level 1)"
	lift_floor_label = "Ground Level"
	lift_floor_name = "Surface Access Airlocks"
	lift_announce_str = "Arriving at Ground Level."

/area/turbolift/skyplanet_outpost/upper
	name = "Sky Level (level 2)"
	lift_floor_label = "Sky Level"
	lift_floor_name = "Nanotrasen Landing Pads"
	lift_announce_str = "Arriving at Sky Level."

/area/turbolift/skyplanet_city/lower
	name = "Motov'arna Industrial (level 1)"
	lift_floor_label = "Surface Level"
	lift_floor_name = "Industrial District"
	lift_announce_str = "Arriving at Ground Level. Glory to the workers!"

/area/turbolift/skyplanet_city/upper
	name = "Motov'arna Residential (level 2)"
	lift_floor_label = "Sky Level"
	lift_floor_name = "Residential District"
	lift_announce_str = "Arriving at Sky Level. Long Live the Revolution!"

/area/turbolift/skyplanet_military/lower
	name = "Motov'arna Garrison (level 1)"
	lift_floor_label = "Surface Level"
	lift_floor_name = "Ground Level"
	lift_announce_str = "Arriving at Ground Level. The Hadii Revolution is eternal!"

/area/turbolift/skyplanet_military/upper
	name = "Motov'arna Garrison (level 2)"
	lift_floor_label = "Sky Level"
	lift_floor_name = "Upper Level"
	lift_announce_str = "Arriving at Sky Level. Report treasonous behavior to your Commissar!"
