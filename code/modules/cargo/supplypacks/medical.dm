/*
*	Here is where any supply packs
*	related to medical tasks live.
*/


/datum/supply_pack/med
	group = "Medical"

/datum/supply_pack/med/medical
	name = "Medical crate"
	contains = list(
			/obj/item/storage/firstaid/regular,
			/obj/item/storage/firstaid/fire,
			/obj/item/storage/firstaid/toxin,
			/obj/item/storage/firstaid/o2,
			/obj/item/storage/firstaid/adv,
			/obj/item/reagent_containers/glass/bottle/antitoxin,
			/obj/item/reagent_containers/glass/bottle/inaprovaline,
			/obj/item/reagent_containers/glass/bottle/stoxin,
			/obj/item/storage/box/syringes,
			/obj/item/storage/box/autoinjectors
			)
	cost = 10
	container_type = /obj/structure/closet/crate/nanomed
	container_name = "Medical crate"

/datum/supply_pack/med/bloodpack
	name = "BloodPack crate"
	contains = list(/obj/item/storage/box/bloodpacks = 3)
	cost = 10
	container_type = /obj/structure/closet/crate/medical
	container_name = "BloodPack crate"

/datum/supply_pack/med/bodybag
	name = "Body bag crate"
	contains = list(/obj/item/storage/box/bodybags = 3)
	cost = 10
	container_type = /obj/structure/closet/crate/medical
	container_name = "Body bag crate"

/datum/supply_pack/med/cryobag
	name = "Stasis bag crate"
	contains = list(/obj/item/bodybag/cryobag = 3)
	cost = 40
	container_type = /obj/structure/closet/crate/medical
	container_name = "Stasis bag crate"

/datum/supply_pack/med/surgery
	name = "Surgery crate"
	contains = list(
			/obj/item/surgical/cautery,
			/obj/item/surgical/surgicaldrill,
			/obj/item/clothing/mask/breath/medical,
			/obj/item/tank/anesthetic,
			/obj/item/surgical/FixOVein,
			/obj/item/surgical/hemostat,
			/obj/item/surgical/scalpel,
			/obj/item/surgical/bonegel,
			/obj/item/surgical/retractor,
			/obj/item/surgical/bonesetter,
			/obj/item/surgical/circular_saw
			)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Surgery crate"
	access = access_medical

/datum/supply_pack/med/deathalarm
	name = "Death Alarm crate"
	contains = list(
			/obj/item/storage/box/cdeathalarm_kit,
			/obj/item/storage/box/cdeathalarm_kit
			)
	cost = 40
	container_type = /obj/structure/closet/crate/veymed
	container_name = "Death Alarm crate"
	access = access_medical

/datum/supply_pack/med/clotting
	name = "Clotting Medicine crate"
	contains = list(
			/obj/item/storage/firstaid/clotting
			)
	cost = 100
	container_type = /obj/structure/closet/crate/secure/zenghu
	container_name = "Clotting Medicine crate"
	access = access_medical

/datum/supply_pack/med/sterile
	name = "Sterile equipment crate"
	contains = list(
			/obj/item/clothing/under/rank/medical/scrubs/green = 2,
			/obj/item/clothing/head/surgery/green = 2,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves,
			/obj/item/storage/belt/medical = 3
			)
	cost = 10
	container_type = /obj/structure/closet/crate
	container_name = "Sterile equipment crate"

