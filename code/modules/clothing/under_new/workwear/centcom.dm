/**
 * The refined uniforms of Central Command.
 */

/obj/item/clothing/under/rank/centcom
	name = "\improper CentCom Officer uniform"
	desc = "The formal uniform of the Central Command Officer. Striking and recognizable, it radiates authority."
	icon = 'icons/clothing/uniform/workwear/centcom/officer.dmi'
	icon_state = "officer"

/obj/item/clothing/under/rank/centcom/fem
	icon = 'icons/clothing/uniform/workwear/centcom/officer_fem.dmi'
	icon_state = "officer_fem"

/obj/item/clothing/under/rank/centcom/representative
	name = "\improper CentCom Representative uniform"
	desc = "The formal uniform of the Central Command Representative. These guys must be really important."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom.dmi'
	icon_state = "centcom"

/obj/item/clothing/under/rank/centcom/representative/fem
	name = "\improper CentCom Representative uniform"
	desc = "The formal uniform of the Central Command Representative. These guys must be really important."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom_fem.dmi'
	icon_state = "centcom_fem"

/obj/item/clothing/under/rank/centcom/green
	displays_id = FALSE

/obj/item/clothing/under/rank/centcom/green/commander
	name = "\improper CentCom officer's suit"
	desc = "It's a suit worn by CentCom's highest-tier Commanders."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom_commander.dmi'
	icon_state = "centcom_commander"

/obj/item/clothing/under/rank/centcom/green/intern
	name = "\improper CentCom intern's jumpsuit"
	desc = "It's a jumpsuit worn by those interning for CentCom. The top is styled after a polo shirt for easy identification."
	icon = 'icons/clothing/uniform/workwear/centcom/intern.dmi'
	icon_state = "intern"

/obj/item/clothing/under/rank/centcom/green/officer
	name = "\improper CentCom turtleneck suit"
	desc = "A casual, yet refined green turtleneck, used by CentCom Officials. It has a fragrance of aloe."
	icon = 'icons/clothing/uniform/workwear/centcom/officer_green.dmi'
	icon_state = "officer_green"

/obj/item/clothing/under/rank/centcom/green/officer_skirt
	name = "\improper CentCom turtleneck skirt"
	desc = "A skirt version of the CentCom turtleneck, rarer and more sought after than the original."
	icon = 'icons/clothing/uniform/workwear/centcom/officer_skirt.dmi'
	icon_state = "officer_skirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/centcom/green/centcom_skirt
	name = "\improper CentCom officer's suitskirt"
	desc = "It's a suitskirt worn by CentCom's highest-tier Commanders."
	icon = 'icons/clothing/uniform/workwear/centcom/centcom_skirt.dmi'
	icon_state = "centcom_skirt"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/centcom/military
	name = "tactical combat uniform"
	desc = "A dark colored uniform worn by CentCom's conscripted military forces."
	icon = 'icons/clothing/uniform/workwear/centcom/military.dmi'
	icon_state = "military"
	armor_type = /datum/armor/military/jumpsuit

/obj/item/clothing/under/rank/centcom/military/eng
	name = "tactical engineering uniform"
	desc = "A dark colored uniform worn by CentCom's regular military engineers."
	icon = 'icons/clothing/uniform/workwear/centcom/military_eng.dmi'
	icon_state = "military_eng"

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon = 'icons/clothing/uniform/workwear/centcom/ert_uniform.dmi'
	icon_state = "ert_uniform"

/obj/item/clothing/under/gov
	desc = "A neat proper uniform of someone on offical business. The collar is <i>immaculately</i> starched."
	name = "Green formal uniform"
	icon = 'icons/clothing/uniform/workwear/centcom/greensuit.dmi'
	icon_state = "greensuit"
	starting_accessories = list(/obj/item/clothing/accessory/tie/darkgreen)

/obj/item/clothing/under/gov/skirt
	name = "Green formal skirt uniform"
	desc = "A neat proper uniform of someone on offical business. The top button is sewn shut."
	icon = 'icons/clothing/uniform/workwear/centcom/greensuit_skirt.dmi'
	icon_state = "greensuit_skirt"

/**
 * Customs
 */

/obj/item/clothing/under/customs
	name = "customs uniform"
	desc = "A standard OriCon customs uniform.  Complete with epaulettes."
	icon = 'icons/clothing/uniform/workwear/centcom/cu_suit.dmi'
	icon_state = "cu_suit"

/obj/item/clothing/under/customs/khaki
	icon = 'icons/clothing/uniform/workwear/centcom/cu_suit_kh.dmi'
	icon_state = "cu_suit_kh"
