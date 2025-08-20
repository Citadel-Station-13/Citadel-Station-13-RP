/*
CIRCUITS BELOW
*/

/datum/prototype/design/circuit
	lathe_type = LATHE_TYPE_CIRCUIT
	req_tech = list(TECH_DATA = 2)
	materials_base = list(MAT_GLASS = 2000)
	reagents = list("sacid" = 20)
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/prototype/design/circuit/generate_name(template)
	if(build_path)
		var/obj/item/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			return "Machine circuit design ([..()])"
		else if(initial(C.board_type) == "computer")
			return "Computer circuit design ([..()])"
		else
			return "Circuit design ([..()])"

/datum/prototype/design/circuit/generate_desc(template_name, template_desc)
	return "Allows for the construction of \a [build_name] circuit board."

/datum/prototype/design/circuit/arcademachine
	design_name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/circuitboard/arcade/battle

/datum/prototype/design/circuit/oriontrail
	design_name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/circuitboard/arcade/orion_trail

/datum/prototype/design/circuit/clawmachine
	design_name = "grab-a-gift arcade machine"
	id = "clawmachine"
	req_tech = list(TECH_DATA = 1)
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/circuitboard/arcade/clawmachine

/datum/prototype/design/circuit/jukebox
	design_name = "jukebox"
	id = "jukebox"
	req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/circuitboard/jukebox

/datum/prototype/design/circuit/seccamera
	design_name = "security camera monitor"
	id = "seccamera"
	category = DESIGN_CATEGORY_SECURITY
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/security

/datum/prototype/design/circuit/secdata
	design_name = "security records console"
	id = "sec_data"
	category = DESIGN_CATEGORY_SECURITY
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/secure_data

/datum/prototype/design/circuit/prisonmanage
	design_name = "prisoner management console"
	id = "prisonmanage"
	category = DESIGN_CATEGORY_SECURITY
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/prisoner

/datum/prototype/design/circuit/med_data
	design_name = "medical records console"
	id = "med_data"
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/med_data

/datum/prototype/design/circuit/operating
	design_name = "patient monitoring console"
	id = "operating"
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/operating

/datum/prototype/design/circuit/scan_console
	design_name = "DNA machine"
	id = "scan_console"
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/prototype/design/circuit/clonecontrol
	design_name = "cloning control console"
	id = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/cloning

/datum/prototype/design/circuit/clonepod
	design_name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/clonepod

/datum/prototype/design/circuit/clonescanner
	design_name = "cloning scanner"
	id = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/clonescanner

/datum/prototype/design/circuit/crewconsole
	design_name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	category = DESIGN_CATEGORY_MEDICAL
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/crew

/datum/prototype/design/circuit/teleconsole
	design_name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	category = DESIGN_CATEGORY_TELEPORTATION
	build_path = /obj/item/circuitboard/teleporter

/datum/prototype/design/circuit/robocontrol
	design_name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/robotics

/datum/prototype/design/circuit/mechacontrol
	design_name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/mecha_control

/datum/prototype/design/circuit/rdconsole
	design_name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/rdconsole

/datum/prototype/design/circuit/aifixer
	design_name = "AI integrity restorer"
	id = "aifixer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	category = DESIGN_CATEGORY_AI
	build_path = /obj/item/circuitboard/aifixer

/datum/prototype/design/circuit/comm_monitor
	design_name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_TELECOMMUNICATIONS
	build_path = /obj/item/circuitboard/comm_monitor

/datum/prototype/design/circuit/comm_server
	design_name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_TELECOMMUNICATIONS
	build_path = /obj/item/circuitboard/comm_server

/datum/prototype/design/circuit/message_monitor
	design_name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	category = DESIGN_CATEGORY_TELECOMMUNICATIONS
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/message_monitor

/datum/prototype/design/circuit/aiupload
	design_name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	category = DESIGN_CATEGORY_AI
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/aiupload

/datum/prototype/design/circuit/borgupload
	design_name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	category = DESIGN_CATEGORY_AI
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/borgupload

/datum/prototype/design/circuit/destructive_analyzer
	design_name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/destructive_analyzer

/datum/prototype/design/circuit/protolathe
	design_name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/protolathe

/datum/prototype/design/circuit/circuit_imprinter
	design_name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/prototype/design/circuit/autolathe
	design_name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/machine/lathe/autolathe

/datum/prototype/design/circuit/rdservercontrol
	design_name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/prototype/design/circuit/rdserver
	design_name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/rdserver

