/**
 * Non-food related services like Chaplain, Librarian, IAA, aka dweebs.
 */

/obj/item/clothing/under/rank/chaplain
	desc = "It's a black jumpsuit, often worn by religious folk."
	name = "chaplain's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/service/chaplain.dmi'
	icon_state = "chaplain"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/chaplain/skirt_pleated
	name = "chaplain's pleated skirt"
	icon = 'icons/clothing/uniform/workwear/service/chaplain_skirt.dmi'
	icon_state = "chaplain_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/internalaffairs
	desc = "The plain, professional attire of an Internal Affairs Agent. The collar is <i>immaculately</i> starched."
	name = "Internal Affairs uniform"
	icon = 'icons/clothing/uniform/workwear/service/internalaffairs.dmi'
	icon_state = "internalaffairs"
	starting_accessories = list(/obj/item/clothing/accessory/tie/black)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/internalaffairs/skirt
	desc = "The plain, professional attire of an Internal Affairs Agent. The top button is sewn shut."
	name = "Internal Affairs skirt"
	icon = 'icons/clothing/uniform/workwear/service/internalaffairs_skirt.dmi'
	icon_state = "internalaffairs_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//reuses spritesheet
/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon = 'icons/clothing/uniform/formal/suits/red_suit.dmi'
	icon_state = "red_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
