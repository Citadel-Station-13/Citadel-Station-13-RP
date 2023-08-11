/**
 *! Ship/Space Station Areas
 *? Generic Maint Areas for use in ship maps and potentially space maps. Uses proper nautical terms for funzies
 */
/area/main_map


/**
 * Hallways
 */
/area/main_map/hallway
	sound_env = HALLWAY
	ambience = AMBIENCE_GENERIC

/area/main_map/hallway/deck0
	name = "Flight Deck Main Hallway"

/area/main_map/hallway/deck1
	name = "Deck 1 Main Hallway"

/area/main_map/hallway/deck1/fore
	name = "Deck 1 Fore Hallway"
/area/main_map/hallway/deck2
	name = "Deck 2 Main Hallway"

/area/main_map/hallway/deck3
	name = "Deck 3 Main Hallway"

/area/main_map/hallway/deck4
	name = "Deck 4 Main Hallway"
/**
 * Hangar
 */
/area/main_map/Hangar_bay
	name = "\improper Hangar Bay"
	sound_env = HANGAR

/area/main_map/Hangar_bay/deck0

/area/main_map/Hangar_bay/deck0/a

/area/main_map/Hangar_bay/deck0/b

/area/main_map/Hangar_bay/deck0/c

/area/main_map/Hangar_bay/deck0/d

/area/main_map/Hangar_bay/deck1
	name = "\improper Hangar Bay Deck 1"

/area/main_map/Hangar_bay/deck1/a
	name = "\improper Hangar Bay Deck 1A"

/area/main_map/Hangar_bay/deck1/b
	name = "\improper Hangar Bay Deck 1B"

/area/main_map/Hangar_bay/deck1/c
	name = "\improper Hangar Bay Deck 1C"

/area/main_map/Hangar_bay/deck1/d
	name = "\improper Hangar Bay Deck 1D"

/area/main_map/Hangar_bay/deck2
	name = "\improper Hangar Bay Deck 2"

/area/main_map/Hangar_bay/deck2/a
	name = "\improper Hangar Bay Deck 2A"

/area/main_map/Hangar_bay/deck2/b
	name = "\improper Hangar Bay Deck 2B"

/area/main_map/Hangar_bay/deck2/c
	name = "\improper Hangar Bay Deck 1C"

/area/main_map/Hangar_bay/deck2/d
	name = "\improper Hangar Bay Deck 2D"

/area/main_map/Hangar_bay/deck3
	name = "\improper Hangar Bay Deck 3"

/area/main_map/Hangar_bay/deck3/a
	name = "\improper Hangar Bay Deck 3A"

/area/main_map/Hangar_bay/deck3/b
	name = "\improper Hangar Bay Deck 3B"

/area/main_map/Hangar_bay/deck3/c
	name = "\improper Hangar Bay Deck 3C"

/area/main_map/Hangar_bay/deck3/d
	name = "\improper Hangar Bay Deck 3D"

/area/main_map/Hangar_bay/deck4
	name = "\improper Hangar Bay Deck 4"

/area/main_map/Hangar_bay/deck4/a
	name = "\improper Hangar Bay Deck 4A"

/area/main_map/Hangar_bay/deck4/b
	name = "\improper Hangar Bay Deck 4B"

/area/main_map/Hangar_bay/deck4/c
	name = "\improper Hangar Bay Deck 4C"

/area/main_map/Hangar_bay/deck4/d
	name = "\improper Hangar Bay Deck 4D"

/**
 *! Ship/Space Station Areas
 *? Generic Maint Areas for use in ship maps and potentially space maps. Uses proper nautical terms for funzies
 */

/area/main_map/maintenance
	area_flags = AREA_RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE


/area/main_map/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/main_map/maintenance/engineering/deck2
	name = "Engineering Maintenance Deck 2"
/area/main_map/maintenance/engineering/deck2/atmospheric_entrance
	name = "Engineering Maintenance Deck Atmospherics"

/area/main_map/maintenance/engineering/deck2/power_line

/area/main_map/maintenance/engineering/deck3

/area/main_map/maintenance/engineering/deck4

/area/main_map/maintenance/engineering/deck4/secondary
/**
 *! Deck One Maint Areas
 */
/area/main_map/maintenance/deck_one
	name = "\improper Deck 1 Maintenance"
	icon_state = "maintcentral"

/area/main_map/maintenance/deck_one/port
	name = "\improper Deck 1 Port Maintenance"
	icon_state = "pmaint"

/area/main_map/maintenance/deck_one/starboard
	name = "\improper Deck 1 Starboard Maintenance"
	icon_state = "smaint"

/area/main_map/maintenance/deck_one/forward
	name = "\improper Deck 1 Forward Maintenance"
	icon_state = "fmaint"

/area/main_map/maintenance/deck_one/forward/port
	name = "\improper Deck 1 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/main_map/maintenance/deck_one/forward/starboard
	name = "\improper Deck 1 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/main_map/maintenance/deck_one/aft
	name = "\improper Deck 1 Aft Maintenance"
	icon_state = "amaint"