/datum/supply_pack/med/extragear
	name = "Medical surplus equipment"
	contains = list(
			/obj/item/storage/belt/medical = 3,
			/obj/item/clothing/glasses/hud/health = 3,
			/obj/item/radio/headset/headset_med/alt = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 3
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Medical surplus equipment"
	access = access_medical

/datum/supply_pack/med/cmogear
	name = "Chief medical officer equipment"
	contains = list(
			/obj/item/storage/belt/medical,
			/obj/item/radio/headset/heads/cmo,
			/obj/item/clothing/under/rank/chief_medical_officer,
			/obj/item/reagent_containers/hypospray/vial,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/shoes/white,
			/obj/item/cartridge/cmo,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/healthanalyzer,
			/obj/item/flashlight/pen,
			/obj/item/reagent_containers/syringe
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Chief medical officer equipment"
	access = access_cmo

/datum/supply_pack/med/doctorgear
	name = "Medical Doctor equipment"
	contains = list(
			/obj/item/storage/belt/medical,
			/obj/item/radio/headset/headset_med,
			/obj/item/clothing/under/rank/medical,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat,
			/obj/item/clothing/mask/surgical,
			/obj/item/storage/firstaid/adv,
			/obj/item/clothing/shoes/white,
			/obj/item/cartridge/medical,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/healthanalyzer,
			/obj/item/flashlight/pen,
			/obj/item/reagent_containers/syringe
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Medical Doctor equipment"
	access = access_medical_equip

/datum/supply_pack/med/chemistgear
	name = "Chemist equipment"
	contains = list(
			/obj/item/storage/box/beakers,
			/obj/item/radio/headset/headset_med,
			/obj/item/storage/box/autoinjectors,
			/obj/item/clothing/under/rank/chemist,
			/obj/item/clothing/glasses/science,
			/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/shoes/white,
			/obj/item/cartridge/chemistry,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/reagent_containers/dropper,
			/obj/item/healthanalyzer,
			/obj/item/storage/box/pillbottles,
			/obj/item/reagent_containers/syringe
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Chemist equipment"
	access = access_chemistry

/datum/supply_pack/med/paramedicgear
	name = "Paramedic equipment"
	contains = list(
			/obj/item/storage/belt/medical/emt,
			/obj/item/radio/headset/headset_med,
			/obj/item/clothing/under/rank/medical/scrubs/black,
			/obj/item/clothing/accessory/armband/medblue,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat/emt,
			/obj/item/clothing/under/rank/medical/paramedic,
			/obj/item/clothing/suit/storage/toggle/fr_jacket,
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/under/rank/medical/paramedic,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/storage/firstaid/adv,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/healthanalyzer,
			/obj/item/cartridge/medical,
			/obj/item/flashlight/pen,
			/obj/item/reagent_containers/syringe,
			/obj/item/clothing/accessory/storage/white_vest
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Paramedic equipment"
	access = access_medical_equip

/datum/supply_pack/med/psychiatristgear
	name = "Psychiatrist equipment"
	contains = list(
			/obj/item/clothing/under/rank/psych,
			/obj/item/radio/headset/headset_med,
			/obj/item/clothing/under/rank/psych/turtleneck,
			/obj/item/clothing/shoes/laceup,
			/obj/item/clothing/suit/storage/toggle/labcoat,
			/obj/item/clothing/shoes/white,
			/obj/item/clipboard,
			/obj/item/folder/white,
			/obj/item/pen,
			/obj/item/cartridge/medical
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Psychiatrist equipment"
	access = access_psychiatrist

/datum/supply_pack/med/medicalscrubs
	name = "Medical scrubs"
	contains = list(
			/obj/item/clothing/shoes/white = 3,,
			/obj/item/clothing/under/rank/medical/scrubs = 3,
			/obj/item/clothing/under/rank/medical/scrubs/green = 3,
			/obj/item/clothing/under/rank/medical/scrubs/purple = 3,
			/obj/item/clothing/under/rank/medical/scrubs/black = 3,
			/obj/item/clothing/head/surgery = 3,
			/obj/item/clothing/head/surgery/purple = 3,
			/obj/item/clothing/head/surgery/blue = 3,
			/obj/item/clothing/head/surgery/green = 3,
			/obj/item/clothing/head/surgery/black = 3,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Medical scrubs crate"
	access = access_medical_equip

/datum/supply_pack/med/autopsy
	name = "Autopsy equipment"
	contains = list(
			/obj/item/folder/white,
			/obj/item/camera,
			/obj/item/camera_film = 2,
			/obj/item/autopsy_scanner,
			/obj/item/surgical/scalpel,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves,
			/obj/item/pen
			)
	cost = 20
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Autopsy equipment crate"
	access = access_morgue

/datum/supply_pack/med/medicaluniforms
	name = "Medical uniforms"
	contains = list(
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/under/rank/chief_medical_officer,
			/obj/item/clothing/under/rank/geneticist,
			/obj/item/clothing/under/rank/virologist,
			/obj/item/clothing/under/rank/nursesuit,
			/obj/item/clothing/under/rank/nurse,
			/obj/item/clothing/under/rank/orderly,
			/obj/item/clothing/under/rank/medical = 3,
			/obj/item/clothing/under/rank/medical/paramedic = 3,
			/obj/item/clothing/suit/storage/toggle/labcoat = 3,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
			/obj/item/clothing/suit/storage/toggle/labcoat/emt,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
			/obj/item/clothing/suit/storage/toggle/labcoat/genetics,
			/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
			/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 10
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Medical uniform crate"
	access = access_medical_equip

/datum/supply_pack/med/medicalbiosuits
	name = "Medical biohazard gear"
	contains = list(
			/obj/item/clothing/head/bio_hood = 3,
			/obj/item/clothing/suit/bio_suit = 3,
			/obj/item/clothing/head/bio_hood/virology = 2,
			/obj/item/clothing/suit/bio_suit/cmo,
			/obj/item/clothing/head/bio_hood/cmo,
			/obj/item/clothing/mask/gas = 5,
			/obj/item/tank/oxygen = 5,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 50
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Medical biohazard equipment"
	access = access_medical_equip

/datum/supply_pack/med/portablefreezers
	name = "Portable freezers crate"
	contains = list(/obj/item/storage/box/freezer = 7)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Portable freezers"
	access = access_medical_equip

/datum/supply_pack/med/virus
	name = "Virus sample crate"
	contains = list(/obj/item/virusdish/random = 4)
	cost = 25
	container_type = /obj/structure/closet/crate/secure
	container_name = "Virus sample crate"
	access = access_cmo

/datum/supply_pack/med/defib
	name = "Defibrillator crate"
	contains = list(/obj/item/defib_kit = 2)
	cost = 30
	container_type = /obj/structure/closet/crate/medical
	container_name = "Defibrillator crate"

/datum/supply_pack/med/distillery
	name = "Chemical distiller crate"
	contains = list(/obj/machinery/portable_atmospherics/powered/reagent_distillery = 1)
	cost = 175
	container_type = /obj/structure/largecrate
	container_name = "Chemical distiller crate"

/datum/supply_pack/med/advdistillery
	name = "Industrial Chemical distiller crate"
	contains = list(/obj/machinery/portable_atmospherics/powered/reagent_distillery/industrial = 1)
	cost = 250
	container_type = /obj/structure/largecrate
	container_name = "Industrial Chemical distiller crate"

/datum/supply_pack/med/oxypump
	name = "Oxygen pump crate"
	contains = list(/obj/machinery/oxygen_pump/mobile = 1)
	cost = 125
	container_type = /obj/structure/largecrate
	container_name = "Oxygen pump crate"

/datum/supply_pack/med/anestheticpump
	name = "Anesthetic pump crate"
	contains = list(/obj/machinery/oxygen_pump/mobile/anesthetic = 1)
	cost = 130
	container_type = /obj/structure/largecrate
	container_name = "Anesthetic pump crate"

/datum/supply_pack/med/stablepump
	name = "Portable stabilizer crate"
	contains = list(/obj/machinery/oxygen_pump/mobile/stabilizer = 1)
	cost = 175
	container_type = /obj/structure/largecrate
	container_name = "Portable stabilizer crate"

/datum/supply_pack/med/medicalbiosuits
	contains = list(
			/obj/item/clothing/head/bio_hood/scientist = 3,
			/obj/item/clothing/suit/bio_suit/scientist = 3,
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/suit/bio_suit/cmo,
			/obj/item/clothing/head/bio_hood/cmo,
			/obj/item/clothing/shoes/white = 7,
			/obj/item/clothing/mask/gas = 7,
			/obj/item/tank/oxygen = 7,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 40

/datum/supply_pack/med/virologybiosuits
	name = "Virology biohazard gear"
	contains = list(
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 40
	container_type = /obj/structure/closet/crate/secure
	container_name = "Virology biohazard equipment"
	access = access_medical_equip

/datum/supply_pack/med/virus
	name = "Virus sample crate"
	contains = list(/obj/item/virusdish/random = 4)
	cost = 25
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Virus sample crate"
	access = access_medical_equip


/datum/supply_pack/med/bloodpack
	container_type = /obj/structure/closet/crate/medical/blood

/datum/supply_pack/med/compactdefib
	name = "Compact Defibrillator crate"
	contains = list(/obj/item/defib_kit/compact = 1)
	cost = 90
	container_type = /obj/structure/closet/crate/secure/nanomed
	container_name = "Compact Defibrillator crate"
	access = access_medical_equip

/datum/supply_pack/med/ml3m
	name = "Cell-Loaded Medigun crate"
	contains = list(
			/obj/item/gun/ballistic/cell_loaded/medical = 1,
			/obj/item/ammo_magazine/cell_mag/medical = 1
			)
	cost = 250
	container_type = /obj/structure/closet/crate/secure/veymed
	container_name = "Cell-Loaded Medigun crate"
	access = access_cmo

/datum/supply_pack/med/ml3m_cells
	name = "Cell-Loaded Medigun Cell Pack crate"
	contains = list(
			/obj/item/ammo_casing/microbattery/medical/brute = 3,
			/obj/item/ammo_casing/microbattery/medical/burn = 3,
			/obj/item/ammo_casing/microbattery/medical/stabilize = 3
			)
	cost = 100
	container_type = /obj/structure/closet/crate/secure/veymed
	container_name = "Cell-Loaded Medigun Cell Pack crate"
	access = access_cmo
