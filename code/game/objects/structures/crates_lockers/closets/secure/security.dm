/obj/structure/closet/secure_closet/captains
	name = "Facility Director's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/command
	req_access = list(ACCESS_COMMAND_CAPTAIN)

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/captain,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/suit/storage/vest/capcarapace,
		/obj/item/cartridge/captain,
		/obj/item/storage/lockbox/medal,
		/obj/item/radio/headset/heads/captain,
		/obj/item/radio/headset/heads/captain/alt,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/clothing/accessory/holster/leg,
		/obj/item/melee/telebaton,
		/obj/item/flash,
		/obj/item/gps/command,
		/obj/item/storage/belt/sheath,
		/obj/item/melee/baton/loaded/mini,
		/obj/item/storage/box/ids)

/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/command/hop
	req_access = list(ACCESS_COMMAND_HOP)

	starts_with = list(
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/hop,
		/obj/item/radio/headset/heads/hop,
		/obj/item/radio/headset/heads/hop/alt,
		/obj/item/storage/box/ids = 2,
		/obj/item/gps/command,
		/obj/item/gun/energy/gun,
		/obj/item/storage/box/commandkeys,
		/obj/item/storage/box/servicekeys,
		/obj/item/melee/baton/loaded/mini,
		/obj/item/flash)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	closet_appearance = /singleton/closet_appearance/secure_closet/command/hop
	req_access = list(ACCESS_COMMAND_HOP)

	starts_with = list(
		/obj/item/clothing/under/rank/head_of_personnel,
		/obj/item/clothing/under/rank/head_of_personnel/skirt_pleated,
		/obj/item/clothing/under/dress/dress_hop,
		/obj/item/clothing/under/dress/dress_hr,
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/black/skirt,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/red/skirt,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/head_of_personnel_whimsy,
		/obj/item/clothing/head/caphat/hop,
		/obj/item/clothing/suit/storage/hooded/wintercoat/captain/hop,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
		/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit/skirt,
		/obj/item/clothing/glasses/sunglasses)

/*
/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(ACCESS_SECURITY_HOS)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"
	req_access = list(ACCESS_SECURITY_HOS)
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/under/bodysuit/bodysuitseccom,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/cartridge/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/heads/hos/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/shield/riot,
		/obj/item/shield/riot/tele,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/storage/box/firingpins,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/tool/crowbar/red,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/magnetic/railgun/heater/pistol/hos,
		/obj/item/cell/device/weapon,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/melee/telebaton,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security/hos,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/gps/security/hos,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/mask/gas/half)

/obj/structure/closet/secure_closet/hos/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()
*/

//_vr file contents:
/obj/structure/closet/secure_closet/hos
	name = "head of security's attire"
	closet_appearance = /singleton/closet_appearance/secure_closet/security/hos
	req_access = list(ACCESS_SECURITY_HOS)
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/head/helmet/HoS/hat,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/accessory/poncho/roles/cloak/hos,
		/obj/item/clothing/under/rank/head_of_security/jensen,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/under/rank/head_of_security/skirt_pleated,
		/obj/item/clothing/under/rank/head_of_security/skirt_pleated/alt,
		/obj/item/clothing/under/rank/head_of_security/turtleneck,
		/obj/item/clothing/under/oricon/mildress/marine/command,
		/obj/item/clothing/suit/storage/vest/hoscoat/jensen,
		/obj/item/clothing/suit/storage/vest/hoscoat/combatcoat,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/suit/storage/vest/hos_overcoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/clothing/suit/dress/marine/command/hos,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/under/bodysuit/bodysuitseccom)

/obj/structure/closet/secure_closet/hos2
	name = "head of security's gear"
	closet_appearance = /singleton/closet_appearance/secure_closet/security/hos
	req_access = list(ACCESS_SECURITY_HOS)
	storage_capacity = 2.5 * MOB_MEDIUM

	// citadel edit NSFW > Multiphase
	starts_with = list(
		/obj/item/cartridge/hos,
		/obj/item/storage/belt/security,
		/obj/item/radio/headset/heads/hos,
		/obj/item/radio/headset/heads/hos/alt,
		/obj/item/shield/riot/tele,
		/obj/item/storage/box/holobadge/hos,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/tool/crowbar/red,
		/obj/item/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun/multiphase,
		/obj/item/melee/telebaton,
		/obj/item/storage/box/survival_knife,
		/obj/item/gps/security/hos,
		/obj/item/flashlight/maglight,
		/obj/item/storage/box/flashbangs,
		/obj/item/barrier_tape_roll/police,
		/obj/item/megaphone,
		/obj/item/holowarrant)

