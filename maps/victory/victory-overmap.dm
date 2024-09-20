/obj/overmap/entity/visitable/ship/victory
	name = "NSV Victory"	// Name of the location on the overmap.
	desc = "The Victory is one of the many ships that is a part of the NDV Marksmans Fleet in this sector"

	scanner_desc = @{"[i]Registration[/i]: NSV Victory
[i]Class[/i]: Science Vessel
[i]Transponder[/i]: Transmitting (CIV), Nanotrasen IFF
[b]Notice[/b]: Nanotrasen Vessel, authorized personnel only"}

	icon_state = "ship"
	vessel_mass = 12500 // temporarily buffed by 2x due to vorestation fucking up large gas thruster code
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_capitalship_docking2", "victory_excursion_hangar", "victory_space_SW", "victory_mining_port")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("victory_excursion_hangar"),
		"Courser Scouting Vessel" = list("victory_courser_hangar"),
		"Hammerhead Patrol Barge" = list("victory_hammerhead_hangar"),
		"Civilian Transport" = list("victory_civvie_home"),
		"Dart EMT Shuttle" = list("victory_emt_dock"),
		"Beruang Trade Ship" = list("victory_annex_dock"),
		"Mining Shuttle" = list("victory_mining_port"),
		"NDV Quicksilver" = list("victory_specops_dock")
		)
