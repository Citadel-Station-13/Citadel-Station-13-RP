
/area/strelka
	name = "\improper ship Base"
	dynamic_lighting = 1
	requires_power = 1
	ambience = AMBIENCE_GENERIC
	icon = 'icons/turf/areas.dmi'
	icon_state = ""

/area/strelka/pointdefense
	name = "\improper turret point defense"
	icon_state = "bridge"

//DECK 4
//
// BRIDGE

/area/maintenance/strelka/bridge4
	name = "\improper Deck 4 Bridge Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE
	nightshift_level = NIGHTSHIFT_LEVEL_UNSET

/area/bridge/strelka
	name = "\improper Deck 4 Bridge"
	icon_state = "bridge"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_BRIDGE
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/captain
	name = "\improper Deck 4 Captain Office"
	icon_state = "captain"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/captain/room
	name = "\improper Deck 4 Captain Room"
	icon_state = "captain"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/hop
	name = "\improper Deck 4 HoP Counter"
	icon_state = "captain"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/hop/office
	name = "\improper Deck 4 HoP Office"
	icon_state = "captain"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/hop/room
	name = "\improper Deck 4 Hop Room"
	icon_state = "captain"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

//Deck 3
//
//BRIDGE

/area/bridge/strelka/ai
	name = "\improper Deck 3 AI Chamber"
	icon_state = "ai_chamber"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_SENSITIVE

/area/bridge/strelka/borg
	name = "\improper Deck 3 AI Borg Chamber"
	icon_state = "ai_chamber"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_SENSITIVE

/area/bridge/strelka/upload
	name = "\improper Deck 3 AI Upload Chamber"
	icon_state = "ai_chamber"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_SENSITIVE

/area/bridge/strelka/deck3
	name = "\improper Deck 3 Bridge"
	icon_state = "bridge"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_HALLWAYS

/area/bridge/strelka/blueshield
	name = "\improper Deck 3 Blueshield office"
	icon_state = "bridge"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/blueshield/room
	name = "\improper Deck 3 Blueshield Room"
	icon_state = "bridge"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/rd
	name = "\improper Deck 3 Chief Science Officer Quarters"
	icon_state = "purple"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/md
	name = "\improper Deck 3 Chief Medical Officer Quarters"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

//DECK2 BRIDGE

/area/bridge/strelka/hos
	name = "\improper Deck 2 Head of Security Quarters"
	icon_state = "sec_hos"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/ce
	name = "\improper Deck 2 Chief Engineer Quarters"
	icon_state = "yellow"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/iaa
	name = "\improper Deck 2 IAA offices"
	icon_state = "darkred"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_FACILITIES

/area/bridge/strelka/hallway
	name = "\improper Deck 2 Bridge hallway"
	icon_state = "darkred"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_HALLWAYS

//DECK1 BRIDGE

/area/bridge/strelka/balista
	name = "\improper Deck 1 Balista"
	icon_state = "darkred"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_BRIDGE
	nightshift_level = NIGHTSHIFT_LEVEL_COMMAND_SENSITIVE

// DECK 4 HALLWAY

/area/hallway/strelka/deck4
	name = "\improper Deck 4 Primary Hallway"
	icon_state = "hallC1"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_STRELKA_HALLWAY_UPPER
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

// DECK 3 HALLWAY

/area/hallway/strelka/deck3
	name = "\improper Deck 3 Primary Garden Way"
	icon_state = "hallC"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_STRELKA_HALLWAY
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

// DECK 2 HALLWAY

/area/hallway/strelka/deck2
	name = "\improper Deck 2 Primary Hallway"
	icon_state = "hallC"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_STRELKA_MUSEUM
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

// DECK 1 HALLWAY

/area/hallway/strelka/deck1
	name = "\improper Deck 1 Primary Hallway"
	icon_state = "hallC"
	sound_env = LARGE_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

//Civilian

