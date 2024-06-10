/*
*	Here is where any supply packs
*	related to security tasks live
*/


/datum/supply_pack/security
	group = "Security"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack/randomised/security
	group = "Security"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack/randomised/security/armor
	name = "Armor - Security armor"
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/storage/vest,
			/obj/item/clothing/suit/storage/vest/officer,
			/obj/item/clothing/suit/storage/vest/warden,
			/obj/item/clothing/suit/storage/vest/hos,
			/obj/item/clothing/suit/storage/vest/detective,
			/obj/item/clothing/suit/storage/vest/heavy,
			/obj/item/clothing/suit/storage/vest/heavy/officer,
			/obj/item/clothing/suit/storage/vest/heavy/warden,
			/obj/item/clothing/suit/storage/vest/heavy/hos
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor crate"

/datum/supply_pack/randomised/security/carriers
	name = "Armor - Plate carriers"
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier,
			/obj/item/clothing/suit/armor/pcarrier/alt,
			/obj/item/clothing/suit/armor/pcarrier/blue,
			/obj/item/clothing/suit/armor/pcarrier/green,
			/obj/item/clothing/suit/armor/pcarrier/navy,
			/obj/item/clothing/suit/armor/pcarrier/tan,
			/obj/item/clothing/suit/armor/pcarrier/press
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Plate Carrier crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/carriertags
	name = "Armor - Plate carrier tags"
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
			/obj/item/clothing/accessory/armor/tag/abneg
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Plate Carrier crate"

/datum/supply_pack/security/helmcovers
	name = "Armor - Helmet covers"
	contains = list(
			/obj/item/clothing/accessory/armor/helmcover/blue,
			/obj/item/clothing/accessory/armor/helmcover/blue,
			/obj/item/clothing/accessory/armor/helmcover/navy,
			/obj/item/clothing/accessory/armor/helmcover/navy,
			/obj/item/clothing/accessory/armor/helmcover/green,
			/obj/item/clothing/accessory/armor/helmcover/green,
			/obj/item/clothing/accessory/armor/helmcover/tan,
			/obj/item/clothing/accessory/armor/helmcover/tan
			)
	cost = 15
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Helmet Covers crate"

