// Transfer Shuttle docking area

/area/station/space/endeavour/tram
	name = "\improper Transfer Shuttle Docking"
	icon_state = "dk_yellow"
	area_flags = AREA_FLAG_ERODING

//Aft Stairs

/area/station/hallway/endeavour/aft_stairs_one
	name = "\improper Aft Stairwell Deck 1"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/aft_stairs_two
	name = "\improper Aft Stairwell Deck 2"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/aft_stairs_three
	name = "\improper Aft Stairwell Deck 3"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/aft_stairs_four
	name = "\improper Aft Stairwell Deck 4"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

//Amidships Stairs

/area/station/hallway/endeavour/amidships_stairs_one
	name = "\improper Amidships Stairwell Deck 1"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/amidships_stairs_two
	name = "\improper Amidships Stairwell Deck 2"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/amidships_stairs_three
	name = "\improper Amidships Stairwell Deck 3"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/amidships_stairs_four
	name = "\improper Amidships Stairwell Deck 4"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

//Forward Stairs

/area/station/hallway/endeavour/forward_stairs_one
	name = "\improper Forward Stairwell Deck 1"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/forward_stairs_two
	name = "\improper Forward Stairwell Deck 2"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/forward_stairs_three
	name = "\improper Forward Stairwell Deck 3"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/station/hallway/endeavour/forward_stairs_four
	name = "\improper Forward Stairwell Deck 4"
	icon_state = "dk_yellow"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

// Public Areas


/area/station/hallway/endeavour/public_garden
	name = "\improper Public Garden"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/station/hallway/endeavour/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR

/area/station/hallway/endeavour/fishing_garden
	name = "\improper Fish Pond"
	icon_state = "blue"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/station/hallway/endeavour/sauna
	name = "\improper Public Sauna"
	icon_state = "green"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/station/hallway/endeavour/lounge
	name = "\improper Station Lounge"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/station/hallway/endeavour/public_meeting_room
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
/area/station/hallway/endeavour/d4aftmaint
	name = "\improper Deck 4 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4fwdportmaint
	name = "\improper Deck 4 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4fwdstrbdmaint
	name = "\improper Deck 4 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4aftportmaint
	name = "\improper Deck 4 Aft Port Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4aftstrbdmaint
	name = "\improper Deck 4 Aft Starboard Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4fwdmaint
	name = "\improper Deck 4 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4amidportmaint
	name = "\improper Deck 4 Port Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4amidstarbdmaint
	name = "\improper Deck 4 Starboard Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d4fwdhall
	name = "\improper Deck 4 Forward Hallway"
	icon_state = "hallF"

/area/station/hallway/endeavour/d4afthall
	name = "\improper Deck 4 Aft Hallway"
	icon_state = "hallA"

/area/station/hallway/endeavour/d4porthall
	name = "\improper Deck 4 Port Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d4portforhall
	name = "\improper Deck 4 Port Forward Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d4portamidhall
	name = "\improper Deck 4 Port Amidships Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d4portafthall
	name = "\improper Deck 4 Port Aft Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d4starboardhall
	name = "\improper Deck 4 Starboard Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d4starboardforhall
	name = "\improper Deck 4 Starboard Forward Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d4starboardamidhall
	name = "\improper Deck 4 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d4starboardafthall
	name = "\improper Deck 4 Starboard Aft Hallway"
	icon_state = "hallS"

/** Deck 3
 */
/area/station/hallway/endeavour/d3aftmaint
	name = "\improper Deck 3 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3aftportmaint
	name = "\improper Deck 3 Aft Port Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3aftstrbdmaint
	name = "\improper Deck 3 Aft Starboard Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3fwdmaint
	name = "\improper Deck 3 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3fwdportmaint
	name = "\improper Deck 3 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3fwdstrbdmaint
	name = "\improper Deck 3 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3amidportmaint
	name = "\improper Deck 3 Port Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3amidstarbdmaint
	name = "\improper Deck 3 Starboard Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d3fwdhall
	name = "\improper Deck 3 Forward Hallway"
	icon_state = "hallF"

/area/station/hallway/endeavour/d3afthall
	name = "\improper Deck 3 Aft Hallway"
	icon_state = "hallA"

