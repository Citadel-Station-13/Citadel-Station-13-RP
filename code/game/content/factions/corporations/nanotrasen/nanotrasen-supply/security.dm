/*
*	Here is where any supply packs
*	related to security tasks live
*/


/datum/supply_pack/nanotrasen/security
	abstract_type = /datum/supply_pack/nanotrasen/security
	category = "Security"
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_access = list(
		/datum/access/station/security/equipment,
	)
	supply_pack_flags = SUPPLY_PACK_LOCK_PRIVATE_ORDERS

/datum/supply_pack/nanotrasen/security/weapons
	name = "Weapons - Security basic equipment"
	contains = list(
		/obj/item/flash = 2,
		/obj/item/reagent_containers/spray/pepper = 2,
		/obj/item/melee/baton/loaded = 2,
		/obj/item/gun/projectile/energy/taser = 2,
		/obj/item/gunbox = 2,
		/obj/item/storage/box/flashbangs = 2,
	)
	worth = 400
	container_name = "Security equipment crate"

/datum/supply_pack/nanotrasen/security/armor
	name = "Armor - Security armor"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/clothing/suit/storage/vest,
		/obj/item/clothing/suit/storage/vest/officer,
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/clothing/suit/storage/vest/heavy,
		/obj/item/clothing/suit/storage/vest/heavy/officer,
		/obj/item/clothing/suit/storage/vest/heavy/warden,
		/obj/item/clothing/suit/storage/vest/heavy/hos,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor crate"

/datum/supply_pack/nanotrasen/security/carriers
	name = "Armor - Plate carriers"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/clothing/suit/armor/pcarrier,
		/obj/item/clothing/suit/armor/pcarrier/alt,
		/obj/item/clothing/suit/armor/pcarrier/blue,
		/obj/item/clothing/suit/armor/pcarrier/green,
		/obj/item/clothing/suit/armor/pcarrier/navy,
		/obj/item/clothing/suit/armor/pcarrier/tan,
		/obj/item/clothing/suit/armor/pcarrier/press,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Plate Carrier crate"

/datum/supply_pack/nanotrasen/security/carriertags
	name = "Armor - Plate carrier tags"
	// todo: just do fucking holotags WHY ARE WE SPAMMING THESE??
	contains = list(
		/obj/item/clothing/accessory/armor/tag,
		/obj/item/clothing/accessory/armor/tag/nts,
		/obj/item/clothing/accessory/armor/tag/ntc,
		/obj/item/clothing/accessory/armor/tag/opos,
		/obj/item/clothing/accessory/armor/tag/oneg,
		/obj/item/clothing/accessory/armor/tag/apos,
		/obj/item/clothing/accessory/armor/tag/aneg,
		/obj/item/clothing/accessory/armor/tag/bpos,
		/obj/item/clothing/accessory/armor/tag/bneg,
		/obj/item/clothing/accessory/armor/tag/abpos,
		/obj/item/clothing/accessory/armor/tag/abneg,
	)
	worth = 100
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Plate Carrier crate"

/datum/supply_pack/nanotrasen/security/helmcovers
	name = "Armor - Helmet covers"
	// todo: just do fucking holocovers WHY ARE WE SPAMMING THESE??
	contains = list(
		/obj/item/clothing/accessory/armor/helmcover/blue = 2,
		/obj/item/clothing/accessory/armor/helmcover/navy = 2,
		/obj/item/clothing/accessory/armor/helmcover/green = 2,
		/obj/item/clothing/accessory/armor/helmcover/tan = 2,
	)
	worth = 100
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Helmet Covers crate"

/datum/supply_pack/nanotrasen/security/armorplates
	name = "Armor - Security p-carrier armor plates"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/clothing/accessory/armor/armorplate = 2,
		/obj/item/clothing/accessory/armor/armorplate/stab = 2,
		/obj/item/clothing/accessory/armor/armorplate/medium = 2,
		/obj/item/clothing/accessory/armor/armorplate/tactical,
		/obj/item/clothing/accessory/armor/armorplate/ablative,
		/obj/item/clothing/accessory/armor/armorplate/riot,
		/obj/item/clothing/accessory/armor/armorplate/ballistic,
	)
	worth = 1000
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"

