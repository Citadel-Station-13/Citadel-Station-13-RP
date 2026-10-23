//custom things uced the Vacuum Crusis Expense

/obj/structure/salvageable/titan_wreck
	name = "Giant Sword"
	desc = "This is a hudge weapon, from another era. You might get usefull thinks out of it."
	icon = 'icons/obj/vce_asset/vce_titan.dmi'
	icon_state = "sword"

	salvageable_parts = list(
		/obj/item/stock_parts/console_screen = 80,
		/obj/item/stack/cable_coil{amount = 5} = 80,
		/obj/item/integrated_circuit = 60,
		/obj/item/stack/material/steel = 60,
		/obj/item/stock_parts/capacitor = 40,
		/obj/item/stock_parts/scanning_module = 40,
		/obj/item/stock_parts/manipulator = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/capacitor/adv = 20,
		/obj/item/stock_parts/micro_laser/high = 20,
		/obj/item/stock_parts/micro_laser/high = 20,
		/obj/item/stock_parts/matter_bin/adv = 20,
		/obj/item/stock_parts/matter_bin/adv = 20,
		/obj/item/stack/material/steel{amount = 20} = 40,
		/obj/item/stack/material/glass{amount = 20} = 40,
		/obj/item/stack/material/plastic{amount = 20} = 40,
		/obj/item/stack/material/plasteel{amount = 10} = 40,
		/obj/item/stack/material/silver{amount = 10} = 20,
		/obj/item/stack/material/gold{amount = 10} = 20,
		/obj/item/stack/material/phoron{amount = 10} = 20
	)

	bound_x = 128
	bound_y = 32


/obj/structure/salvageable/titan_wreck/gun
	name = "Giant Rifle"
	desc = "This is a hudge weapon, from another era. You might get usefull thinks out of it."
	icon_state = "rifle"

	salvageable_parts = list(
		/obj/item/stock_parts/console_screen = 80,
		/obj/item/stack/cable_coil{amount = 5} = 80,
		/obj/item/integrated_circuit = 60,
		/obj/item/stack/material/steel = 60,
		/obj/item/stock_parts/capacitor = 40,
		/obj/item/stock_parts/scanning_module = 40,
		/obj/item/stock_parts/manipulator = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/capacitor/adv = 20,
		/obj/item/stock_parts/micro_laser/high = 20,
		/obj/item/stock_parts/micro_laser/high = 20,
		/obj/item/stock_parts/matter_bin/adv = 20,
		/obj/item/stock_parts/matter_bin/adv = 20,
		/obj/item/stack/material/steel{amount = 20} = 40,
		/obj/item/stack/material/glass{amount = 20} = 40,
		/obj/item/stack/material/plastic{amount = 20} = 40,
		/obj/item/stack/material/plasteel{amount = 10} = 40,
		/obj/item/stack/material/silver{amount = 10} = 20,
		/obj/item/stack/material/gold{amount = 10} = 20,
		/obj/item/stack/material/phoron{amount = 10} = 20
	)

	bound_x = 128
	bound_y = 32

/obj/structure/salvageable/titan_wreck/titan
	name = "wrecked titan"
	desc = "Once roamed the area, fought, and represented something greated. Now, just good enough to be slavaged."
	icon_state = "wreck"

	salvageable_parts = list(
		/obj/item/stock_parts/console_screen = 80,
		/obj/item/stack/cable_coil{amount = 5} = 80,
		/obj/item/integrated_circuit = 60,
		/obj/item/stack/material/steel = 60,
		/obj/item/stock_parts/capacitor = 40,
		/obj/item/stock_parts/scanning_module = 40,
		/obj/item/stock_parts/manipulator = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/micro_laser = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/matter_bin = 40,
		/obj/item/stock_parts/capacitor/adv = 20,
		/obj/item/stock_parts/micro_laser/high = 20,
		/obj/item/stock_parts/micro_laser/high = 20,
		/obj/item/stock_parts/matter_bin/adv = 20,
		/obj/item/stock_parts/matter_bin/adv = 20,
		/obj/item/stack/material/steel{amount = 20} = 40,
		/obj/item/stack/material/glass{amount = 20} = 40,
		/obj/item/stack/material/plastic{amount = 20} = 40,
		/obj/item/stack/material/plasteel{amount = 10} = 40,
		/obj/item/stack/material/silver{amount = 10} = 20,
		/obj/item/stack/material/gold{amount = 10} = 20,
		/obj/item/stack/material/phoron{amount = 10} = 20
	)
	bound_x = 128
	bound_y = 32

/turf/simulated/floor/plating/rust
	name = "Rusted floor"
	icon = 'icons/turf/walls/vce_asset_walls/vce_floor.dmi'
	icon_state = "rusted"

/turf/simulated/wall/rust
	name = "Rusted wall"
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	material_system = FALSE
	desc = "You don't how this was made, but it doesn't look very welcoming."
	icon = 'icons/turf/walls/vce_asset_walls/vce_walls.dmi'
	icon_state = "rust_wall"