/area/main_map/maintenance/deck_one/aft/port
	name = "\improper Deck 1 Aft Port Maintenance"
	icon_state = "apmaint"

/area/main_map/maintenance/deck_one/aft/starboard
	name = "\improper Deck 1 Aft Starboard Maintenance"
	icon_state = "asmaint"

/**
 *! Deck Two Maint Areas
 */
/area/main_map/maintenance/deck_two
	name = "\improper Deck 2 Maintenance"
	icon_state = "maintcentral"

/area/main_map/maintenance/deck_two/port
	name = "\improper Deck 2 Port Maintenance"
	icon_state = "pmaint"

/area/main_map/maintenance/deck_two/starboard
	name = "\improper Deck 2 Starboard Maintenance"
	icon_state = "smaint"

/area/main_map/maintenance/deck_two/forward
	name = "\improper Deck 2 Forward Maintenance"
	icon_state = "fmaint"

/area/main_map/maintenance/deck_two/forward/port
	name = "\improper Deck 2 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/main_map/maintenance/deck_two/forward/starboard
	name = "\improper Deck 2 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/main_map/maintenance/deck_two/aft
	name = "\improper Deck 2 Aft Maintenance"
	icon_state = "amaint"

/area/main_map/maintenance/deck_two/aft/port
	name = "\improper Deck 2 Aft Port Maintenance"
	icon_state = "apmaint"

/area/main_map/maintenance/deck_two/aft/starboard
	name = "\improper Deck 2 Aft Starboard Maintenance"
	icon_state = "asmaint"


/**
 *! Deck Three Maint Areas
 */
/area/main_map/maintenance/deck_three
	name = "\improper Deck 3 Maintenance"
	icon_state = "maintcentral"
/area/main_map/maintenance/deck_three/port
	name = "\improper Deck 3 Port Maintenance"
	icon_state = "pmaint"

/area/main_map/maintenance/deck_three/starboard
	name = "\improper Deck 3 Starboard Maintenance"
	icon_state = "smaint"

/area/main_map/maintenance/deck_three/forward
	name = "\improper Deck 3 Forward Maintenance"
	icon_state = "fmaint"

/area/main_map/maintenance/deck_three/forward/port
	name = "\improper Deck 3 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/main_map/maintenance/deck_three/forward/starboard
	name = "\improper Deck 3 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/main_map/maintenance/deck_three/aft
	name = "\improper Deck 3 Aft Maintenance"
	icon_state = "amaint"

/area/main_map/maintenance/deck_three/aft/port
	name = "\improper Deck 3 Aft Port Maintenance"
	icon_state = "apmaint"

/area/main_map/maintenance/deck_three/aft/starboard
	name = "\improper Deck 3 Aft Starboard Maintenance"
	icon_state = "asmaint"


/**
 *! Deck Four Maint Areas
 */
/area/main_map/maintenance/deck_four
	name = "\improper Deck 4 Maintenance"
	icon_state = "maintcentral"

/area/main_map/maintenance/deck_four/port
	name = "\improper Deck 4 Port Maintenance"
	icon_state = "pmaint"

/area/main_map/maintenance/deck_four/starboard
	name = "\improper Deck 4 Starboard Maintenance"
	icon_state = "smaint"

/area/main_map/maintenance/deck_four/forward
	name = "\improper Deck 4 Forward Maintenance"
	icon_state = "fmaint"

/area/main_map/maintenance/deck_four/forward/port
	name = "\improper Deck 4 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/main_map/maintenance/deck_four/forward/starboard
	name = "\improper Deck 4 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/main_map/maintenance/deck_four/aft
	name = "\improper Deck 4 Aft Maintenance"
	icon_state = "amaint"

/area/main_map/maintenance/deck_four/aft/port
	name = "\improper Deck 4 Aft Port Maintenance"
	icon_state = "apmaint"

/area/main_map/maintenance/deck_four/aft/starboard
	name = "\improper Deck 4 Aft Starboard Maintenance"
	icon_state = "asmaint"


/**
 * Panic Bunkers
 */

/area/main_map/maintenance/panic_bunker
	name = "\improper Panic Bunker One"

/area/main_map/maintenance/panic_bunker/two
	name = "\improper Panic Bunker Two"

/area/main_map/maintenance/panic_bunker/three
	name = "\improper Panic Bunker Three"

/area/main_map/maintenance/panic_bunker/four
	name = "\improper Panic Bunker Four"

/area/main_map/maintenance/panic_bunker/five
	name = "\improper Panic Bunker Five"


/**
 * Atomspheric Substation
 */

/area/main_map/maintenance/atmospheric_substation
	name = "\improper Atmospheric Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_ATMOS

/area/main_map/maintenance/atmospheric_substation/medical
	name = "\improper Medical Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/cargo
	name = "\improper Cargo Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/security
	name = "\improper Security Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/command
	name = "\improper Command Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/service
	name = "\improper Service Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/civilian
	name = "\improper Civilian Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/Hangar_bay
	name = "\improper Hangar Bay Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/research
	name = "\improper Research Atmospheric Substation"

