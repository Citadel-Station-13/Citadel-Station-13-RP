/obj/item/organ/internal/heart/unathi
	icon = 'icons/mob/species/unathi/organs.dmi'
	icon_state = "heart-on"
	dead_icon = "heart-off"

/obj/item/organ/internal/lungs/unathi
	icon = 'icons/mob/species/unathi/organs.dmi'
	color = "#b3cbc3"

/obj/item/organ/internal/liver/unathi
	icon = 'icons/mob/species/unathi/organs.dmi'
	name = "filtration organ"
	icon_state = "liver"

//Unathi liver acts as kidneys, too.
/obj/item/organ/internal/liver/unathi/process(delta_time)
	..()
	if(!owner) return

	if(owner.reagents.has_reagent(/datum/reagent/drink/coffee::id))
		if(is_bruised())
			owner.adjustToxLoss(0.1 * (delta_time * 5))
		else if(is_broken())
			owner.adjustToxLoss(0.3 * (delta_time * 5))

	if(owner.reagents.has_reagent(/datum/reagent/sugar::id))
		if(is_bruised())
			owner.adjustToxLoss(0.1 * (delta_time * 5))
		else if(is_broken())
			owner.adjustToxLoss(0.3 * (delta_time * 5))

/obj/item/organ/internal/brain/unathi
	icon = 'icons/mob/species/unathi/organs.dmi'
	color = "#b3cbc3"

/obj/item/organ/internal/stomach/unathi
	color = "#b3cbc3"
	max_acid_volume = 40

/obj/item/organ/internal/intestine/unathi
	color = "#b3cbc3"
