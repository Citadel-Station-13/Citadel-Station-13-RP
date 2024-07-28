/*
*	Here is where any supply packs related
*	to being atmospherics tasks live.
*/


/datum/supply_pack/nanotrasen/atmospherics
	category = "Atmospherics"

/datum/supply_pack/nanotrasen/atmospherics/inflatable
	name = "Inflatable barriers"
	contains = list(
		/obj/item/storage/briefcase/inflatable = 3,
	)
	container_type = /obj/structure/closet/crate/engineering
	container_name = "Inflatable Barrier Crate"

/datum/supply_pack/nanotrasen/atmospherics/canister_empty
	name = "Empty gas canister"
	container_name = "Empty gas canister crate"
	container_type = /obj/structure/largecrate
	contains = list(
		/obj/machinery/portable_atmospherics/canister = 1,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_air
	name = "Air canister"
	container_name = "Air canister crate"
	container_type = /obj/structure/largecrate
	contains = list(
		/obj/machinery/portable_atmospherics/canister/air,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_helium
	name = "Helium canister"
	container_name = "Helium canister crate"
	container_type = /obj/structure/largecrate
	contains = list(
		/obj/machinery/portable_atmospherics/canister/helium,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_oxygen
	name = "Oxygen canister"
	container_name = "Oxygen canister crate"
	container_type = /obj/structure/largecrate
	contains = list(
		/obj/machinery/portable_atmospherics/canister/oxygen,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_nitrogen
	name = "Nitrogen canister"
	container_name = "Nitrogen canister crate"
	container_type = /obj/structure/largecrate
	contains = list(
		/obj/machinery/portable_atmospherics/canister/nitrogen,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_phoron
	name = "Phoron gas canister"
	container_name = "Phoron gas canister crate"
	container_type = /obj/structure/closet/crate/secure/large
	container_access = list(
		ACCESS_ENGINEERING_ATMOS,
	)
	contains = list(
		/obj/machinery/portable_atmospherics/canister/phoron,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_nitrous_oxide
	name = "N2O gas canister"
	container_name = "N2O gas canister crate"
	container_type = /obj/structure/closet/crate/secure/large
	contains = list(
		/obj/machinery/portable_atmospherics/canister/nitrous_oxide,
	)

/datum/supply_pack/nanotrasen/atmospherics/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	container_name = "CO2 canister crate"
	container_type = /obj/structure/closet/crate/secure/large
	contains = list(
		/obj/machinery/portable_atmospherics/canister/carbon_dioxide,
	)

/datum/supply_pack/nanotrasen/atmospherics/air_dispenser
	name = "Pipe Dispenser"
	container_type = /obj/structure/closet/crate/secure/large
	container_name = "Pipe Dispenser Crate"
	contains = list(
		/obj/machinery/pipedispenser/orderable,
	)

/datum/supply_pack/nanotrasen/atmospherics/disposals_dispenser
	name = "Disposals Pipe Dispenser"
	container_type = /obj/structure/closet/crate/secure/large
	container_name = "Disposal Dispenser Crate"
	contains = list(
		/obj/machinery/pipedispenser/disposal/orderable,
	)

/datum/supply_pack/nanotrasen/atmospherics/internals
	name = "Internals crate"
	contains = list(
		/obj/item/clothing/mask/gas = 3,
		/obj/item/tank/air = 3,
	)
	container_type = /obj/structure/closet/crate/internals
	container_name = "Internals crate"

/datum/supply_pack/nanotrasen/atmospherics/evacuation
	name = "Emergency equipment"
	contains = list(
		/obj/item/storage/toolbox/emergency = 2,
		/obj/item/clothing/suit/storage/hazardvest = 2,
		/obj/item/clothing/suit/storage/vest = 2,
		/obj/item/tank/emergency/oxygen/engi = 4,
		/obj/item/clothing/suit/space/emergency = 4,
		/obj/item/clothing/head/helmet/space/emergency = 4,
		/obj/item/clothing/mask/gas = 4,
	)
	container_type = /obj/structure/closet/crate/internals
	container_name = "Emergency crate"