/datum/supply_pack/nanotrasen/security/carrierarms
	name = "Armor - Security armguard attachments"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/clothing/accessory/armor/armguards,
		/obj/item/clothing/accessory/armor/armguards/blue,
		/obj/item/clothing/accessory/armor/armguards/navy,
		/obj/item/clothing/accessory/armor/armguards/green,
		/obj/item/clothing/accessory/armor/armguards/tan,
		/obj/item/clothing/accessory/armor/armguards/ablative,
		/obj/item/clothing/accessory/armor/armguards/riot,
		/obj/item/clothing/accessory/armor/armguards/ballistic,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"

/datum/supply_pack/nanotrasen/security/carrierlegs
	name = "Armor - Security legguard attachments"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/clothing/accessory/armor/legguards,
		/obj/item/clothing/accessory/armor/legguards/blue,
		/obj/item/clothing/accessory/armor/legguards/navy,
		/obj/item/clothing/accessory/armor/legguards/green,
		/obj/item/clothing/accessory/armor/legguards/tan,
		/obj/item/clothing/accessory/armor/legguards/ablative,
		/obj/item/clothing/accessory/armor/legguards/riot,
		/obj/item/clothing/accessory/armor/legguards/ballistic,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"

/datum/supply_pack/nanotrasen/security/carrierbags
	name = "Armor - Security p-carrier pouch attachments"
	lazy_gacha_amount = 5
	lazy_gacha_contained = list(
		/obj/item/clothing/accessory/storage/pouches,
		/obj/item/clothing/accessory/storage/pouches/blue,
		/obj/item/clothing/accessory/storage/pouches/navy,
		/obj/item/clothing/accessory/storage/pouches/green,
		/obj/item/clothing/accessory/storage/pouches/tan,
		/obj/item/clothing/accessory/storage/pouches/large,
		/obj/item/clothing/accessory/storage/pouches/large/blue,
		/obj/item/clothing/accessory/storage/pouches/large/navy,
		/obj/item/clothing/accessory/storage/pouches/large/green,
		/obj/item/clothing/accessory/storage/pouches/large/tan,
	)
	worth = 500
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"

/datum/supply_pack/nanotrasen/security/armory
	abstract_type = /datum/supply_pack/nanotrasen/security/armory
	container_access = list(
		/datum/access/station/security/armory,
	)

/datum/supply_pack/nanotrasen/security/armory/riot_gear
	name = "Gear - Riot"
	contains = list(
		/obj/item/melee/baton = 3,
		/obj/item/shield/riot = 3,
		/obj/item/handcuffs = 3,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/box/beanbags,
		/obj/item/storage/box/handcuffs,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Riot gear crate"

/datum/supply_pack/nanotrasen/security/armory/riot_armor
	name = "Armor Set - Riot"
	contains = list(
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/gloves/arm_guard/riot,
		/obj/item/clothing/shoes/leg_guard/riot,
	)
	worth = 650 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Riot armor crate"

/datum/supply_pack/nanotrasen/security/armory/riot_plates
	name = "Armor Set - Riot (P-Carrier)"
	contains = list(
		/obj/item/clothing/head/helmet/riot,
		/obj/item/clothing/suit/armor/pcarrier/riot,
		/obj/item/clothing/accessory/armor/armguards/riot,
		/obj/item/clothing/accessory/armor/legguards/riot,
	)
	worth = 650 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Riot armor crate"

/datum/supply_pack/nanotrasen/security/armory/ablative_armor
	name = "Armor Set - Ablative"
	contains = list(
		/obj/item/clothing/head/helmet/ablative,
		/obj/item/clothing/suit/armor/laserproof,
		/obj/item/clothing/gloves/arm_guard/laserproof,
		/obj/item/clothing/shoes/leg_guard/laserproof,
	)
	worth = 750 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ablative armor crate"

/datum/supply_pack/nanotrasen/security/armory/ablative_plates
	name = "Armor Set - Ablative (P-Carrier)"
	contains = list(
		/obj/item/clothing/head/helmet/ablative,
		/obj/item/clothing/suit/armor/pcarrier/ablative,
		/obj/item/clothing/accessory/armor/armguards/ablative,
		/obj/item/clothing/accessory/armor/legguards/ablative,
	)
	worth = 750 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ablative armor crate"

/datum/supply_pack/nanotrasen/security/armory/bullet_resistant_armor
	name = "Armor Set - Ballistic"
	contains = list(
		/obj/item/clothing/head/helmet/ballistic,
		/obj/item/clothing/suit/armor/bulletproof,
		/obj/item/clothing/gloves/arm_guard/bulletproof,
		/obj/item/clothing/shoes/leg_guard/bulletproof,
	)
	worth = 750 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ballistic armor crate"

/datum/supply_pack/nanotrasen/security/armory/bullet_resistant_plates
	name = "Armor Set - Ballistic (P-Carrier)"
	contains = list(
		/obj/item/clothing/head/helmet/ballistic,
		/obj/item/clothing/suit/armor/pcarrier/ballistic,
		/obj/item/clothing/accessory/armor/armguards/ballistic,
		/obj/item/clothing/accessory/armor/legguards/ballistic,
	)
	worth = 750 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ballistic armor crate"

/datum/supply_pack/nanotrasen/security/armory/combat_armor
	name = "Armor - Combat"
	contains = list(
		/obj/item/clothing/head/helmet/combat,
		/obj/item/clothing/suit/armor/combat,
		/obj/item/clothing/gloves/arm_guard/combat,
		/obj/item/clothing/shoes/leg_guard/combat,
	)
	worth = 750 // lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Combat armor crate"

/datum/supply_pack/nanotrasen/security/armory/tactical
	name = "Armor - NT Tactical"
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "NT Tactical armor crate"
	worth = 850 // the milrp tax is real

	contains = list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/suit/armor/tactical,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical,
		/obj/item/storage/belt/security/tactical,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/gloves/black,
	)