/datum/prototype/design/circuit/mechfab
	design_name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/mechfab

/datum/prototype/design/circuit/prosfab
	design_name = "prosthetics fabricator"
	id = "prosfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/prosthetics

/datum/prototype/design/circuit/processor
	design_name = "slime processor"
	id = "slime_processor"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/processor

/datum/prototype/design/circuit/mech_recharger
	design_name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_CHARGING
	build_path = /obj/item/circuitboard/mech_recharger

/datum/prototype/design/circuit/recharge_station
	design_name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_CHARGING
	build_path = /obj/item/circuitboard/recharge_station

/datum/prototype/design/circuit/atmosalerts
	design_name = "atmosphere alert console"
	id = "atmosalerts"
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/atmos_alert

/datum/prototype/design/circuit/air_management
	design_name = "atmosphere monitoring console"
	id = "air_management"
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/air_management

/datum/prototype/design/circuit/rcon_console
	design_name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/rcon_console

/datum/prototype/design/circuit/dronecontrol
	design_name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/drone_control

/datum/prototype/design/circuit/powermonitor
	design_name = "power monitoring console"
	id = "powermonitor"
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/powermonitor

/datum/prototype/design/circuit/solarcontrol
	design_name = "solar control console"
	id = "solarcontrol"
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_GENERATING
	build_path = /obj/item/circuitboard/solar_control

/*
/datum/prototype/design/circuit/shutoff_monitor
	design_name = "Automatic shutoff valve monitor"
	id = "shutoff_monitor"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shutoff_monitor
*/

/datum/prototype/design/circuit/pacman
	design_name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_GENERATING
	build_path = /obj/item/circuitboard/pacman

/datum/prototype/design/circuit/superpacman
	design_name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_GENERATING
	build_path = /obj/item/circuitboard/pacman/super

/datum/prototype/design/circuit/mrspacman
	design_name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	category = DESIGN_CATEGORY_POWER
	subcategory = DESIGN_SUBCATEGORY_GENERATING
	build_path = /obj/item/circuitboard/pacman/mrs

/datum/prototype/design/circuit/batteryrack
	design_name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_POWER
	build_path = /obj/item/circuitboard/batteryrack

/datum/prototype/design/circuit/smes_cell
	design_name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	category = DESIGN_CATEGORY_POWER
	build_path = /obj/item/circuitboard/smes

/datum/prototype/design/circuit/grid_checker
	design_name = "power grid checker"
	desc = "Allows for the construction of circuit boards used to build a grid checker."
	id = "grid_checker"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_POWER
	build_path = /obj/item/circuitboard/grid_checker

/datum/prototype/design/circuit/breakerbox
	design_name = "breaker box"
	desc = "Allows for the construction of circuit boards used to build a breaker box."
	id = "breakerbox"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_POWER
	build_path = /obj/item/circuitboard/breakerbox

/datum/prototype/design/circuit/gas_heater
	design_name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	category = DESIGN_CATEGORY_ATMOS
	build_path = /obj/item/circuitboard/unary_atmos/heater

/datum/prototype/design/circuit/gas_cooler
	design_name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	category = DESIGN_CATEGORY_ATMOS
	build_path = /obj/item/circuitboard/unary_atmos/cooler

/datum/prototype/design/circuit/secure_airlock
	design_name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_ATMOS
	build_path = /obj/item/airlock_electronics/secure

/datum/prototype/design/circuit/ordercomp
	design_name = "supply ordering console"
	id = "ordercomp"
	category = DESIGN_CATEGORY_CARGO_MINING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/supplycomp

/datum/prototype/design/circuit/supplycomp
	design_name = "supply control console"
	id = "supplycomp"
	req_tech = list(TECH_DATA = 3)
	category = DESIGN_CATEGORY_CARGO_MINING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/supplycomp/control

/datum/prototype/design/circuit/biogenerator
	design_name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	category = DESIGN_CATEGORY_RECREATION
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/biogenerator

/datum/prototype/design/circuit/miningdrill
	design_name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	category = DESIGN_CATEGORY_CARGO_MINING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/miningdrill

/datum/prototype/design/circuit/miningdrillbrace
	design_name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	category = DESIGN_CATEGORY_CARGO_MINING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/miningdrillbrace

/datum/prototype/design/circuit/comconsole
	design_name = "communications console"
	id = "comconsole"
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/communications

/datum/prototype/design/circuit/idcardconsole
	design_name = "ID card modification console"
	id = "idcardconsole"
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/card

