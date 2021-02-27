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
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_capitalship_docking2", "triumph_excursion_hangar", "triumph_space_SW", "triumph_mining_port")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("triumph_excursion_hangar"),
		"Civilian Transport" = list("triumph_civvie_home"),
		"Dart EMT Shuttle" = list("triumph_emt_dock"),
		"Beruang Trade Ship" = list("triumph_annex_dock"),
		"Mining Shuttle" = list("triumph_mining_port")
		)

// EXCURSION SHUTTLE DATA
/obj/effect/overmap/visitable/ship/landable/excursion
	name = "Excursion Shuttle"
	desc = "A modified Excursion shuttle thats seen in use of the Marksman fleet of NanoTrasen."
	fore_dir = WEST
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Excursion Shuttle"

/datum/shuttle/autodock/overmap/excursion
	name = "Excursion Shuttle"
	warmup_time = 2
	shuttle_area = list(/area/shuttle/excursion/cockpit, /area/shuttle/excursion/general, /area/shuttle/excursion/cargo)
	current_location = "triumph_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	fuel_consumption = 2

/area/shuttle/excursion
	name = "Excursion Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(access_pilot)

// Public Civilian Shuttle

/obj/effect/overmap/visitable/ship/landable/civvie
	name = "Civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = EAST
	vessel_mass = 15000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Civilian Transport"


// Vox Pirate ship (Yaya, yous be giving us all your gear now.)

/obj/effect/overmap/visitable/ship/landable/pirate
	name = "Pirate Skiff"
	desc = "Yous need not care about this."
	fore_dir = WEST
	vessel_mass = 7000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Pirate Skiff"

/*/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/pirate/cockpit, /area/shuttle/pirate/general, /area/shuttle/pirate/cargo)
	current_location = "piratebase_hanger"
	docking_controller_tag = "pirate_docker"
	fuel_consumption = 5

/obj/machinery/computer/shuttle_control/explore/pirate
	name = "short jump raiding console"
	shuttle_tag = "Pirate Skiff"
*/

// Mining Shuttle

/obj/effect/overmap/visitable/ship/landable/mining
	name = "Mining Shuttle"
	desc = "It ain't much, but it's honest work."
	fore_dir = WEST
	vessel_mass = 7000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Mining Shuttle"

// Trade Shuttle

/obj/effect/overmap/visitable/ship/landable/trade
	name = "Beruang Trade Ship"
	desc = "You know our motto: 'We deliver!'"
	fore_dir = WEST
	vessel_mass = 25000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Beruang Trade Ship"

//EMT Shuttle

/obj/effect/overmap/visitable/ship/landable/emt
	name = "Dart EMT Shuttle"
	desc = "The budget didn't allow for flashing lights."
	fore_dir = EAST
	vessel_mass = 9000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Dart EMT Shuttle"

// STATIC PLANET/BASE LOCATIONS

// -- Datums -- //
/obj/effect/overmap/visitable/sector/debrisfield
	name = "Debris Field"
	desc = "Space junk galore."
	scanner_desc = @{"[i]Information[/i]: A collection of ruins from ages ago.."}
	icon_state = "dust2"
	color = "#BBBBBB"
	known = FALSE
	in_space = 1
	initial_generic_waypoints = list("triumph_excursion_debrisfield")


/obj/effect/overmap/visitable/sector/class_d
	name = "Unidentified Planet"
	desc = "ASdlke ERROR%%%% UNABLE TO----."
	scanner_desc = @{"[i]Information[/i]: Scans report a planet with nearly no atmosphere, but life-signs are registered."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#882933"

/obj/effect/overmap/visitable/sector/class_h
	name = "Desert Planet"
	desc = "Planet readings indicate light atmosphere and high heat."
	scanner_desc = @{"[i]Information[/i]
Atmosphere: Thin
Weather: Sunny, little to no wind
Lifesign: Multiple Fauna and humanoid life-signs detected."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#BA9066"


/obj/effect/overmap/visitable/sector/pirate_base
	name = "Vox Pirate Base"
	desc = "A nest of hostiles to the company. Caution is advised."
	scanner_desc = @{"[i]Information[/i]
Warning, unable to scan through sensor shielding systems at location. Possible heavy hostile life-signs."}
	in_space = 1
	known = FALSE
	icon_state = "piratebase"
	color = "#FF3333"
	initial_generic_waypoints = list("piratebase_hanger")

/obj/effect/overmap/visitable/sector/mining_planet
	name = "Mineral Rich Planet"
	desc = "A planet filled with valuable minerals. No life signs currently detected on the surface."
	scanner_desc = @{"[i]Information[/i]
Atmopshere: Mix of Oxygen, Nitrogen and Phoron. DANGER
Lifesigns: No immediate life-signs detected."}
	in_space = 0
	icon_state = "globe"
	color = "#8F6E4C"
	initial_generic_waypoints = list("mining_outpost")

/obj/effect/overmap/visitable/sector/gaia_planet
	name = "Gaia Planet"
	desc = "A planet with peaceful life, and ample flora."
	scanner_desc = @{"[i]Incoming Message[/i]: Hello travler! Looking to enjoy the shine of the star on land?
Are you weary from all that constant space travel?
Looking to quench a thirst of multiple types?
Then look no further than the resorts of Sigmar!
With a branch on every known Gaia planet, we aim to please and serve.
Our fully automated ---- [i]Message exceeds character limit.[/i]
[i] Information [/i]
Atmosphere: Breathable with standard human required environment
Weather: Sunny, with chance of showers and thunderstorms. 25C
Lifesign: Multiple Fauna. No history of hostile life recorded
Ownership: Planet is owned by the Happy Days and Sunshine Corporation.
Allignment: Neutral to NanoTrasen. No Discount for services expected."}
	in_space = 0
	icon_state = "globe"
	known = FALSE
	color = "#33BB33"

/obj/effect/overmap/visitable/sector/frozen_planet
	name = "Frozen Planet"
	desc = "A world shrouded in cold and snow that seems to never let up."
	scanner_desc = @{"[i]Information[/i]: A planet with a very cold atmosphere. Possible life signs detected."}
	icon_state = "globe"
	color = "#3434AA"
	known = FALSE
	in_space = 0

/obj/effect/overmap/visitable/sector/trade_post
	name = "Nebula Gas Food Mart"
	desc = "A ubiquitous chain of traders common in this area of the Galaxy."
	scanner_desc = @{"[i]Information[/i]: A trade post and fuel depot. Possible life signs detected."}
	in_space = 1
	known = TRUE
	icon_state = "fueldepot"
	color = "#8F6E4C"

	initial_generic_waypoints = list("nebula_space_SW")

	initial_restricted_waypoints = list(
		"Beruang Trade Ship" = list("tradeport_hangar"),
		"Mining Shuttle" = list("nebula_pad_2"),
		"Excursion Shuttle" = list("nebula_pad_3"),
		"Pirate Skiff" = list("nebula_pad_4"),
		"Dart EMT Shuttle" = list("nebula_pad_5"),
		"Civilian Transport" = list("nebula_pad_6")
		)
