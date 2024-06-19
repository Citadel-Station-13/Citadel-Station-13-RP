
//Misc

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	snowflake_worn_state = "hazard"
	siemens_coefficient = 0.8
	armor_type = /datum/armor/engineering/jumpsuit
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	snowflake_worn_state = "sterile"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit

//Pirate Mate Fatigues
/obj/item/clothing/under/worn_fatigues
	name = "special ops fatigues"
	desc = "These worn fatigues match the pattern known to be used by JSDF Marine Corps special forces."
	icon_state = "russobluecamo"

/obj/item/clothing/under/onestar
	name = "one star jumpsuit"
	desc = "A jumpsuit in One Star colours."
	icon = 'icons/clothing/uniform/misc/onestar.dmi'
	icon_state = "os_jumpsuit"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/under/iwlcommissar
	name = "commissar uniform"
	desc = "A decorated uniform belonging to a political officer. Red stripes on the shoulderpads denote their political affiliation to the All-Labor United Front."
	icon = 'icons/clothing/uniform/misc/iwluni.dmi'
	icon_state = "iwl_comm_uniform"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/under/iwlofficer
	name = "officer's uniform"
	desc = "A decorated uniform belonging to a normal officer. Padded for cold Vorodzhian winters"
	icon = 'icons/clothing/uniform/misc/iwluni.dmi'
	icon_state = "iwl_off_uniform"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/under/iwluniform
	name = "soldiery uniform"
	desc = "Green fatigues for conscripted Leaguer youth. "
	icon = 'icons/clothing/uniform/misc/iwluni.dmi'
	icon_state = "iwl_uniform"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