/datum/supply_pack/randomised/security/armorplates
	name = "Armor - Security p-carrier armor plates"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/armor/armorplate,
			/obj/item/clothing/accessory/armor/armorplate/stab,
			/obj/item/clothing/accessory/armor/armorplate,
			/obj/item/clothing/accessory/armor/armorplate/stab,
			/obj/item/clothing/accessory/armor/armorplate/medium,
			/obj/item/clothing/accessory/armor/armorplate/medium,
			/obj/item/clothing/accessory/armor/armorplate/tactical,
			/obj/item/clothing/accessory/armor/armorplate/ablative,
			/obj/item/clothing/accessory/armor/armorplate/riot,
			/obj/item/clothing/accessory/armor/armorplate/ballistic
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/randomised/security/carrierarms
	name = "Armor - Security armguard attachments"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/armor/armguards,
			/obj/item/clothing/accessory/armor/armguards/blue,
			/obj/item/clothing/accessory/armor/armguards/navy,
			/obj/item/clothing/accessory/armor/armguards/green,
			/obj/item/clothing/accessory/armor/armguards/tan,
			/obj/item/clothing/accessory/armor/armguards/ablative,
			/obj/item/clothing/accessory/armor/armguards/riot,
			/obj/item/clothing/accessory/armor/armguards/ballistic
			)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/randomised/security/carrierlegs
	name = "Armor - Security legguard attachments"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/armor/legguards,
			/obj/item/clothing/accessory/armor/legguards/blue,
			/obj/item/clothing/accessory/armor/legguards/navy,
			/obj/item/clothing/accessory/armor/legguards/green,
			/obj/item/clothing/accessory/armor/legguards/tan,
			/obj/item/clothing/accessory/armor/legguards/ablative,
			/obj/item/clothing/accessory/armor/legguards/riot,
			/obj/item/clothing/accessory/armor/legguards/ballistic
			)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/randomised/security/carrierbags
	name = "Armor - Security p-carrier pouch attachments"
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/storage/pouches,
			/obj/item/clothing/accessory/storage/pouches/blue,
			/obj/item/clothing/accessory/storage/pouches/navy,
			/obj/item/clothing/accessory/storage/pouches/green,
			/obj/item/clothing/accessory/storage/pouches/tan,
			/obj/item/clothing/accessory/storage/pouches/large,
			/obj/item/clothing/accessory/storage/pouches/large/blue,
			/obj/item/clothing/accessory/storage/pouches/large/navy,
			/obj/item/clothing/accessory/storage/pouches/large/green,
			/obj/item/clothing/accessory/storage/pouches/large/tan
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Armor plate crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/riot_gear
	name = "Gear - Riot"
	contains = list(
			/obj/item/melee/baton = 3,
			/obj/item/shield/riot = 3,
			/obj/item/handcuffs = 3,
			/obj/item/storage/box/flashbangs,
			/obj/item/storage/box/beanbags,
			/obj/item/storage/box/handcuffs
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Riot gear crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/riot_armor
	name = "Armor Set - Riot"
	contains = list(
			/obj/item/clothing/head/helmet/riot,
			/obj/item/clothing/suit/armor/riot,
			/obj/item/clothing/gloves/arm_guard/riot,
			/obj/item/clothing/shoes/leg_guard/riot
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Riot armor crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/riot_plates
	name = "Armor Set - Riot (P-Carrier)"
	contains = list(
			/obj/item/clothing/head/helmet/riot,
			/obj/item/clothing/suit/armor/pcarrier/riot,
			/obj/item/clothing/accessory/armor/armguards/riot,
			/obj/item/clothing/accessory/armor/legguards/riot
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Riot armor crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/ablative_armor
	name = "Armor Set - Ablative"
	contains = list(
			/obj/item/clothing/head/helmet/ablative,
			/obj/item/clothing/suit/armor/laserproof,
			/obj/item/clothing/gloves/arm_guard/laserproof,
			/obj/item/clothing/shoes/leg_guard/laserproof
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ablative armor crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/ablative_plates
	name = "Armor Set - Ablative (P-Carrier)"
	contains = list(
			/obj/item/clothing/head/helmet/ablative,
			/obj/item/clothing/suit/armor/pcarrier/ablative,
			/obj/item/clothing/accessory/armor/armguards/ablative,
			/obj/item/clothing/accessory/armor/legguards/ablative
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ablative armor crate"
	access = ACCESS_SECURITY_ARMORY


/datum/supply_pack/security/bullet_resistant_armor
	name = "Armor Set - Ballistic"
	contains = list(
			/obj/item/clothing/head/helmet/ballistic,
			/obj/item/clothing/suit/armor/bulletproof,
			/obj/item/clothing/gloves/arm_guard/bulletproof,
			/obj/item/clothing/shoes/leg_guard/bulletproof
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ballistic armor crate"
	access = ACCESS_SECURITY_ARMORY


/datum/supply_pack/security/bullet_resistant_plates
	name = "Armor Set - Ballistic (P-Carrier)"
	contains = list(
			/obj/item/clothing/head/helmet/ballistic,
			/obj/item/clothing/suit/armor/pcarrier/ballistic,
			/obj/item/clothing/accessory/armor/armguards/ballistic,
			/obj/item/clothing/accessory/armor/legguards/ballistic
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Ballistic armor crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/combat_armor
	name = "Armor - Combat"
	contains = list(
			/obj/item/clothing/head/helmet/combat,
			/obj/item/clothing/suit/armor/combat,
			/obj/item/clothing/gloves/arm_guard/combat,
			/obj/item/clothing/shoes/leg_guard/combat
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Combat armor crate"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/tactical
	name = "Armor - NT Tactical"
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "NT Tactical armor crate"
	cost = 40
	access = ACCESS_SECURITY_ARMORY
	contains = list(
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/storage/belt/security/tactical,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/storage/belt/security/tactical,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/black
			)

/datum/supply_pack/security/flexitac
	name = "Armor - Tactical Light"
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Tactical Light armor crate"
	cost = 75
	access = ACCESS_SECURITY_ARMORY
	contains = list(
				/obj/item/clothing/suit/storage/vest/heavy/flexitac,
				/obj/item/clothing/head/helmet/flexitac,
				/obj/item/clothing/shoes/leg_guard/flexitac,
				/obj/item/clothing/gloves/arm_guard/flexitac,
				/obj/item/clothing/mask/balaclava/tactical,
				/obj/item/clothing/glasses/sunglasses/sechud/tactical,
				/obj/item/storage/belt/security/tactical,
				/obj/item/clothing/suit/storage/vest/heavy/flexitac,
				/obj/item/clothing/head/helmet/flexitac,
				/obj/item/clothing/shoes/leg_guard/flexitac,
				/obj/item/clothing/gloves/arm_guard/flexitac,
				/obj/item/clothing/mask/balaclava/tactical,
				/obj/item/clothing/glasses/sunglasses/sechud/tactical,
				/obj/item/storage/belt/security/tactical
				)

/datum/supply_pack/security/securitybarriers
	name = "Misc - Security Barriers"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	container_type = /obj/structure/largecrate
	container_name = "Security barrier crate"
	access = null

/datum/supply_pack/security/securityshieldgen
	name = "Misc - Wall shield generators"
	contains = list(/obj/machinery/shieldwallgen = 4)
	cost = 20
	container_type = /obj/structure/closet/crate/secure
	container_name = "Wall shield generators crate"
	access = ACCESS_COMMAND_TELEPORTER

/datum/supply_pack/randomised/security/holster
	name = "Gear - Holsters"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
			)
	cost = 15
	container_type = /obj/structure/closet/crate/corporate/nanotrasen
	container_name = "Holster crate"

/datum/supply_pack/security/extragear
	name = "Gear - Security surplus equipment"
	contains = list(
			/obj/item/storage/belt/security = 3,
			/obj/item/clothing/glasses/sunglasses/sechud = 3,
			/obj/item/radio/headset/headset_sec/alt = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3,
			/obj/item/storage/belt/dualholster = 3
			)
	cost = 15
	container_type = /obj/structure/closet/crate/corporate/nanotrasen
	container_name = "Security surplus equipment"

/datum/supply_pack/security/detectivegear
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
			/obj/item/storage/bag/detective
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Forensic equipment"
	access = ACCESS_SECURITY_FORENSICS

/datum/supply_pack/security/detectivescan
	name = "Forensic - Scanning Equipment"
	contains = list(
			/obj/item/mass_spectrometer,
			/obj/item/reagent_scanner,
			/obj/item/storage/briefcase/crimekit,
			/obj/item/detective_scanner
			)
	cost = 60
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Forensic equipment"
	access = ACCESS_SECURITY_FORENSICS

/datum/supply_pack/security/detectiveclothes
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
			/obj/item/clothing/gloves/black = 2
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Investigation clothing"
	access = ACCESS_SECURITY_FORENSICS

/datum/supply_pack/security/officergear
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
			/obj/item/grenade/flashbang,
			/obj/item/melee/baton/loaded,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/barrier_tape_roll/police,
			/obj/item/clothing/gloves/black,
			/obj/item/hailer,
			/obj/item/flashlight/flare,
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/head/soft/sec/corp,
			/obj/item/clothing/under/rank/security/corp,
			/obj/item/gun/energy/taser,
			/obj/item/flashlight/maglight
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Officer equipment"
	access = ACCESS_SECURITY_BRIG

/datum/supply_pack/security/wardengear
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
			/obj/item/flashlight/maglight
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Warden equipment"
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/headofsecgear
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
			/obj/item/shield/riot/tele,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/flashlight/maglight
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Head of security equipment"
	access = ACCESS_SECURITY_HOS

/datum/supply_pack/security/securityclothing
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
			/obj/item/storage/box/holobadge
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security uniform crate"

/datum/supply_pack/security/navybluesecurityclothing
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
			/obj/item/storage/box/holobadge
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Navy blue security uniform crate"

/datum/supply_pack/security/corporatesecurityclothing
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
			/obj/item/storage/box/holobadge
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Corporate security uniform crate"

/datum/supply_pack/security/biosuit
	name = "Gear - Security biohazard gear"
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/storage/box/gloves
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Security biohazard gear"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack/security/posters
	name = "Gear - Morale Posters"
	contains = list(
			/obj/item/contraband/poster/nanotrasen = 6
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Morale Posters"
	access = ACCESS_ENGINEERING_MAINT

/datum/supply_pack/security/biosuit
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/storage/box/gloves
			)
	cost = 40

/datum/supply_pack/randomised/security/holster
	num_contained = 5
	contains = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip,
			/obj/item/clothing/accessory/holster/leg,
			/obj/item/storage/belt/dualholster
			)

/datum/supply_pack/security/kevlarkit
	name = "Misc - Kevlar Upgrade Kits"
	contains = list(
			/obj/item/kevlarupgrade = 5,
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Kevlar Upgrade Kits"
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack/security/pcarriers/combat
	name = "Armor - Combat Armor (P-Carrier)"
	contains = list(
			/obj/item/clothing/suit/armor/pcarrier = 3,
			/obj/item/clothing/accessory/armor/armorplate/combat = 3,
			/obj/item/clothing/accessory/armor/armguards/combat = 3,
			/obj/item/clothing/accessory/armor/legguards/combat = 3,
			/obj/item/clothing/head/helmet/redcombat = 3,
			)
	cost = 70
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	container_name = "Combat Armor crate"
	access = ACCESS_SECURITY_EQUIPMENT
	contraband = 1

/datum/supply_pack/security/helmets
	name = "Armor - Helmet Pack"
	contains = list(
			/obj/item/clothing/head/helmet = 3,
			/obj/item/clothing/head/helmet/warden = 1,
			/obj/item/clothing/head/helmet/HoS = 1,
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	access = ACCESS_SECURITY_EQUIPMENT

/datum/supply_pack/security/wardengear
	name = "Tracking Implants"
	contains = list(
			/obj/item/storage/box/trackimp = 1
			)
	cost = 30
	container_type = /obj/structure/closet/crate/secure/corporate/nanotrasen
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/battlerifle
	name = "Battle Rifle Pack"
	contains = list(
			/obj/item/gun/ballistic/automatic/battlerifle = 2,
			/obj/item/ammo_magazine/m95 = 4
			)
	cost = 60
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	access = ACCESS_SECURITY_ARMORY

/datum/supply_pack/security/quadshot
	name = "Quad Shotgun Pack"
	contains = list(
			/obj/item/gun/ballistic/shotgun/doublebarrel/quad = 2,
			/obj/item/storage/box/shotgunshells = 2,
			/obj/item/storage/belt/security/tactical/bandolier = 2,
			)
	cost = 70
	container_type = /obj/structure/closet/crate/secure/corporate/heph
	access = ACCESS_SECURITY_ARMORY