/datum/prototype/design/circuit/emp_data
	design_name = "employment records console"
	id = "emp_data"
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/skills

/datum/prototype/design/circuit/arf_generator
	design_name = "atmospheric field generator"
	id = "arf_generator"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 4, TECH_BIO = 3)
	category = DESIGN_CATEGORY_ATMOS
	build_path = /obj/item/circuitboard/arf_generator

/datum/prototype/design/circuit/mecha
	abstract_type = /datum/prototype/design/circuit/mecha
	category = DESIGN_CATEGORY_MECHA
	req_tech = list(TECH_DATA = 3)

/datum/prototype/design/circuit/mecha/generate_name(template)
	return "Exosuit module circuit design ([template])"

/datum/prototype/design/circuit/mecha/generate_desc(template_name, template_desc)
	return "Allows for the construction of \a [template_name] module."

/datum/prototype/design/circuit/mecha/ripley_main
	design_name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/prototype/design/circuit/mecha/ripley_peri
	design_name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/prototype/design/circuit/mecha/odysseus_main
	design_name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/prototype/design/circuit/mecha/odysseus_peri
	design_name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/prototype/design/circuit/mecha/gygax_main
	design_name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/prototype/design/circuit/mecha/gygax_peri
	design_name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/prototype/design/circuit/mecha/gygax_targ
	design_name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

/datum/prototype/design/circuit/mecha/gygax_medical
	design_name = "'Serenity' medical control"
	id = "gygax_medical"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/medical

/datum/prototype/design/circuit/mecha/durand_main
	design_name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/prototype/design/circuit/mecha/durand_peri
	design_name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/prototype/design/circuit/mecha/durand_targ
	design_name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

/datum/prototype/design/circuit/mecha/honker_main
	design_name = "'H.O.N.K.' central control"
	id = "honker_main"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/main

/datum/prototype/design/circuit/mecha/honker_peri
	design_name = "'H.O.N.K.' peripherals control"
	id = "honker_peri"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/peripherals

/datum/prototype/design/circuit/mecha/honker_targ
	design_name = "'H.O.N.K.' weapon control and targeting"
	id = "honker_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/targeting

/datum/prototype/design/circuit/mecha/phazon_main
	design_name = "'Phazon' central control"
	id = "phazon_main"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 4, TECH_BLUESPACE = 6, TECH_ARCANE = 2)
	build_path = /obj/item/circuitboard/mecha/phazon/main

/datum/prototype/design/circuit/mecha/phazon_peri
	design_name = "'Phazon' peripherals control"
	id = "phazon_peri"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 4, TECH_BLUESPACE = 6, TECH_ARCANE = 2)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/prototype/design/circuit/mecha/phazon_targ
	design_name = "'Phazon' weapon control and targeting"
	id = "phazon_targ"
	req_tech = list(TECH_DATA = 6, TECH_COMBAT = 4, TECH_BLUESPACE = 6, TECH_ARCANE = 2)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting

/datum/prototype/design/circuit/mecha/reticent_main
	design_name = "'Reticent' central control"
	id = "reticent_main"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/main

/datum/prototype/design/circuit/mecha/reticent_peri
	design_name = "'Reticent' peripherals control"
	id = "reticent_peri"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/peripherals

/datum/prototype/design/circuit/mecha/reticent_targ
	design_name = "'Reticent' weapon control and targeting"
	id = "reticent_targ"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 2, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/targeting

///Fighters///

/datum/prototype/design/circuit/mecha/fighter
	abstract_type = /datum/prototype/design/circuit/mecha/fighter

//Pinnace//

/datum/prototype/design/circuit/mecha/fighter/pinnace_main
	design_name = "Pinnace central control board"
	id = "pinnace_main"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/main

/datum/prototype/design/circuit/mecha/fighter/pinnace_flight
	design_name = "Pinnace flight control board"
	id = "pinnace_flight"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/flight

/datum/prototype/design/circuit/mecha/fighter/pinnace_targeting
	design_name = "Pinnace weapon control and targeting board"
	id = "pinnace_targeting"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/targeting

/datum/prototype/design/circuit/mecha/fighter/pinnace_cockpit_control
	design_name = "Pinnace manual flight control instruments"
	id = "pinnace_cockpit_control"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/cockpitboard

//Baron//

/datum/prototype/design/circuit/mecha/fighter/baron_main
	design_name = "Baron central control board"
	id = "baron_main"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/main