/datum/supply_pack/nanotrasen/security/armory/flexitac
	name = "Armor - Tactical Light"
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Tactical Light armor crate"
	worth = 850 // the milrp tax is real
	contains = list(
		/obj/item/clothing/suit/storage/vest/heavy/flexitac,
		/obj/item/clothing/head/helmet/flexitac,
		/obj/item/clothing/shoes/leg_guard/flexitac,
		/obj/item/clothing/gloves/arm_guard/flexitac,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical,
		/obj/item/storage/belt/security/tactical,
	)

/datum/supply_pack/nanotrasen/security/securitybarriers
	name = "Misc - Security Barriers"
	contains = list(
		/obj/machinery/deployable/barrier = 4,
	)
	container_type = /obj/structure/largecrate
	container_name = "Security barrier crate"

/datum/supply_pack/nanotrasen/security/holster
	name = "Gear - Holsters"
	lazy_gacha_amount = 4
	lazy_gacha_contained = list(
		/obj/item/clothing/accessory/holster,
		/obj/item/clothing/accessory/holster/armpit,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/clothing/accessory/holster/hip,
	)
	container_type = /obj/structure/closet/crate/corporate/nanotrasen
	container_name = "Holster crate"

/datum/supply_pack/nanotrasen/security/extragear
	name = "Gear - Security surplus equipment"
	contains = list(
		/obj/item/storage/belt/security = 3,
		/obj/item/clothing/glasses/sunglasses/sechud = 3,
		/obj/item/radio/headset/headset_sec/alt = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3,
		/obj/item/storage/belt/dualholster = 3,
	)
	worth = 600 // i'm lazy
	container_type = /obj/structure/closet/crate/corporate/nanotrasen
	container_name = "Security surplus equipment"

/datum/supply_pack/nanotrasen/security/detectivegear
	name = "Forensic - Investigation equipment"
	contains = list(
		/obj/item/storage/box/evidence = 2,
		/obj/item/clothing/suit/storage/vest/detective,
		/obj/item/cartridge/detective,
		/obj/item/radio/headset/headset_sec,
		/obj/item/barrier_tape_roll/police,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/camera,
		/obj/item/folder/red,
		/obj/item/folder/blue,
		/obj/item/storage/belt/detective,
		/obj/item/clothing/gloves/black,
		/obj/item/tape_recorder,
		/obj/item/mass_spectrometer,
		/obj/item/camera_film = 2,
		/obj/item/storage/photo_album,
		/obj/item/reagent_scanner,
		/obj/item/flashlight/maglight,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/storage/bag/detective,
	)
	worth = 750 // i'm lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Forensic equipment"

/datum/supply_pack/nanotrasen/security/detectivescan
	name = "Forensic - Scanning Equipment"
	contains = list(
		/obj/item/mass_spectrometer,
		/obj/item/reagent_scanner,
		/obj/item/storage/briefcase/crimekit,
		/obj/item/detective_scanner,
	)
	worth = 850 // detective scanner buff someday
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Forensic equipment"