/obj/structure/closet/secure_closet/blueshield
	name = "blueshield's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/blueshield
	req_access = list(ACCESS_COMMAND_BLUESHIELD)
	storage_capacity = 2.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/disk/nifsoft/blueshield,
		/obj/item/radio/headset/heads/blueshield,
		/obj/item/radio/headset/heads/blueshield/alt,
		/obj/item/clothing/glasses/sunglasses/medhud,
		/obj/item/clothing/head/beret/sec/corporate/blueshield,
		/obj/item/clothing/under/oricon/utility/sysguard/crew/blueshield,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/suit/armor/pcarrier/light/ntbs,
		/obj/item/gunbox/carrier/blueshield,
		/obj/item/storage/backpack/blueshield,
		/obj/item/storage/belt/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/flash,
		/obj/item/gun/ballistic/revolver/consul,
		/obj/item/ammo_magazine/s44,
		/obj/item/ammo_magazine/s44,
		/obj/item/ammo_magazine/s44,
		/obj/item/ammo_magazine/s44,
		/obj/item/ammo_magazine/s44/rubber,
		/obj/item/ammo_magazine/s44/rubber,
		/obj/item/ammo_magazine/s44/rubber,
		/obj/item/ammo_magazine/s44/empty,
		/obj/item/melee/telebaton,

		/obj/item/gps/command/blueshield,
		/obj/item/tank/oxygen,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/accessory/badge/holo,
		/obj/item/clothing/accessory/badge/holo/cord,
		/obj/item/tool/crowbar/red,
		/obj/item/flashlight/maglight,
		/obj/item/cartridge/security)

/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/security/warden
	req_access = list(ACCESS_SECURITY_ARMORY)

	starts_with = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/under/rank/warden/skirt_pleated,
		/obj/item/clothing/suit/storage/vest/wardencoat,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/clothing/head/helmet/warden/hat,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/clothing/accessory/badge/holo/warden,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/firingpins,
		/obj/item/storage/belt/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/cell/device/weapon,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/gps/security,
		/obj/item/flashlight/maglight,
		/obj/item/megaphone,
		/obj/item/clothing/mask/gas/half,
		/obj/item/gun/ballistic/shotgun/pump/combat/warden,
		/obj/item/holowarrant)

/obj/structure/closet/secure_closet/warden/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/security
	req_access = list(ACCESS_SECURITY_BRIG)

	starts_with = list(
		/obj/item/modular_computer/tablet/preset/custom_loadout/standard/security,
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
		/obj/item/flashlight/glowstick,
		/obj/item/clothing/suit/armor/vest/alt,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/gun/energy/secutor,
		/obj/item/cell/device/weapon,
		/obj/item/gps/security,
		/obj/item/holowarrant,
		/obj/item/clothing/under/bodysuit/bodysuitsec,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security,
		/obj/item/clothing/shoes/boots/winter/security,
		/obj/item/flashlight/maglight,
		/obj/item/holowarrant)

/obj/structure/closet/secure_closet/security/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	if(prob(30))
		starts_with += /obj/item/contraband/poster/nanotrasen
	return ..()

/obj/structure/closet/secure_closet/security/cargo/Initialize(mapload)
	starts_with += /obj/item/clothing/accessory/armband/cargo
	starts_with += /obj/item/encryptionkey/headset_cargo
	return ..()

/obj/structure/closet/secure_closet/security/engine/Initialize(mapload)
	starts_with += /obj/item/clothing/accessory/armband/engine
	starts_with += /obj/item/encryptionkey/headset_eng
	return ..()

/obj/structure/closet/secure_closet/security/science/Initialize(mapload)
	starts_with += /obj/item/clothing/accessory/armband/science
	starts_with += /obj/item/encryptionkey/headset_sci
	return ..()

