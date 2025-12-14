/obj/item/clothing/suit/technomancer
	name = "chrome manipulation suit"
	desc = "It's a very shiny and somewhat protective suit, built to help carry cores on the user's back."
	icon_state = "technomancer_suit"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|FEET|HANDS
	armor_type = /datum/armor/technomancer/standard
	siemens_coefficient = 0.75

/obj/item/clothing/under/technomancer
	name = "initiate's jumpsuit"
	desc = "It's a blue colored jumpsuit.  There appears to be light-weight armor padding underneath, providing some protection.  \
	There is also a healthy amount of insulation underneath."
	icon = 'icons/clothing/uniform/workwear/technomancer/initiate.dmi'
	icon_state = "initiate"
	armor_type = /datum/armor/technomancer/jumpsuit
	siemens_coefficient = 0.3
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/technomancer/apprentice
	name = "apprentice's jumpsuit"
	desc = "It's a blue colored jumpsuit with some silver markings.  There appears to be light-weight armor padding \
	underneath, providing some protection.  There is also a healthy amount of insulation underneath."
	icon = 'icons/clothing/uniform/workwear/technomancer/apprentice.dmi'
	icon_state = "apprentice"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/technomancer/master
	name = "master's jumpsuit"
	desc = "It's a blue colored jumpsuit with some gold markings.  There appears to be light-weight armor padding \
	underneath, providing some protection.  There is also a healthy amount of insulation underneath."
	icon = 'icons/clothing/uniform/workwear/technomancer/technomancer.dmi'
	icon_state = "technomancer"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/head/technomancer
	name = "initiate's hat"
	desc = "It's a somewhat silly looking blue pointed hat."
	icon_state = "initiate"
	armor_type = /datum/armor/technomancer/standard
	siemens_coefficient = 0.3

/obj/item/clothing/head/technomancer/apprentice
	name = "apprentice's hat"
	desc = "It's a somewhat silly looking blue pointed hat.  This one has a silver colored metalic feather strapped to it."
	icon_state = "apprentice"

/obj/item/clothing/head/technomancer/master
	name = "master's hat"
	desc = "It's a somewhat silly looking blue pointed hat.  This one has a gold colored metalic feather strapped to it."
	icon_state = "technomancer"
