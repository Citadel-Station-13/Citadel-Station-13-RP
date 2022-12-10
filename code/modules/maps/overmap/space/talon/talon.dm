///////////////////////////
//// Spawning and despawning

/datum/spawnpoint/talon
	display_name = "ITV Talon Cryo"
	restrict_job = list("Talon Captain", "Talon Pilot", "Talon Engineer", "Talon Doctor", "Talon Guard")
	announce_channel = "Talon"

/obj/machinery/cryopod/talon
	announce_channel = "Talon"
	on_store_message = "has entered cryogenic storage."
	on_store_name = "ITV Talon Cryo"
	on_enter_visible_message = "starts climbing into the"
	on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	on_store_visible_message_1 = "hums and hisses as it moves"
	on_store_visible_message_2 = "into cryogenic storage."

/obj/machinery/cryopod/robot/talon
	announce_channel = "Talon"
	on_store_name = "ITV Talon Robotic Storage"

/obj/landmark/map_data/talon
    height = 2

///////////////////////////
//// The Talon
/obj/effect/overmap/visitable/ship/talon
	scanner_name = "ITV Talon"
	scanner_desc = @{"[i]Registration[/i]: ITV Talon
[i]Class[/i]: Frigate
[i]Transponder[/i]: Transmitting (CIV)
[b]Notice[/b]: Independent trader vessel"}
	color = "#aacccc"
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("talon_fore", "talon_aft", "talon_port", "talon_starboard")
	initial_restricted_waypoints = list("Talon's boat" = list("offmap_spawn_talonboat"), "Talon lifeboat" = list("offmap_spawn_talon_lifeboat"))

	skybox_icon = 'icons/map_assets/talon/skybox.dmi' //Art by Gwyvern, distributed under Creative Commons license
	skybox_icon_state = "skybox"
	skybox_pixel_x = 270
	skybox_pixel_y = 60

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/talonboat
	name = "boat control console"
	shuttle_tag = "Talon's boat"
	req_one_access = list(access_talon)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/talonboat
	name = "Talon's boat bay"
	base_area = /area/talon/deckone/central_hallway
	base_turf = /turf/simulated/floor/tiled/monotile
	landmark_tag = "offmap_spawn_talonboat"
	docking_controller = "talon_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/talonboat

// The talon's boat

/datum/shuttle/autodock/overmap/talonboat
	name = "Talon's boat"
	current_location = "offmap_spawn_talonboat"
	docking_controller_tag = "talonboat_docker"
	shuttle_area = /area/shuttle/talonboat
	fuel_consumption = 2
	defer_initialisation = TRUE

/area/shuttle/talonboat
	name = "Talon's Boat"

///////////////////////////
//// The Lifeboat
/obj/effect/overmap/visitable/ship/landable/talon_lifeboat
	name = "Talon lifeboat"
	desc = "A tiny engineless lifeboat from the ITV Talon."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Talon lifeboat"

/*
/obj/effect/overmap/visitable/ship/talon_lifeboat/landable/get_skybox_representation()
	var/image/I = image('aro.dmi', "skybox")
	I.pixel_x = 200
	I.pixel_y = 200
	return I
*/

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/talon_lifeboat
	name = "lifeboat control console"
	shuttle_tag = "Talon lifeboat"
	req_one_access = list(access_talon)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/talon_lifeboat
	name = "Talon lifeboat dock"
	base_area = /area/talon/maintenance/decktwo_aft
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "offmap_spawn_talon_lifeboat"
	docking_controller = "talon_lifeboatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/talon_lifeboat

// The talon's boat

/datum/shuttle/autodock/overmap/talon_lifeboat
	name = "Talon lifeboat"
	current_location = "offmap_spawn_talon_lifeboat"
	docking_controller_tag = "talonlifeboat_docker"
	shuttle_area = /area/talon/decktwo/lifeboat
	fuel_consumption = 0
	defer_initialisation = TRUE


///////////////////////////
//// The Various Machines
/obj/machinery/telecomms/allinone/talon
	freq_listening = list(PUB_FREQ, TALON_FREQ)

/obj/item/paper/talon_shields
	name = "To whatever asshole"
	info = {"To whatever <b>asshole</b> keeps resetting the shield generator,<br>\
Please stop fucking around before you get us all killed. thanks.<br>\
<br>\
To whoever has to fix this,<br>\
Radius to <b>60</b> to cover the entire ship.<br>\
Z-level <b>1</b> so that it can cover both levels.<br>\
Charge rate <b>0.9</b> so that it can charge decently fast.<br>\
Max strength between <b>2-10</b> depending on what to expect, from dust to meteors.</br>\
<b>Max out</b> the Capacitor. Don't question it. Just do it.</br>\
Good luck<br>\
<br>\
<i>Harry Townes</i>"}

/obj/item/paper/talon_lifeboat
	name = "Survival Directions"
	info = {"<h3>Survival Directions</h3><br>
<b>Only jettison lifeboat into space if no other means of survival available.</b><br>
First attempt to protect lifeboat by means of shield generator in bubble mode until help arrives.<br>
Do not attempt to exit lifeboat without wearing proper protective equipment and setting up an in-situ airlock. This can be done using metalfoam and inflatable barriers.<br>
If lifeboat destruction is imminent, jettison lifeboat into space.<br>
Once in open space, consider disabling nonessential power-consuming electronics via the APC, or even disabling the APC entirely, and turning it on at invernals as necessary.<br>
((OOC: You can also pray/ahelp.))
"}

//Prevents remote control of drones
/obj/machinery/drone_fabricator/talon
	name = "somewhat glitchy drone fabricator"
	desc = "Obtained from a derelict, it seems to work sometimes, not work sometimes, and work TOO good sometimes. Didn't come with a control console either..."
	drone_type = /mob/living/silicon/robot/drone/talon

/mob/living/silicon/robot/drone/talon
	foreign_droid = TRUE
	idcard_type = /obj/item/card/id/synthetic/talon

/obj/item/card/id/synthetic/talon
	name = "\improper Talon synthetic ID"
	desc = "Access module for Talon synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Talon synthetic"

/obj/item/card/id/synthetic/talon/Initialize(mapload)
	. = ..()
	access = list(access_talon, access_synth)

/obj/machinery/power/smes/buildable/offmap_spawn/Initialize(mapload, install_coils)
	. = ..()
	charge = 1e7
	RCon = TRUE
	input_level = input_level_max
	output_level = output_level_max
	input_attempt = TRUE

/obj/machinery/power/apc/talon
	req_access = list()
	req_one_access = list(access_talon)
	alarms_hidden = 1

/obj/machinery/power/apc/talon/hyper
	cell_type = /obj/item/cell/hyper

/obj/machinery/alarm/talon
	req_access = list()
	req_one_access = list(access_talon)
	alarms_hidden = 1

/obj/machinery/door/firedoor/glass/talon
	req_access = list()
	req_one_access = list(access_talon)

/obj/machinery/door/firedoor/glass/talon/hidden
	name = "\improper Emergency Shutter System"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas. This model fits flush with the walls, and has a panel in the floor for maintenance."
	icon = 'icons/obj/doors/DoorHazardHidden.dmi'

/obj/machinery/camera/network/talon
	network = list(NETWORK_TALON_SHIP)

/obj/machinery/photocopier/faxmachine/talon
	department = "ITV Talon"
	desc = "The ship's fax machine! It's a safe assumption that most of the departments listed aren't on your ship, since the ship only has one."

/obj/item/clothing/head/helmet/space/void/captain/talon
	name = "talon captain's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/captain/talon
	name = "talon captain's voidsuit"

/obj/item/clothing/head/helmet/space/void/security/talon
	name = "talon guard's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/security/talon
	name = "talon guard's voidsuit"

/obj/item/clothing/head/helmet/space/void/medical/talon
	name = "talon doctor's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/medical/talon
	name = "talon doctor's voidsuit"

/obj/item/clothing/head/helmet/space/void/atmos/talon
	name = "talon engineer's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/atmos/talon
	name = "talon engineer's voidsuit"

/obj/item/clothing/head/helmet/space/void/pilot/talon
	name = "talon pilot's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/pilot/talon
	name = "talon pilot's voidsuit"

/obj/item/gps/command/taloncap
	gps_tag = "TALC"
/obj/item/gps/security/talonguard
	gps_tag = "TALG"
/obj/item/gps/medical/talonmed
	gps_tag = "TALM"
/obj/item/gps/engineering/taloneng
	gps_tag = "TALE"
/obj/item/gps/explorer/talonpilot
	gps_tag = "TALP"

/obj/structure/closet/secure_closet/talon_captain
	name = "talon captain's locker"
	req_access = list(access_talon)
	// closet_appearance = /singleton/// closet_appearance/secure_closet/talon/captain

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/captain/talon,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/melee/telebaton,
		/obj/item/flash,
		/obj/item/radio,
		/obj/item/radio/headset/talon,
		/obj/item/clothing/head/helmet/space/void/refurb/officer/talon,
		/obj/item/clothing/suit/space/void/refurb/officer/talon,
		/obj/item/clothing/shoes/magboots,
		/obj/item/tank/oxygen,
		/obj/item/suit_cooling_unit,
		/obj/item/gps/command/taloncap
	)

/obj/structure/closet/secure_closet/talon_guard
	name = "talon guard's locker"
	req_access = list(access_talon)
	// closet_appearance = /singleton/// closet_appearance/secure_closet/talon/guard

	starts_with = list(
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/clothing/under/utility,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless,
		/obj/item/handcuffs = 2,
		/obj/item/gun/energy/stunrevolver,
		/obj/item/clothing/accessory/armor/tag/sec,
		/obj/item/flash,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/storage/belt/security,
		/obj/item/radio,
		/obj/item/radio/headset/talon,
		/obj/item/clothing/accessory/oricon/department/security,
		/obj/item/clothing/head/helmet/space/void/refurb/marine/talon,
		/obj/item/clothing/suit/space/void/refurb/marine/talon,
		/obj/item/clothing/shoes/magboots,
		/obj/item/tank/oxygen,
		/obj/item/suit_cooling_unit,
		/obj/item/gps/security/talonguard,
		/obj/item/melee/baton
	)

/obj/structure/closet/secure_closet/talon_doctor
	name = "talon doctor's locker"
	req_access = list(access_talon)
	// closet_appearance = /singleton/// closet_appearance/secure_closet/talon/doctor

	starts_with = list(
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/nurse,
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/white,
		/obj/item/radio,
		/obj/item/radio/headset/talon,
		/obj/item/clothing/head/helmet/space/void/refurb/medical/alt/talon,
		/obj/item/clothing/suit/space/void/refurb/medical/talon,
		/obj/item/clothing/shoes/magboots,
		/obj/item/tank/oxygen,
		/obj/item/suit_cooling_unit,
		/obj/item/gps/medical/talonmed
	)

/obj/structure/closet/secure_closet/talon_engineer
	name = "talon engineer's locker"
	req_access = list(access_talon)
	// closet_appearance = /singleton/// closet_appearance/secure_closet/talon/engineer

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/flashlight,
		/obj/item/extinguisher,
		/obj/item/radio,
		/obj/item/radio/headset/talon,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/barrier_tape_roll/atmos,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/head/helmet/space/void/refurb/engineering/talon,
		/obj/item/clothing/suit/space/void/refurb/engineering/talon,
		/obj/item/clothing/shoes/magboots,
		/obj/item/tank/oxygen,
		/obj/item/suit_cooling_unit,
		/obj/item/gps/engineering/taloneng
	)

