/// under items
GLOBAL_LIST_INIT(clothing_under, generate_chameleon_choices(/obj/item/clothing/under,
	list(/obj/item/clothing/under/gimmick, /obj/item/clothing/under/chameleon)))
// hats
GLOBAL_LIST_INIT(clothing_head, generate_chameleon_choices(/obj/item/clothing/head,
	list(/obj/item/clothing/head/chameleon, /obj/item/clothing/head/justice)))
// suits
GLOBAL_LIST_INIT(clothing_suit, generate_chameleon_choices(/obj/item/clothing/suit,
	list(/obj/item/clothing/suit/cyborg_suit, /obj/item/clothing/suit/chameleon, /obj/item/clothing/suit/justice, /obj/item/clothing/suit/greatcoat)))
// shoes
GLOBAL_LIST_INIT(clothing_shoes, generate_chameleon_choices(/obj/item/clothing/shoes,
	list(/obj/item/clothing/shoes/syndigaloshes, /obj/item/clothing/shoes/chameleon, /obj/item/clothing/shoes/cyborg, /obj/item/clothing/shoes/leg_guard/combat/imperial)))
// backpacks
GLOBAL_LIST_INIT(clothing_backpack, generate_chameleon_choices(/obj/item/storage/backpack,
	list(/obj/item/storage/backpack/chameleon, /obj/item/storage/backpack/satchel/withwallet)))
// gloves
GLOBAL_LIST_INIT(clothing_gloves, generate_chameleon_choices(/obj/item/clothing/gloves,
	list(/obj/item/clothing/gloves/chameleon)))
// masks
GLOBAL_LIST_INIT(clothing_mask, generate_chameleon_choices(/obj/item/clothing/mask,
	list(/obj/item/clothing/mask/chameleon)))
// glasses
GLOBAL_LIST_INIT(clothing_glasses, generate_chameleon_choices(/obj/item/clothing/glasses,
	list(/obj/item/clothing/glasses/chameleon)))
// belts
GLOBAL_LIST_INIT(clothing_belt, generate_chameleon_choices(/obj/item/storage/belt,
	list(/obj/item/storage/belt/chameleon)))
// accessories
GLOBAL_LIST_INIT(clothing_accessory, generate_chameleon_choices(/obj/item/clothing/accessory,
	list(/obj/item/clothing/accessory/chameleon)))

GLOBAL_LIST_INIT(clothing_ears, generate_chameleon_choices(/obj/item/clothing/ears))

GLOBAL_LIST_INIT(clothing_headsets, generate_chameleon_choices(/obj/item/radio/headset))

// clothing you shouldn't be able to obtain through normal means (i.e. random loot)
GLOBAL_LIST_INIT(restricted_clothing, list(
	// holosphere items which have quirky behaviour
	/obj/item/clothing/under/chameleon/holosphere,
	/obj/item/clothing/suit/chameleon/holosphere,
	/obj/item/clothing/head/chameleon/holosphere,
	/obj/item/clothing/shoes/chameleon/holosphere,
	/obj/item/clothing/gloves/chameleon/holosphere,
	/obj/item/clothing/mask/chameleon/holosphere,
	// admin-spawn stuff
	/obj/item/clothing/under/acj,

))