/datum/supply_pack/nanotrasen/security/detectiveclothes
	name = "Forensic - Investigation apparel"
	contains = list(
		/obj/item/clothing/under/det/black = 2,
		/obj/item/clothing/under/det/grey = 2,
		/obj/item/clothing/head/det/grey = 2,
		/obj/item/clothing/under/det/skirt = 2,
		/obj/item/clothing/under/det = 2,
		/obj/item/clothing/head/det = 2,
		/obj/item/clothing/suit/storage/det_trench,
		/obj/item/clothing/suit/storage/det_trench/grey,
		/obj/item/clothing/suit/storage/forensics/red,
		/obj/item/clothing/suit/storage/forensics/blue,
		/obj/item/clothing/under/det/corporate = 2,
		/obj/item/clothing/accessory/badge/holo/detective = 2,
		/obj/item/clothing/gloves/black = 2,
	)
	worth = 750 // the LARPer tax is real + these are armored
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Investigation clothing"

/datum/supply_pack/nanotrasen/security/officergear
	name = "Gear - Officer equipment"
	contains = list(
		/obj/item/clothing/suit/storage/vest/officer,
		/obj/item/clothing/head/helmet,
		/obj/item/cartridge/security,
		/obj/item/clothing/accessory/badge/holo,
		/obj/item/clothing/accessory/badge/holo/cord,
		/obj/item/radio/headset/headset_sec,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/grenade/simple/flashbang,
		/obj/item/melee/baton/loaded,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/clothing/gloves/black,
		/obj/item/hailer,
		/obj/item/flashlight/flare,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/head/soft/sec/corp,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/gun/projectile/energy/taser,
		/obj/item/flashlight/maglight,
	)
	worth = 750 // i'm lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Officer equipment"

/datum/supply_pack/nanotrasen/security/wardengear
	name = "Gear - Warden equipment"
	contains = list(
		/obj/item/clothing/suit/storage/vest/warden,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/suit/storage/vest/wardencoat,
		/obj/item/clothing/suit/storage/vest/wardencoat/alt,
		/obj/item/clothing/head/helmet/warden,
		/obj/item/cartridge/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/barrier_tape_roll/police,
		/obj/item/hailer,
		/obj/item/clothing/accessory/badge/holo/warden,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/loaded,
		/obj/item/storage/box/holobadge,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/flashlight/maglight,
	)
	worth = 850 // i'm lazy
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Warden equipment"
	container_access = list(
		/datum/access/station/security/armory,
	)

/datum/supply_pack/nanotrasen/security/headofsecgear
	name = "Gear - Head of security equipment"
	contains = list(
		/obj/item/clothing/head/helmet/HoS,
		/obj/item/clothing/suit/storage/vest/hos,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/suit/storage/vest/hoscoat,
		/obj/item/clothing/head/helmet/dermal,
		/obj/item/cartridge/hos,
		/obj/item/radio/headset/heads/hos,
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/storage/belt/security,
		/obj/item/flash,
		/obj/item/hailer,
		/obj/item/clothing/accessory/badge/holo/hos,
		/obj/item/clothing/accessory/holster/waist,
		/obj/item/melee/telebaton,
		/obj/item/shield/transforming/telescopic,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/flashlight/maglight,
	)
	worth = 1500 // the milrper tax is real + good armor + don't lose your shit lol
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Head of security equipment"
	container_access = list(
		/datum/access/station/security/hos,
	)

/datum/supply_pack/nanotrasen/security/securityclothing
	name = "Misc - Security uniform red"
	contains = list(
		/obj/item/storage/backpack/satchel/sec = 2,
		/obj/item/storage/backpack/security = 2,
		/obj/item/clothing/accessory/armband = 4,
		/obj/item/clothing/under/rank/security = 4,
		/obj/item/clothing/under/rank/security2 = 4,
		/obj/item/clothing/under/rank/warden,
		/obj/item/clothing/under/rank/head_of_security,
		/obj/item/clothing/head/soft/sec = 4,
		/obj/item/clothing/gloves/black = 4,
		/obj/item/storage/box/holobadge,
	)
	worth = 500 // *facepalm* item spam
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security uniform crate"