/obj/structure/closet/secure_closet/talon_pilot
	name = "talon pilot's locker"
	req_access = list(access_talon)
	// closet_appearance = /singleton/// closet_appearance/secure_closet/talon/pilot

	starts_with = list(
		/obj/item/material/knife/tacknife/survival,
		/obj/item/clothing/head/pilot,
		/obj/item/clothing/under/rank/pilot1,
		/obj/item/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/reagent_containers/food/snacks/liquidfood,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/radio,
		/obj/item/clothing/under/utility/blue,
		/obj/item/clothing/accessory/oricon/specialty/pilot,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless,
		/obj/item/radio/headset/talon,
		/obj/item/flashlight/color/orange,
		/obj/item/clothing/head/helmet/space/void/refurb/pilot/talon,
		/obj/item/clothing/suit/space/void/refurb/pilot/talon,
		/obj/item/clothing/shoes/magboots,
		/obj/item/tank/oxygen,
		/obj/item/suit_cooling_unit,
		/obj/item/gps/explorer/talonpilot
	)

///////////////////////////
//// Computers
// Talon helmet cameras
/datum/computer_file/program/camera_monitor/talon_helmet
	filename = "talhcammon"
	filedesc = "Helmet Camera Monitoring (Talon)"
	extended_desc = "This program allows remote access to Talon helmet camera systems."
	size = 4 //Smaller because limited scope
	tguimodule_path = /datum/tgui_module/camera/ntos/talon_helmet
	required_access = access_talon

