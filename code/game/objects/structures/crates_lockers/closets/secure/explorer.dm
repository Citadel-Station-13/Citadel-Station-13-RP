//SC Exploration Secure Closets Port
/obj/structure/closet/secure_closet/explorer
	name = "explorer locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/expedition
	req_access = list(ACCESS_GENERAL_EXPLORER)

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/gun/energy/frontier/locked/holdout,
		/obj/item/radio/headset/explorer,
		/obj/item/clothing/accessory/armor/helmetcamera/exploration/body,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/storage/box/flare,
		/obj/item/geiger_counter,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/storage/box/survival_knife,
		/obj/item/material/knife/machete,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/reagent_containers/food/snacks/liquid,
		/obj/item/reagent_containers/food/snacks/liquid/protein,
		/obj/item/cataloguer)

/obj/structure/closet/secure_closet/explorer/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()

//SC Misc_vr locker.
/obj/structure/closet/secure_closet/sar
	name = "field medic locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/expedition/medic
	starts_with = list(
		/obj/item/storage/backpack/dufflebag/emt,
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/clothing/accessory/armor/helmetcamera/exploration/body,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/antitoxin,
		/obj/item/storage/belt/medical/emt,
		/obj/item/storage/box/survival_knife,
		/obj/item/gun/energy/frontier/locked/holdout,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer/medic,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/radio/headset/sar,
		/obj/item/cartridge/medical,
		/obj/item/material/knife/machete,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/healthanalyzer,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/reagent_containers/food/snacks/liquid = 2,
		/obj/item/reagent_containers/food/snacks/liquid/protein = 2,
		/obj/item/tool/crowbar,
		/obj/item/extinguisher/mini,
		/obj/item/storage/box/freezer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/barrier_tape_roll/medical,
		/obj/item/gps/medical,
		/obj/item/geiger_counter,
		/obj/item/bodybag/cryobag,
		/obj/item/cataloguer/compact)

//Pilot Locker
/obj/structure/closet/secure_closet/pilot
	name = "pilot locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/expedition
	req_access = list(ACCESS_GENERAL_PILOT)

/obj/structure/closet/secure_closet/pilot
	starts_with = list(
		/obj/item/storage/backpack/parachute,
		/obj/item/storage/box/survival_knife,
		/obj/item/gun/energy/frontier/locked/holdout,
		/obj/item/clothing/head/pilot,
		/obj/item/clothing/accessory/armor/helmetcamera/exploration,
		/obj/item/clothing/accessory/armor/helmetcamera/exploration/body,
		/obj/item/clothing/under/rank/pilot1,
		/obj/item/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/radio/headset/pilot/alt,
		/obj/item/flashlight,
		/obj/item/reagent_containers/food/snacks/liquid,
		/obj/item/reagent_containers/food/snacks/liquid/protein,
		/obj/item/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/storage/box/flare,
		/obj/item/gun/ballistic/shotgun/flare/explo,
		/obj/item/storage/box/flashshells,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/gps/explorer,
		/obj/item/cataloguer/compact)

/obj/structure/closet/secure_closet/pilot/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()

//Pathfinder
/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/expedition/pathfinder
	req_access = list(ACCESS_GENERAL_GATEWAY)

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/radio/headset/pathfinder,
		/obj/item/radio/headset/pathfinder/alt,
		/obj/item/clothing/accessory/armor/helmetcamera/exploration,
		/obj/item/clothing/accessory/armor/helmetcamera/exploration/body,
		/obj/item/flashlight,
		/obj/item/gps/explorer,
		/obj/item/storage/belt/explorer,
		/obj/item/storage/box/flare,
		/obj/item/storage/box/explorerkeys,
		/obj/item/geiger_counter,
		/obj/item/cell/device,
		/obj/item/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/storage/box/survival_knife,
		/obj/item/material/knife/machete/deluxe,
		/obj/item/gun/energy/frontier/locked/carbine,
		/obj/item/gun/ballistic/ntles/pathfinder,
		/obj/item/ammo_magazine/m57x28mm/ntles,
		/obj/item/ammo_magazine/m57x28mm/ntles,
		/obj/item/clothing/accessory/holster/machete,
		/obj/item/clothing/accessory/holster/leg,
		/obj/item/reagent_containers/food/snacks/liquid,
		/obj/item/reagent_containers/food/snacks/liquid/protein,
		/obj/item/card/mining_point_card/survey/gimmick,
		/obj/item/cataloguer/compact/pathfinder)

/obj/structure/closet/secure_closet/pathfinder/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack
	else
		starts_with += /obj/item/storage/backpack/satchel/norm
	return ..()
