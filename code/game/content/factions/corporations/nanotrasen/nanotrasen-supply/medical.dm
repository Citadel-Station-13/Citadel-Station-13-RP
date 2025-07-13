/*
*	Here is where any supply packs
*	related to medical tasks live.
*/


/datum/supply_pack/nanotrasen/medical
	abstract_type = /datum/supply_pack/nanotrasen/medical
	category = "Medical"

/datum/supply_pack/nanotrasen/medical/supplies
	name = "Medical Supplies crate"
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
		/obj/item/storage/box/autoinjectors,
	)
	worth = 250
	container_type = /obj/structure/closet/crate/corporate/nanomed
	container_name = "Medical crate"

/datum/supply_pack/nanotrasen/medical/bloodpack
	name = "BloodPack crate"
	contains = list(
		/obj/item/storage/box/bloodpacks = 3,
	)
	worth = 250
	container_type = /obj/structure/closet/crate/medical/blood
	container_name = "BloodPack crate"

/datum/supply_pack/nanotrasen/medical/bodybag
	name = "Body bag crate"
	contains = list(
		/obj/item/storage/box/bodybags = 3,
	)
	worth = 125
	container_type = /obj/structure/closet/crate/medical
	container_name = "Body bag crate"

/datum/supply_pack/nanotrasen/medical/cryobag
	name = "Stasis bag crate"
	contains = list(
		/obj/item/bodybag/cryobag = 3,
	)
	worth = 120
	container_type = /obj/structure/closet/crate/medical
	container_name = "Stasis bag crate"

/datum/supply_pack/nanotrasen/medical/surgery
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
		/obj/item/surgical/circular_saw,
	)
	worth = 300
	container_type = /obj/structure/closet/crate/corporate/nanomed
	container_name = "Surgery crate"

/datum/supply_pack/nanotrasen/medical/deathalarm
	name = "Death Alarm crate"
	contains = list(
		/obj/item/storage/box/cdeathalarm_kit,
		/obj/item/storage/box/cdeathalarm_kit,
	)
	worth = 750
	container_type = /obj/structure/closet/crate/corporate/veymed

/datum/supply_pack/nanotrasen/medical/clotting
	name = "Clotting Medicine crate"
	contains = list(
		/obj/item/storage/firstaid/clotting,
	)
	worth = 750 // "it's too high" go rebalance IB to not be a 5 minute death sentence, don't add chemicals to nullify it then
	container_type = /obj/structure/closet/crate/corporate/zenghu

/datum/supply_pack/nanotrasen/medical/sterile
	name = "Sterile equipment crate"
	contains = list(
		/obj/item/clothing/under/rank/medical/scrubs/green = 2,
		/obj/item/clothing/head/surgery/green = 2,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
		/obj/item/storage/belt/medical = 3,
	)
	worth = 150

/datum/supply_pack/nanotrasen/medical/extragear
	name = "Medical surplus equipment"
	contains = list(
		/obj/item/storage/belt/medical = 3,
		/obj/item/clothing/glasses/hud/health = 3,
		/obj/item/radio/headset/headset_med/alt = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 3,
	)
	worth = 150
	container_type = /obj/structure/closet/crate/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/cmogear
	name = "Chief medical officer equipment"
	contains = list(
		/obj/item/storage/belt/medical,
		/obj/item/radio/headset/heads/cmo,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/storage/hypokit/advanced/cmo/full/loaded,
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
		/obj/item/reagent_containers/syringe,
	)
	worth = 1000 // don't lose your shit
	container_type = /obj/structure/closet/crate/secure/corporate/nanomed
	container_name = "Chief medical officer equipment"
	container_access = list(
		/datum/access/station/medical/cmo,
	)

/datum/supply_pack/nanotrasen/medical/doctorgear
	name = "Medical Doctor Equipment"
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
		/obj/item/reagent_containers/syringe,
	)
	worth = 450
	container_type = /obj/structure/closet/crate/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/chemistgear
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
		/obj/item/storage/box/syringes,
		/obj/item/storage/hypokit/full/loaded,
	)
	worth = 450
	container_type = /obj/structure/closet/crate/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/paramedicgear
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
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/storage/hypokit/full/loaded,
	)
	worth = 450
	container_type = /obj/structure/closet/crate/secure/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/psychiatristgear
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
		/obj/item/cartridge/medical,
	)
	worth = 450
	container_type = /obj/structure/closet/crate/secure/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/medicalscrubs
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
		/obj/item/storage/box/gloves,
	)
	worth = 500 // item spam
	container_type = /obj/structure/closet/crate/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/autopsy
	name = "Autopsy equipment"
	contains = list(
		/obj/item/folder/white,
		/obj/item/camera,
		/obj/item/camera_film = 2,
		/obj/item/autopsy_scanner,
		/obj/item/surgical/scalpel,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
		/obj/item/pen,
	)
	worth = 450
	container_type = /obj/structure/closet/crate/corporate/nanomed
	container_name = "Autopsy equipment crate"

