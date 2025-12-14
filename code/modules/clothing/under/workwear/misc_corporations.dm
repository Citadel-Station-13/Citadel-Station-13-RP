/**
 * Workwear for corporations other than NT. If one corporation gets many items split it off into its own file.
 */

/obj/item/clothing/under/brandjumpsuit/aether
	name = "\improper Aether jumpsuit"
	desc = "A jumpsuit belonging to Aether Atmospherics and Recycling, a Trans-Stellar that supplies recycling and atmospheric systems to colonies."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/aether.dmi'
	icon_state = "aether"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/pcrc
	name = "\improper PCRC uniform"
	desc = "A uniform belonging to Proxima Centauri Risk Control, a private security firm."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/pcrc.dmi'
	icon_state = "pcrc"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

/obj/item/clothing/under/pcrc_fem
	name = "\improper PCRC uniform"
	desc = "A uniform belonging to Proxima Centauri Risk Control, a private security firm."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/pcrc_fem.dmi'
	icon_state = "pcrc_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/brandjumpsuit/grayson
	name = "\improper Grayson overalls"
	desc = "A set of overalls belonging to Grayson Manufactories, a mining Trans-Stellar."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/mechanic.dmi'
	icon_state = "mechanic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

//Reuses spritesheet
/obj/item/clothing/under/trader_coveralls
	name = "nebula gas outfit"
	desc = "A hardy and practical uniform distributed to Nebula Gas employees, meant to provide protection and comfort in industrial environments."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/mechanic.dmi'
	icon_state = "mechanic"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)

//Reuses spritesheet
/obj/item/clothing/under/brandjumpsuit/wardt
	name = "\improper Ward-Takahashi jumpsuit"
	desc = "A jumpsuit belonging to Ward-Takahashi, a Trans-Stellar in the consumer goods market."
	icon = 'icons/clothing/uniform/workwear/dept_science/robotics2.dmi'
	icon_state = "robotics2"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/brandjumpsuit/mbill
	name = "\improper Major Bill's uniform"
	desc = "A uniform belonging to Major Bill's Transportation, a shipping megacorporation."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/mbill.dmi'
	icon_state = "mbill"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/major_bills)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/confederacy
	name = "\improper Confederacy uniform"
	desc = "A military uniform belonging to the Confederacy of Man, an independent human government." //Name pending review
	icon = 'icons/clothing/uniform/workwear/misc_corporations/confed.dmi'
	icon_state = "confed"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/saare
	name = "SAARE uniform"
	desc = "A dress uniform belonging to Stealth Assault Enterprises, a minor private military corporation." //Name pending review
	icon = 'icons/clothing/uniform/workwear/misc_corporations/saare.dmi'
	icon_state = "saare"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/saare_fem
	name = "SAARE uniform"
	desc = "A dress uniform belonging to Stealth Assault Enterprises, a minor private military corporation."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/saare_fem.dmi'
	icon_state = "saare_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/brandjumpsuit/focal
	name = "\improper Focal Point jumpsuit"
	desc = "A jumpsuit belonging to Focal Point Energistics, an engineering megacorporation."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/focal.dmi'
	icon_state = "focal"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/brandjumpsuit/hephaestus
	name = "\improper Hephaestus jumpsuit"
	desc = "A jumpsuit belonging to Hephaestus Industries, a Trans-Stellar best known for its arms production."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/heph.dmi'
	icon_state = "heph"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/brandjumpsuit/hephaestus_fem
	name = "\improper Hephaestus jumpsuit (female)"
	desc = "A jumpsuit belonging to Hephaestus Industries, a Trans-Stellar best known for its arms production."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/heph_fem.dmi'
	icon_state = "heph_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/brandjumpsuit/guardian_inc
	name = "\improper Guardian Inc Work outfit"
	desc = "A jumpsuit of the Guardian Inc salvage company."
	icon = 'icons/clothing/uniform/workwear/misc_corporations/guardian.dmi'
	icon_state = "guardian"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
