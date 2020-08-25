/obj/effect/overmap/visitable/ship/triumph
	name = "NSV Triumph"	// Name of the location on the overmap.
	desc = "The Triumph is one of the many ships that is a part of the NDV Marksmans Fleet in this sector"

	scanner_desc = @{"[i]Registration[/i]: NSV Triumph
[i]Class[/i]: Science Vessel
[i]Transponder[/i]: Transmitting (CIV), NanoTrasen IFF
[b]Notice[/b]: NanoTrasen Vessel, authorized personnel only"}

	icon_state = "ship"
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	start_x = 4
	start_y = 5
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_shared_space", "nav_capitalship_docking1", "nav_capitalship_docking2")

	initial_restricted_waypoints = list("nav_hanger_excursion")
