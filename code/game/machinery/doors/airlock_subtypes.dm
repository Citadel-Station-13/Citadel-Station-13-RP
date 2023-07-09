// i kind of want to strangle whoever thought it was a good idea to shove a bunch of door subtypes in the middle of the fucking airlock code.

/obj/machinery/door/airlock/command
	name = "Command Airlock"
	icon_state = "preview"
	req_one_access = list(ACCESS_COMMAND_BRIDGE)
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/airlock/security
	name = "Security Airlock"
	icon_state = "preview"
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT)
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	open_sound_powered = 'sound/machines/door/sec1o.ogg'
	close_sound_powered = 'sound/machines/door/sec1c.ogg'
	door_color = COLOR_SECURITY_RED

/obj/machinery/door/airlock/engineering
	name = "Engineering Airlock"
	icon_state = "preview"
	req_one_access = list(ACCESS_ENGINEERING_MAIN)
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_AMBER
	stripe_color = COLOR_SUN

/obj/machinery/door/airlock/engineeringatmos
	name = "Atmospherics Airlock"
	icon_state = "preview"
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_AMBER
	stripe_color = COLOR_ATMOSPHERICS_CYAN

/obj/machinery/door/airlock/medical
	name = "Medical Airlock"
	icon_state = "preview"
	req_one_access = list(ACCESS_MEDICAL_MAIN)
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	open_sound_powered = 'sound/machines/door/med1o.ogg'
	close_sound_powered = 'sound/machines/door/med1c.ogg'
	door_color = COLOR_WHITE
	stripe_color = COLOR_BABY_BLUE

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon_state = "preview"
	//req_one_access = list(ACCESS_ENGINEERING_MAINT) // Maintenance is open access
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	open_sound_powered = 'sound/machines/door/door2o.ogg'
	close_sound_powered = 'sound/machines/door/door2c.ogg'
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/maintenance/cargo
	req_one_access = list(ACCESS_SUPPLY_BAY)
	open_sound_powered = 'sound/machines/door/door2o.ogg'
	close_sound_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/command
	req_one_access = list(ACCESS_COMMAND_BRIDGE)

/obj/machinery/door/airlock/maintenance/common
	open_sound_powered = 'sound/machines/door/hall3o.ogg'
	close_sound_powered = 'sound/machines/door/hall3c.ogg'

/obj/machinery/door/airlock/maintenance/engi
	req_one_access = list(ACCESS_ENGINEERING_MAIN)

/obj/machinery/door/airlock/maintenance/int


/obj/machinery/door/airlock/maintenance/medical
	req_one_access = list(ACCESS_MEDICAL_MAIN)

/obj/machinery/door/airlock/maintenance/rnd
	req_one_access = list(ACCESS_SCIENCE_MAIN)

/obj/machinery/door/airlock/maintenance/sec
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT)

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon_state = "preview"
	airlock_type = "External"
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'
	icon = 'icons/obj/doors/external/door.dmi'
	fill_file = 'icons/obj/doors/external/fill_steel.dmi'
	color_file = 'icons/obj/doors/external/color.dmi'
	color_fill_file = 'icons/obj/doors/external/fill_color.dmi'
	glass_file = 'icons/obj/doors/external/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/external/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/external/lights_deny.dmi'
	lights_file = 'icons/obj/doors/external/lights_green.dmi'
	emag_file = 'icons/obj/doors/external/emag.dmi'
	door_color = COLOR_NT_RED

/obj/machinery/door/airlock/external/glass/bolted
	window_color = GLASS_COLOR
	icon_state = "door_locked" // So it looks visibly bolted in map editor
	locked = 1

