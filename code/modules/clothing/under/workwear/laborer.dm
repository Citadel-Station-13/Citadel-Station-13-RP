/**
 * The working mans clothes.
 */

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon = 'icons/clothing/uniform/workwear/laborer/overalls.dmi'
	icon_state = "overalls"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/overalls_fem
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon = 'icons/clothing/uniform/workwear/laborer/overalls_fem.dmi'
	icon_state = "overalls_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/overalls/sleek
	name = "sleek overalls"
	desc = "A set of modern pleather reinforced overalls."
	icon = 'icons/clothing/uniform/workwear/laborer/overalls_sleek.dmi'
	icon_state = "overalls_sleek"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/overalls/sleek_fem
	name = "sleek overalls"
	desc = "A set of modern pleather reinforced overalls."
	icon = 'icons/clothing/uniform/workwear/laborer/overalls_sleek_fem.dmi'
	icon_state = "overalls_sleek_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

//Reuses spritesheet
/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/mechanic.dmi'
	icon_state = "mechanic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/frontier
	name = "frontier clothes"
	desc = "A rugged flannel shirt and denim overalls. A popular style among frontier colonists."
	icon = 'icons/clothing/uniform/workwear/laborer/frontier.dmi'
	icon_state = "frontier"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/utility_fur_pants
	name = "Utility Fur Pants"
	desc = "A pair of pants designed to match the Utility Fur coat."
	icon = 'icons/clothing/uniform/workwear/laborer/furup.dmi'
	icon_state = "furup"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Reuses spritesheet
/obj/item/clothing/under/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon = 'icons/clothing/uniform/workwear/oricon/utility/black.dmi'
	icon_state = "black"
	armor_type = /datum/armor/none
	siemens_coefficient = 0.9
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Reuses spritesheet
/obj/item/clothing/under/utility/blue
	name = "utility uniform"
	desc = "A comfortable blue utility jumpsuit."
	icon = 'icons/clothing/uniform/workwear/oricon/utility/navy.dmi'
	icon_state = "navy"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Reuses spritesheet
/obj/item/clothing/under/utility/grey
	name = "utility uniform"
	desc = "A comfortable grey utility jumpsuit."
	icon = 'icons/clothing/uniform/workwear/oricon/utility/grey.dmi'
	icon_state = "grey"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

//Reuses spritesheet
/obj/item/clothing/under/navy_gray
	name = "navy gray jumpsuit"
	desc = "A light grey-blue jumpsuit resembling those worn in the Navy, without any of the traditional markings."
	icon = 'icons/clothing/uniform/workwear/oricon/utility/lightnavy.dmi'
	icon_state = "lightnavy"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