/obj/structure/closet/secure_closet/security/med/Initialize(mapload)
	starts_with += /obj/item/clothing/accessory/armband/medblue
	starts_with += /obj/item/encryptionkey/headset_med
	return ..()


/obj/structure/closet/secure_closet/detective
	name = "detective's cabinet"
	closet_appearance = /singleton/closet_appearance/cabinet/secure
	req_access = list(ACCESS_SECURITY_FORENSICS)

	starts_with = list(
		/obj/item/clothing/accessory/badge/holo/detective,
		/obj/item/clothing/gloves/forensic,
		/obj/item/gun/ballistic/revolver/detective45,
		/obj/item/ammo_magazine/s45/rubber,
		/obj/item/ammo_magazine/s45/rubber,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/storage/belt/detective,
		/obj/item/storage/box/evidence,
		/obj/item/radio/headset/headset_sec,
		/obj/item/radio/headset/headset_sec/alt,
		/obj/item/clothing/suit/storage/vest/,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/barrier_tape_roll/police,
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/flashlight/maglight,
		/obj/item/reagent_containers/food/drinks/flask/detflask,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/tape_recorder,
		/obj/item/camera,
		/obj/item/camera_film = 2,
		/obj/item/storage/bag/detective,
		/obj/item/cassette_tape/random = 3)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(ACCESS_COMMAND_CAPTAIN)

	starts_with = list(
		/obj/item/reagent_containers/syringe/ld50_syringe/choral = 2)

GLOBAL_LIST_BOILERPLATE(all_brig_closets, /obj/structure/closet/secure_closet/brig)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(ACCESS_SECURITY_BRIG)
	anchored = 1
	var/id = null

	starts_with = list(
		/obj/item/clothing/under/color/prison,
		/obj/item/clothing/shoes/orange)

/obj/structure/closet/secure_closet/posters
	name = "morale storage"
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	anchored = 1

	starts_with = list(
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen,
		/obj/item/contraband/poster/nanotrasen)

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(ACCESS_COMMAND_IAA)

	starts_with = list(
		/obj/item/clothing/shoes/brown,
		/obj/item/paper/Court = 3,
		/obj/item/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/storage/briefcase)


/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	closet_appearance = /singleton/closet_appearance/wall/secure
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	density = 1

//Custom NT Security Lockers, Only found at central command
/obj/structure/closet/secure_closet/nanotrasen_security
	name = "NanoTrasen security officer's locker"
	icon = 'icons/obj/closet.dmi'
	closet_appearance = /singleton/closet_appearance/secure_closet/sol
	req_access = list(ACCESS_SECURITY_BRIG)
	storage_capacity = 3.5 * MOB_MEDIUM

	starts_with = list(
		/obj/item/clothing/under/bodysuit/bodysuitsecweewoo,
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
		/obj/item/gun/energy/secutor,
		/obj/item/cell/device/weapon,
		/obj/item/flashlight/maglight,
		/obj/item/clothing/head/soft/nanotrasen,
		/obj/item/clothing/head/beret/nanotrasen,
		/obj/item/clothing/under/nanotrasen/security,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless)

/obj/structure/closet/secure_closet/nanotrasen_security/Initialize(mapload)
	if(prob(25))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(75))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/nanotrasen_commander
	name = "NanoTrasen commander's locker"
	icon = 'icons/obj/closet.dmi'
	closet_appearance = /singleton/closet_appearance/secure_closet/sol/two/dark
	req_access = list(ACCESS_SECURITY_BRIG)
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

/obj/structure/closet/secure_closet/nanotrasen_commander/Initialize(mapload)
	if(prob(25))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(75))
		starts_with += /obj/item/storage/backpack/dufflebag/sec
	return ..()

/obj/structure/closet/secure_closet/nanotrasen_warden
	name = "NanoTrasen warden's locker"
	icon = 'icons/obj/closet.dmi'
	closet_appearance = /singleton/closet_appearance/secure_closet/sol/two
	req_access = list(ACCESS_SECURITY_BRIG)
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

/obj/structure/closet/secure_closet/nanotrasen_warden/Initialize(mapload)
	if(prob(25))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	if(prob(75))
		new /obj/item/storage/backpack/dufflebag/sec(src)
	return ..()
