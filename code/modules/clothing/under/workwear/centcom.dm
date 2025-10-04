/**
 * The refined uniforms of Central Command.
 */

/obj/item/clothing/under/rank/centcom
	name = "\improper CentCom Officer uniform"
	desc = "The formal uniform of the Central Command Officer. Striking and recognizable, it radiates authority."
	icon = 'icons/clothing/uniform/workwear/centcom/officer.dmi'
	icon_state = "officer"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/fem
	icon = 'icons/clothing/uniform/workwear/centcom/officer_fem.dmi'
	icon_state = "officer_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/representative
	name = "\improper CentCom Representative uniform"
	desc = "The formal uniform of the Central Command Representative. These guys must be really important."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom.dmi'
	icon_state = "centcom"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_TESHARI, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/centcom/representative/fem
	name = "\improper CentCom Representative uniform"
	desc = "The formal uniform of the Central Command Representative. These guys must be really important."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom_fem.dmi'
	icon_state = "centcom_fem"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/centcom/green
	displays_id = FALSE

/obj/item/clothing/under/rank/centcom/green/commander
	name = "\improper CentCom officer's suit"
	desc = "It's a suit worn by CentCom's highest-tier Commanders."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom_commander.dmi'
	icon_state = "centcom_commander"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/green/intern
	name = "\improper CentCom intern's jumpsuit"
	desc = "It's a jumpsuit worn by those interning for CentCom. The top is styled after a polo shirt for easy identification."
	icon = 'icons/clothing/uniform/workwear/centcom/intern.dmi'
	icon_state = "intern"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/green/officer
	name = "\improper CentCom turtleneck suit"
	desc = "A casual, yet refined green turtleneck, used by CentCom Officials. It has a fragrance of aloe."
	icon = 'icons/clothing/uniform/workwear/centcom/officer_green.dmi'
	icon_state = "officer_green"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/green/officer_skirt
	name = "\improper CentCom turtleneck skirt"
	desc = "A skirt version of the CentCom turtleneck, rarer and more sought after than the original."
	icon = 'icons/clothing/uniform/workwear/centcom/officer_skirt.dmi'
	icon_state = "officer_skirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/green/centcom_skirt
	name = "\improper CentCom officer's suitskirt"
	desc = "It's a suitskirt worn by CentCom's highest-tier Commanders."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom_skirt.dmi'
	icon_state = "centcom_skirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/rank/centcom/military
	name = "tactical combat uniform"
	desc = "A dark colored uniform worn by CentCom's conscripted military forces."
	icon = 'icons/clothing/uniform/workwear/centcom/military.dmi'
	icon_state = "military"
	armor_type = /datum/armor/military/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/rank/centcom/military/eng
	name = "tactical engineering uniform"
	desc = "A dark colored uniform worn by CentCom's regular military engineers."
	icon = 'icons/clothing/uniform/workwear/centcom/military_eng.dmi'
	icon_state = "military_eng"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon = 'icons/clothing/uniform/workwear/centcom/ert_uniform.dmi'
	icon_state = "ert_uniform"
	armor_type = /datum/armor/centcom/jumpsuit
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI, BODYTYPE_VOX)
	worn_rolldown_bodytypes = BODYTYPES(BODYTYPE_DEFAULT, BODYTYPE_UNATHI_DIGI)
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/para
	name = "PARA tactical uniform"
	desc = "A standard grey jumpsuit, emblazoned with the Icon of the PMD. Close inspection of the embroidery reveals a complex web of glyphs written in an unknown language."
	icon = 'icons/clothing/uniform/workwear/centcom/para_ert_uniform.dmi'
	icon_state = "para_ert_uniform"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/pmd
	name = "PMD uniform"
	desc = "A black uniform whose back is emblazoned with the Icon of the PMD. Close inspection of the silver embroidery reveals a complex web of glyphs written in an unknown language."
	icon = 'icons/clothing/uniform/workwear/centcom/pmd_uniform.dmi'
	icon_state = "pmd_uniform"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/gov
	desc = "A neat proper uniform of someone on offical business. The collar is <i>immaculately</i> starched."
	name = "Green formal uniform"
	icon = 'icons/clothing/uniform/workwear/centcom/greensuit.dmi'
	icon_state = "greensuit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/darkgreen)
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_rollsleeve_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)

/obj/item/clothing/under/gov/skirt
	name = "Green formal skirt uniform"
	desc = "A neat proper uniform of someone on offical business. The top button is sewn shut."
	icon = 'icons/clothing/uniform/workwear/centcom/greensuit_skirt.dmi'
	icon_state = "greensuit_skirt"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/**
 * Customs
 */

/obj/item/clothing/under/customs
	name = "customs uniform"
	desc = "A standard OriCon customs uniform.  Complete with epaulettes."
	icon = 'icons/clothing/uniform/workwear/centcom/cu_suit.dmi'
	icon_state = "cu_suit"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"

/obj/item/clothing/under/customs/khaki
	icon = 'icons/clothing/uniform/workwear/centcom/cu_suit_kh.dmi'
	icon_state = "cu_suit_kh"
	worn_bodytypes = BODYTYPES(BODYTYPE_DEFAULT)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL
	inhand_icon = 'icons/clothing/uniform/workwear/basic_colored_jumpsuit.dmi'
	inhand_state = "grey"
