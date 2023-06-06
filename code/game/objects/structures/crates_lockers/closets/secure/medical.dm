/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical junk."
	closet_appearance = /singleton/closet_appearance/secure_closet/medical
	req_access = list(ACCESS_MEDICAL_MAIN)

	starts_with = list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 2,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 2)


/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	closet_appearance = /singleton/closet_appearance/secure_closet/medical/alt
	req_access = list(ACCESS_MEDICAL_SURGERY)

	starts_with = list(
		/obj/item/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3)


/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(ACCESS_MEDICAL_EQUIPMENT)
	closet_appearance = /singleton/closet_appearance/secure_closet/medical

	starts_with = list(
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/nurse,
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/white,
		/obj/item/cartridge/medical,
		/obj/item/radio/headset/headset_med,
		/obj/item/radio/headset/headset_med/alt,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
		/obj/item/clothing/shoes/boots/winter/medical,
		/obj/item/clothing/under/rank/nursesuit,
		/obj/item/clothing/head/nursehat,
		/obj/item/gps/medical,
		/obj/item/storage/box/freezer = 3)

/obj/structure/closet/secure_closet/medical3/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/medic
	else
		starts_with += /obj/item/storage/backpack/satchel/med
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/med
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs
			starts_with += /obj/item/clothing/head/surgery/blue
		if ("green")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/green
			starts_with += /obj/item/clothing/head/surgery/green
		if ("purple")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/purple
			starts_with += /obj/item/clothing/head/surgery/purple
		if ("black")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/black
			starts_with += /obj/item/clothing/head/surgery/black
		if ("navyblue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/navyblue
			starts_with += /obj/item/clothing/head/surgery/navyblue
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs
			starts_with += /obj/item/clothing/head/surgery/blue
		if ("green")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/green
			starts_with += /obj/item/clothing/head/surgery/green
		if ("purple")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/purple
			starts_with += /obj/item/clothing/head/surgery/purple
		if ("black")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/black
			starts_with += /obj/item/clothing/head/surgery/black
		if ("navyblue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/navyblue
			starts_with += /obj/item/clothing/head/surgery/navyblue
	return ..()


/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	closet_appearance = /singleton/closet_appearance/secure_closet/medical/paramedic
	req_access = list(ACCESS_MEDICAL_EQUIPMENT)

	starts_with = list(
		/obj/item/storage/backpack/dufflebag/emt,
		/obj/item/clothing/under/bodysuit/bodysuitemt,
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/antitoxin,
		/obj/item/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/suit/storage/toggle/labcoat/emt,
		/obj/item/radio/headset/headset_med/alt,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/para,
		/obj/item/cartridge/medical,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/flashlight,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/healthanalyzer,
		/obj/item/radio/off,
		/obj/random/medical,
		/obj/item/tool/crowbar,
		/obj/item/gps/medical,
		/obj/item/extinguisher/mini,
		/obj/item/storage/box/freezer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/barrier_tape_roll/medical,
		/obj/item/storage/lockbox/limb_plate/emt)

/obj/structure/closet/secure_closet/paramedic/Initialize(mapload)
	starts_with += /obj/item/gps/medical
	return ..()

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(ACCESS_MEDICAL_CMO)
	closet_appearance = /singleton/closet_appearance/secure_closet/cmo

	starts_with = list(
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/under/rank/chief_medical_officer/skirt,
		/obj/item/clothing/under/rank/chief_medical_officer/skirt_pleated,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/cartridge/cmo,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/clothing/shoes/brown	,
		/obj/item/radio/headset/heads/cmo,
		/obj/item/radio/headset/heads/cmo/alt,
		/obj/item/flash,
		/obj/item/reagent_containers/hypospray/vial,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo,
		/obj/item/clothing/shoes/boots/winter/medical,
		/obj/item/storage/box/freezer,
		/obj/item/clothing/mask/gas,
		/obj/item/barrier_tape_roll/medical,
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/gps/medical/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/reagent_containers/glass/beaker/vial,
		/obj/item/clothing/under/rank/chief_medical_officer/turtleneck)

/obj/structure/closet/secure_closet/CMO/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/storage/backpack/medic
	else
		starts_with += /obj/item/storage/backpack/satchel/med
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/med
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs
			starts_with += /obj/item/clothing/head/surgery/blue
		if ("green")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/green
			starts_with += /obj/item/clothing/head/surgery/green
		if ("purple")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/purple
			starts_with += /obj/item/clothing/head/surgery/purple
		if ("black")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/black
			starts_with += /obj/item/clothing/head/surgery/black
		if ("navyblue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/navyblue
			starts_with += /obj/item/clothing/head/surgery/navyblue
	return ..()


/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(ACCESS_MEDICAL_SURGERY)

	starts_with = list(
		/obj/item/assembly/signaler,
		/obj/item/radio/electropack = 3)


/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	closet_appearance = /singleton/closet_appearance/secure_closet/medical/chemicals
	req_access = list(ACCESS_MEDICAL_CHEMISTRY)

	starts_with = list(
		/obj/item/storage/box/pillbottles = 2,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 2,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 2,
		/obj/item/storage/fancy/vials)


/obj/structure/closet/secure_closet/psych
	name = "psychiatric closet"
	desc = "Store psychology tools and medicines in here."
	closet_appearance = /singleton/closet_appearance/secure_closet/medical
	req_access = list(ACCESS_MEDICAL_PSYCH)

	starts_with = list(
		/obj/item/clothing/under/rank/psych,
		/obj/item/clothing/under/rank/psych/turtleneck,
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/reagent_containers/glass/bottle/stoxin,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle/citalopram,
		/obj/item/reagent_containers/pill/methylphenidate,
		/obj/item/clipboard,
		/obj/item/folder/white,
		/obj/item/tape_recorder,
		/obj/item/cassette_tape/random = 3,
		/obj/item/camera,
		/obj/item/toy/plushie/therapy/blue)


/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	closet_appearance = /singleton/closet_appearance/wall/medical
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(ACCESS_MEDICAL_EQUIPMENT)

/obj/structure/closet/secure_closet/medical_wall/pills
	name = "pill cabinet"

	starts_with = list(
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/storage/pill_bottle/carbon,
		/obj/random/medical/pillbottle)


/obj/structure/closet/secure_closet/medical_wall/anesthetics
	name = "anesthetics wall closet"
	desc = "Used to knock people out."
	req_access = list(ACCESS_MEDICAL_SURGERY)

	starts_with = list(
		/obj/item/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3)

/obj/structure/closet/secure_closet/medical_wall/synth_anesthetics
	name = "robotics anesthetics wall closet"
	desc = "Used to knock people out."
	req_access = list(ACCESS_SCIENCE_ROBOTICS)

	starts_with = list(
		/obj/item/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3)
