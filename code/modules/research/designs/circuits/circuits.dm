/*
CIRCUITS BELOW
*/

/datum/design/circuit
	lathe_type = LATHE_TYPE_CIRCUIT
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 2000)
	reagents = list("sacid" = 20)
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/circuit/generate_name(template)
	if(build_path)
		var/obj/item/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			return "Machine circuit design ([..()])"
		else if(initial(C.board_type) == "computer")
			return "Computer circuit design ([..()])"
		else
			return "Circuit design ([..()])"

/datum/design/circuit/generate_desc(template_name, template_desc)
	return "Allows for the construction of \a [build_name] circuit board."

/datum/design/circuit/arcademachine
	design_name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle

/datum/design/circuit/oriontrail
	design_name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail

/datum/design/circuit/clawmachine
	design_name = "grab-a-gift arcade machine"
	id = "clawmachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/clawmachine

/datum/design/circuit/jukebox
	design_name = "jukebox"
	id = "jukebox"
	req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	build_path = /obj/item/circuitboard/jukebox

/datum/design/circuit/seccamera
	design_name = "security camera monitor"
	id = "seccamera"
	build_path = /obj/item/circuitboard/security

/datum/design/circuit/secdata
	design_name = "security records console"
	id = "sec_data"
	build_path = /obj/item/circuitboard/secure_data

/datum/design/circuit/prisonmanage
	design_name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/prisoner

/datum/design/circuit/med_data
	design_name = "medical records console"
	id = "med_data"
	build_path = /obj/item/circuitboard/med_data

/datum/design/circuit/operating
	design_name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/circuitboard/operating

/datum/design/circuit/scan_console
	design_name = "DNA machine"
	id = "scan_console"
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/design/circuit/clonecontrol
	design_name = "cloning control console"
	id = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/cloning

/datum/design/circuit/clonepod
	design_name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonepod

/datum/design/circuit/clonescanner
	design_name = "cloning scanner"
	id = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonescanner

/datum/design/circuit/crewconsole
	design_name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/crew

/datum/design/circuit/teleconsole
	design_name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/circuit/robocontrol
	design_name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics

/datum/design/circuit/mechacontrol
	design_name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/mecha_control

/datum/design/circuit/rdconsole
	design_name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/circuit/aifixer
	design_name = "AI integrity restorer"
	id = "aifixer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/aifixer

/datum/design/circuit/comm_monitor
	design_name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/circuit/comm_server
	design_name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/circuit/message_monitor
	design_name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/circuit/aiupload
	design_name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/circuit/borgupload
	design_name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/circuit/destructive_analyzer
	design_name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/destructive_analyzer

/datum/design/circuit/protolathe
	design_name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit/circuit_imprinter
	design_name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/circuit/autolathe
	design_name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/machine/lathe/autolathe

/datum/design/circuit/rdservercontrol
	design_name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/circuit/rdserver
	design_name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/circuit/mechfab
	design_name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab

/datum/design/circuit/prosfab
	design_name = "prosthetics fabricator"
	id = "prosfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/prosthetics

/datum/design/circuit/mech_recharger
	design_name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger

/datum/design/circuit/recharge_station
	design_name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station

/datum/design/circuit/atmosalerts
	design_name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/circuit/air_management
	design_name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/circuitboard/air_management

/datum/design/circuit/rcon_console
	design_name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console

/datum/design/circuit/dronecontrol
	design_name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control

/datum/design/circuit/powermonitor
	design_name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/circuit/solarcontrol
	design_name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/solar_control

/*
/datum/design/circuit/shutoff_monitor
	design_name = "Automatic shutoff valve monitor"
	id = "shutoff_monitor"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shutoff_monitor
*/

/datum/design/circuit/pacman
	design_name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman

/datum/design/circuit/superpacman
	design_name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/circuit/mrspacman
	design_name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs

/datum/design/circuit/batteryrack
	design_name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/batteryrack

