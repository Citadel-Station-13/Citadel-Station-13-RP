/**
 * Workwear for the janitors
 */

//This maid outfit is an actual janitor uniform, so it goes here instead of costumes.
/obj/item/clothing/under/dress/maid/janitor
	name = "maid uniform"
	desc = "A simple maid uniform for housekeeping."
	icon = 'icons/clothing/uniform/workwear/janitor/janimaid.dmi'
	icon_state = "janimaid"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/janitor
	desc = "It's the official uniform of the station's janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon = 'icons/clothing/uniform/workwear/janitor/janitor.dmi'
	icon_state = "janitor"
	armor_type = /datum/armor/civilian/jumpsuit/janitor
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/rank/janitor_fem
	name = "janitor's jumpsuit"
	desc = "It's the official uniform of the station's janitor. It has minor protection from biohazards."
	icon = 'icons/clothing/uniform/workwear/janitor/janitor_fem.dmi'
	icon_state = "janitor_fem"
	armor_type = /datum/armor/civilian/jumpsuit/janitor
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/janitor/skirt_pleated
	name = "janitor's pleated skirt"
	desc = "The official pleated skirt of the local janitor. It bears minor protection from biohazards."
	icon = 'icons/clothing/uniform/workwear/janitor/janitor_skirt.dmi'
	icon_state = "janitor_skirt"
	armor_type = /datum/armor/civilian/jumpsuit/janitor
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/janitor/starcon
	name = "janitor's uniform"
	desc = "It's the official uniform of the station's janitor with minor modifications. It has minor protection from biohazards, but not from the harshness of space."
	icon = 'icons/clothing/uniform/workwear/janitor/janitor_sc.dmi'
	icon_state = "janitor_sc"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