// Talon ship cameras
/datum/computer_file/program/camera_monitor/talon_ship
	filename = "talscammon"
	filedesc = "Ship Camera Monitoring (Talon)"
	extended_desc = "This program allows remote access to the Talon's camera system."
	size = 10 //Smaller because limited scope
	tguimodule_path = /datum/tgui_module/camera/ntos/talon_ship
	required_access = access_talon

/datum/tgui_module/camera/ntos/talon_ship
	name = "Talon Ship Camera Monitor"
/datum/tgui_module/camera/ntos/talon_ship/New(host)
	. = ..(host, list(NETWORK_TALON_SHIP, NETWORK_THUNDER))

/datum/tgui_module/camera/ntos/talon_helmet
	name = "Talon Helmet Camera Monitor"
/datum/tgui_module/camera/ntos/talon_helmet/New(host)
	. = ..(host, list(NETWORK_TALON_HELMETS))

/datum/computer_file/program/power_monitor/talon
	filename = "tpowermonitor"
	filedesc = "Power Monitoring (Talon)"
	required_access = access_talon
/datum/computer_file/program/alarm_monitor/talon
	filename = "talarmmonitoreng"
	filedesc = "Alarm Monitoring (Talon)"
	required_access = access_talon
/datum/computer_file/program/rcon_console/talon
	filename = "trconconsole"
	filedesc = "RCON Remote Control (Talon)"
	required_access = access_talon
