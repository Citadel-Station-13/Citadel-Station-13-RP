/**
 * Trek Clothes
 */

/obj/item/clothing/under/rank/trek
	name = "Section 31 Uniform"
	desc = "Oooh... right."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = ""

//TOS
/obj/item/clothing/under/rank/trek/command
	name = "Command Uniform"
	desc = "The uniform worn by command officers in the mid 2260s."
	icon_state = "trek_command"
	item_state = "trek_command"
	armor_type = /datum/armor/station/padded

/obj/item/clothing/under/rank/trek/engsec
	name = "Operations Uniform"
	desc = "The uniform worn by operations officers of the mid 2260s. You feel strangely vulnerable just seeing this..."
	icon_state = "trek_engsec"
	item_state = "trek_engsec"
	armor_type = /datum/armor/station/padded

/obj/item/clothing/under/rank/trek/medsci
	name = "MedSci Uniform"
	desc = "The uniform worn by medsci officers in the mid 2260s."
	icon_state = "trek_medsci"
	item_state = "trek_medsci"
	permeability_coefficient = 0.50
	armor_type = /datum/armor/medical/jumpsuit

//TNG
/obj/item/clothing/under/rank/trek/command/next
	desc = "The uniform worn by command officers. This one's from the mid 2360s."
	icon_state = "trek_next_command"
	item_state = "trek_next_command"

/obj/item/clothing/under/rank/trek/engsec/next
	desc = "The uniform worn by operation officers. This one's from the mid 2360s."
	icon_state = "trek_next_engsec"
	item_state = "trek_next_engsec"

/obj/item/clothing/under/rank/trek/medsci/next
	desc = "The uniform worn by medsci officers. This one's from the mid 2360s."
	icon_state = "trek_next_medsci"
	item_state = "trek_next_medsci"

//ENT
/obj/item/clothing/under/rank/trek/command/ent
	desc = "The uniform worn by command officers of the 2140s."
	icon_state = "trek_ent_command"
	item_state = "trek_ent_command"

/obj/item/clothing/under/rank/trek/engsec/ent
	desc = "The uniform worn by operations officers of the 2140s."
	icon_state = "trek_ent_engsec"
	item_state = "trek_ent_engsec"

/obj/item/clothing/under/rank/trek/medsci/ent
	desc = "The uniform worn by medsci officers of the 2140s."
	icon_state = "trek_ent_medsci"
	item_state = "trek_ent_medsci"

//VOY
/obj/item/clothing/under/rank/trek/command/voy
	desc = "The uniform worn by command officers of the 2370s."
	icon_state = "trek_voy_command"
	item_state = "trek_voy_command"

/obj/item/clothing/under/rank/trek/engsec/voy
	desc = "The uniform worn by operations officers of the 2370s."
	icon_state = "trek_voy_engsec"
	item_state = "trek_voy_engsec"

/obj/item/clothing/under/rank/trek/medsci/voy
	desc = "The uniform worn by medsci officers of the 2370s."
	icon_state = "trek_voy_medsci"
	item_state = "trek_voy_medsci"

/obj/item/clothing/under/rank/trek/command/ds9
	desc = "The uniform worn by command officers of the 2380s."
	icon_state = "trek_command"
	item_state = "trek_ds9_command"

/obj/item/clothing/under/rank/trek/command/ds9/equipped(mob/user, slot, flags) // Cit change to take into account weirdness with defines. When put on it forces the correct sprite sheet. However when removed it shows a missing sprite for either uniform or suit depending on if it's the overcoat or uniform. Don't know how to fix
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.w_uniform == src)
		if(H.species.get_species_id() == SPECIES_ID_VOX)
			icon_override = 'icons/mob/clothing/species/vox/uniform.dmi'
		else
			icon_override = 'icons/vore/custom_clothes_vr.dmi'
	update_worn_icon()

/obj/item/clothing/under/rank/trek/engsec/ds9
	desc = "The uniform worn by operations officers of the 2380s."
	icon_state = "trek_engsec"
	item_state = "trek_ds9_engsec"

/obj/item/clothing/under/rank/trek/engsec/ds9/equipped(mob/user, slot, flags) // Cit change, ditto
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.w_uniform == src)
		if(H.species.get_species_id() == SPECIES_ID_VOX)
			icon_override = 'icons/mob/clothing/species/vox/uniform.dmi'
		else
			icon_override = 'icons/vore/custom_clothes_vr.dmi'
	update_worn_icon()

/obj/item/clothing/under/rank/trek/medsci/ds9
	desc = "The uniform undershit worn by medsci officers of the 2380s."
	icon_state = "trek_medsci"
	item_state = "trek_ds9_medsci"

/obj/item/clothing/under/rank/trek/medsci/ds9/equipped(mob/user, slot, flags) // Cit change, ditto
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.w_uniform == src)
		if(H.species.get_species_id() == SPECIES_ID_VOX)
			icon_override = 'icons/mob/clothing/species/vox/uniform.dmi'
		else
			icon_override = 'icons/vore/custom_clothes_vr.dmi'
	update_worn_icon()

