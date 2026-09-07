
// The shuttle's area(s)
/area/sector/hev_vespa
	name = "\improper Event Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/sector/hev_vespa/engineering
	name = "\improper Exp Ship - Engineering"
/area/sector/hev_vespa/engineeringpower
	name = "\improper Exp Ship - Engineering Power Station"
/area/sector/hev_vespa/engineeringequipment
	name = "\improper Exp Ship - Engineering Equipment Room"
/area/sector/hev_vespa/engineeringstorage
	name = "\improper Exp Ship - Engineering Storage Room"
/area/sector/hev_vespa/hangar
	name = "\improper Exp Ship - Hangar"
/area/sector/hev_vespa/hangarcontrol
	name = "\improper Exp Ship - Exploration Equipment Room"
/area/sector/hev_vespa/cabin1
	name = "\improper Exp Ship - Cabin 1"
/area/sector/hev_vespa/cabin2
	name = "\improper Exp Ship - Cabin 2"
/area/sector/hev_vespa/cabin3
	name = "\improper Exp Ship - Cabin 3"
/area/sector/hev_vespa/cabin4
	name = "\improper Exp Ship - Cabin 4"
/area/sector/hev_vespa/cabin5
	name = "\improper Exp Ship - Cabin 5"
/area/sector/hev_vespa/cabin6
	name = "\improper Exp Ship - Cabin 6"
/area/sector/hev_vespa/cabin7
	name = "\improper Exp Ship - Cabin 7"
/area/sector/hev_vespa/cabin8
	name = "\improper Exp Ship - Cabin 8"
/area/sector/hev_vespa/cabin9
	name = "\improper Exp Ship - Cabin 9"
/area/sector/hev_vespa/corridor1
	name = "\improper Exp Ship - Corridor"
/area/sector/hev_vespa/corridor2
	name = "\improper Exp Ship - Corridor"
/area/sector/hev_vespa/corridor3
	name = "\improper Exp Ship - Corridor"
/area/sector/hev_vespa/corridor4
	name = "\improper Exp Ship - Corridor"
/area/sector/hev_vespa/corridor5
	name = "\improper Exp Ship - Corridor"
/area/sector/hev_vespa/corridor6
	name = "\improper Exp Ship - Corridor"
/area/sector/hev_vespa/sm
	name = "\improper Exp Ship - Supermatter"
/area/sector/hev_vespa/smstorage
	name = "\improper Exp Ship - Supermatter Storage"
/area/sector/hev_vespa/medical
	name = "\improper Exp Ship - Medical"
/area/sector/hev_vespa/medical1
	name = "\improper Exp Ship - Medical Pacient Room"
/area/sector/hev_vespa/medicalchem
	name = "\improper Exp Ship - Chemistry"
/area/sector/hev_vespa/medicalmain
	name = "\improper Exp Ship - Medical Main"
/area/sector/hev_vespa/medicaleq
	name = "\improper Exp Ship - Medical Equipment Room"
/area/sector/hev_vespa/medicalsur
	name = "\improper Exp Ship - Medical Surgery"
/area/sector/hev_vespa/armoury
	name = "\improper Exp Ship - Lightweight Armoury"
/area/sector/hev_vespa/secmain
	name = "\improper Exp Ship - Security"
/area/sector/hev_vespa/seclobby
	name = "\improper Exp Ship - Security Lobby"
/area/sector/hev_vespa/seclobby2
	name = "\improper Exp Ship - Security Lobby"
/area/sector/hev_vespa/seceq
	name = "\improper Exp Ship - Security Equipment Room"
/area/sector/hev_vespa/sechall
	name = "\improper Exp Ship - Security Hall"
/area/sector/hev_vespa/seccells
	name = "\improper Exp Ship - Security Holding Cells"
/area/sector/hev_vespa/cafet
	name = "\improper Exp Ship - Cafeteria"
/area/sector/hev_vespa/cargo
	name = "\improper Exp Ship - Storage"
/area/sector/hev_vespa/bridge
	name = "\improper Exp Ship - Bridge"
/area/sector/hev_vespa/engines
	name = "\improper Exp Ship - Engines Port"
/area/sector/hev_vespa/engines2
	name = "\improper Exp Ship - Engines Starboard"
/area/sector/hev_vespa/captqua
	name = "\improper Exp Ship - Captain's Quarters"
/area/sector/hev_vespa/expedition
	name = "\improper Exp Ship - Expedition Prep"
/area/sector/hev_vespa/atmospherics
	name = "\improper Exp Ship - Atmos"
/area/sector/hev_vespa/northairlock
	name = "\improper Exp Ship - Airlock"
/area/sector/hev_vespa/southairlock
	name = "\improper Exp Ship - Airlock"
/area/sector/hev_vespa/maintenancerim
	name = "\improper Exp Ship - Maintenance"
/area/sector/hev_vespa/maintenance1
	name = "\improper Exp Ship - Maintenance"
/area/sector/hev_vespa/maintenance2
	name = "\improper Exp Ship - Maintenance"
/area/sector/hev_vespa/shieldgen
	name = "\improper Exp Ship - Shield Generator"

// The 'ship'
/obj/overmap/entity/visitable/ship/vespa
	desc = "A spacefaring vessel, of Hephaestus design."
	scanner_name = "HPV Vespa"
	scanner_desc = @{"[i]Registration[/i]: HPV Vespa
[i]Class[/i]: Cruiser
[i]Transponder[/i]: Transmitting (CIV), Hephaestus Industries
[b]Notice[/b]: Corporate vessel"}
	color = "#4cad73" //Green
	vessel_mass = 10000
	initial_generic_waypoints = list("hpv_port", "hpv_starboard", "hpv_hangar")
	fore_dir = 4