/datum/computer_file/program/atmos_control/talon
	filename = "tatmoscontrol"
	filedesc = "Atmosphere Control (Talon)"
	required_access = access_talon
/datum/computer_file/program/suit_sensors/talon
	filename = "tsensormonitor"
	filedesc = "Suit Sensors Monitoring (Talon)"
	required_access = access_talon

// Modular computer/console presets
/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/pilot
	name = "pilot's laptop"

/* PENDING HARDSYNC!
/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/pilot/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/ship_nav())
*/

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/engineer
	name = "engineer's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/engineer/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/power_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/rcon_console/talon())
	hard_drive.store_file(new/datum/computer_file/program/atmos_control/talon())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/security
	name = "guard's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/security/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_ship())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/medical
	name = "doctor's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/medical/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors/talon())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_helmet())
	set_autorun("tsensormonitor")

//Generic modular consoles scattered around
/obj/item/modular_computer/console/preset/talon
	name = "talon modular computer"

/obj/item/modular_computer/console/preset/talon/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/super(src)
	network_card = new/obj/item/computer_hardware/network_card/wired(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/talon/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/power_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/rcon_console/talon())
	hard_drive.store_file(new/datum/computer_file/program/atmos_control/talon())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_ship())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors/talon())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_helmet())


// Just in case someone decides to clean up radio.dm and remove this Im going to leave a copy commented out here. Might save someone some trouble later trying to find this. Bloop
/*
/obj/item/bluespace_radio/talon_prelinked
	name = "bluespace radio (talon)"
	handset = /obj/item/radio/bluespace_handset/linked/talon_prelinked

/obj/item/radio/bluespace_handset/linked/talon_prelinked
	bs_tx_preload_id = "talon_aio" //Transmit to a receiver
	bs_rx_preload_id = "talon_aio" //Recveive from a transmitter
*/
/*	//Just keeping this here for reference, this would go into the define's folder of a map -Bloop
	lateload_z_levels = list(
		list("Offmap Ship - Talon Z1","Offmap Ship - Talon Z2")//I swear to god this better work -Bloop
	)
*/
/*
// Talon offmap spawn stuff
/datum/map_template/triumph_lateload/offmap/talon1
	name = "Offmap Ship - Talon Z1"
	desc = "Offmap spawn ship, the Talon."
	mappath = "_maps/map_levels/140x140/talon/talon1.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/talon1

/datum/map_template/triumph_lateload/offmap/talon2
	name = "Offmap Ship - Talon Z2"
	desc = "Offmap spawn ship, the Talon."
	mappath = "_maps/map_levels/140x140/talon/talon2.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/talon2

/datum/map_z_level/triumph_lateload/talon1
	name = "Talon Deck One"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/space
	z = Z_LEVEL_TALON1

/datum/map_z_level/triumph_lateload/talon2
	name = "Talon Deck Two"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open
	z = Z_LEVEL_TALON2
*/
