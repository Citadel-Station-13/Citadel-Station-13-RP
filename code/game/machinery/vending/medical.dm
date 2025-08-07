/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(ACCESS_MEDICAL_MAIN)
	products = list(
		/obj/item/reagent_containers/glass/bottle/antitoxin = 4,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_containers/glass/bottle/stoxin = 4,
		/obj/item/reagent_containers/glass/bottle/toxin = 4,
		/obj/item/reagent_containers/syringe/antiviral = 4,
		/obj/item/reagent_containers/syringe = 30,
		/obj/item/healthanalyzer = 5,
		/obj/item/reagent_containers/glass/beaker = 4,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 6,
		/obj/item/stack/medical/advanced/ointment = 6,
		/obj/item/stack/medical/splint = 4,
		/obj/item/storage/pill_bottle/carbon = 2,
		/obj/item/storage/pill_bottle = 3,
		/obj/item/storage/box/vmcrystal = 4,
		/obj/item/clothing/glasses/omnihud/med = 4,
		/obj/item/glasses_kit = 1,
		/obj/item/storage/quickdraw/syringe_case = 4,
		/obj/item/storage/single_use/med_pouch/overdose = 3,
		/obj/item/storage/single_use/med_pouch/radiation = 3,
		/obj/item/storage/single_use/med_pouch/toxin = 3,
		/obj/item/storage/single_use/med_pouch/oxyloss = 3,
		/obj/item/storage/single_use/med_pouch/burn = 3,
		/obj/item/storage/single_use/med_pouch/trauma = 3,
		/obj/item/hypospray = 6,
		/obj/item/storage/hypokit = 6,
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/pill/stox = 4,
		/obj/item/reagent_containers/pill/antitox = 6,
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_log_access = ACCESS_MEDICAL_CMO
	has_logs = 1
/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/storage/single_use/med_pouch/trauma = 1,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/single_use/med_pouch/burn = 1,
		/obj/item/reagent_containers/hypospray/autoinjector = 4,
		/obj/item/healthanalyzer = 1,
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/antitoxin = 4,
		/obj/item/reagent_containers/syringe/antiviral = 4,
		/obj/item/reagent_containers/pill/tox = 1,
	)
	req_log_access = ACCESS_MEDICAL_CMO
	has_logs = 1

// Modified version from tether_things.dm
/obj/machinery/vending/wallmed1/public
	products = list(
		/obj/item/stack/medical/bruise_pack = 8,
		/obj/item/storage/single_use/med_pouch/trauma = 2,
		/obj/item/stack/medical/ointment = 8,
		/obj/item/storage/single_use/med_pouch/burn = 2,
		/obj/item/reagent_containers/hypospray/autoinjector = 16,
		/obj/item/healthanalyzer = 4,
	)

//Airlock antitox vendor. Used on the tether map and a few other POIS and such
/obj/machinery/vending/wallmed_airlock
	name = "Airlock NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser. This limited-use version dispenses antitoxins with mild painkillers for surface EVAs."
	icon_state = "wallmed"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/reagent_containers/pill/airlock = 20,
		/obj/item/storage/single_use/med_pouch/oxyloss = 2,
		/obj/item/storage/single_use/med_pouch/toxin = 2,
		/obj/item/healthanalyzer = 1,
	)
	contraband = list(/obj/item/reagent_containers/pill/tox = 2)
	req_log_access = ACCESS_MEDICAL_CMO
	has_logs = 1

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/reagent_containers/hypospray/autoinjector = 5,
		/obj/item/reagent_containers/syringe/antitoxin = 3,
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/storage/single_use/med_pouch/oxyloss = 1,
		/obj/item/storage/single_use/med_pouch/trauma = 1,
		/obj/item/storage/single_use/med_pouch/burn = 1,
		/obj/item/storage/single_use/med_pouch/toxin = 1,
		/obj/item/storage/single_use/med_pouch/radiation = 1,
		/obj/item/storage/single_use/med_pouch/overdose = 1,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/healthanalyzer = 3,
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3,
	)
	req_log_access = ACCESS_MEDICAL_CMO
	has_logs = 1

/obj/machinery/vending/blood
	name = "Blood-Onator"
	desc = "Freezer-vendor for storage and quick dispensing of blood packs"
	product_ads = "The true life juice!;Vampire's choice!;Home-grown blood only!;Donate today, be saved tomorrow!;Approved by Zeng-Hu Pharmaceuticals Incorporated!; Curse you, Vey-Med artificial blood!"
	icon_state = "blood"
	idle_power_usage = 211
	req_access = list(ACCESS_MEDICAL_MAIN)
	products = list(
		/obj/item/reagent_containers/blood/prelabeled/APlus = 3,
		/obj/item/reagent_containers/blood/prelabeled/AMinus = 3,
		/obj/item/reagent_containers/blood/prelabeled/BPlus = 3,
		/obj/item/reagent_containers/blood/prelabeled/BMinus = 3,
		/obj/item/reagent_containers/blood/prelabeled/ABPlus = 2,
		/obj/item/reagent_containers/blood/prelabeled/ABMinus = 1,
		/obj/item/reagent_containers/blood/prelabeled/OPlus = 2,
		/obj/item/reagent_containers/blood/prelabeled/OMinus = 5,
		/obj/item/reagent_containers/blood/empty = 5,
		/obj/item/reagent_containers/food/drinks/bludboxmax = 5,
		/obj/item/reagent_containers/food/drinks/bludboxmaxlight = 5,
	)
	contraband = list(
		/obj/item/reagent_containers/glass/bottle/stoxin = 2,
	)
	req_log_access = ACCESS_MEDICAL_CMO
	has_logs = 1