/area/station/hallway/endeavour/d3porthall
	name = "\improper Deck 3 Port Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d3portforhall
	name = "\improper Deck 3 Port Forward Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d3portamidhall
	name = "\improper Deck 3 Port Amidships Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d3portafthall
	name = "\improper Deck 3 Port Aft Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d3starboardhall
	name = "\improper Deck 3 Starboard Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d3starboardforhall
	name = "\improper Deck 3 Starboard Forward Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d3starboardamidhall
	name = "\improper Deck 3 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d3starboardafthall
	name = "\improper Deck 3 Starboard Aft Hallway"
	icon_state = "hallS"

/** Deck 2
 */
/area/station/hallway/endeavour/d2aftmaint
	name = "\improper Deck 2 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2aftportmaint
	name = "\improper Deck 2 Aft Port Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2aftstrbdmaint
	name = "\improper Deck 2 Aft Starboard Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2fwdportmaint
	name = "\improper Deck 2 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2fwdstrbdmaint
	name = "\improper Deck 2 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2fwdmaint
	name = "\improper Deck 2 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2amidportmaint
	name = "\improper Deck 2 Port Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2amidstarbdmaint
	name = "\improper Deck 2 Starboard Amidships Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d2fwdhall
	name = "\improper Deck 2 Forward Hallway"
	icon_state = "hallF"

/area/station/hallway/endeavour/d2afthall
	name = "\improper Deck 2 Aft Hallway"
	icon_state = "hallA"

/area/station/hallway/endeavour/d2porthall
	name = "\improper Deck 2 Port Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d2portforhall
	name = "\improper Deck 2 Port Forward Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d2portamidhall
	name = "\improper Deck 2 Port Amidships Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d2portafthall
	name = "\improper Deck 2 Port Aft Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d2starboardhall
	name = "\improper Deck 2 Starboard Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d2starboardforhall
	name = "\improper Deck 2 Starboard Forward Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d1starboardamidhall
	name = "\improper Deck 2 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d2starboardafthall
	name = "\improper Deck 2 Starboard Aft Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/reservehanger
	name = "\improper Reserve Forward Hanger"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/** Deck 1
 */
/area/station/hallway/endeavour/d1aftmaint
	name = "\improper Deck 1 Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1portaftmaint
	name = "\improper Deck 1 Port Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1strbdaftmaint
	name = "\improper Deck 1 Starboard Aft Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1amidportmaint
	name = "\improper Deck 1 Port Amidships Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1amidstrbdmaint
	name = "\improper Deck 1 Port Amidships Maintenance"
	icon_state = "amaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1fwdmaint
	name = "\improper Deck 1 Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1portfwdmaint
	name = "\improper Deck 1 Port Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1strfwdmaint
	name = "\improper Deck 1 Starboard Forward Maintenance"
	icon_state = "fmaint"
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/station/hallway/endeavour/d1fwdhall
	name = "\improper Deck 1 Forward Hallway"
	icon_state = "hallF"

/area/station/hallway/endeavour/d1afthall
	name = "\improper Deck 1 Aft Hallway"
	icon_state = "hallA"

/area/station/hallway/endeavour/d1porthall
	name = "\improper Deck 1 Port Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d1portforhall
	name = "\improper Deck 1 Port Forward Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d1portamidhall
	name = "\improper Deck 1 Port Amidships Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d1portafthall
	name = "\improper Deck 1 Port Aft Hallway"
	icon_state = "hallP"

/area/station/hallway/endeavour/d1starboardhall
	name = "\improper Deck 1 Starboard Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d1starboardforhall
	name = "\improper Deck 1 Starboard Forward Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d1starboardamidhall
	name = "\improper Deck 1 Starboard Amidships Hallway"
	icon_state = "hallS"

/area/station/hallway/endeavour/d1starboardafthall
	name = "\improper Deck 1 Starboard Aft Hallway"
	icon_state = "hallS"

// Cryo Areas

/area/station/hallway/endeavour/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "crew_quarters"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/station/hallway/endeavour/crew_quarters/cryo/recovery
	name = "\improper Cryogenics Recovery"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/** Civillian
 */
/area/station/hallway/endeavour/civillian/evastorage
	name = "\improper Public EVA Storage"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/** Mining
 */

/area/station/mining/endeavour/breakroom
	name = "\improper Mining Breakroom"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/** Command
 */
/area/station/endeavour/command/turrets
	name = "\improper Auxiliary Bridge"
	icon_state = "bridge"
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/** Science
 */