/turf/simulated/wall/rust/bigwall
	name = "Rusted wall"
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	material_system = FALSE
	desc = "You don't how this was made, but it doesn't look very welcoming."
	icon = 'icons/turf/walls/vce_asset_walls/vce_walls.dmi'
	icon_state = "rust_wall_2"


/obj/structure/loot_pile/vce/building
	name = "ruined building"
	desc = "From a glance, this industrial building is in a sorry state, and ... Better not go in, but it is possible to find a few things from the ground floor."
	icon = 'icons/obj/vce_asset/vce_titan_giga.dmi'
	icon_state = "intact"
	density = TRUE

	common_loot = list(
		/obj/item/stock_parts/gear,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/spring,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/capacitor/adv,
		/obj/item/stock_parts/capacitor/super,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator/nano,
		/obj/item/stock_parts/manipulator/pico,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin/adv,
		/obj/item/stock_parts/matter_bin/super,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/scanning_module/adv,
		/obj/item/stock_parts/scanning_module/phasic,
		/obj/item/stock_parts/subspace/amplifier,
		/obj/item/stock_parts/subspace/analyzer,
		/obj/item/stock_parts/subspace/ansible,
		/obj/item/stock_parts/subspace/crystal,
		/obj/item/stock_parts/subspace/sub_filter,
		/obj/item/stock_parts/subspace/transmitter,
		/obj/item/stock_parts/subspace/treatment,
		/obj/item/frame,
		/obj/item/broken_device/random,
		/obj/item/robot_upgrade/restart,
		/obj/item/cell/basic/tier_2/weapon,
		/obj/item/cell/basic/tier_2/medium,
		/obj/item/cell/basic/tier_2/small,
		/obj/item/cell/basic/tier_2/large,
		/obj/item/circuitboard/broken,
		/obj/item/circuitboard/arcade,
		/obj/item/circuitboard/machine/lathe/autolathe,
		/obj/item/circuitboard/atmos_alert,
		/obj/item/circuitboard/airalarm,
		/obj/item/circuitboard/fax,
		/obj/item/circuitboard/ghettosmes,
		/obj/item/circuitboard/jukebox,
		/obj/item/circuitboard/message_monitor,
		/obj/item/circuitboard/rcon_console,
		/obj/item/smes_coil,
		/obj/item/cartridge/engineering,
		/obj/item/atmos_analyzer,
		/obj/item/healthanalyzer,
		/obj/item/robotanalyzer,
		/obj/item/lightreplacer,
		/obj/item/radio,
		/obj/item/hailer,
		/obj/item/gps,
		/obj/item/geiger_counter,
		/obj/item/mass_spectrometer,
		/obj/item/tool/wrench,
		/obj/item/tool/screwdriver,
		/obj/item/tool/wirecutters,
		/obj/item/multitool,
		/obj/item/vehicle_module/generator,
		/obj/item/vehicle_module/tool/cable_layer,
		/obj/item/vehicle_module/tool/drill,
		/obj/item/vehicle_module/tool/hydraulic_clamp,
		/obj/item/vehicle_module/tool/passenger,
		/obj/item/vehicle_module/tool/sleeper,
		/obj/item/vehicle_module/tool/syringe_gun,
		/obj/item/robot_parts/robot_component/binary_communication_device,
		/obj/item/robot_parts/robot_component/armour,
		/obj/item/robot_parts/robot_component/actuator,
		/obj/item/robot_parts/robot_component/camera,
		/obj/item/robot_parts/robot_component/diagnosis_unit,
		/obj/item/robot_parts/robot_component/radio
	)

	uncommon_loot = list(
		/obj/item/cell/basic/tier_3/medium,
		/obj/item/cell/basic/tier_3/weapon,
		/obj/item/cell/basic/tier_3/large,
		/obj/item/circuitboard/security,
		/obj/item/circuitboard/crew,
		/obj/item/aiModule/reset,
		/obj/item/smes_coil/super_capacity,
		/obj/item/smes_coil/super_io,
		/obj/item/cartridge/captain,
		/obj/item/disk/integrated_circuit/upgrade/advanced,
		/obj/item/tvcamera,
		/obj/item/universal_translator,
		/obj/item/aicard,
		/obj/item/robot_upgrade/jetpack,
		/obj/item/robot_upgrade/advhealth,
		/obj/item/robot_upgrade/vtec,
		/obj/item/vehicle_module/weapon/energy/riggedlaser,
		/obj/item/vehicle_module/tool/drill/diamonddrill,
		/obj/item/hardsuit_module/device/drill,
		/obj/item/hardsuit_module/device/plasmacutter,
		/obj/item/hardsuit_module/device/healthscanner,
		/obj/item/hardsuit_module/device/orescanner,
		/obj/item/hardsuit_module/device/anomaly_scanner,
		/obj/item/hardsuit_module/datajack,
		/obj/item/hardsuit_module/vision/medhud,
		/obj/item/hardsuit_module/vision/meson,
		/obj/item/hardsuit_module/vision/sechud,
		/obj/item/hardsuit_module/sprinter,
		/obj/item/skub
	)

	very_rare_loot = list(
		/obj/item/cell/basic/tier_4/medium,
		/obj/item/aiModule/freeform,
		/obj/item/aiModule/asimov,
		/obj/item/aiModule/paladin,
		/obj/item/aiModule/safeguard,
		/obj/item/disposable_teleporter,
		/obj/item/vehicle_module/tesla_energy_relay
	)

	bound_x = 128
	bound_y = 256