// For convenience in making docking ports: one that is pre-bolted with frequency set!
/obj/machinery/door/airlock/external/glass/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/glass_external
	name = "External Airlock"
	airlock_type = "GExternal"
	icon = 'icons/obj/doors/external/door.dmi'
	fill_file = 'icons/obj/doors/external/fill_steel.dmi'
	color_file = 'icons/obj/doors/external/color.dmi'
	color_fill_file = 'icons/obj/doors/external/fill_color.dmi'
	glass_file = 'icons/obj/doors/external/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/external/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/external/lights_deny.dmi'
	lights_file = 'icons/obj/doors/external/lights_green.dmi'
	emag_file = 'icons/obj/doors/external/emag.dmi'
	opacity = FALSE
	glass = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	opacity = 0
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_AIRLOCK)
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'
	door_color = COLOR_MAROON
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 1
	glass = 1
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/centcom
	name = "Centcom Airlock"
	icon = 'icons/obj/doors/centcomm/door.dmi'
	req_one_access = list(ACCESS_CENTCOM_GENERAL)
	opacity = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'

/obj/machinery/door/airlock/glass/centcom
	name = "Airlock"
	icon = 'icons/obj/doors/centcomm/door.dmi'
	opacity = 0
	glass = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/vault
	name = "Vault"
	airlock_type = "Vault"
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	req_one_access = list(ACCESS_COMMAND_VAULT)
	open_sound_powered = 'sound/machines/door/vault1o.ogg'
	close_sound_powered = 'sound/machines/door/vault1c.ogg'
	icon = 'icons/obj/doors/vault/door.dmi'
	fill_file = 'icons/obj/doors/vault/fill_steel.dmi'

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	airlock_type = "Hatch"
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	req_one_access = list(ACCESS_ENGINEERING_MAINT)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'
	icon = 'icons/obj/doors/hatch/door.dmi'
	fill_file = 'icons/obj/doors/hatch/fill_steel.dmi'
	stripe_file = 'icons/obj/doors/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/hatch/fill_stripe.dmi'
	bolts_file = 'icons/obj/doors/hatch/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/hatch/lights_deny.dmi'
	lights_file = 'icons/obj/doors/hatch/lights_green.dmi'
	panel_file = 'icons/obj/doors/hatch/panel.dmi'
	welded_file = 'icons/obj/doors/hatch/welded.dmi'
	emag_file = 'icons/obj/doors/hatch/emag.dmi'
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	airlock_type = "Hatch"
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch
	req_one_access = list(ACCESS_ENGINEERING_MAINT)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'
	icon = 'icons/obj/doors/hatch/door.dmi'
	fill_file = 'icons/obj/doors/hatch/fill_steel.dmi'
	stripe_file = 'icons/obj/doors/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/hatch/fill_stripe.dmi'
	bolts_file = 'icons/obj/doors/hatch/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/hatch/lights_deny.dmi'
	lights_file = 'icons/obj/doors/hatch/lights_green.dmi'
	panel_file = 'icons/obj/doors/hatch/panel.dmi'
	welded_file = 'icons/obj/doors/hatch/welded.dmi'
	emag_file = 'icons/obj/doors/hatch/emag.dmi'
	stripe_color = COLOR_AMBER


/obj/machinery/door/airlock/glass/command
	name = "Command Airlock"
	opacity = FALSE
	glass = TRUE
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = 1
	req_one_access = list(ACCESS_COMMAND_BRIDGE)
	open_sound_powered = 'sound/machines/door/cmd1o.ogg'
	close_sound_powered = 'sound/machines/door/cmd1c.ogg'
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE
	window_color = GLASS_COLOR


/obj/machinery/door/airlock/glass/engineering
	name = "Engineering Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_MAIN)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_AMBER
	stripe_color = COLOR_SUN
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/glass/engineeringatmos
	name = "Atmospherics Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_AMBER
	stripe_color = COLOR_ATMOSPHERICS_CYAN
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/glass/security
	name = "Security Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = 1
	req_one_access = list(ACCESS_SECURITY_EQUIPMENT)
	open_sound_powered = 'sound/machines/door/sec1o.ogg'
	close_sound_powered = 'sound/machines/door/sec1c.ogg'
	door_color = COLOR_SECURITY_RED
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/glass/medical
	name = "Medical Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1
	req_one_access = list(ACCESS_MEDICAL_MAIN)
	open_sound_powered = 'sound/machines/door/med1o.ogg'
	close_sound_powered = 'sound/machines/door/med1c.ogg'
	door_color = COLOR_WHITE
	stripe_color = COLOR_BABY_BLUE
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	req_one_access = list(ACCESS_SUPPLY_MINE)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_CARGO_BROWN

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_AMBER
	stripe_color = COLOR_ATMOSPHERICS_CYAN