/area/station/endeavour/rnd/robotics/morgue
	name = "\improper Robotics Morgue"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/rnd/robotics/smallcraft
	name = "\improper Small Craft and Probe Assembly"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Exploration
 */
/area/station/hallway/endeavour/exploration
	name = "\improper Exploration Department"
	icon_state = "purple"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/station/hallway/endeavour/exploration/hallway_fore
	name = "\improper Exploration Fore Hallway"

/area/station/hallway/endeavour/exploration/hallway_aft
	name = "\improper Exploration Aft Hallway"

/area/station/hallway/endeavour/exploration/aux_hanger
	name = "\improper Exploration Auxilliary Hanger"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/** Medical
 */

/area/station/endeavour/medical/virology_fore_access
	name = "\improper Virology Fore Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/medical/virology_aft_access
	name = "\improper Virology Aft Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/medical/cmo_dorm
	name = "\improper CMO Dormitory"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/station/endeavour/medical/locker_room
	name = "\improper Medical Locker Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Substations
 */

/area/station/endeavour/engineering/substation
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/engineering/substation/deck1forward
	name = "\improper Deck 1 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck1amidships
	name = "\improper Deck 1 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck1aft
	name = "\improper Deck 1 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck2forward
	name = "\improper Deck 2 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck2amidships
	name = "\improper Deck 2 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck2aft
	name = "\improper Deck 2 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck3forward
	name = "\improper Deck 3 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck3amidships
	name = "\improper Deck 3 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck3aft
	name = "\improper Deck 3 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck4forward
	name = "\improper Deck 4 Foreward Substation"
	icon_state = "engineering"
	ambience = 'sound/ambience/engineering/engineering3.ogg'

/area/station/endeavour/engineering/substation/deck4amidships
	name = "\improper Deck 4 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck4aft
	name = "\improper Deck 4 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION


/** Civillian
 */
/area/station/endeavour/civilian/evastorage
	name = "\improper Public EVA Storage"
	icon_state = "purple"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/** Command
 */
/area/station/endeavour/command/turrets
	name = "\improper Auxiliary Bridge"
	icon_state = "bridge"
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/** Science
 */
/area/station/endeavour/rnd/robotics/morgue
	name = "\improper Robotics Morgue"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/rnd/robotics/smallcraft
	name = "\improper Small Craft and Probe Assembly"
	icon_state = "robotics"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Exploration
 */
/area/station/endeavour/exploration
	name = "\improper Exploration Department"
	icon_state = "purple"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/station/endeavour/exploration/hallway_fore
	name = "\improper Exploration Fore Hallway"

/area/station/endeavour/exploration/hallway_aft
	name = "\improper Exploration Aft Hallway"

/area/station/endeavour/exploration/aux_hanger
	name = "\improper Exploration Auxilliary Hanger"
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/** Medical
 */

/area/station/endeavour/medical/virology_fore_access
	name = "\improper Virology Fore Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/medical/virology_aft_access
	name = "\improper Virology Aft Access"
	icon_state = "virology"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/medical/cmo_dorm
	name = "\improper CMO Dormitory"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_LEISURE

/area/station/endeavour/medical/locker_room
	name = "\improper Medical Locker Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/** Substations
 */

/area/station/endeavour/engineering/substation
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/station/endeavour/engineering/substation/deck1forward
	name = "\improper Deck 1 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck1amidships
	name = "\improper Deck 1 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck1aft
	name = "\improper Deck 1 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck2forward
	name = "\improper Deck 2 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck2amidships
	name = "\improper Deck 2 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck2aft
	name = "\improper Deck 2 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck3forward
	name = "\improper Deck 3 Foreward Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck3amidships
	name = "\improper Deck 3 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck3aft
	name = "\improper Deck 3 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck4forward
	name = "\improper Deck 4 Foreward Substation"
	icon_state = "engineering"
	ambience = 'sound/ambience/engineering/engineering3.ogg'

/area/station/endeavour/engineering/substation/deck4amidships
	name = "\improper Deck 4 Amidships Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION

/area/station/endeavour/engineering/substation/deck4aft
	name = "\improper Deck 4 Aft Substation"
	icon_state = "engineering"
	ambience = AMBIENCE_SUBSTATION
