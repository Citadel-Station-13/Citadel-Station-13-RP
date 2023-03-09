/*
CIRCUITS BELOW
*/

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 2000)
	chemicals = list("sacid" = 20)
	work = (5 * (1 / 3) * 10) // auto regexed to be old time divided by 3 in seconds.

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	identifier = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/battle

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	identifier = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/orion_trail
	sort_string = "MAAAB"		// Duplicate string, really need to redo this whole thing

/datum/design/circuit/clawmachine
	name = "grab-a-gift arcade machine"
	identifier = "clawmachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/arcade/clawmachine

/datum/design/circuit/jukebox
	name = "jukebox"
	identifier = "jukebox"
	req_tech = list(TECH_MAGNET = 2, TECH_DATA = 1)
	build_path = /obj/item/circuitboard/jukebox

/datum/design/circuit/seccamera
	name = "security camera monitor"
	identifier = "seccamera"
	build_path = /obj/item/circuitboard/security
	sort_string = "DAAAZ"	// Duplicate string, really need to redo this whole thing

/datum/design/circuit/secdata
	name = "security records console"
	identifier = "sec_data"
	build_path = /obj/item/circuitboard/secure_data

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	identifier = "prisonmanage"
	build_path = /obj/item/circuitboard/prisoner

/datum/design/circuit/med_data
	name = "medical records console"
	identifier = "med_data"
	build_path = /obj/item/circuitboard/med_data

/datum/design/circuit/operating
	name = "patient monitoring console"
	identifier = "operating"
	build_path = /obj/item/circuitboard/operating

/datum/design/circuit/scan_console
	name = "DNA machine"
	identifier = "scan_console"
	build_path = /obj/item/circuitboard/scan_consolenew

/datum/design/circuit/clonecontrol
	name = "cloning control console"
	identifier = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/cloning

/datum/design/circuit/clonepod
	name = "clone pod"
	identifier = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonepod

/datum/design/circuit/clonescanner
	name = "cloning scanner"
	identifier = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/clonescanner

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	identifier = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/crew

/datum/design/circuit/teleconsole
	name = "teleporter control console"
	identifier = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/teleporter

/datum/design/circuit/robocontrol
	name = "robotics control console"
	identifier = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics

/datum/design/circuit/mechacontrol
	name = "exosuit control console"
	identifier = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/mecha_control

/datum/design/circuit/rdconsole
	name = "R&D control console"
	identifier = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole

/datum/design/circuit/aifixer
	name = "AI integrity restorer"
	identifier = "aifixer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/aifixer

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	identifier = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_monitor

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	identifier = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/comm_server

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	identifier = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/circuitboard/message_monitor

/datum/design/circuit/aiupload
	name = "AI upload console"
	identifier = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	identifier = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	identifier = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/destructive_analyzer

/datum/design/circuit/protolathe
	name = "protolathe"
	identifier = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	identifier = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/circuit/autolathe
	name = "autolathe board"
	identifier = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	identifier = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/circuit/rdserver
	name = "R&D server"
	identifier = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	identifier = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab

/datum/design/circuit/prosfab
	name = "prosthetics fabricator"
	identifier = "prosfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/prosthetics

/datum/design/circuit/mech_recharger
	name = "mech recharger"
	identifier = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	identifier = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	identifier = "atmosalerts"
	build_path = /obj/item/circuitboard/atmos_alert

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	identifier = "air_management"
	build_path = /obj/item/circuitboard/air_management

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	identifier = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_POWER = 5)
	build_path = /obj/item/circuitboard/rcon_console

/datum/design/circuit/dronecontrol
	name = "drone control console"
	identifier = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/drone_control

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	identifier = "powermonitor"
	build_path = /obj/item/circuitboard/powermonitor

/datum/design/circuit/solarcontrol
	name = "solar control console"
	identifier = "solarcontrol"
	build_path = /obj/item/circuitboard/solar_control

/*
/datum/design/circuit/shutoff_monitor
	name = "Automatic shutoff valve monitor"
	identifier = "shutoff_monitor"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shutoff_monitor
*/

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	identifier = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/pacman

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	identifier = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	identifier = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/pacman/mrs

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	identifier = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/batteryrack

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	identifier = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/smes

/datum/design/circuit/grid_checker
	name = "power grid checker"
	desc = "Allows for the construction of circuit boards used to build a grid checker."
	identifier = "grid_checker"
	req_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/grid_checker

/datum/design/circuit/breakerbox
	name = "breaker box"
	desc = "Allows for the construction of circuit boards used to build a breaker box."
	identifier = "breakerbox"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/breakerbox

/datum/design/circuit/gas_heater
	name = "gas heating system"
	identifier = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/unary_atmos/heater

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	identifier = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/unary_atmos/cooler

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	identifier = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/airlock_electronics/secure

/datum/design/circuit/ordercomp
	name = "supply ordering console"
	identifier = "ordercomp"
	build_path = /obj/item/circuitboard/supplycomp
	sort_string = "KAAAY"	// Duplicate string, really need to redo this whole thing

