/obj/overmap/visitable/ship/triumph
	name = "NSV Triumph"	// Name of the location on the overmap.
	desc = "The Triumph is one of the many ships that is a part of the NDV Marksmans Fleet in this sector"

	scanner_desc = @{"[i]Registration[/i]: NSV Triumph
[i]Class[/i]: Science Vessel
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Vessel, authorized personnel only"}

	icon_state = "ship"
	vessel_mass = 25000
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_capitalship_docking2", "triumph_excursion_hangar", "triumph_space_SW", "triumph_mining_port")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("triumph_excursion_hangar"),
		"Courser Scouting Vessel" = list("triumph_courser_hangar"),
		"Hammerhead Patrol Barge" = list("triumph_hammerhead_hangar"),
		"Civilian Transport" = list("triumph_civvie_home"),
		"Dart EMT Shuttle" = list("triumph_emt_dock"),
		"Beruang Trade Ship" = list("triumph_annex_dock"),
		"Mining Shuttle" = list("triumph_mining_port")
		)
