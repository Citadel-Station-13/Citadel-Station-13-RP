// -- Datums -- //

/obj/overmap/entity/visitable/sector/lavaland
	name = "Surt"
	desc = "A volcanic planet home to the bronze age Scori civilization."
	scanner_desc = @{"[i]Stellar Body[/i]: Surt
[i]Class[/i]: Regressed F-Class Planet
[i]Habitability[/i]: Extremely Low (Extremely High Temperature, Toxic Atmosphere, High Volcanic Activity)
[i]Population[/i]: (Native Scori Population Unknown: Estimates Range from 20-100 Million)
[i]Controlling Goverment[/i]: Early Fuedal Realms
[b]Relationship with NT[/b]: Nanotrasen Protectorate (Unofficial).
[b]Notice[/b]: Native population protected under the Primitive Species Preservation Act."}

	icon_state = "globe"
	color = "#d62000" //Lava Red
	in_space = 0
	initial_generic_waypoints = list(
		"surt_pad_1a",
		"surt_pad_1b",
		"surt_pad_1c",
		"surt_pad_1d",
		"surt_pad_2a",
		"surt_pad_2b",
		"surt_pad_2c",
		"surt_pad_2d"
		)

	start_x	= 40
	start_y	= 10

/obj/machinery/telecomms/relay/preset/surt //Surt T-Comms info is kept here to be used on multiple maps
	id = "Surt Relay"
	autolinkers = list("surt_relay")

/area/shuttle/excursion/lavaland
	name = "Shuttle Landing Point"
	area_flags = AREA_RAD_SHIELDED

/area/lavaland
	name = "Surt"
	icon_state = "away"
	requires_power = 1
	dynamic_lighting = 1

/area/lavaland/horrors
	name = "Surt - Horrors"

/area/lavaland/dogs
	name = "Surt - Dogs"

/area/lavaland/idleruins
	name = "Surt - Idle Ruins"

/area/lavaland/ashlander_camp
	name = "Surt - Ashlander Camp"

/area/lavaland/bosses
	name = "Surt - Boss"
	requires_power = 0

/area/lavaland/central/base
	name = "Surt Outpost"
	icon_state = "green"

/area/lavaland/central/base/common
	name = "Surt Outpost - Common Areas"
	icon_state = "blue"

/area/lavaland/central/base/airlock
	name = "Surt Outpost - Airlock"
	icon_state = "blue"

/area/lavaland/central/base/pads
	name = "Surt Outpost - Landing Pads"
	icon_state = "blue"

/area/lavaland/central/base/teleporter
	name = "Surt Outpost - Teleporter"
	icon_state = "blue"

/area/lavaland/central/base/mining_storage
	name = "Surt Outpost - Mining Storage"
	icon_state = "blue"

/area/lavaland/central/base/engine
	name = "Surt Outpost - Engine Room"
	icon_state = "blue"

/area/lavaland/central/base/dorms
	name = "Surt Outpost - Engine Dorms"
	icon_state = "blue"

/area/lavaland/central/base/teleporter
	name = "Surt Outpost - Teleporter"
	icon_state = "blue"

/area/lavaland/central/base/exterior
	name = "Surt Outpost - Exterior Scaffold"
	icon_state = "blue"

/area/lavaland/central/explored
	name = "Surt (Center) - Thoroughfare"
	icon_state = "red"
	ambience = AMBIENCE_LAVA

/area/lavaland/central/unexplored
	name = "Surt (Center) - Unknown"
	icon_state = "yellow"
	ambience = AMBIENCE_LAVA

/area/lavaland/central/transit
	name = "Surt (Center) - Transit"
	icon_state = "blue"

/area/lavaland/north/explored
	name = "Surt (North) - Thoroughfare"
	icon_state = "red"
	ambience = AMBIENCE_LAVA

/area/lavaland/north/unexplored
	name = "Surt (North) - Unknown"
	icon_state = "yellow"
	ambience = AMBIENCE_LAVA

/area/lavaland/south/explored
	name = "Surt (South) - Thoroughfare"
	icon_state = "red"
	ambience = AMBIENCE_LAVA

/area/lavaland/south/unexplored
	name = "Surt (South) - Unknown"
	icon_state = "yellow"
	ambience = AMBIENCE_LAVA

/area/lavaland/east/explored
	name = "Surt (East) - Thoroughfare"
	icon_state = "red"
	ambience = AMBIENCE_LAVA

/area/lavaland/east/unexplored
	name = "Surt (East) - Unknown"
	icon_state = "yellow"
	ambience = AMBIENCE_LAVA

/area/lavaland/east/transit
	name = "Surt (East) - Transit"
	icon_state = "blue"

/area/lavaland/east/ashlander_village
	name = "Surt (East) - Ashlander Village"
	icon_state = "blue"

/area/lavaland/west/explored
	name = "Surt (West) - Thoroughfare"
	icon_state = "red"
	ambience = AMBIENCE_LAVA
