/*
*	Here is where any supply packs
*	related to engineering tasks live.
*/


/datum/supply_pack/nanotrasen/engineering
	abstract_type = /datum/supply_pack/nanotrasen/engineering
	container_type = /obj/structure/closet/crate/engineering
	category = "Engineering"

/datum/supply_pack/nanotrasen/engineering/lightbulbs
	name = "Replacement lights"
	contains = list(
		/obj/item/storage/box/lights/mixed = 3,
	)

/datum/supply_pack/nanotrasen/engineering/electrical
	name = "Electrical maintenance crate"
	contains = list(
		/obj/item/storage/toolbox/electrical = 2,
		/obj/item/clothing/gloves/yellow = 2,
		/obj/item/cell = 2,
		/obj/item/cell/high = 2,
	)
	worth = 300
	container_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/nanotrasen/engineering/e_welders
	name = "Electric welder crate"
	contains = list(
		/obj/item/weldingtool/electric = 3,
	)
	container_type = /obj/structure/closet/crate/engineering/electrical

/datum/supply_pack/nanotrasen/engineering/mechanical
	name = "Mechanical maintenance crate"
	contains = list(
		/obj/item/storage/belt/utility/full = 3,
		/obj/item/clothing/suit/storage/hazardvest = 3,
		/obj/item/clothing/head/welding = 2,
		/obj/item/clothing/head/hardhat,
	)
	worth = 300
	container_type = /obj/structure/closet/crate/engineering
	container_name = "Mechanical maintenance crate"

/datum/supply_pack/nanotrasen/engineering/fueltank
	name = "welding fuel tank"
	contains = list(
		/obj/structure/reagent_dispensers/fueltank,
	)
	worth = 200
	container_type = /obj/structure/largecrate

/datum/supply_pack/nanotrasen/engineering/solar
	name = "Solar Pack crate"
	contains  = list(
		/obj/item/frame2/solar_panel = 21,
		/obj/item/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar,
	)
	worth = 500 // solars are cheap nowadays :)
	container_type = /obj/structure/closet/crate/corporate/focalpoint

/datum/supply_pack/nanotrasen/engineering/shield_generator
	name = "Shield Generator Construction Kit"
	contains = list(
		/obj/item/circuitboard/shield_generator,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/micro_laser,
		/obj/item/smes_coil,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/subspace/amplifier,
		)
	worth = 1000

