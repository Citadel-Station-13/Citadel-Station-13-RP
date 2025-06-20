/**
 * Bar, Kitchen, Hydroponics Uniforms
 * Spiritual grouping of items, there aren't enough to give them their own file and they are arguably all closely related enough to go in the same file.
 */

/obj/item/clothing/under/rank/bartender
	desc = "It looks like it could use some more flair."
	name = "bartender's uniform"
	icon = 'icons/clothing/uniform/workwear/service/ba_suit.dmi'
	icon_state = "ba_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/bartender/skirt
	desc = "Short and cute."
	name = "bartender's skirt"
	icon = 'icons/clothing/uniform/workwear/service/ba_suit_skirt.dmi'
	icon_state = "ba_suit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/bartender/skirt_pleated
	name = "bartender's pleated skirt"
	desc = "Short, and to the point."
	icon = 'icons/clothing/uniform/workwear/service/barman_skirt.dmi'
	icon_state = "barman_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/btcbartender
	name = "BTC Bartender"
	desc = "For the classy bartender who converts their paychecks into Spesscoin."
	icon = 'icons/clothing/uniform/workwear/service/btc_bartender.dmi'
	icon_state = "btc_bartender"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/chef
	desc = "It's an apron which is given only to the most <b>hardcore</b> chefs in space."
	name = "chef's uniform"
	icon = 'icons/clothing/uniform/workwear/service/chef.dmi'
	icon_state = "chef"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/chef/skirt_pleated
	name = "chef's pleated skirt"
	desc = "It's a skirt of which is given only to the most <b>ludicrous</b> of spacebound chefs."
	icon = 'icons/clothing/uniform/workwear/service/chef_skirt.dmi'
	icon_state = "chef_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/service/hydroponics.dmi'
	icon_state = "hydroponics"
	permeability_coefficient = 0.50
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/hydroponics/skirt_pleated
	name = "botanist's pleated skirt"
	icon = 'icons/clothing/uniform/workwear/service/hydroponics_skirt.dmi'
	icon_state = "hydroponics_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tips."
	icon = 'icons/clothing/uniform/workwear/service/waiter.dmi'
	icon_state = "waiter"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/waiter_fem
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tips."
	icon = 'icons/clothing/uniform/workwear/service/waiter_fem.dmi'
	icon_state = "waiter_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