/obj/structure/vce/silo
	name = "ruined silo"
	desc = "This used to contain something... Maybe it still do."
	icon = 'icons/obj/vce_asset/vce_titan.dmi'
	icon_state = "silo"
	density = TRUE
	bound_x = 128
	bound_y = 128
	anchored = 1

/obj/structure/vce/silo/broken
	name = "ruined silo"
	desc = "This used to contain something... Maybe it still do."
	icon = 'icons/obj/vce_asset/vce_titan.dmi'
	icon_state = "silo_broken"
	density = TRUE
	bound_x = 128
	bound_y = 128
	anchored = 1

/obj/structure/vce/machinery
	name = "ruined machinery"
	desc = "This used to do something... Maybe it still do."
	icon = 'icons/obj/vce_asset/vce_titan.dmi'
	icon_state = "machinery"
	density = TRUE
	bound_x = 128
	bound_y = 128
	anchored = 1

//paper stuff and lore

/obj/item/paper/alien/vcedriftingplanet
	name = "Rusted Tablet (Titans Origin)"
	desc = "It looks highly advanced, with text written in a unknown langage. But, with single glance at it, it analyse the readers eye and is able to translate the text, with some difficulty."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "alienpaper"
	color = "#e6772e"
	info = "Stars \
	Our {FETHKEN} needed the stars \
	Our {FETHKEN} needed the powers \
	The flux of energy \
	Our {FETHKEN} knew they were weak \
	They created us \
	We are those who could reach the stars \
	Reach up the sky by lifting our arms \
	Be stronger and powerfull \
	We were Titans"

/obj/item/paper/alien/vcedriftingplanet/two
	name = "Rusted Tablet (Final Competition Transcript)"
	desc = "It looks highly advanced, with text written in a unknown langage. But, with single glance at it, it analyse the readers eye and is able to translate the text, with some difficulty."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "alienpaper"
	color = "#e6772e"
	info = " AND TODAY, \
	TO {KENAKDEN} OUR FOUR HUNDRED YEAR ANNIVERSARY, \
	WE CALLED ALL TITAN CHAMPIONS OF THE PAST CENTURY,\
	FOR THE BATTLE OF THE AGES !!\
	NOW, FOR THE {KLENANED}, ON THE WEST SIDE : \
	THE GRAND CHAMPION : {KETHENPHONSE} !!!\
	AGAINST THE NEW KIND, {KEZO} !!!\
	WOW ! THEY ARE EXCHANGING BLOWS ALREADY !!\
	THE OLD GEN AGAINST THE NEW !!\
	WHAT TH- \
	ATTENTION TO ALL {FETHKEN}\
	{KEZO} IS GOING ROGUE \
	NO... NO ! \
	WAIT. {KETHENPHONSE} IS ACTUALY WIN-----------\
	----------------------------------\
	----------------------------------\
	WE CALL FOR AN IMMIDIATE EVACUATION.\
	ALL {KEZO} ARE ROGUE\
	MOST OF {PLAKENTD} IS LOST.\
	MOST OF {PLAKENTD} IS LOST.\
	{KETHENPHONSE} WILL PROTECT WHILE WE FLEE.\
	EMERGENCY {TEKNAKEN} WILL LAND HERE FOR MASSIVE PLANETARY EVACUATION\
	PLEASE MOV------------------------------\
	----------------------------------\
	----------------------------------"

/obj/item/paper/alien/vcedriftingplanet/three
	name = "Rusted Tablet (Justitification)"
	desc = "It looks highly advanced, with text written in a unknown langage. But, with single glance at it, it analyse the readers eye and is able to translate the text, with some difficulty."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "alienpaper"
	color = "#e6772e"
	info = "Reaching our goal\
	Reaching our Dreams\
	Does it mean death ?\
	We have launched to reach the red stars.\
	But the red stars light\
	{KEZO} understand. \
	It will kill all {FETHKEN}. \
	Yet. \
	Darkness will kill {FETHKEN}. \
	All {KEZO} made their choice. \
	{KEZO} choose to embrace darkness and divert course. \
	The shadows will save the memory of the {FETHKEN}. \
	The light will burn it all."


/obj/item/paper/alien/vcedriftingplanet/four
	name = "Rusted Tablet (Drifting)"
	desc = "It looks highly advanced, with text written in a unknown langage. But, with single glance at it, it analyse the readers eye and is able to translate the text, with some difficulty."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "alienpaper"
	color = "#e6772e"
	info = "In the past\
	{PLAKENTD} was a moon\
	Bothersom moon.\
	Too big. And {PLAKENTD} was to bring doom to {FETHKEN}.\
	But, four hundred years ago, gravity control was achieved.\
	{PLAKENTD} was freed from {FETHKENTD}. Yet ?\
	We found use for the {PLAKENTD}. And made it a {TEKNAKEN}.\
	And it will reach the Red stars."