/obj/machinery/door/airlock/research
	name = "Research Airlock"
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	open_sound_powered = 'sound/machines/door/sci1o.ogg'
	close_sound_powered = 'sound/machines/door/sci1c.ogg'
	door_color = COLOR_WHITE
	stripe_color = COLOR_PALE_PURPLE_GRAY

/obj/machinery/door/airlock/glass/research
	name = "Research Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = 1
	req_one_access = list(ACCESS_SCIENCE_MAIN)
	open_sound_powered = 'sound/machines/door/sci1o.ogg'
	close_sound_powered = 'sound/machines/door/sci1c.ogg'
	door_color = COLOR_WHITE
	stripe_color = COLOR_PURPLE_GRAY
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/glass/mining
	name = "Mining Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = 1
	req_one_access = list(ACCESS_SUPPLY_MINE)
	open_sound_powered = 'sound/machines/door/cgo1o.ogg'
	close_sound_powered = 'sound/machines/door/cgo1c.ogg'
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_CARGO_BROWN
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/glass/atmos
	name = "Atmospherics Airlock"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = 1
	req_one_access = list(ACCESS_ENGINEERING_ATMOS)
	open_sound_powered = 'sound/machines/door/eng1o.ogg'
	close_sound_powered = 'sound/machines/door/eng1c.ogg'
	door_color = COLOR_AMBER
	stripe_color = COLOR_ATMOSPHERICS_CYAN
	window_color = GLASS_COLOR


/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/Doorgold.dmi'
	mineral = "gold"
	door_color = COLOR_GOLD

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	mineral = "silver"
	door_color = COLOR_SILVER

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	mineral = "diamond"
	door_color = COLOR_DIAMOND

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	mineral = "uranium"
	var/last_event = 0
	var/rad_power = RAD_INTENSITY_MAT_SPECIAL_URANIUM_AIRLOCK
	door_color = COLOR_PAKISTAN_GREEN

/obj/machinery/door/airlock/bananium
	name = "Bananium Airlock"
	desc = "An absolute atrocity."
	mineral = "bananium"
	open_sound_powered = 'sound/items/bikehorn.ogg'
	close_sound_powered = 'sound/items/bikehorn.ogg'
	door_color = COLOR_YELLOW

/obj/machinery/door/airlock/silencium
	name = "Silencium Airlock"
	desc = "The pinnacle of noise cancelling door technology."
	mineral = "silencium"
	open_sound_powered = 'sound/effects/footstep/carpet1.ogg'
	close_sound_powered = 'sound/effects/footstep/carpet1.ogg'
	door_color = COLOR_SILVER

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	mineral = "sandstone"
	door_color = COLOR_PALE_ORANGE

/obj/machinery/door/airlock/science
	name = "Research Airlock"
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	req_one_access = list(ACCESS_SCIENCE_MAIN)
	open_sound_powered = 'sound/machines/door/sci1o.ogg'
	close_sound_powered = 'sound/machines/door/sci1c.ogg'

/obj/machinery/door/airlock/glass_science
	name = "Glass Airlocks"
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	glass = 1
	req_one_access = list(ACCESS_SCIENCE_MAIN)
	open_sound_powered = 'sound/machines/door/sci1o.ogg'
	close_sound_powered = 'sound/machines/door/sci1c.ogg'
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/highsecurity
	name = "Secure Airlock"
	airlock_type = "Secure"
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_file = 'icons/obj/doors/secure/fill_steel.dmi'
	explosion_resistance = 20
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	req_one_access = list(ACCESS_COMMAND_VAULT)
	open_sound_powered = 'sound/machines/door/secure1o.ogg'
	close_sound_powered = 'sound/machines/door/secure1c.ogg'

