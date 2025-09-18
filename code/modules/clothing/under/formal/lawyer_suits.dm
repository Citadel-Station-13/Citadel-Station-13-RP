/**
 * This would be workwear, but we don't actually have lawyers, so they're just nice suits. But we might want to keep the designation? Ce la vie
 */

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "lawyer suit"

/obj/item/clothing/under/lawyer/black
	name = "black lawyer suit"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_black.dmi'
	icon_state = "lawyer_black"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/black/skirt
	name = "black lawyer skirt"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_black_skirt.dmi'
	icon_state = "lawyer_black_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//REUSES SPRITESHEET
/obj/item/clothing/under/lawyer/female
	name = "black lawyer suit"
	icon = 'icons/clothing/uniform/formal/suits/black_suit_fem.dmi'
	icon_state = "black_suit_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/red
	name = "red lawyer suit"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_red.dmi'
	icon_state = "lawyer_red"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/red/skirt
	name = "red lawyer skirt"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_red_skirt.dmi'
	icon_state = "lawyer_red_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/blue
	name = "blue lawyer suit"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_blue.dmi'
	icon_state = "lawyer_blue"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/blue/skirt
	name = "blue lawyer skirt"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_blue_skirt.dmi'
	icon_state = "lawyer_blue_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/bluesuit
	name = "blue suit"
	desc = "A classy suit."
	icon = 'icons/clothing/uniform/formal/lawyer_suits/bluesuit.dmi'
	icon_state = "bluesuit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/red)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/lawyer/bluesuit/skirt
	name = "blue skirt suit"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/bluesuit_skirt.dmi'
	icon_state = "bluesuit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/purpsuit
	name = "purple suit"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_purp.dmi'
	icon_state = "lawyer_purp"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/purpsuit/skirt
	name = "purple skirt suit"
	icon = 'icons/clothing/uniform/formal/lawyer_suits/lawyer_purp_skirt.dmi'
	icon_state = "lawyer_purp_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/lawyer/oldman
	name = "Old Man's Suit"
	desc = "A classic suit for the older gentleman, with built in back support."
	icon = 'icons/clothing/uniform/formal/lawyer_suits/oldman.dmi'
	icon_state = "oldman"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oldwoman
	name = "Old Woman's Attire"
	desc = "A typical outfit for the older woman, a lovely cardigan and comfortable skirt."
	icon = 'icons/clothing/uniform/formal/lawyer_suits/oldwoman.dmi'
	icon_state = "oldwoman"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
