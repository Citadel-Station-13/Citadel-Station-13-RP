// Transfer Shuttle docking area

/area/space/tram/endeavour
	name = "\improper Transfer Shuttle Docking"
	icon_state = "dk_yellow"
	area_flags = AREA_FLAG_ERODING

//Aft Stairs

/area/hallway/aft_stairs_one/endeavour
	name = "\improper Aft Stairwell Deck 1"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/aft_stairs_two/endeavour
	name = "\improper Aft Stairwell Deck 2"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/aft_stairs_three/endeavour
	name = "\improper Aft Stairwell Deck 3"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/aft_stairs_four/endeavour
	name = "\improper Aft Stairwell Deck 4"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

//Amidships Stairs

/area/hallway/amidships_stairs_one/endeavour
	name = "\improper Amidships Stairwell Deck 1"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/amidships_stairs_two/endeavour
	name = "\improper Amidships Stairwell Deck 2"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/amidships_stairs_three/endeavour
	name = "\improper Amidships Stairwell Deck 3"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/amidships_stairs_four/endeavour
	name = "\improper Amidships Stairwell Deck 4"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

//Forward Stairs

/area/hallway/forward_stairs_one/endeavour
	name = "\improper Forward Stairwell Deck 1"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/forward_stairs_two/endeavour
	name = "\improper Forward Stairwell Deck 2"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/forward_stairs_three/endeavour
	name = "\improper Forward Stairwell Deck 3"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hallway/forward_stairs_four/endeavour
	name = "\improper Forward Stairwell Deck 4"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

// Public Areas


/area/hallway/public_garden/endeavour
	name = "\improper Public Garden"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/hallway/bar_backroom/endeavour
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR

/area/hallway/fishing_garden/endeavour
	name = "\improper Fish Pond"
	icon_state = "blue"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/hallway/sauna/endeavour
	name = "\improper Public Sauna"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/hallway/lounge/endeavour
	name = "\improper Station Lounge"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/hallway/public_meeting_room/endeavour
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES


/** Endeavour Hallways
 */
/area/station/hallway/endeavour
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/** Deck 4
 */
/area/hallway/d4aftmaint/endeavour
	name = "\improper Deck 4 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4fwdportmaint/endeavour
	name = "\improper Deck 4 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4fwdstrbdmaint/endeavour
	name = "\improper Deck 4 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4aftportmaint/endeavour
	name = "\improper Deck 4 Aft Port Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4aftstrbdmaint/endeavour
	name = "\improper Deck 4 Aft Starboard Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4fwdmaint/endeavour
	name = "\improper Deck 4 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4amidportmaint/endeavour
	name = "\improper Deck 4 Port Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4amidstarbdmaint/endeavour
	name = "\improper Deck 4 Starboard Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d4fwdhall/endeavour
	name = "\improper Deck 4 Forward Hallway"
	icon_state = "hallF"

/area/hallway/d4afthall/endeavour
	name = "\improper Deck 4 Aft Hallway"
	icon_state = "hallA"

/area/hallway/d4porthall/endeavour
	name = "\improper Deck 4 Port Hallway"
	icon_state = "hallP"

/area/hallway/d4portforhall/endeavour
	name = "\improper Deck 4 Port Forward Hallway"
	icon_state = "hallP"

/area/hallway/d4portamidhall/endeavour
	name = "\improper Deck 4 Port Amidships Hallway"
	icon_state = "hallP"

/area/hallway/d4portafthall/endeavour
	name = "\improper Deck 4 Port Aft Hallway"
	icon_state = "hallP"

/area/hallway/d4starboardhall/endeavour
	name = "\improper Deck 4 Starboard Hallway"
	icon_state = "hallS"

/area/hallway/d4starboardforhall/endeavour
	name = "\improper Deck 4 Starboard Forward Hallway"
	icon_state = "hallS"

/area/hallway/d4starboardamidhall/endeavour
	name = "\improper Deck 4 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/hallway/d4starboardafthall/endeavour
	name = "\improper Deck 4 Starboard Aft Hallway"
	icon_state = "hallS"

/** Deck 3
 */
/area/hallway/d3aftmaint/endeavour
	name = "\improper Deck 3 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3aftportmaint/endeavour
	name = "\improper Deck 3 Aft Port Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3aftportsecmaint/endeavour
	name = "\improper Deck 3 Aft Port Security Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3aftstrbdmaint/endeavour
	name = "\improper Deck 3 Aft Starboard Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3fwdmaint/endeavour
	name = "\improper Deck 3 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3fwdportmaint/endeavour
	name = "\improper Deck 3 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3fwdstrbdmaint/endeavour
	name = "\improper Deck 3 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3amidportmaint/endeavour
	name = "\improper Deck 3 Port Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3amidstarbdmaint/endeavour
	name = "\improper Deck 3 Starboard Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d3fwdhall/endeavour
	name = "\improper Deck 3 Forward Hallway"
	icon_state = "hallF"

/area/hallway/d3afthall/endeavour
	name = "\improper Deck 3 Aft Hallway"
	icon_state = "hallA"