/area/arrival/strelka
	name = "\improper Deck 4 Arrival"
	icon_state = "hallC1"
	ambience = AMBIENCE_ARRIVALS
	sound_env = SMALL_ENCLOSED
	requires_power = 1
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/hydroponics/strelka/hallway/botany
	name = "\improper Deck 4 Botany Overpass"
	icon_state = "green"
	sound_env = LARGE_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_BOTANY
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/crew_quarters/bar/strelka
	name = "\improper Deck 4 Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/crew_quarters/bar/strelka/back
	name = "\improper Deck 4 Bar backroom"
	icon_state = "bar"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/crew_quarters/kitchen/strelka
	name = "\improper Deck 4 Kitchen"
	icon_state = "kitchen"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/crew_quarters/kitchen/strelka/freeze
	name = "\improper Deck 4 Kitchen Freezer"
	icon_state = "kitchen"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/hallway/strelka/dormhallway
	name = "\improper Deck 4 Dorm Hallway"
	icon_state = "locker"
	sound_env = LARGE_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_HALLWAYS

/area/strelka/dormhallway/Dorm
	name = "\improper Deck 4 Dorm 1"
	icon_state = "crew_quarters"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/strelka/dormhallway/Dorm/Room2
	name = "\improper Deck 4 Dorm 2"

/area/strelka/dormhallway/Dorm/Room3
	name = "\improper Deck 4 Dorm 3"

/area/strelka/dormhallway/Dorm/Room4
	name = "\improper Deck 4 Dorm 4"

/area/strelka/dormhallway/pool
	name = "\improper Deck 4 Pool"
	icon_state = "green"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_POOL

/area/strelka/dormhallway/pool/sauna
	name = "\improper Deck 4 Sauna 1"
	icon_state = "green"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_SAUNA
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/strelka/dormhallway/pool/sauna/room2
	name = "\improper Deck 4 Sauna 2"
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/library/strelka/library
	name = "\improper Deck 4 Library"
	icon_state = "library"
	sound_env = MEDIUM_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/library/strelka/library/room
	name = "\improper Deck 4 Library Room"
	icon_state = "library"
	sound_env = SMALL_SOFTFLOOR
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/fitness/strelka
	name = "\improper Deck 4 Fitness room"
	icon_state = "fitness"
	sound_env = MEDIUM_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/strelka/adherent
	name = "\improper Deck 4 Adherent room"
	icon_state = "fitness"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/strelka/nanite
	name = "\improper Deck 4 Nanite room"
	icon_state = "fitness"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_AI
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/fitness/strelka/clown
	name = "\improper Deck 4 Clown room"
	icon_state = "clown"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/fitness/strelka/mime
	name = "\improper Deck 4 Mime room"
	icon_state = "mime"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/chapel/strelka
	name = "\improper Deck 4 Chapel"
	icon_state = "chapel"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_CHAPEL
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/chapel/strelka/morgue
	name = "\improper Deck 4 Chapel Morgue"
	icon_state = "chapel_morgue"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/chapel/strelka/office
	name = "\improper Deck 4 Chapel Office"
	icon_state = "chapeloffice"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/janitor
	name = "\improper Deck 4 janitorial office"
	icon_state = "janitor"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/maintenance/strelka
	name = "\improper Deck 4 Maintenance and chute"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

/area/maintenance/strelka/library
	name = "\improper Deck 4 Maintenance Library"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

//MEDICAL