/datum/design/circuit/smes_cell
	design_name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/smes

/datum/design/circuit/grid_checker
	design_name = "power grid checker"
	desc = "Allows for the construction of circuit boards used to build a grid checker."
	id = "grid_checker"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/grid_checker

/datum/design/circuit/breakerbox
	design_name = "breaker box"
	desc = "Allows for the construction of circuit boards used to build a breaker box."
	id = "breakerbox"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/breakerbox

/datum/design/circuit/gas_heater
	design_name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/unary_atmos/heater

/datum/design/circuit/gas_cooler
	design_name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/cooler

/datum/design/circuit/secure_airlock
	design_name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure

/datum/design/circuit/ordercomp
	design_name = "supply ordering console"
	id = "ordercomp"
	build_path = /obj/item/circuitboard/supplycomp

/datum/design/circuit/supplycomp
	design_name = "supply control console"
	id = "supplycomp"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/supplycomp/control

/datum/design/circuit/biogenerator
	design_name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator

/datum/design/circuit/miningdrill
	design_name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill

/datum/design/circuit/miningdrillbrace
	design_name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace

/datum/design/circuit/comconsole
	design_name = "communications console"
	id = "comconsole"
	build_path = /obj/item/circuitboard/communications

/datum/design/circuit/idcardconsole
	design_name = "ID card modification console"
	id = "idcardconsole"
	build_path = /obj/item/circuitboard/card

/datum/design/circuit/emp_data
	design_name = "employment records console"
	id = "emp_data"
	build_path = /obj/item/circuitboard/skills

/datum/design/circuit/arf_generator
	design_name = "atmospheric field generator"
	id = "arf_generator"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/arf_generator

/datum/design/circuit/mecha
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/mecha/generate_name(template)
	return "Exosuit module circuit design ([template])"

/datum/design/circuit/mecha/generate_desc(template_name, template_desc)
	return "Allows for the construction of \a [template_name] module."

/datum/design/circuit/mecha/ripley_main
	design_name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/circuit/mecha/ripley_peri
	design_name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/design/circuit/mecha/odysseus_main
	design_name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/circuit/mecha/odysseus_peri
	design_name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/design/circuit/mecha/gygax_main
	design_name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/circuit/mecha/gygax_peri
	design_name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/circuit/mecha/gygax_targ
	design_name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

/datum/design/circuit/mecha/gygax_medical
	design_name = "'Serenity' medical control"
	id = "gygax_medical"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/medical

/datum/design/circuit/mecha/durand_main
	design_name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/circuit/mecha/durand_peri
	design_name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/circuit/mecha/durand_targ
	design_name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

/datum/design/circuit/mecha/honker_main
	design_name = "'H.O.N.K.' central control"
	id = "honker_main"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/main

/datum/design/circuit/mecha/honker_peri
	design_name = "'H.O.N.K.' peripherals control"
	id = "honker_peri"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/peripherals

/datum/design/circuit/mecha/honker_targ
	design_name = "'H.O.N.K.' weapon control and targeting"
	id = "honker_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/targeting

/datum/design/circuit/mecha/reticent_main
	design_name = "'Reticent' central control"
	id = "reticent_main"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/main

/datum/design/circuit/mecha/reticent_peri
	design_name = "'Reticent' peripherals control"
	id = "reticent_peri"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/peripherals

/datum/design/circuit/mecha/reticent_targ
	design_name = "'Reticent' weapon control and targeting"
	id = "reticent_targ"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 2, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/targeting

///Fighters///

//Pinnace//

/datum/design/circuit/mecha/fighter/pinnace_main
	design_name = "Pinnace central control board"
	id = "pinnace_main"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/main

/datum/design/circuit/mecha/fighter/pinnace_flight
	design_name = "Pinnace flight control board"
	id = "pinnace_flight"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/flight

