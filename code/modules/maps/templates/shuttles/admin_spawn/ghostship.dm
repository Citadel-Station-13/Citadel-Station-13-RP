

// Map template for spawning the shuttle
/datum/map_template/shuttle/overmap/generic/ghostship
	name = "OM Ship - Ghost Ship (New Z)"
	desc = "The a modified pirate Vespa. The pirates seem long dead."
	suffix = "ghostship.dmm"

// The shuttle's area(s)
/area/ship/ghostship
	name = "\improper Event Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/ship/ghostship/engineering
	name = "\improper Unknown Vessel - Engineering"
/area/ship/ghostship/engineeringpower
	name = "\improper Unknown Vessel - Engineering Power Station"
/area/ship/ghostship/engineeringequipment
	name = "\improper Unknown Vessel - Engineering Equipment Room"
/area/ship/ghostship/engineeringstorage
	name = "\improper Unknown Vessel - Engineering Storage Room"
/area/ship/ghostship/hangar
	name = "\improper Unknown Vessel - Converted Hangar"
/area/ship/ghostship/hangarcontrol
	name = "\improper Unknown Vessel - EVA Raid Storage"
/area/ship/ghostship/cabin1
	name = "\improper Unknown Vessel - Cabin 1"
/area/ship/ghostship/cabin2
	name = "\improper Unknown Vessel - Cabin 2"
/area/ship/ghostship/cabin3
	name = "\improper Unknown Vessel - Cabin 3"
/area/ship/ghostship/cabin4
	name = "\improper Unknown Vessel - Cabin 4"
/area/ship/ghostship/cabin5
	name = "\improper Unknown Vessel - Cabin 5"
/area/ship/ghostship/cabin6
	name = "\improper Unknown Vessel - Cabin 6"
/area/ship/ghostship/cabin7
	name = "\improper Unknown Vessel - Cabin 7"
/area/ship/ghostship/cabin8
	name = "\improper Unknown Vessel - Cabin 8"
/area/ship/ghostship/cabin9
	name = "\improper Unknown Vessel - Cabin 9"
/area/ship/ghostship/corridor1
	name = "\improper Unknown Vessel - Corridor"
/area/ship/ghostship/corridor2
	name = "\improper Unknown Vessel - Corridor"
/area/ship/ghostship/corridor3
	name = "\improper Unknown Vessel - Corridor"
/area/ship/ghostship/corridor4
	name = "\improper Unknown Vessel - Corridor"
/area/ship/ghostship/corridor5
	name = "\improper Unknown Vessel - Corridor"
/area/ship/ghostship/corridor6
	name = "\improper Unknown Vessel - Corridor"
/area/ship/ghostship/sm
	name = "\improper Unknown Vessel - Engine Room"
/area/ship/ghostship/smstorage
	name = "\improper Unknown Vessel - Engine Room Storage"
/area/ship/ghostship/medical
	name = "\improper Unknown Vessel - Medical"
/area/ship/ghostship/medical1
	name = "\improper Unknown Vessel - Medical Patient Room"
/area/ship/ghostship/medicalchem
	name = "\improper Unknown Vessel - Drug Lab"
/area/ship/ghostship/medicalmain
	name = "\improper Unknown Vessel - Medical Main"
/area/ship/ghostship/medicaleq
	name = "\improper Unknown Vessel - Medical Equipment Room"
/area/ship/ghostship/medicalsur
	name = "\improper Unknown Vessel - Surgery Room"
/area/ship/ghostship/armoury
	name = "\improper Unknown Vessel - Armoury"
/area/ship/ghostship/secmain
	name = "\improper Unknown Vessel - Firing Range"
/area/ship/ghostship/seclobby
	name = "\improper Unknown Vessel - Brig Entrance"
/area/ship/ghostship/seclobby2
	name = "\improper Unknown Vessel - Security Lobby"
/area/ship/ghostship/seceq
	name = "\improper Unknown Vessel - Security Equipment Room"
/area/ship/ghostship/sechall
	name = "\improper Unknown Vessel - Security Hall"
/area/ship/ghostship/seccells
	name = "\improper Unknown Vessel - Brig"
/area/ship/ghostship/cafet
	name = "\improper Unknown Vessel - Cafeteria"
/area/ship/ghostship/cargo
	name = "\improper Unknown Vessel - Storage"
/area/ship/ghostship/bridge
	name = "\improper Unknown Vessel - Bridge"
/area/ship/ghostship/engines
	name = "\improper Unknown Vessel - Engines Port"
/area/ship/ghostship/engines2
	name = "\improper Unknown Vessel - Engines Starboard"
/area/ship/ghostship/captqua
	name = "\improper Unknown Vessel - Captain's Quarters"
/area/ship/ghostship/expedition
	name = "\improper Unknown Vessel - Expedition Prep"
/area/ship/ghostship/atmospherics
	name = "\improper Unknown Vessel - Atmos"
/area/ship/ghostship/northairlock
	name = "\improper Unknown Vessel - Airlock"
/area/ship/ghostship/southairlock
	name = "\improper Unknown Vessel - Airlock"
/area/ship/ghostship/maintenancerim
	name = "\improper Unknown Vessel - Maintenance"
/area/ship/ghostship/maintenance1
	name = "\improper Unknown Vessel - Maintenance"
/area/ship/ghostship/maintenance2
	name = "\improper Unknown Vessel - Maintenance"
/area/ship/ghostship/shieldgen
	name = "\improper Unknown Vessel - Shield Generator"
/area/ship/ghostship/starboardhangar
	name = "\improper Unknown Vessel - Starboard Hangar"
/area/ship/ghostship/porthangar
	name = "\improper Unknown Vessel - Port Hangar"

// The 'ship'
/obj/overmap/entity/visitable/ship/ghostship
	desc = "A spacefaring vessel of archaic design. What is it doing out here?"
	scanner_name = "Unknown Vessel"
	scanner_desc = @{"[i]Registration[/i]: ERRR [Registration Not Found]
[i]Class[/i]: NULL
[i]Transponder[/i]: ERR [No Transponder Detected]
[b]Notice[/b]: Corporate vessel"}
	color = "#4cad73" //Green
	vessel_mass = 12000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("ghostship_port", "ghostship_starboard")
	fore_dir = 4
