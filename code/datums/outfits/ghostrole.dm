//Outfits for ghost roles!
//Ashlanders!
/datum/outfit/ashlander
	name = "Ashlander - Debug"
	uniform = /obj/item/clothing/under/tribal_tunic/ashlander
	shoes = /obj/item/clothing/shoes/footwraps
	back = /obj/item/storage/backpack/satchel/bone

/datum/outfit/ashlander/nomad
	name = "Ashlander - Nomad"
	belt = /obj/item/material/knife/tacknife/combatknife/bone
	r_hand = /obj/item/material/twohanded/spear/bone

/datum/outfit/ashlander/craftsman
	name = "Ashlander - Craftsman"
	shoes = /obj/item/clothing/shoes/ashwalker
	belt = /obj/item/pickaxe/bone
	r_hand = /obj/item/storage/bag/ore/ashlander

/datum/outfit/ashlander/farmer
	name = "Ashlander - Farmer"
	shoes = /obj/item/clothing/shoes/ashwalker
	gloves = /obj/item/clothing/gloves/goliath
	l_pocket = /obj/item/material/knife/machete/hatchet/bone
	r_hand = /obj/item/reagent_containers/glass/stone
	l_hand = /obj/item/storage/bag/plants/ashlander

/datum/outfit/ashlander/hunter
	name = "Ashlander - Hunter"
	suit = /obj/item/clothing/suit/armor/ashlander
	shoes = /obj/item/clothing/shoes/ashwalker
	belt = /obj/item/storage/belt/quiver/full/ash
	back = /obj/item/gun/ballistic/bow/ashen
	r_hand = /obj/item/material/knife/tacknife/combatknife/bone

/datum/outfit/ashlander/merchant
	name = "Ashlander - Merchant"
	shoes = /obj/item/clothing/shoes/ashwalker
	belt = /obj/item/gun/ballistic/musket/pistol/tribal
	l_hand = /obj/item/storage/box/munition_box
	r_hand = /obj/item/reagent_containers/glass/powder_horn/tribal/filled

/datum/outfit/ashlander/sentry
	name = "Ashlander - Sentry"
	head = /obj/item/clothing/head/helmet/ashlander
	suit = /obj/item/clothing/suit/armor/ashlander
	shoes = /obj/item/clothing/shoes/ashwalker
	belt = /obj/item/reagent_containers/glass/powder_horn/tribal/filled
	r_hand = /obj/item/gun/ballistic/musket/tribal
	l_hand = /obj/item/storage/box/munition_box

/datum/outfit/ashlander/priest
	name = "Ashlander - Priest"
	suit = /obj/item/clothing/suit/ashen_vestment
	belt = /obj/item/melee/ashlander/elder
	l_pocket = /obj/item/elderstone

//Pirates!
/datum/outfit/pirate
	name = "Pirate - Debug"
	uniform = /obj/item/clothing/under/surplus/desert
	suit = /obj/item/clothing/suit/storage/vest/tactical/pirate
	shoes = /obj/item/clothing/shoes/boots/workboots
	back = /obj/item/storage/backpack/rebel
	l_ear = /obj/item/radio/headset/raider
	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/external/pirate

/datum/outfit/pirate/immigrant
	name = "Pirate - Immigrant"
	belt = /obj/item/gun/ballistic/pirate
	r_pocket = /obj/item/melee/energy/sword/pirate

/datum/outfit/pirate/dilettante
	name = "Pirate - Dilettante"
	uniform = /obj/item/clothing/under/surplus
	shoes = /obj/item/clothing/shoes/boots/jackboots
	belt = /obj/item/melee/energy/sword/pirate
	l_hand = /obj/item/shield/makeshift

/datum/outfit/pirate/professional
	name = "Pirate - Professional"
	uniform = /obj/item/clothing/under/surplus/russoblue
	suit = /obj/item/clothing/suit/armor/tactical/pirate
	shoes = /obj/item/clothing/shoes/boots/jackboots
	mask = /obj/item/clothing/mask/balaclava
	belt = /obj/item/gun/energy/zip
	r_pocket = /obj/item/melee/energy/sword/pirate
	r_hand = /obj/item/shield/makeshift

//Traders
/datum/outfit/trader
	name = "Trader"
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/brown
	back = /obj/item/storage/backpack/satchel
	l_ear = /obj/item/radio/headset/trader
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/trader_coveralls
	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/external/merchant	//created a new ID so merchant can open their doors
	pda_slot = SLOT_ID_RIGHT_POCKET
	pda_type = /obj/item/pda/chef //cause I like the look
	id_pda_assignment = "Trader"

/datum/outfit/trader/vox //This needs to be updated.
	name = "Trader - Vox"
	shoes = /obj/item/clothing/shoes/boots/jackboots/toeless
	back = /obj/item/tank/vox
	uniform = /obj/item/clothing/under/vox/vox_robes
	suit = /obj/item/clothing/suit/armor/vox_scrap
	mask = /obj/item/clothing/mask/breath
