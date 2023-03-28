//////////////////////////////////////////////////////////////////////////
// There is literally a dm file for triumph shuttles, why are these here//
//////////////////////////////////////////////////////////////////////////
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

/area/shuttle/excursion
	name = "Excursion Shuttle"
	icon_state = "shuttle"

/obj/machinery/computer/shuttle_control/explore/excursion
	name = "short jump console"
	shuttle_tag = "Excursion Shuttle"
	req_one_access = list(ACCESS_GENERAL_PILOT)

//Courser Shuttle Data
/obj/effect/overmap/visitable/ship/landable/courser
	name = "Courser Scouting Vessel"
	desc = "Where there's a cannon, there's a way."
	fore_dir = EAST
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Courser Scouting Vessel"

// Public Civilian Shuttle

/obj/effect/overmap/visitable/ship/landable/civvie
	name = "Civilian Transport"
	desc = "A basic, but slow, transport to ferry civilian to and from the ship."
	fore_dir = EAST
	vessel_mass = 15000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Civilian Transport"



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
	name = "Pirate Base"
	desc = "A nest of hostiles to the company. Caution is advised."
	scanner_desc = @{"[i]Information[/i]
Warning, unable to scan through sensor shielding systems at location. Possible heavy hostile life-signs."}
	in_space = 1
	known = FALSE
	icon_state = "piratebase"
	color = "#FF3333"
	initial_generic_waypoints = list("pirate_docking_arm")

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

/obj/effect/overmap/visitable/sector/class_p
	name = "Frozen Planet"
	desc = "A world shrouded in cold and snow that seems to never let up."
	scanner_desc = @{"[i]Information[/i]: A planet with a very cold atmosphere. Possible life signs detected."}
	icon_state = "globe"
	color = "#3434AA"
	known = FALSE
	in_space = 0