/area/medical/strelka
	name = "\improper Deck 3 Medical Waiting Lobby"
	icon_state = "medbay"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_MEDICAL
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/medical/strelka/main
	name = "\improper Deck 3 Medical Main room"
	icon_state = "medbay"
	sound_env = STANDARD_STATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/roomhallway
	name = "\improper Deck 3 Medical Room Hallway"
	icon_state = "medbay"
	sound_env = STANDARD_STATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/medical/strelka/room
	name = "\improper Deck 3 Medical Room1"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/room2
	name = "\improper Deck 3 Medical Room2"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/surgery
	name = "\improper Deck 3 Medical Surgery Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/resleeve
	name = "\improper Deck 3 Medical Resleeving Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/morgue
	name = "\improper Deck 3 Medical morgue"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/emtroom
	name = "\improper Deck 3 Medical EMT Prep Room"
	icon_state = "medbay"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/medical/strelka/psy
	name = "\improper Deck 3 Medical Psychiatry Room"
	icon_state = "medbay"
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/maintenance/strelka/medical
	name = "\improper Deck 3 Medical Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

//Cargo

/area/quartermaster/strelka
	name = "\improper Deck 3 Cargo Lobby"
	icon_state = "cargo_hallway"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_HANGAR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/quartermaster/strelka/reception
	name = "\improper Deck 3 Cargo Reception"
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/quartermaster/strelka/cargo/hangar
	name = "\improper Deck 3 Cargo Hangar"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/quartermaster/strelka/cargo/mining
	name = "\improper Deck 3 Cargo Mining"
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/mininghangar
	name = "\improper Deck 3 Cargo Mining hangar"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/quartermaster/strelka/qm
	name = "\improper Deck 3 Cargo QM office"
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/quartermaster/strelka/portal
	name = "\improper Deck 3 Cargo Portal room"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/maintenance/strelka/cargo
	name = "\improper Deck 3 Medical Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

//Science

/area/rnd/strelka
	name = "\improper Deck 3 RnD Lobby"
	icon_state = "research"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/rnd/strelka/science/main
	name = "\improper Deck 3 RnD Main area"
	icon_state = "research"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/strelka/science/secondary
	name = "\improper Deck 3 RnD Secondary area"
	icon_state = "research"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/strelka/robotics
	name = "\improper Deck 3 RnD Robotics"
	icon_state = "research"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/strelka/xenobio
	name = "\improper Deck 3 RnD Xenobio area"
	icon_state = "research"
	sound_env = STANDARD_STATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/strelka/test
	name = "\improper Deck 3 RnD testing"
	icon_state = "research"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/strelka/servers
	name = "\improper Deck 3 RnD server room"
	icon_state = "research"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/rnd/strelka/xenobotany
	name = "\improper Deck 3 RnD Xenobotany"
	icon_state = "research"
	sound_env = STANDARD_STATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/maintenance/strelka/science
	name = "\improper Deck 3 Science Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

/area/rnd/strelka/tele
	name = "\improper Deck 2 RnD telescience and Xenoarcheology"
	icon_state = "research"
	sound_env = STANDARD_STATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/rnd/strelka/anomaly
	name = "\improper Deck 2 RnD Anomaly lab"
	icon_state = "research"
	sound_env = STANDARD_STATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES


//SECURITY

/area/security/strelka
	name = "\improper Deck 2 Security Lobby"
	icon_state = "security"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/security/strelka/reception
	name = "\improper Deck 2 Security reception"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/main
	name = "\improper Deck 2 Main Security"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/warden
	name = "\improper Deck 2 Security Warden office"
	icon_state = "security_sub"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/storage
	name = "\improper Deck 2 Security storage"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/cell1
	name = "\improper Deck 2 Security Cell 1"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/cell2
	name = "\improper Deck 2 Security Cell 2"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/cell3
	name = "\improper Deck 2 Security Cell 3"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/evidence
	name = "\improper Deck 2 Security Evidence storage"
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/interogation
	name = "\improper Deck 2 Security Interrogation"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/detective
	name = "\improper Deck 2 Detective Office"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/detective/lab
	name = "\improper Deck 2 Detective Lab"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/maintenance/strelka/sec
	name = "\improper Deck 2 Security Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

//Exploration / EMT