/datum/design/circuit/supplycomp
	name = "supply control console"
	identifier = "supplycomp"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/supplycomp/control
	sort_string = "KAAAZ"	// Duplicate string, really need to redo this whole thing

/datum/design/circuit/biogenerator
	name = "biogenerator"
	identifier = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/circuitboard/biogenerator

/datum/design/circuit/miningdrill
	name = "mining drill head"
	identifier = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrill

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	identifier = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/circuitboard/miningdrillbrace

/datum/design/circuit/comconsole
	name = "communications console"
	identifier = "comconsole"
	build_path = /obj/item/circuitboard/communications

/datum/design/circuit/idcardconsole
	name = "ID card modification console"
	identifier = "idcardconsole"
	build_path = /obj/item/circuitboard/card

/datum/design/circuit/emp_data
	name = "employment records console"
	identifier = "emp_data"
	build_path = /obj/item/circuitboard/skills

/datum/design/circuit/arf_generator
	name = "atmospheric field generator"
	identifier = "arf_generator"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/arf_generator

/datum/design/circuit/mecha
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	identifier = "ripley_main"
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	identifier = "ripley_peri"
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

/datum/design/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	identifier = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	identifier = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

/datum/design/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	identifier = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	identifier = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	identifier = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

/datum/design/circuit/mecha/gygax_medical
	name = "'Serenity' medical control"
	identifier = "gygax_medical"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/mecha/gygax/medical

/datum/design/circuit/mecha/durand_main
	name = "'Durand' central control"
	identifier = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	identifier = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	identifier = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

/datum/design/circuit/mecha/honker_main
	name = "'H.O.N.K.' central control"
	identifier = "honker_main"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/main

/datum/design/circuit/mecha/honker_peri
	name = "'H.O.N.K.' peripherals control"
	identifier = "honker_peri"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/peripherals

/datum/design/circuit/mecha/honker_targ
	name = "'H.O.N.K.' weapon control and targeting"
	identifier = "honker_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/honker/targeting

/datum/design/circuit/mecha/reticent_main
	name = "'Reticent' central control"
	identifier = "reticent_main"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/main

/datum/design/circuit/mecha/reticent_peri
	name = "'Reticent' peripherals control"
	identifier = "reticent_peri"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/peripherals

/datum/design/circuit/mecha/reticent_targ
	name = "'Reticent' weapon control and targeting"
	identifier = "reticent_targ"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 2, TECH_ILLEGAL = 4)
	build_path = /obj/item/circuitboard/mecha/reticent/targeting

/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	identifier = "tcom-server"
	build_path = /obj/item/circuitboard/telecomms/server

/datum/design/circuit/tcom/processor
	name = "processor unit"
	identifier = "tcom-processor"
	build_path = /obj/item/circuitboard/telecomms/processor

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	identifier = "tcom-bus"
	build_path = /obj/item/circuitboard/telecomms/bus

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	identifier = "tcom-hub"
	build_path = /obj/item/circuitboard/telecomms/hub

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	identifier = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/circuitboard/telecomms/relay

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	identifier = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/broadcaster

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	identifier = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/circuitboard/telecomms/receiver

/datum/design/circuit/tcom/exonet_node
	name = "exonet node"
	identifier = "tcom-exonet_node"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 4)
	build_path = /obj/item/circuitboard/telecomms/exonet_node

/datum/design/circuit/ntnet_relay
	name = "NTNet Quantum Relay"
	identifier = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/ntnet_relay

/datum/design/circuit/aicore
	name = "AI core"
	identifier = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore

/datum/design/circuit/fossilrevive
	name = "Fossil DNA extractor"
	identifier = "fossilrevive"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/dnarevive

/datum/design/circuit/shield_generator
	name = "shield generator"
	identifier = "shield_generator"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_BLUESPACE = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/shield_generator

/datum/design/circuit/shield_diffuser
	name = "shield diffuser"
	identifier = "shield_diffuser"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 2, TECH_ENGINEERING = 5)
	build_path = /obj/item/circuitboard/shield_diffuser

/datum/design/circuit/pointdefense
	name = "point defense battery"
	identifier = "pointdefense"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3, TECH_COMBAT = 4)
	build_path = /obj/item/circuitboard/pointdefense

/datum/design/circuit/pointdefense_control
	name = "point defense control" //Once upon a time, this was called a deluxe microwave.
	identifier = "pointdefense_control"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	build_path = /obj/item/circuitboard/pointdefense_control

/datum/design/circuit/massive_gas_pump
	name = "High performance gas pump"
	identifier = "massive_gas_pump"
	req_tech = list(TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/massive_gas_pump

/datum/design/circuit/massive_heat_pump
	name = "High performance heat pump"
	identifier = "massive_heat_pump"
	req_tech = list(TECH_ENGINEERING = 4)
	build_path = /obj/item/circuitboard/massive_heat_pump
