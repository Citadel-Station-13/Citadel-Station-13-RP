/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/ce
	req_access = list(ACCESS_ENGINEERING_CE)

	starts_with = list(
		/obj/item/clothing/shoes/magboots/advanced,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/blueprints,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/under/rank/chief_engineer/skirt,
		/obj/item/clothing/under/rank/chief_engineer/skirt_pleated,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/shoes/brown,
		/obj/item/cartridge/ce,
		/obj/item/radio/headset/heads/ce,
		/obj/item/radio/headset/heads/ce/alt,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/multitool,
		/obj/item/storage/belt/utility/chief/full,
		/obj/item/flash,
		/obj/item/t_scanner/upgraded,
		/obj/item/barrier_tape_roll/engineering,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce,
		/obj/item/clothing/shoes/boots/winter/engineering,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/gps/engineering/ce,
		/obj/item/reagent_containers/spray/windowsealant,
		/obj/item/pipe_dispenser,
		/obj/item/shield_diffuser,
		/obj/item/switchtool/holo/CE,
		/obj/item/clothing/accessory/poncho/roles/cloak/ce,
		)

/obj/structure/closet/secure_closet/engineering_chief/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/eng
	return ..()

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/electrical
	req_access = list(ACCESS_ENGINEERING_ENGINE)

	starts_with = list(
		/obj/item/clothing/gloves/yellow = 2,
		/obj/item/storage/toolbox/electrical = 3,
		/obj/item/module/power_control = 3,
		/obj/item/multitool = 3,
		/obj/item/inducer = 1,
		/obj/item/lightreplacer = 1)


/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/welding
	req_access = list(ACCESS_ENGINEERING_CONSTRUCTION)

	starts_with = list(
		/obj/item/clothing/head/welding = 3,
		/obj/item/weldingtool/largetank = 3,
		/obj/item/weldpack = 3,
		/obj/item/clothing/glasses/welding = 3)

/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering
	req_access = list(ACCESS_ENGINEERING_ENGINE)

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/radio/headset/headset_eng,
		/obj/item/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/under/bodysuit/bodysuithazard,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/cartridge/engineering,
		/obj/item/barrier_tape_roll/engineering,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/shoes/boots/winter/engineering,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/gps/engineering,
		/obj/item/reagent_containers/spray/windowsealant,
		/obj/item/shield_diffuser,
		)

/obj/structure/closet/secure_closet/engineering_personal/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/eng
	return ..()


/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/atmos
	req_access = list(ACCESS_ENGINEERING_ATMOS)

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/flashlight,
		/obj/item/extinguisher,
		/obj/item/radio/headset/headset_eng,
		/obj/item/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/cartridge/atmos,
		/obj/item/barrier_tape_roll/atmos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos,
		/obj/item/clothing/shoes/boots/winter/atmos,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/gps/engineering/atmos,
		/obj/item/pipe_dispenser,
		/obj/item/shield_diffuser,
		)

/obj/structure/closet/secure_closet/atmos_personal/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/eng
	return ..()

/obj/structure/closet/secure_closet/senior_engineer
	name = "Senior engineer's locker"
	desc = "It looks like it has been stuffed to the brim with Space OSHA violation notices."
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/senior
	req_access = list(ACCESS_ENGINEERING_ENGINE)

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/radio/headset/headset_eng,
		/obj/item/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/under/bodysuit/bodysuithazard,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/cartridge/engineering,
		/obj/item/barrier_tape_roll/engineering,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/shoes/boots/winter/engineering,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/gps/engineering,
		/obj/item/reagent_containers/spray/windowsealant,
		/obj/item/shield_diffuser,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/flashlight,
		/obj/item/extinguisher,
		/obj/item/cartridge/atmos,
		/obj/item/barrier_tape_roll/atmos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos,
		/obj/item/clothing/shoes/boots/winter/atmos,
		/obj/item/gps/engineering/atmos,
		/obj/item/pipe_dispenser,
		)
