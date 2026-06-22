// The shuttle's area(s)
/area/sector/itv_vespa
	name = "\improper Event Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/sector/itv_vespa/engineering
	name = "\improper Unknown Vessel - Engineering"
/area/sector/itv_vespa/engineeringpower
	name = "\improper Unknown Vessel - Engineering Power Station"
/area/sector/itv_vespa/engineeringequipment
	name = "\improper Unknown Vessel - Engineering Equipment Room"
/area/sector/itv_vespa/engineeringstorage
	name = "\improper Unknown Vessel - Engineering Storage Room"
/area/sector/itv_vespa/hangar
	name = "\improper Unknown Vessel - Converted Hangar"
/area/sector/itv_vespa/hangarcontrol
	name = "\improper Unknown Vessel - EVA Raid Storage"
/area/sector/itv_vespa/cabin1
	name = "\improper Unknown Vessel - Cabin 1"
/area/sector/itv_vespa/cabin2
	name = "\improper Unknown Vessel - Cabin 2"
/area/sector/itv_vespa/cabin3
	name = "\improper Unknown Vessel - Cabin 3"
/area/sector/itv_vespa/cabin4
	name = "\improper Unknown Vessel - Cabin 4"
/area/sector/itv_vespa/cabin5
	name = "\improper Unknown Vessel - Cabin 5"
/area/sector/itv_vespa/cabin6
	name = "\improper Unknown Vessel - Cabin 6"
/area/sector/itv_vespa/cabin7
	name = "\improper Unknown Vessel - Cabin 7"
/area/sector/itv_vespa/cabin8
	name = "\improper Unknown Vessel - Cabin 8"
/area/sector/itv_vespa/cabin9
	name = "\improper Unknown Vessel - Cabin 9"
/area/sector/itv_vespa/corridor1
	name = "\improper Unknown Vessel - Corridor"
/area/sector/itv_vespa/corridor2
	name = "\improper Unknown Vessel - Corridor"
/area/sector/itv_vespa/corridor3
	name = "\improper Unknown Vessel - Corridor"
/area/sector/itv_vespa/corridor4
	name = "\improper Unknown Vessel - Corridor"
/area/sector/itv_vespa/corridor5
	name = "\improper Unknown Vessel - Corridor"
/area/sector/itv_vespa/corridor6
	name = "\improper Unknown Vessel - Corridor"
/area/sector/itv_vespa/sm
	name = "\improper Unknown Vessel - Engine Room"
/area/sector/itv_vespa/smstorage
	name = "\improper Unknown Vessel - Engine Room Storage"
/area/sector/itv_vespa/medical
	name = "\improper Unknown Vessel - Medical"
/area/sector/itv_vespa/medical1
	name = "\improper Unknown Vessel - Medical Patient Room"
/area/sector/itv_vespa/medicalchem
	name = "\improper Unknown Vessel - Drug Lab"
/area/sector/itv_vespa/medicalmain
	name = "\improper Unknown Vessel - Medical Main"
/area/sector/itv_vespa/medicaleq
	name = "\improper Unknown Vessel - Medical Equipment Room"
/area/sector/itv_vespa/medicalsur
	name = "\improper Unknown Vessel - Surgery Room"
/area/sector/itv_vespa/armoury
	name = "\improper Unknown Vessel - Armoury"
/area/sector/itv_vespa/secmain
	name = "\improper Unknown Vessel - Firing Range"
/area/sector/itv_vespa/seclobby
	name = "\improper Unknown Vessel - Brig Entrance"
/area/sector/itv_vespa/seclobby2
	name = "\improper Unknown Vessel - Security Lobby"
/area/sector/itv_vespa/seceq
	name = "\improper Unknown Vessel - Security Equipment Room"
/area/sector/itv_vespa/sechall
	name = "\improper Unknown Vessel - Security Hall"
/area/sector/itv_vespa/seccells
	name = "\improper Unknown Vessel - Brig"
/area/sector/itv_vespa/cafet
	name = "\improper Unknown Vessel - Cafeteria"
/area/sector/itv_vespa/cargo
	name = "\improper Unknown Vessel - Storage"
/area/sector/itv_vespa/bridge
	name = "\improper Unknown Vessel - Bridge"
/area/sector/itv_vespa/engines
	name = "\improper Unknown Vessel - Engines Port"
/area/sector/itv_vespa/engines2
	name = "\improper Unknown Vessel - Engines Starboard"
/area/sector/itv_vespa/captqua
	name = "\improper Unknown Vessel - Captain's Quarters"
/area/sector/itv_vespa/expedition
	name = "\improper Unknown Vessel - Expedition Prep"
/area/sector/itv_vespa/atmospherics
	name = "\improper Unknown Vessel - Atmos"
/area/sector/itv_vespa/northairlock
	name = "\improper Unknown Vessel - Airlock"
/area/sector/itv_vespa/southairlock
	name = "\improper Unknown Vessel - Airlock"
/area/sector/itv_vespa/maintenancerim
	name = "\improper Unknown Vessel - Maintenance"
/area/sector/itv_vespa/maintenance1
	name = "\improper Unknown Vessel - Maintenance"
/area/sector/itv_vespa/maintenance2
	name = "\improper Unknown Vessel - Maintenance"
/area/sector/itv_vespa/shieldgen
	name = "\improper Unknown Vessel - Shield Generator"
/area/sector/itv_vespa/starboardhangar
	name = "\improper Unknown Vessel - Starboard Hangar"
/area/sector/itv_vespa/porthangar
	name = "\improper Unknown Vessel - Port Hangar"

// The 'ship'
/obj/overmap/entity/visitable/ship/itv_vespa
	desc = "A spacefaring vessel of archaic design. What is it doing out here?"
	scanner_name = "Unknown Vessel"
	scanner_desc = @{"[i]Registration[/i]: ERRR [Registration Not Found]
[i]Class[/i]: NULL
[i]Transponder[/i]: ERR [No Transponder Detected]
[b]Notice[/b]: Corporate vessel"}
	color = "#4cad73" //Green
	vessel_mass = 12000
	initial_generic_waypoints = list("ghostship_port", "ghostship_starboard")
	fore_dir = 4