/area/strelka/explo
	name = "\improper Deck 2 Away team Hangar"
	icon_state = "hangar"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_HANGAR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/strelka/explo/pathfy
	name = "\improper Deck 2 Away team Pathfinder office"
	icon_state = "hangar"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/explo/emt
	name = "\improper Deck 2 Security and EMT Hangar"
	icon_state = "hangar"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_HANGAR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

//engineering

/area/engineering/hallway/strelka/engineering
	name = "\improper Deck 2 Engineering lobby"
	icon_state = "engineering"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_ATMOS
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_HALLWAYS

/area/engineering/strelka/storage
	name = "\improper Deck 2 Engineering storage room"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/shield
	name = "\improper Deck 2 Engineering Shield room"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/engine
	name = "\improper Deck 2 Engineering Engine room"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/atmos/strelka/engineering/atmos
	name = "\improper Deck 2 Engineering Atmos room"
	icon_state = "atmos"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/atmos/storage
	name = "\improper Deck 2 Engineering Atmos storage"
	icon_state = "atmos"
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/nacelle
	name = "\improper Deck 2 Engineering Nacelle - Port"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/nacelle2
	name = "\improper Deck 2 Engineering Nacelle - Starboard"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/board
	name = "\improper Deck 2 Engineering Circuit storage"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/engineering/strelka/coms
	name = "\improper Deck 2 Engineering Communication room"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/engineering/strelka/gas
	name = "\improper Deck 2 Engineering / RnD Gas storage"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/maintenance/strelka/eva
	name = "\improper Deck 2 Engineering Maintenance / EVA and solars"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

/area/maintenance/strelka/bridge
	name = "\improper Deck 2 Bridge Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE

// DECK 1 Security

/area/strelka/pilot_EVA
	name = "\improper Deck 1 Security EVA prep room"
	icon_state = "security_sub"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/security/strelka/armory
	name = "\improper Deck 1 Security Armory section 1"
	icon_state = "security_sub"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_HIGHSEC
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/security/strelka/armory2
	name = "\improper Deck 1 Security Armory section 2"
	icon_state = "security_sub"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_HIGHSEC
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/security/strelka/armory3
	name = "\improper Deck 1 Security Armory section 3"
	icon_state = "security_sub"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/strelka/checkpoint
	name = "\improper Deck 1 Security Checkpoint"
	icon_state = "security_sub"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/fighterbaysec
	name = "\improper Deck 1 Security Duke Fighterbay"
	icon_state = "security_sub"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

//Deck 1 Civilian

/area/strelka/pilot
	name = "\improper Deck 1 Pilot office"
	icon_state = "bluenew"
	sound_env = SMALL_SOFTFLOOR
	ambience = AMBIENCE_STRELKA_ROOM_WOOD
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/pilot/eva
	name = "\improper Deck 1 Pilot prep room"
	icon_state = "bluenew"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/toolstorage
	name = "\improper Deck 1 Tool Storage"
	icon_state = "bluenew"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_STRELKA_ROOM
	nightshift_level = NIGHTSHIFT_LEVEL_PUBLIC_FACILITIES

/area/strelka/firingrange
	name = "\improper Deck 1 Tool Firing range"
	icon_state = "bluenew"
	sound_env = SMALL_ENCLOSED
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_FACILITIES

/area/strelka/fighterbay
	name = "\improper Deck 1 Fighterbay"
	icon_state = "security_sub"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_HIGHSEC
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/strelka/civhangar
	name = "\improper Deck 1 Civilian Shuttle Hangar"
	icon_state = "green"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_HANGAR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/strelka/hangardeck
	name = "\improper Deck 1 Hangar deck"
	icon_state = "bluenew"
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_HANGAR
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/strelka/gateway
	name = "\improper Deck 1 Hangar deck"
	icon_state = "submap2"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_SUBSTATION
	nightshift_level = NIGHTSHIFT_LEVEL_DEPARTMENT_SENSITIVE

/area/maintenance/strelka/civ
	name = "\improper Deck 1 Maintenance"
	icon_state = "maintcentral"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_MAINTENANCE