/datum/supply_pack/nanotrasen/engineering/teg
	name = "Mark I TEG + Circulators"
	contains = list(
		/obj/machinery/power/generator,
		/obj/machinery/atmospherics/component/binary/circulator = 2,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/large

/datum/supply_pack/nanotrasen/engineering/radsuit
	contains = list(
		/obj/item/clothing/suit/radiation = 3,
		/obj/item/clothing/head/radiation = 3,
	)
	name = "Radiation suits package"
	container_type = /obj/structure/closet/radiation
	container_name = "Radiation suit locker"

/datum/supply_pack/nanotrasen/engineering/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	worth = 350
	container_type = /obj/structure/closet/crate/secure/engineering
	contains = list(
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/matter_bin,
		/obj/item/circuitboard/pacman,
	)

/datum/supply_pack/nanotrasen/engineering/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	container_type = /obj/structure/closet/crate/secure/engineering
	worth = 650
	contains = list(
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/matter_bin,
		/obj/item/circuitboard/pacman/super,
	)

/datum/supply_pack/nanotrasen/engineering/reflector
	name = "Reflector crate"
	container_name = "Reflector crate"
	container_type = /obj/structure/closet/crate/engineering
	contains = list(
		/obj/structure/prop/prism/reflector = 1,
	)

/datum/supply_pack/nanotrasen/engineering/tritium
	name = "Tritium crate"
	container_name = "Tritium crate"
	container_type = /obj/structure/closet/crate/engineering
	contains = list(
		/datum/prototype/material/hydrogen/tritium = 50,
	)

/datum/supply_pack/nanotrasen/engineering/thermoregulator
	name = "Thermal Regulator"
	contains = list(
		/obj/machinery/power/thermoregulator,
	)
	container_type = /obj/structure/closet/crate/large
	container_name = "thermal regulator crate"

/datum/supply_pack/nanotrasen/engineering/algae
	name = "Algae Sheets (10)"
	contains = list(
		/datum/prototype/material/algae = 10,
	)
	container_type = /obj/structure/closet/crate
	container_name = "algae sheets crate"

/datum/supply_pack/nanotrasen/engineering/point_defense_cannon_circuit
	name = "Point Defense Turret Circuit"
	contains = list(
		/obj/item/circuitboard/pointdefense = 2,
	)
	worth = 450
	container_type = /obj/structure/closet/crate/corporate/heph
	container_name = "point defense turret circuit crate"

/datum/supply_pack/nanotrasen/engineering/point_defense_control_circuit
	name = "Point Defense Controller Circuit"
	contains = list(
		/obj/item/circuitboard/pointdefense_control = 1,
	)
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/heph
	container_name = "point defense mainframe circuit crate"

/datum/supply_pack/nanotrasen/engineering/portable_pump
	name = "Portable Pump (2x)"
	contains = list(
		/obj/machinery/portable_atmospherics/powered/pump = 2,
	)
	container_name = "portable pumps crate"

/datum/supply_pack/nanotrasen/engineering/shield_wall_generators
	name = "Misc - Wall shield generators"
	contains = list(
		/obj/machinery/shieldwallgen = 4,
	)
	container_type = /obj/structure/closet/crate/secure
	container_name = "Wall shield generators crate"

//*                         Engine                          *//
//* Access locked because most of these are very dangerous. *//


/datum/supply_pack/nanotrasen/engineering/engine
	abstract_type = /datum/supply_pack/nanotrasen/engineering/engine
	container_type = /obj/structure/closet/crate/secure/engineering
	container_access = list(
		/datum/access/station/engineering/engine,
	)
	supply_pack_flags = SUPPLY_PACK_LOCK_PRIVATE_ORDERS

/datum/supply_pack/nanotrasen/engineering/engine/emitter
	name = "Emitter crate"
	contains = list(
		/obj/machinery/power/emitter = 2,
	)
	container_name = "Emitter crate"

/datum/supply_pack/nanotrasen/engineering/engine/gyrotron
	name = "gyrotron crate"
	contains = list(
		/obj/machinery/power/emitter/gyrotron,
		/obj/item/circuitboard/gyrotron_control,
	)

/datum/supply_pack/nanotrasen/engineering/engine/field_generator
	name = "Field Generator crate"
	contains = list(
		/obj/machinery/field_generator = 2,
	)
	container_name = "Field Generator crate"

/datum/supply_pack/nanotrasen/engineering/engine/singularity_generator
	name = "Singularity Generator crate"
	contains = list(
		/obj/machinery/the_singularitygen,
	)
	worth = 4500
	container_name = "Singularity Generator crate"

/datum/supply_pack/nanotrasen/engineering/engine/radiation_collector
	name = "Collector crate"
	contains = list(
		/obj/machinery/power/rad_collector = 3,
	)
	container_type = /obj/structure/closet/crate/secure/engineering
	container_name = "collector crate"

/datum/supply_pack/nanotrasen/engineering/engine/particle_accelerator
	name = "Particle Accelerator crate"
	contains = list(
		/obj/structure/particle_accelerator/fuel_chamber,
		/obj/machinery/particle_accelerator/control_box,
		/obj/structure/particle_accelerator/particle_emitter/center,
		/obj/structure/particle_accelerator/particle_emitter/left,
		/obj/structure/particle_accelerator/particle_emitter/right,
		/obj/structure/particle_accelerator/power_box,
		/obj/structure/particle_accelerator/end_cap,
		/obj/item/paper/particle_info,
		)
	worth = 1800
	container_name = "Particle Accelerator crate"

/datum/supply_pack/nanotrasen/engineering/engine/tesla_generator
	name = "Tesla Generator crate"
	contains = list(
		/obj/machinery/the_singularitygen/tesla,
	)
	container_type = /obj/structure/closet/crate/secure/engineering
	container_name = "Tesla Generator crate"

/datum/supply_pack/nanotrasen/engineering/engine/fission
	name = "Fission Starter crate"
	contains = list(
		/obj/machinery/power/fission,
		/obj/item/circuitboard/fission_monitor,
		/obj/item/storage/briefcase/fission/fuelmixed,
		/obj/item/storage/briefcase/fission/reflectormixed,
		/obj/item/storage/briefcase/fission/controlmixed,
	)
	worth = 2750
	container_type = /obj/structure/closet/crate/secure/engineering
	container_name = "fission core crate"

/datum/supply_pack/nanotrasen/engineering/engine/fission/expansion
	name = "Fission Expansion crate"
	contains = list(
		/obj/item/circuitboard/fission_monitor,
		/obj/item/storage/briefcase/fission/uranium,
		/obj/item/storage/briefcase/fission/tungstencarbide,
		/obj/item/storage/briefcase/fission/boron,
	)
	worth = 2000
	container_type = /obj/structure/closet/crate/secure/engineering
	container_name = "fission expansion crate"

/datum/supply_pack/nanotrasen/engineering/engine/supermatter_core
	name = "Supermatter Core"
	contains = list(
		/obj/machinery/power/supermatter,
	)
	worth = 4500 // oh god it's the big supermatter :skull:
	container_type = /obj/structure/closet/crate/secure/phoron
	container_name = "Supermatter crate (CAUTION)"

/datum/supply_pack/nanotrasen/engineering/engine/fusion_core
	name = "R-UST Mk. 8 Tokamak fusion core crate"
	worth = 1250
	container_name = "R-UST Mk. 8 Tokamak Fusion Core crate"
	contains = list(
		/obj/item/book/manual/rust_engine,
		/obj/machinery/power/fusion_core,
		/obj/item/circuitboard/fusion_core_control,
	)

/datum/supply_pack/nanotrasen/engineering/engine/fusion_fuel_injector
	name = "R-UST Mk. 8 fuel injector crate"
	worth = 1250
	container_name = "R-UST Mk. 8 fuel injector crate"
	contains = list(
		/obj/machinery/fusion_fuel_injector,
		/obj/machinery/fusion_fuel_injector,
		/obj/item/circuitboard/fusion_fuel_control,
	)

/datum/supply_pack/nanotrasen/engineering/engine/fusion_fuel_compressor
	name = "fusion fuel compressor parts crate"
	contains = list(
		/obj/item/circuitboard/fusion_fuel_compressor,
		/obj/item/stock_parts/manipulator/nano = 2,
		/obj/item/stock_parts/matter_bin/super = 2,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5,
	)
	worth = 500

//* SMES Coils *//
/datum/supply_pack/nanotrasen/engineering/smescoil
	abstract_type = /datum/supply_pack/nanotrasen/engineering/smescoil

/datum/supply_pack/nanotrasen/engineering/smescoil/normal
	name = "Superconducting Magnetic Coil"
	contains = list(
		/obj/item/smes_coil,
	)

/datum/supply_pack/nanotrasen/engineering/smescoil/super_capacity
	name = "Superconducting Capacitance Coil"
	contains = list(
		/obj/item/smes_coil/super_capacity,
	)

/datum/supply_pack/nanotrasen/engineering/smescoil/super_io
	name = "Superconducting Transmission Coil"
	contains = list(
		/obj/item/smes_coil/super_io,
	)
