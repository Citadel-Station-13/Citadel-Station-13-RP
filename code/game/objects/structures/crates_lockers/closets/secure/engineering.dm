<<<<<<< HEAD
/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		new /obj/item/clothing/accessory/storage/brown_vest(src)
		new /obj/item/blueprints(src)
		new /obj/item/clothing/under/rank/chief_engineer(src)
		new /obj/item/clothing/under/rank/chief_engineer/skirt(src)
		new /obj/item/clothing/head/hardhat/white(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/weapon/cartridge/ce(src)
		new /obj/item/device/radio/headset/heads/ce(src)
		new /obj/item/device/radio/headset/heads/ce/alt(src)
		new /obj/item/weapon/storage/toolbox/mechanical(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/device/multitool(src)
		new /obj/item/weapon/storage/belt/utility/chief/full(src)
		new /obj/item/device/flash(src)
		new /obj/item/device/t_scanner/upgraded
		new /obj/item/taperoll/engineering(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering(src)
		new /obj/item/clothing/shoes/boots/winter/engineering(src)
		new /obj/item/weapon/tank/emergency/oxygen/engi(src)
		new /obj/item/weapon/reagent_containers/spray/windowsealant(src) //vorestation addition
		return



/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"


	New()
		..()
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/clothing/gloves/yellow(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/storage/toolbox/electrical(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/weapon/module/power_control(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/multitool(src)
		new /obj/item/device/multitool(src)
		return



/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"


	New()
		..()
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/clothing/glasses/welding(src)
		new /obj/item/clothing/glasses/welding(src)
		return



/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		new /obj/item/clothing/accessory/storage/brown_vest(src)
		new /obj/item/weapon/storage/toolbox/mechanical(src)
		new /obj/item/device/radio/headset/headset_eng(src)
		new /obj/item/device/radio/headset/headset_eng/alt(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/clothing/glasses/meson(src)
		new /obj/item/weapon/cartridge/engineering(src)
		new /obj/item/taperoll/engineering(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering(src)
		new /obj/item/clothing/shoes/boots/winter/engineering(src)
		new /obj/item/weapon/tank/emergency/oxygen/engi(src)
		new /obj/item/weapon/reagent_containers/spray/windowsealant(src) //vorestation addition
		return



/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	req_access = list(access_atmospherics)
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"


	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/industrial(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/eng(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/eng(src)
		new /obj/item/clothing/accessory/storage/brown_vest(src)
		new /obj/item/clothing/suit/fire/firefighter(src)
		new /obj/item/device/flashlight(src)
		new /obj/item/weapon/extinguisher(src)
		new /obj/item/device/radio/headset/headset_eng(src)
		new /obj/item/device/radio/headset/headset_eng/alt(src)
		new /obj/item/clothing/suit/storage/hazardvest(src)
		new /obj/item/clothing/mask/gas(src)
		new /obj/item/weapon/cartridge/atmos(src)
		new /obj/item/taperoll/atmos(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos(src)
		new /obj/item/clothing/shoes/boots/winter/atmos(src)
		new /obj/item/weapon/tank/emergency/oxygen/engi(src)
		return
=======
/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"
	req_access = list(access_ce)

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/blueprints,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/under/rank/chief_engineer/skirt,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/shoes/brown,
		/obj/item/weapon/cartridge/ce,
		/obj/item/device/radio/headset/heads/ce,
		/obj/item/device/radio/headset/heads/ce/alt,
		/obj/item/weapon/storage/toolbox/mechanical,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/device/multitool,
		/obj/item/weapon/storage/belt/utility/chief/full,
		/obj/item/device/flash,
		/obj/item/device/t_scanner/upgraded,
		/obj/item/taperoll/engineering,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/shoes/boots/winter/engineering,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/reagent_containers/spray/windowsealant) //VOREStation Add

/obj/structure/closet/secure_closet/engineering_chief/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/industrial
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/eng
	return ..()

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"
	req_access = list(access_engine_equip)

	starts_with = list(
		/obj/item/clothing/gloves/yellow = 2,
		/obj/item/weapon/storage/toolbox/electrical = 3,
		/obj/item/weapon/module/power_control = 3,
		/obj/item/device/multitool = 3)


/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"
	req_access = list(access_construction)

	starts_with = list(
		/obj/item/clothing/head/welding = 3,
		/obj/item/weapon/weldingtool/largetank = 3,
		/obj/item/weapon/weldpack = 3,
		/obj/item/clothing/glasses/welding = 3)

/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"
	req_access = list(access_engine_equip)

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/weapon/storage/toolbox/mechanical,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/weapon/cartridge/engineering,
		/obj/item/taperoll/engineering,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/shoes/boots/winter/engineering,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/reagent_containers/spray/windowsealant) //VOREStation Add

/obj/structure/closet/secure_closet/engineering_personal/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/industrial
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/eng
	return ..()


/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"
	req_access = list(access_atmospherics)

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/device/flashlight,
		/obj/item/weapon/extinguisher,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/cartridge/atmos,
		/obj/item/taperoll/atmos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos,
		/obj/item/clothing/shoes/boots/winter/atmos,
		/obj/item/weapon/tank/emergency/oxygen/engi)

/obj/structure/closet/secure_closet/atmos_personal/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/industrial
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/eng
	return ..()
>>>>>>> 787102a... Merge pull request #3776 from VOREStation/aro-sync-05-27-2018
