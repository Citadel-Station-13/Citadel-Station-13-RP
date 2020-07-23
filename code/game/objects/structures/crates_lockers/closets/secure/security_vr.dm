/obj/structure/closet/secure_closet/hos
	name = "head of security's attire"
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	req_access = list(access_hos)
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/under/bodysuit/bodysuitseccom,
		/obj/item/clothing/under/solgov/mildress/marine/command,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/suit/dress/marine/command/hos,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/storage/belt/security,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/mask/gas/half)

/obj/structure/closet/secure_closet/hos2
	name = "head of security's gear"
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	req_access = list(access_hos)
	storage_capacity = 2.5 * MOB_MEDIUM

	// citadel edit NSFW > Multiphase
	starts_with = list(
		/obj/item/cartridge/hos,
		/obj/item/barrier_tape_roll/police,
		/obj/item/shield/riot/tele,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/tool/crowbar/red,
		/obj/item/storage/box/flashbangs,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun/multiphase,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/gps/security/hos,
		/obj/item/flashlight/maglight)

//Custom NT Security Lockers, Only found at central command
/obj/structure/closet/secure_closet/nanotrasen_security
	name = "NanoTrasen security officer's locker"
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secC1"
	icon_closed = "secC"
	icon_locked = "secC1"
	icon_opened = "secCopen"
	icon_broken = "secCbroken"
	icon_off = "seCcoff"
	req_access = list(access_brig)
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/nanotrasen,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/grenade/flashbang,
		/obj/item/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/hailer,
		/obj/item/flashlight/flare,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/gun/energy/taser,
		/obj/item/cell/device/weapon,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/head/soft/nanotrasen,
		/obj/item/clothing/head/beret/nanotrasen,
		/obj/item/clothing/under/nanotrasen/security,
		/obj/item/clothing/under/bodysuit/bodysuitsecweewoo,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless)

/obj/structure/closet/secure_closet/nanotrasen_security/Initialize()
	if(prob(25))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(75))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/nanotrasen_commander
	name = "NanoTrasen commander's locker"
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secC1"
	icon_closed = "secC"
	icon_locked = "secC1"
	icon_opened = "secCopen"
	icon_broken = "secCbroken"
	icon_off = "seCcoff"
	req_access = list(access_brig)
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/cartridge/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/shield/riot,
		/obj/item/shield/riot/tele,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/tool/crowbar/red,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless,
		/obj/item/clothing/under/nanotrasen/security/commander)

/obj/structure/closet/secure_closet/nanotrasen_commander/Initialize()
	if(prob(25))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(75))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/nanotrasen_warden
	name = "NanoTrasen warden's locker"
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secC1"
	icon_closed = "secC"
	icon_locked = "secC1"
	icon_opened = "secCopen"
	icon_broken = "secCbroken"
	icon_off = "seCcoff"
	req_access = list(access_brig)
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/nanotrasen/security/warden,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/clothing/accessory/badge/holo/warden,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/device/weapon,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/flashlight/maglight,
		/obj/item/megaphone,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless)

/obj/structure/closet/secure_closet/nanotrasen_warden/Initialize()
	if(prob(25))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	if(prob(75))
		new /obj/item/storage/backpack/dufflebag/sec(src)
	return ..()