/datum/design/circuit/mecha/fighter/pinnace_targeting
	design_name = "Pinnace weapon control and targeting board"
	id = "pinnace_targeting"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/targeting

/datum/design/circuit/mecha/fighter/pinnace_cockpit_control
	design_name = "Pinnace manual flight control instruments"
	id = "pinnace_cockpit_control"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/pinnace/cockpitboard

//Baron//

/datum/design/circuit/mecha/fighter/baron_main
	design_name = "Baron central control board"
	id = "baron_main"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/main

/datum/design/circuit/mecha/fighter/baron_flight
	design_name = "Baron flight control board"
	id = "baron_flight"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/flight

/datum/design/circuit/mecha/fighter/baron_targeting
	design_name = "Baron weapon control and targeting board"
	id = "baron_targeting"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/targeting

/datum/design/circuit/mecha/fighter/baron_cockpit_control
	design_name = "Baron manual flight control instruments"
	id = "baron_cockpit_control"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/baron/cockpitboard

//Duke//

/datum/design/circuit/mecha/fighter/duke_main
	design_name = "Duke central control board"
	id = "duke_main"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/main

/datum/design/circuit/mecha/fighter/duke_flight
	design_name = "Duke flight control board"
	id = "duke_flight"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/flight

/datum/design/circuit/mecha/fighter/duke_targeting
	design_name = "Duke weapon control and targeting board"
	id = "duke_targeting"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/targeting

/datum/design/circuit/mecha/fighter/duke_cockpit_control
	design_name = "Duke manual flight control instruments"
	id = "duke_cockpit_control"
	req_tech = list(TECH_DATA = 5, TECH_POWER = 4, TECH_COMBAT = 3)
	build_path = /obj/item/circuitboard/mecha/fighter/duke/cockpitboard

//Tcomms//

/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/generate_name(template)
	return "Telecommunications machinery circuit design ([template])"

/datum/design/circuit/tcom/generate_desc(template_name, template_desc)
	return "Allows for the construction of a telecommunications [template_name] circuit board."

/datum/design/circuit/tcom/server
	design_name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/circuitboard/telecomms/server

/datum/design/circuit/tcom/processor
	design_name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/circuitboard/telecomms/processor

/datum/design/circuit/tcom/bus
	design_name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/circuitboard/telecomms/bus

/datum/design/circuit/tcom/hub
	design_name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/circuitboard/telecomms/hub

/datum/design/circuit/tcom/relay
	design_name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/telecomms/relay

/datum/design/circuit/tcom/broadcaster
	design_name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/broadcaster

/datum/design/circuit/tcom/receiver
	design_name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/receiver

/datum/design/circuit/tcom/exonet_node
	design_name = "exonet node"
	id = "tcom-exonet_node"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/telecomms/exonet_node

/datum/design/circuit/ntnet_relay
	design_name = "NTNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/ntnet_relay

/datum/design/circuit/aicore
	design_name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore

/datum/design/circuit/fossilrevive
	design_name = "Fossil DNA extractor"
	id = "fossilrevive"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/dnarevive

/datum/design/circuit/shield_generator
	design_name = "shield generator"
	id = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_BLUESPACE = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shield_generator

/datum/design/circuit/shield_diffuser
	design_name = "shield diffuser"
	id = "shield_diffuser"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 2, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/shield_diffuser

/datum/design/circuit/pointdefense
	design_name = "point defense battery"
	id = "pointdefense"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense

/datum/design/circuit/pointdefense_control
	design_name = "point defense control" //Once upon a time, this was called a deluxe microwave.
	id = "pointdefense_control"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control

/datum/design/circuit/massive_gas_pump
	design_name = "High performance gas pump"
	id = "massive_gas_pump"
	req_tech = list(TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/massive_gas_pump

/datum/design/circuit/massive_heat_pump
	design_name = "High performance heat pump"
	id = "massive_heat_pump"
	req_tech = list(TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/massive_heat_pump