/obj/machinery/door/airlock/voidcraft
	name = "voidcraft hatch"
	desc = "It's an extra resilient airlock intended for spacefaring vessels."
	explosion_resistance = 20
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_voidcraft
	open_sound_powered = 'sound/machines/door/shuttle1o.ogg'
	close_sound_powered = 'sound/machines/door/shuttle1c.ogg'

// Airlock opens from top-bottom instead of left-right.
/obj/machinery/door/airlock/voidcraft/vertical
	assembly_type = /obj/structure/door_assembly/door_assembly_voidcraft/vertical
	open_sound_powered = 'sound/machines/door/shuttle1o.ogg'
	close_sound_powered = 'sound/machines/door/shuttle1c.ogg'

/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock
	name = "Precursor Alpha Object - Doors"
	desc = "This object appears to be used in order to restrict or allow access to \
	rooms based on its physical state. In other words, a door. \
	Despite being designed and created by unknown ancient alien hands, this door has \
	a large number of similarities to the conventional airlock, such as being driven by \
	electricity, opening and closing by physically moving, and being air tight. \
	It also operates by responding to signals through internal electrical conduits. \
	These characteristics make it possible for one with experience with a multitool \
	to manipulate the door.\
	<br><br>\
	The symbol on the door does not match any living species' patterns, giving further \
	implications that this door is very old, and yet it remains operational after \
	thousands of years. It is unknown if that is due to superb construction, or \
	unseen autonomous maintenance having been performed."
	value = CATALOGUER_REWARD_EASY

/obj/machinery/door/airlock/alien
	name = "alien airlock"
	desc = "You're fairly sure this is a door."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock)
	icon = 'icons/obj/doors/Dooralien.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	hackProof = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_alien
	req_one_access = list(ACCESS_FACTION_ALIEN)

/obj/machinery/door/airlock/alien/locked
	icon_state = "door_locked"
	locked = TRUE

/obj/machinery/door/airlock/alien/public // Entry to UFO.
	req_one_access = list()
	normalspeed = FALSE // So it closes faster and hopefully keeps the warm air inside.
	hackProof = TRUE // No borgs

//"Red" Armory Door
/obj/machinery/door/airlock/security/armory
	name = "Red Armory"
	//color = ""

/obj/machinery/door/airlock/security/armory/allowed(mob/user)
	if(get_security_level() in list("green","blue"))
		return FALSE

	return ..(user)

/obj/machinery/door/airlock/multi_tile/glass/
	glass = TRUE
	window_color = GLASS_COLOR

/obj/machinery/door/airlock/multi_tile/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_BABY_BLUE

/obj/machinery/door/airlock/glass/civilian
	glass = TRUE
	door_color = COLOR_EGGSHELL
	stripe_color = COLOR_PALE_BTL_GREEN

/obj/machinery/door/airlock/glass/civilian/alt
	glass = TRUE
	stripe_color = COLOR_PALE_BTL_GREEN

/obj/machinery/door/airlock/civilian
	door_color = COLOR_EGGSHELL
	stripe_color = COLOR_PALE_BTL_GREEN

/obj/machinery/door/airlock/civilian/alt
	stripe_color = COLOR_PALE_BTL_GREEN

/obj/machinery/door/airlock/multi_tile/glass/civilian
	door_color = COLOR_EGGSHELL
	stripe_color = COLOR_PALE_BTL_GREEN

/obj/machinery/door/airlock/multi_tile/glass/civilian/alt
	stripe_color = COLOR_PALE_BTL_GREEN

/obj/machinery/door/airlock/multi_tile/glass/exploration
	door_color = COLOR_GRAY20
	stripe_color = COLOR_EXPLO_VIOLET

/obj/machinery/door/airlock/multi_tile/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_BABY_BLUE

/obj/machinery/door/airlock/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_BABY_BLUE

/obj/machinery/door/airlock/glass/exploration
	door_color = COLOR_GRAY20
	stripe_color = COLOR_EXPLO_VIOLET

/obj/machinery/door/airlock/exploration
	door_color = COLOR_GRAY20
	stripe_color = COLOR_EXPLO_VIOLET