/datum/prototype/design/circuit/mecha/fighter/baron_flight
	design_name = "Baron flight control board"
	id = "baron_flight"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/flight

/datum/prototype/design/circuit/mecha/fighter/baron_targeting
	design_name = "Baron weapon control and targeting board"
	id = "baron_targeting"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/targeting

/datum/prototype/design/circuit/mecha/fighter/baron_cockpit_control
	design_name = "Baron manual flight control instruments"
	id = "baron_cockpit_control"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/cockpitboard

//Duke//

/datum/prototype/design/circuit/mecha/fighter/duke_main
	design_name = "Duke central control board"
	id = "duke_main"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/main

/datum/prototype/design/circuit/mecha/fighter/duke_flight
	design_name = "Duke flight control board"
	id = "duke_flight"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/flight

/datum/prototype/design/circuit/mecha/fighter/duke_targeting
	design_name = "Duke weapon control and targeting board"
	id = "duke_targeting"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/targeting

/datum/prototype/design/circuit/mecha/fighter/duke_cockpit_control
	design_name = "Duke manual flight control instruments"
	id = "duke_cockpit_control"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/cockpitboard

//Tcomms//

/datum/prototype/design/circuit/tcom
	abstract_type = /datum/prototype/design/circuit/tcom
	category = DESIGN_CATEGORY_TELECOMMUNICATIONS
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/prototype/design/circuit/tcom/generate_name(template)
	return "Telecommunications machinery circuit design ([template])"

/datum/prototype/design/circuit/tcom/generate_desc(template_name, template_desc)
	return "Allows for the construction of a telecommunications [template_name] circuit board."

/datum/prototype/design/circuit/tcom/server
	design_name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/circuitboard/telecomms/server

/datum/prototype/design/circuit/tcom/processor
	design_name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/circuitboard/telecomms/processor

/datum/prototype/design/circuit/tcom/bus
	design_name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/circuitboard/telecomms/bus

/datum/prototype/design/circuit/tcom/hub
	design_name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/circuitboard/telecomms/hub

/datum/prototype/design/circuit/tcom/relay
	design_name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/telecomms/relay

/datum/prototype/design/circuit/tcom/broadcaster
	design_name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/broadcaster

/datum/prototype/design/circuit/tcom/receiver
	design_name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/receiver

/datum/prototype/design/circuit/tcom/exonet_node
	design_name = "exonet node"
	id = "tcom-exonet_node"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/telecomms/exonet_node

/datum/prototype/design/circuit/ntnet_relay
	design_name = "NTNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	category = DESIGN_CATEGORY_TELECOMMUNICATIONS
	build_path = /obj/item/circuitboard/ntnet_relay

/datum/prototype/design/circuit/aicore
	design_name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	category = DESIGN_CATEGORY_AI
	build_path = /obj/item/circuitboard/aicore

/datum/prototype/design/circuit/fossilrevive
	design_name = "Fossil DNA extractor"
	id = "fossilrevive"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	category = DESIGN_CATEGORY_SCIENCE
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/dnarevive

/datum/prototype/design/circuit/shield_generator
	design_name = "shield generator"
	id = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_BLUESPACE = 2, TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/shield_generator

/datum/prototype/design/circuit/shield_diffuser
	design_name = "shield diffuser"
	id = "shield_diffuser"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 2, TECH_ENGINEERING = 5)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/shield_diffuser

/datum/prototype/design/circuit/pointdefense
	design_name = "point defense battery"
	id = "pointdefense"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/pointdefense

/datum/prototype/design/circuit/pointdefense_control
	design_name = "point defense control" //Once upon a time, this was called a deluxe microwave.
	id = "pointdefense_control"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/pointdefense_control

/datum/prototype/design/circuit/massive_gas_pump
	design_name = "High performance gas pump"
	id = "massive_gas_pump"
	req_tech = list(TECH_ENGINEERING = 3)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/massive_gas_pump

/datum/prototype/design/circuit/massive_heat_pump
	design_name = "High performance heat pump"
	id = "massive_heat_pump"
	req_tech = list(TECH_ENGINEERING = 4)
	category = DESIGN_CATEGORY_ENGINEERING
	subcategory = DESIGN_SUBCATEGORY_STATION
	build_path = /obj/item/circuitboard/massive_heat_pump

/datum/prototype/design/circuit/coffeemaker
	design_name = "coffeemaker"
	id = "coffeemaker"
	category = DESIGN_CATEGORY_RECREATION
	build_path = /obj/item/circuitboard/machine/coffeemaker
