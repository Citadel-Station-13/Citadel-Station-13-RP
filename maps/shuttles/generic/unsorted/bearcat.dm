DECLARE_SHUTTLE_TEMPLATE(/generic/unsorted/bearcat)
	id = "generic-bearcat"
	name = "Bearcat Salvage Shuttle"
	desc = "An old salvage ship, abandoned but seemingly intact."
	descriptor = /datum/shuttle_descriptor{
		mass = 15000;
		overmap_legacy_name = "Binturong-class Salvage Vessel";
		overmap_legacy_scan_name = "IRV Bearcat";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: IRV Bearcat
[i]Class:[/i] Corvette
[i]Transponder[/i]: Transmitting \'Keep-Away\' Signal
[b]Notice[/b]: Abandoned under unclear circumstances."};
		overmap_icon_color = "#ee3333"; //Reddish, so it looks kinda rusty and beat up
	}

#warn below
/obj/effect/shuttle_landmark/shuttle_initializer/bearcat
/obj/overmap/entity/visitable/ship/landable/bearcat

DECLARE_SHUTTLE_AREA(/bearcat)
	name = "\improper Bearcat"
	//predates artificial gravity - won't matter much due to all the walls to push off of!
	has_gravity = FALSE

DECLARE_SHUTTLE_AREA(/bearcat/crew)
	name = "\improper Bearcat Crew Compartments"
	icon_state = "hallC"

DECLARE_SHUTTLE_AREA(/bearcat/crew_corridors)
	name = "\improper Bearcat Corridors"
	icon_state = "hallC1"

DECLARE_SHUTTLE_AREA(/bearcat/crew_kitchen)
	name = "\improper Bearcat Galley"
	icon_state = "kitchen"

DECLARE_SHUTTLE_AREA(/bearcat/crew_dorms)
	name = "\improper Bearcat Dorms"
	icon_state = "crew_quarters"

DECLARE_SHUTTLE_AREA(/bearcat/crew_saloon)
	name = "\improper Bearcat Saloon"
	icon_state = "conference"

DECLARE_SHUTTLE_AREA(/bearcat/crew_toilets)
	name = "\improper Bearcat Bathrooms"
	icon_state = "toilet"

DECLARE_SHUTTLE_AREA(/bearcat/crew_wash)
	name = "\improper Bearcat Washroom"
	icon_state = "locker"

DECLARE_SHUTTLE_AREA(/bearcat/crew_medbay)
	name = "\improper Bearcat Medical Bay"
	icon_state = "medbay"

DECLARE_SHUTTLE_AREA(/bearcat/cargo)
	name = "\improper Bearcat Cargo Hold"
	icon_state = "quartstorage"

DECLARE_SHUTTLE_AREA(/bearcat/dock)
	name = "\improper Bearcat Docking Bay"
	icon_state = "start"

DECLARE_SHUTTLE_AREA(/bearcat/dock_central)
	name = "\improper Bearcat Passenger Bay"
	icon_state = "start"

DECLARE_SHUTTLE_AREA(/bearcat/dock_port)
	name = "\improper Bearcat Docking Bay Port"
	icon_state = "west"

DECLARE_SHUTTLE_AREA(/bearcat/dock_starboard)
	name = "\improper Bearcat Docking Bay Starboard"
	icon_state = "east"

DECLARE_SHUTTLE_AREA(/bearcat/unused1)
	name = "\improper Bearcat Unused Compartment #1"
	icon_state = "green"

DECLARE_SHUTTLE_AREA(/bearcat/unused2)
	name = "\improper Bearcat Unused Compartment #2"
	icon_state = "yellow"

DECLARE_SHUTTLE_AREA(/bearcat/unused3)
	name = "\improper Bearcat Unused Compartment #3"
	icon_state = "blueold"

DECLARE_SHUTTLE_AREA(/bearcat/maintenance)
	name = "\improper Bearcat Maintenance Compartments"
	icon_state = "storage"

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_storage)
	name = "\improper Bearcat Tools Storage"
	icon_state = "eva"

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_atmos)
	name = "\improper Bearcat Atmospherics Compartment"
	icon_state = "atmos"
	music = list('sound/ambience/ambiatm1.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_power)
	name = "\improper Bearcat Power Compartment"
	icon_state = "engine_smes"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_engine)
	name = "\improper Bearcat Main Engine Compartment"
	icon_state = "engine"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_engine_pod_port)
	name = "\improper Bearcat Port Engine Pod"
	icon_state = "west"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_engine_pod_starboard)
	name = "\improper Bearcat Starboard Engine Pod"
	icon_state = "east"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/maintenance_enginecontrol)
	name = "\improper Bearcat Engine Control Room"
	icon_state = "engine_monitoring"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/command)
	name = "\improper Bearcat Command Deck"
	icon_state = "centcom"
	music = list('sound/ambience/signal.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/command_captain)
	name = "\improper Bearcat Captain's Quarters"
	icon_state = "captain"
	music = list('sound/ambience/signal.ogg')

DECLARE_SHUTTLE_AREA(/bearcat/comms)
	name = "\improper Bearcat Communications Relay"
	icon_state = "tcomsatcham"
	music = list('sound/ambience/signal.ogg')