/datum/supply_pack/nanotrasen/medical/medicaluniforms
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
		/obj/item/storage/box/gloves,
	)
	worth = 500 // item spam + CMO coat
	container_type = /obj/structure/closet/crate/corporate/nanomed

/datum/supply_pack/nanotrasen/medical/medicalbiosuits
	name = "Medical biohazard gear"
	contains = list(
		/obj/item/clothing/head/bio_hood = 2,
		/obj/item/clothing/suit/bio_suit = 2,
		/obj/item/clothing/head/bio_hood/virology = 1,
		/obj/item/clothing/suit/bio_suit/virology = 1,
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/mask/gas = 5,
		/obj/item/tank/oxygen = 5,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
	)
	worth = 900 // 4 bio suits what the fuck??
	container_type = /obj/structure/closet/crate/corporate/nanomed
	container_name = "Medical biohazard equipment"

/datum/supply_pack/nanotrasen/medical/portablefreezers
	name = "Portable freezers crate"
	contains = list(
		/obj/item/storage/box/freezer = 7,
	)
	container_type = /obj/structure/closet/crate
	container_name = "Portable freezers"

/datum/supply_pack/nanotrasen/medical/virus
	name = "Virus sample crate"
	contains = list(
		/obj/item/virusdish/random = 4,
	)
	container_type = /obj/structure/closet/crate/secure
	container_name = "Virus sample crate"
	container_access = list(
		/datum/access/station/medical/cmo,
	)

/datum/supply_pack/nanotrasen/medical/defib
	name = "Defibrillator crate"
	contains = list(
		/obj/item/defib_kit = 2,
	)
	container_type = /obj/structure/closet/crate/medical
	container_name = "Defibrillator crate"

/datum/supply_pack/nanotrasen/medical/distillery
	name = "Chemical distiller crate"
	contains = list(
		/obj/machinery/portable_atmospherics/powered/reagent_distillery = 1,
	)
	container_type = /obj/structure/largecrate

/datum/supply_pack/nanotrasen/medical/advdistillery
	name = "Industrial Chemical distiller crate"
	contains = list(
		/obj/machinery/portable_atmospherics/powered/reagent_distillery/industrial = 1,
	)
	container_type = /obj/structure/largecrate

/datum/supply_pack/nanotrasen/medical/oxypump
	name = "Oxygen pump crate"
	contains = list(
		/obj/machinery/oxygen_pump/mobile = 1,
	)
	container_type = /obj/structure/largecrate

/datum/supply_pack/nanotrasen/medical/anestheticpump
	name = "Anesthetic pump crate"
	contains = list(
		/obj/machinery/oxygen_pump/mobile/anesthetic = 1,
	)
	container_type = /obj/structure/largecrate

/datum/supply_pack/nanotrasen/medical/stablepump
	name = "Portable stabilizer crate"
	contains = list(
		/obj/machinery/oxygen_pump/mobile/stabilizer = 1,
	)
	container_type = /obj/structure/largecrate


/datum/supply_pack/nanotrasen/medical/compactdefib
	name = "Compact Defibrillator crate"
	contains = list(
		/obj/item/defib_kit/compact = 1,
	)
	container_type = /obj/structure/closet/crate/secure/corporate/nanomed
	container_name = "Compact Defibrillator crate"

/datum/supply_pack/nanotrasen/medical/medigun
	name = "Cell-Loaded Medigun crate"
	contains = list(
		/obj/item/gun/projectile/ballistic/microbattery/vm_aml = 1,
		/obj/item/ammo_magazine/microbattery/vm_aml = 1,
	)
	worth = 1500
	container_type = /obj/structure/closet/crate/secure/corporate/veymed
	container_name = "Cell-Loaded Medigun crate"

/datum/supply_pack/nanotrasen/medical/medigun_cells
	name = "Cell-Loaded Medigun Cell Pack crate"
	contains = list(
		/obj/item/ammo_casing/microbattery/vm_aml/brute = 3,
		/obj/item/ammo_casing/microbattery/vm_aml/burn = 3,
		/obj/item/ammo_casing/microbattery/vm_aml/stabilize = 3,
	)
	worth = 1000
	container_type = /obj/structure/closet/crate/secure/corporate/veymed
	container_name = "Cell-Loaded Medigun Cell Pack crate"