/area/hallway/d3porthall/endeavour
	name = "\improper Deck 3 Port Hallway"
	icon_state = "hallP"

/area/hallway/d3portforhall/endeavour
	name = "\improper Deck 3 Port Forward Hallway"
	icon_state = "hallP"

/area/hallway/d3portamidhall/endeavour
	name = "\improper Deck 3 Port Amidships Hallway"
	icon_state = "hallP"

/area/hallway/d3portafthall/endeavour
	name = "\improper Deck 3 Port Aft Hallway"
	icon_state = "hallP"

/area/hallway/d3starboardhall/endeavour
	name = "\improper Deck 3 Starboard Hallway"
	icon_state = "hallS"

/area/hallway/d3starboardforhall/endeavour
	name = "\improper Deck 3 Starboard Forward Hallway"
	icon_state = "hallS"

/area/hallway/d3starboardamidhall/endeavour
	name = "\improper Deck 3 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/hallway/d3starboardafthall/endeavour
	name = "\improper Deck 3 Starboard Aft Hallway"
	icon_state = "hallS"

/** Deck 2
 */
/area/hallway/d2aftmaint/endeavour
	name = "\improper Deck 2 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2aftportmaint/endeavour
	name = "\improper Deck 2 Aft Port Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2aftstrbdmaint/endeavour
	name = "\improper Deck 2 Aft Starboard Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2fwdportmaint/endeavour
	name = "\improper Deck 2 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2fwdstrbdmaint/endeavour
	name = "\improper Deck 2 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2fwdmaint/endeavour
	name = "\improper Deck 2 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2amidportmaint/endeavour
	name = "\improper Deck 2 Port Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2amidstarbdmaint/endeavour
	name = "\improper Deck 2 Starboard Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d2fwdhall/endeavour
	name = "\improper Deck 2 Forward Hallway"
	icon_state = "hallF"

/area/hallway/d2afthall/endeavour
	name = "\improper Deck 2 Aft Hallway"
	icon_state = "hallA"

/area/hallway/d2porthall/endeavour
	name = "\improper Deck 2 Port Hallway"
	icon_state = "hallP"

/area/hallway/d2portforhall/endeavour
	name = "\improper Deck 2 Port Forward Hallway"
	icon_state = "hallP"

/area/hallway/d2portamidhall/endeavour
	name = "\improper Deck 2 Port Amidships Hallway"
	icon_state = "hallP"

/area/hallway/d2portafthall/endeavour
	name = "\improper Deck 2 Port Aft Hallway"
	icon_state = "hallP"

/area/hallway/d2starboardhall/endeavour
	name = "\improper Deck 2 Starboard Hallway"
	icon_state = "hallS"

/area/hallway/d2starboardforhall/endeavour
	name = "\improper Deck 2 Starboard Forward Hallway"
	icon_state = "hallS"

/area/hallway/d1starboardamidhall/endeavour
	name = "\improper Deck 2 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/hallway/d2starboardafthall/endeavour
	name = "\improper Deck 2 Starboard Aft Hallway"
	icon_state = "hallS"

/area/hallway/reservehanger/endeavour
	name = "\improper Reserve Forward Hanger"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/** Deck 1
 */
/area/hallway/d1aftmaint/endeavour
	name = "\improper Deck 1 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1portaftmaint/endeavour
	name = "\improper Deck 1 Port Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1strbdaftmaint/endeavour
	name = "\improper Deck 1 Starboard Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1amidportmaint/endeavour
	name = "\improper Deck 1 Port Amidships Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1amidstrbdmaint/endeavour
	name = "\improper Deck 1 Port Amidships Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1fwdmaint/endeavour
	name = "\improper Deck 1 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1portfwdmaint/endeavour
	name = "\improper Deck 1 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1strfwdmaint/endeavour
	name = "\improper Deck 1 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/hallway/d1fwdhall/endeavour
	name = "\improper Deck 1 Forward Hallway"
	icon_state = "hallF"

/area/hallway/d1afthall/endeavour
	name = "\improper Deck 1 Aft Hallway"
	icon_state = "hallA"

/area/hallway/d1porthall/endeavour
	name = "\improper Deck 1 Port Hallway"
	icon_state = "hallP"

/area/hallway/d1portforhall/endeavour
	name = "\improper Deck 1 Port Forward Hallway"
	icon_state = "hallP"

/area/hallway/d1portamidhall/endeavour
	name = "\improper Deck 1 Port Amidships Hallway"
	icon_state = "hallP"

/area/hallway/d1portafthall/endeavour
	name = "\improper Deck 1 Port Aft Hallway"
	icon_state = "hallP"

/area/hallway/d1starboardhall/endeavour
	name = "\improper Deck 1 Starboard Hallway"
	icon_state = "hallS"

/area/hallway/d1starboardforhall/endeavour
	name = "\improper Deck 1 Starboard Forward Hallway"
	icon_state = "hallS"

/area/hallway/d1starboardamidhall/endeavour
	name = "\improper Deck 1 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/hallway/d1starboardafthall/endeavour
	name = "\improper Deck 1 Starboard Aft Hallway"
	icon_state = "hallS"

