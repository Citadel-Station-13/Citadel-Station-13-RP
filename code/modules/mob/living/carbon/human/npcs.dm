/obj/item/clothing/under/punpun
	name = "fancy uniform"
	desc = "It looks like it was tailored for a monkey."
	icon = 'icons/clothing/uniform/workwear/service/punpun.dmi'
	icon_state = "punpun"
	species_restricted = list(SPECIES_MONKEY)
	worn_bodytypes = BODYTYPES(BODYTYPES_ALL)
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
	worn_has_rollsleeve = UNIFORM_HAS_NO_ROLL

/mob/living/carbon/human/monkey/punpun/Initialize(mapload)
	. = ..()
	name = "Pun Pun"
	real_name = name
	w_uniform = new /obj/item/clothing/under/punpun(src)
	regenerate_icons()