/area/main_map/maintenance/atmospheric_substation/ai
	name = "\improper AI Atmospheric Substation"



/*
/**
 *! Deck One Maint Areas
 */
/area/maintenance/deck_one
	name = "\improper Deck 1 Maintenance"
	icon_state = "maintcentral"

/area/maintenance/deck_one/port
	name = "\improper Deck 1 Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/deck_one/starboard
	name = "\improper Deck 1 Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/deck_one/forward
	name = "\improper Deck 1 Forward Maintenance"
	icon_state = "fmaint"

/area/maintenance/deck_one/forward/port
	name = "\improper Deck 1 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/deck_one/forward/starboard
	name = "\improper Deck 1 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/deck_one/aft
	name = "\improper Deck 1 Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/deck_one/aft/port
	name = "\improper Deck 1 Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/deck_one/aft/starboard
	name = "\improper Deck 1 Aft Starboard Maintenance"
	icon_state = "asmaint"

/**
 *! Deck Two Maint Areas
 */
/area/maintenance/deck_two
	name = "\improper Deck 2 Maintenance"
	icon_state = "maintcentral"

/area/maintenance/deck_two/port
	name = "\improper Deck 2 Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/deck_two/starboard
	name = "\improper Deck 2 Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/deck_two/forward
	name = "\improper Deck 2 Forward Maintenance"
	icon_state = "fmaint"

/area/maintenance/deck_two/forward/port
	name = "\improper Deck 2 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/deck_two/forward/starboard
	name = "\improper Deck 2 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/deck_two/aft
	name = "\improper Deck 2 Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/deck_two/aft/port
	name = "\improper Deck 2 Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/deck_two/aft/starboard
	name = "\improper Deck 2 Aft Starboard Maintenance"
	icon_state = "asmaint"


/**
 *! Deck Three Maint Areas
 */
/area/maintenance/deck_three
	name = "\improper Deck 3 Maintenance"
	icon_state = "maintcentral"
/area/maintenance/deck_three/port
	name = "\improper Deck 3 Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/deck_three/starboard
	name = "\improper Deck 3 Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/deck_three/forward
	name = "\improper Deck 3 Forward Maintenance"
	icon_state = "fmaint"

/area/maintenance/deck_three/forward/port
	name = "\improper Deck 3 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/deck_three/forward/starboard
	name = "\improper Deck 3 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/deck_three/aft
	name = "\improper Deck 3 Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/deck_three/aft/port
	name = "\improper Deck 3 Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/deck_three/aft/starboard
	name = "\improper Deck 3 Aft Starboard Maintenance"
	icon_state = "asmaint"


/**
 *! Deck Four Maint Areas
 */
/area/maintenance/deck_four
	name = "\improper Deck 4 Maintenance"
	icon_state = "maintcentral"

/area/maintenance/deck_four/port
	name = "\improper Deck 4 Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/deck_four/starboard
	name = "\improper Deck 4 Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/deck_four/forward
	name = "\improper Deck 4 Forward Maintenance"
	icon_state = "fmaint"

/area/maintenance/deck_four/forward/port
	name = "\improper Deck 4 Forward Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/deck_four/forward/starboard
	name = "\improper Deck 4 Forward Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/deck_four/aft
	name = "\improper Deck 4 Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/deck_four/aft/port
	name = "\improper Deck 4 Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/deck_four/aft/starboard
	name = "\improper Deck 4 Aft Starboard Maintenance"
	icon_state = "asmaint"


/**
 * Panic Bunkers
 */

/area/maintenance/panic_bunker
	name = "\improper Panic Bunker One"

/area/maintenance/panic_bunker/two
	name = "\improper Panic Bunker Two"

/area/maintenance/panic_bunker/three
	name = "\improper Panic Bunker Three"

/area/maintenance/panic_bunker/four
	name = "\improper Panic Bunker Four"

/area/maintenance/panic_bunker/five
	name = "\improper Panic Bunker Five"


/**
 * Atomspheric Substation
 */

/area/maintenance/atmospheric_substation
	name = "\improper Atmospheric Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_ATMOS

/area/maintenance/atmospheric_substation/medical
	name = "\improper Medical Atmospheric Substation"

/area/maintenance/atmospheric_substation/cargo
	name = "\improper Cargo Atmospheric Substation"

/area/maintenance/atmospheric_substation/security
	name = "\improper Security Atmospheric Substation"

/area/maintenance/atmospheric_substation/command
	name = "\improper Command Atmospheric Substation"

/area/maintenance/atmospheric_substation/service
	name = "\improper Service Atmospheric Substation"

/area/maintenance/atmospheric_substation/civilian
	name = "\improper Civilian Atmospheric Substation"

/area/maintenance/atmospheric_substation/Hangar_bay
	name = "\improper Hangar Bay Atmospheric Substation"

/area/maintenance/atmospheric_substation/research
	name = "\improper Research Atmospheric Substation"

/area/maintenance/atmospheric_substation/ai
	name = "\improper AI Atmospheric Substation"
*/
