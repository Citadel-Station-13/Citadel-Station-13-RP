// i kind of want to strangle whoever thought it was a good idea to shove a bunch of door subtypes in the middle of the fucking airlock code.

/obj/machinery/door/airlock/command
	name = "Command Airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	req_one_access = list(ACCESS_COMMAND_BRIDGE)
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'

/obj/machinery/door/airlock/security
	name = "Security Airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT)
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	open_sound_powered = 'sound/machines/door/sec1o.ogg'
	close_sound_powered = 'sound/machines/door/sec1c.ogg'

/obj/machinery/door/airlock/engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	req_one_access = list(ACCESS_ENGINEERING_MAIN)
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'

/obj/machinery/door/airlock/engineeringatmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'

/obj/machinery/door/airlock/medical
	name = "Medical Airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	req_one_access = list(ACCESS_MEDICAL_MAIN)
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	open_sound_powered = 'sound/machines/door/med1o.ogg'
	close_sound_powered = 'sound/machines/door/med1c.ogg'

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	//req_one_access = list(ACCESS_ENGINEERING_MAINT) // Maintenance is open access
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	open_sound_powered = 'sound/machines/door/door2o.ogg'
	close_sound_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/cargo
	icon = 'icons/obj/doors/Doormaint_cargo.dmi'
	req_one_access = list(ACCESS_SUPPLY_BAY)
	open_sound_powered = 'sound/machines/door/door2o.ogg'
	close_sound_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/command
	icon = 'icons/obj/doors/Doormaint_command.dmi'
	req_one_access = list(ACCESS_COMMAND_BRIDGE)

/obj/machinery/door/airlock/maintenance/common
	icon = 'icons/obj/doors/Doormaint_common.dmi'
	open_sound_powered = 'sound/machines/door/hall3o.ogg'
	close_sound_powered = 'sound/machines/door/hall3c.ogg'

/obj/machinery/door/airlock/maintenance/engi
	icon = 'icons/obj/doors/Doormaint_engi.dmi'
	req_one_access = list(ACCESS_ENGINEERING_MAIN)

/obj/machinery/door/airlock/maintenance/int
	icon = 'icons/obj/doors/Doormaint_int.dmi'

/obj/machinery/door/airlock/maintenance/medical
	icon = 'icons/obj/doors/Doormaint_med.dmi'
	req_one_access = list(ACCESS_MEDICAL_MAIN)

/obj/machinery/door/airlock/maintenance/rnd
	icon = 'icons/obj/doors/Doormaint_rnd.dmi'
	req_one_access = list(ACCESS_SCIENCE_MAIN)

/obj/machinery/door/airlock/maintenance/sec
	icon = 'icons/obj/doors/Doormaint_sec.dmi'
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT)

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/external/door.dmi'
	icon_state = "preview"
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'

/obj/machinery/door/airlock/external/glass/bolted
	icon_state = "door_locked" // So it looks visibly bolted in map editor
	locked = 1

// For convenience in making docking ports: one that is pre-bolted with frequency set!
/obj/machinery/door/airlock/external/glass/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/glass_external
	name = "External Airlock"
	icon = 'icons/obj/doors/external/door.dmi'
	opacity = FALSE
	glass = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	opacity = 0
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_AIRLOCK)
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/centcom
	name = "Centcom Airlock"
	icon = 'icons/obj/doors/Doorele.dmi'
	req_one_access = list(ACCESS_CENTCOM_GENERAL)
	opacity = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'

/obj/machinery/door/airlock/glass_centcom
	name = "Airlock"
	icon = 'icons/obj/doors/Dooreleglass.dmi'
	opacity = 0
	glass = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	req_one_access = list(ACCESS_COMMAND_VAULT)
	open_sound_powered = 'sound/machines/door/vault1o.ogg'
	close_sound_powered = 'sound/machines/door/vault1c.ogg'

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/Doorfreezer.dmi'
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	req_one_access = list(ACCESS_ENGINEERING_MAINT)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch
	req_one_access = list(ACCESS_ENGINEERING_MAINT)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'

/obj/machinery/door/airlock/glass_command
	name = "Command Airlock"
	opacity = FALSE
	glass = TRUE
	icon = 'icons/obj/doors/Doorcomglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = 1
	req_one_access = list(ACCESS_COMMAND_BRIDGE)
	open_sound_powered = 'sound/machines/door/cmd1o.ogg'
	close_sound_powered = 'sound/machines/door/cmd1c.ogg'


/obj/machinery/door/airlock/glass_engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/doors/Doorengglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_MAIN)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'

/obj/machinery/door/airlock/glass_engineeringatmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Doorengatmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'

/obj/machinery/door/airlock/glass_security
	name = "Security Airlock"
	icon = 'icons/obj/doors/Doorsecglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = 1
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT)
	open_sound_powered = 'sound/machines/door/sec1o.ogg'
	close_sound_powered = 'sound/machines/door/sec1c.ogg'

/obj/machinery/door/airlock/glass_medical
	name = "Medical Airlock"
	icon = 'icons/obj/doors/Doormedglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1
	req_one_access = list(ACCESS_MEDICAL_MAIN)
	open_sound_powered = 'sound/machines/door/med1o.ogg'
	close_sound_powered = 'sound/machines/door/med1c.ogg'

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doormining.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	req_one_access = list(ACCESS_SUPPLY_MINE)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmo.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'

/obj/machinery/door/airlock/research
	name = "Research Airlock"
	icon = 'icons/obj/doors/Doorresearch.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	open_sound_powered = 'sound/machines/door/sci1o.ogg'
	close_sound_powered = 'sound/machines/door/sci1c.ogg'

/obj/machinery/door/airlock/glass_research
	name = "Research Airlock"
	icon = 'icons/obj/doors/Doorresearchglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = 1
	req_one_access = list(ACCESS_SCIENCE_MAIN)
	open_sound_powered = 'sound/machines/door/sci1o.ogg'
	close_sound_powered = 'sound/machines/door/sci1c.ogg'

/obj/machinery/door/airlock/glass_mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doorminingglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = 1
	req_one_access = list(ACCESS_SUPPLY_MINE)
	open_sound_powered = 'sound/machines/door/cgo1o.ogg'
	close_sound_powered = 'sound/machines/door/cgo1c.ogg'

/obj/machinery/door/airlock/glass_atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'


/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/Doorgold.dmi'
	mineral = "gold"

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/Doorsilver.dmi'
	mineral = "silver"

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/Doordiamond.dmi'
	mineral = "diamond"

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/Dooruranium.dmi'
	mineral = "uranium"
	var/last_event = 0
	var/rad_power = RAD_INTENSITY_MAT_SPECIAL_URANIUM_AIRLOCK

/obj/machinery/door/airlock/bananium
	name = "Bananium Airlock"
	desc = "An absolute atrocity."
	icon = 'icons/obj/doors/Doorbananium.dmi'
	mineral = "bananium"
	open_sound_powered = 'sound/items/bikehorn.ogg'
	close_sound_powered = 'sound/items/bikehorn.ogg'

/obj/machinery/door/airlock/silencium
	name = "Silencium Airlock"
	desc = "The pinnacle of noise cancelling door technology."
	icon = 'icons/obj/doors/Doorsilencium.dmi'
	mineral = "silencium"
	open_sound_powered = 'sound/effects/footstep/carpet1.ogg'
	close_sound_powered = 'sound/effects/footstep/carpet1.ogg'