/datum/supply_pack/nanotrasen/security/navybluesecurityclothing
	name = "Misc - Security uniform navy blue"
	contains = list(
		/obj/item/storage/backpack/satchel/sec = 2,
		/obj/item/storage/backpack/security = 2,
		/obj/item/clothing/under/rank/security/navyblue = 4,
		/obj/item/clothing/suit/security/navyofficer = 4,
		/obj/item/clothing/under/rank/warden/navyblue,
		/obj/item/clothing/suit/security/navywarden,
		/obj/item/clothing/under/rank/head_of_security/navyblue,
		/obj/item/clothing/suit/security/navyhos,
		/obj/item/clothing/head/beret/sec/navy/officer = 4,
		/obj/item/clothing/head/beret/sec/navy/warden,
		/obj/item/clothing/head/beret/sec/navy/hos,
		/obj/item/clothing/gloves/black = 4,
		/obj/item/storage/box/holobadge,
	)
	worth = 500 // item spam
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Navy blue security uniform crate"

/datum/supply_pack/nanotrasen/security/corporatesecurityclothing
	name = "Misc - Security uniform corporate"
	contains = list(
		/obj/item/storage/backpack/satchel/sec = 2,
		/obj/item/storage/backpack/security = 2,
		/obj/item/clothing/under/rank/security/corp = 4,
		/obj/item/clothing/head/soft/sec/corp = 4,
		/obj/item/clothing/under/rank/warden/corp,
		/obj/item/clothing/under/rank/head_of_security/corp,
		/obj/item/clothing/head/beret/sec = 4,
		/obj/item/clothing/head/beret/sec/corporate/warden,
		/obj/item/clothing/head/beret/sec/corporate/hos,
		/obj/item/clothing/under/det/corporate = 2,
		/obj/item/clothing/gloves/black = 4,
		/obj/item/storage/box/holobadge,
	)
	worth = 500 // item spam
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Corporate security uniform crate"

/datum/supply_pack/nanotrasen/security/biosuit
	name = "Gear - Security biohazard gear"
	contains = list(
		/obj/item/clothing/head/bio_hood/security = 3,
		/obj/item/clothing/under/rank/security = 3,
		/obj/item/clothing/suit/bio_suit/security = 3,
		/obj/item/clothing/shoes/white = 3,
		/obj/item/clothing/mask/gas = 3,
		/obj/item/tank/oxygen = 3,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/storage/box/gloves,
	)
	worth = 1250 // honestly kinda cheap for 3 sets
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security biohazard gear"

/datum/supply_pack/nanotrasen/security/posters
	name = "Gear - Morale Posters"
	contains = list(
		/obj/item/poster/nanotrasen = 6,
	)
	worth = 100 // YEAAAH NANOTRASEN PROPAGANDA WOO
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Morale Posters"

/datum/supply_pack/nanotrasen/security/kevlarkit
	name = "Misc - Kevlar Upgrade Kits"
	contains = list(
		/obj/item/kevlarupgrade = 5,
	)
	worth = 500 // the powergamer tax is real
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Kevlar Upgrade Kits"
	// "why is this not locked"
	// because i'll be entirely blunt here
	// uniform armor upgrades is stupid as shit
	// i have no game design reason to lock it to security
	// because that gives security an unfair advantage (uniform armor is historically antag-only)
	// if you're going to add stuff like this, it's not going to be security-only.
	container_access = null

/datum/supply_pack/nanotrasen/security/pcarriers/combat
	name = "Armor - Combat Armor (P-Carrier)"
	contains = list(
		/obj/item/clothing/suit/armor/pcarrier = 3,
		/obj/item/clothing/accessory/armor/armorplate/combat = 3,
		/obj/item/clothing/accessory/armor/armguards/combat = 3,
		/obj/item/clothing/accessory/armor/legguards/combat = 3,
		/obj/item/clothing/head/helmet/redcombat = 3,
	)
	worth = 1650 // the milrp tax is real + this is cheap for 3 armors
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Combat Armor crate"

/datum/supply_pack/nanotrasen/security/helmets
	name = "Armor - Helmet Pack"
	contains = list(
		/obj/item/clothing/head/helmet = 3,
	)
	worth = 125 * 3 // it's just helmets, 125 a piece is fine
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen

/datum/supply_pack/nanotrasen/security/wardengear
	name = "Tracking Implants"
	contains = list(
		/obj/item/storage/box/trackimp = 1,
	)
	worth = 1500 // the 1984 tax is real, don't spam this shit
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