// Cryo Areas

/area/hallway/cryo/endeavour
	name = "\improper Cryogenic Storage"
	icon_state = "crew_quarters"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/hallway/crew_quarters/cryo/recovery/endeavour
	name = "\improper Cryogenics Recovery"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/** Civillian
 */
/area/hallway/civillian/evastorage/endeavour
	name = "\improper Public EVA Storage"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/** Mining
 */

/area/station/mining/breakroom/endeavour
	name = "\improper Mining Breakroom"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/** Command
 */
/area/station/command/turrets/endeavour
	name = "\improper Auxiliary Bridge"
	icon_state = "bridge"
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/** Science
 */
/area/station/rnd/robotics/morgue/endeavour
	name = "\improper Robotics Morgue"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/rnd/robotics/smallcraft/endeavour
	name = "\improper Small Craft and Probe Assembly"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Exploration
 */
/area/hallway/exploration/endeavour
	name = "\improper Exploration Department"
	icon_state = "purple"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/hallway/exploration/hallway_fore/endeavour
	name = "\improper Exploration Fore Hallway"

/area/hallway/exploration/hallway_aft/endeavour
	name = "\improper Exploration Aft Hallway"

/area/hallway/exploration/aux_hanger/endeavour
	name = "\improper Exploration Auxilliary Hanger"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/** Medical
 */

/area/station/medical/virology_fore_access/endeavour
	name = "\improper Virology Fore Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/medical/virology_aft_access/endeavour
	name = "\improper Virology Aft Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/medical/cmo_dorm/endeavour
	name = "\improper CMO Dormitory"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/station/medical/locker_room/endeavour
	name = "\improper Medical Locker Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Substations
 */

/area/station/engineering/substation/endeavour
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/engineering/substation/deck1forward/endeavour
	name = "\improper Deck 1 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck1amidships/endeavour
	name = "\improper Deck 1 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck1aft/endeavour
	name = "\improper Deck 1 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck2forward/endeavour
	name = "\improper Deck 2 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck2amidships/endeavour
	name = "\improper Deck 2 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck2aft/endeavour
	name = "\improper Deck 2 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck3forward/endeavour
	name = "\improper Deck 3 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck3amidships/endeavour
	name = "\improper Deck 3 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck3aft/endeavour
	name = "\improper Deck 3 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck4forward/endeavour
	name = "\improper Deck 4 Foreward Substation"
	icon_state = "engineering"
	ambience = 'sound/ambience/engineering/engineering3.ogg'

/area/station/engineering/substation/deck4amidships/endeavour
	name = "\improper Deck 4 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck4aft/endeavour
	name = "\improper Deck 4 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION


/** Civillian
 */
/area/station/civilian/evastorage/endeavour
	name = "\improper Public EVA Storage"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/** Command
 */
/area/station/command/turrets/endeavour
	name = "\improper Auxiliary Bridge"
	icon_state = "bridge"
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/** Science
 */
/area/station/rnd/robotics/morgue/endeavour
	name = "\improper Robotics Morgue"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/rnd/robotics/smallcraft/endeavour
	name = "\improper Small Craft and Probe Assembly"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Exploration
 */
/area/station/exploration/endeavour
	name = "\improper Exploration Department"
	icon_state = "purple"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/station/exploration/hallway_fore/endeavour
	name = "\improper Exploration Fore Hallway"

/area/station/exploration/hallway_aft/endeavour
	name = "\improper Exploration Aft Hallway"

/area/station/exploration/aux_hanger/endeavour
	name = "\improper Exploration Auxilliary Hanger"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/** Medical
 */

/area/station/medical/virology_fore_access/endeavour
	name = "\improper Virology Fore Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/medical/virology_aft_access/endeavour
	name = "\improper Virology Aft Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/medical/cmo_dorm/endeavour
	name = "\improper CMO Dormitory"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/station/medical/locker_room/endeavour
	name = "\improper Medical Locker Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Substations
 */

/area/station/engineering/substation/endeavour
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/engineering/substation/deck1forward/endeavour
	name = "\improper Deck 1 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck1amidships/endeavour
	name = "\improper Deck 1 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck1aft/endeavour
	name = "\improper Deck 1 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck2forward/endeavour
	name = "\improper Deck 2 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck2amidships/endeavour
	name = "\improper Deck 2 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck2aft/endeavour
	name = "\improper Deck 2 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck3forward/endeavour
	name = "\improper Deck 3 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck3amidships/endeavour
	name = "\improper Deck 3 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck3aft/endeavour
	name = "\improper Deck 3 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck4forward/endeavour
	name = "\improper Deck 4 Foreward Substation"
	icon_state = "engineering"
	ambience = 'sound/ambience/engineering/engineering3.ogg'

/area/station/engineering/substation/deck4amidships/endeavour
	name = "\improper Deck 4 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/engineering/substation/deck4aft/endeavour
	name = "\improper Deck 4 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION
