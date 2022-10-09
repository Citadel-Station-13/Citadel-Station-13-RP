/obj/item/clothing/under/rank/centcom
	name = "\improper CentCom Officer uniform"
	desc = "The formal uniform of the Central Command Officer. Striking and recognizable, it radiates authority."
	icon_state = "officer"

/obj/item/clothing/under/rank/centcom/fem
	icon_state = "officer_fem"

/obj/item/clothing/under/rank/centcom/representative
	name = "\improper CentCom Representative uniform"
	desc = "The formal uniform of the Central Command Representative. These guys must be really important."
	icon_state = "centcom"

/obj/item/clothing/under/rank/centcom/representative/fem
	name = "\improper CentCom Representative uniform"
	desc = "The formal uniform of the Central Command Representative. These guys must be really important."
	icon_state = "centcom_fem"

/obj/item/clothing/under/rank/centcom/green
	icon = 'icons/obj/clothing/under/centcom.dmi'
	icon_override = 'icons/mob/clothing/under/centcom.dmi'
	displays_id = FALSE

/obj/item/clothing/under/rank/centcom/green/commander
	name = "\improper CentCom officer's suit"
	desc = "It's a suit worn by CentCom's highest-tier Commanders."
	icon_state = "centcom"

/obj/item/clothing/under/rank/centcom/green/intern
	name = "\improper CentCom intern's jumpsuit"
	desc = "It's a jumpsuit worn by those interning for CentCom. The top is styled after a polo shirt for easy identification."
	icon_state = "intern"

/obj/item/clothing/under/rank/centcom/green/officer
	name = "\improper CentCom turtleneck suit"
	desc = "A casual, yet refined green turtleneck, used by CentCom Officials. It has a fragrance of aloe."
	icon_state = "officer"

/obj/item/clothing/under/rank/centcom/green/officer/replica
	name = "\improper CentCom turtleneck replica"
	desc = "A cheap copy of the CentCom turtleneck! A Donk Co. logo can be seen on the collar."

/obj/item/clothing/under/rank/centcom/green/officer_skirt
	name = "\improper CentCom turtleneck skirt"
	desc = "A skirt version of the CentCom turtleneck, rarer and more sought after than the original."
	icon_state = "officer_skirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/centcom/green/officer_skirt/replica
	name = "\improper CentCom turtleneck skirt replica"
	desc = "A cheap copy of the CentCom turtleneck skirt! A Donk Co. logo can be seen on the collar."

/obj/item/clothing/under/rank/centcom/green/centcom_skirt
	name = "\improper CentCom officer's suitskirt"
	desc = "It's a suitskirt worn by CentCom's highest-tier Commanders."
	icon_state = "centcom_skirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/centcom/military
	name = "tactical combat uniform"
	desc = "A dark colored uniform worn by CentCom's conscripted military forces."
	icon_state = "military"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, fire = 50, acid = 40)

/obj/item/clothing/under/rank/centcom/military/eng
	name = "tactical engineering uniform"
	desc = "A dark colored uniform worn by CentCom's regular military engineers."
	icon_state = "military_eng"

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon_state = "ert_uniform"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "black", SLOT_ID_LEFT_HAND = "black")

/obj/item/clothing/under/gov
	desc = "A neat proper uniform of someone on offical business. The collar is <i>immaculately</i> starched."
	name = "Green formal uniform"
	icon_state = "greensuit"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "centcom", SLOT_ID_LEFT_HAND = "centcom")
	starting_accessories = list(/obj/item/clothing/accessory/tie/darkgreen)

/obj/item/clothing/under/gov/skirt
	name = "Green formal skirt uniform"
	desc = "A neat proper uniform of someone on offical business. The top button is sewn shut."
	icon_state = "greensuit_skirt"
