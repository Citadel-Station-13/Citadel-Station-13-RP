/obj/item/organ/internal/brain/alraune
	icon = 'icons/mob/clothing/species/alraune/organs.dmi'
	icon_state = "neurostroma"
	name = "neuro-stroma"
	desc = "A knot of fibrous plant matter."
	parent_organ = BP_TORSO // brains in their core

/obj/item/organ/internal/eyes/alraune
	icon = 'icons/mob/clothing/species/alraune/organs.dmi'
	icon_state = "photoreceptors"
	name = "photoreceptors"
	desc = "Bulbous and fleshy plant matter."

/obj/item/organ/internal/kidneys/alraune
	icon = 'icons/mob/clothing/species/alraune/organs.dmi'
	icon_state = "rhyzofilter"
	name = "rhyzofilter"
	desc = "A tangle of root nodules."

/obj/item/organ/internal/liver/alraune
	icon = 'icons/mob/clothing/species/alraune/organs.dmi'
	icon_state = "phytoextractor"
	name = "enzoretector"
	desc = "A bulbous gourd-like structure."

//Begin fruit gland and its code.
/obj/item/organ/internal/fruitgland //Amazing name, I know.
	icon = 'icons/mob/clothing/species/alraune/organs.dmi'
	icon_state = "phytoextractor"
	name = "fruit gland"
	desc = "A bulbous gourd-like structure."
	organ_tag = O_FRUIT
	var/generated_reagents = list("sugar" = 2) //This actually allows them. This could be anything, but sugar seems most fitting.
	var/usable_volume = 250 //Five fruit.
	var/transfer_amount = 50
	var/empty_message = list("Your have no fruit on you.", "You have a distinct lack of fruit..")
	var/full_message = list("You have a multitude of fruit that is ready for harvest!", "You have fruit that is ready to be picked!")
	var/emote_descriptor = list("fruit right off of the Alraune!", "a fruit from the Alraune!")
	var/verb_descriptor = list("grabs", "snatches", "picks")
	var/self_verb_descriptor = list("grab", "snatch", "pick")
	var/short_emote_descriptor = list("picks", "grabs")
	var/self_emote_descriptor = list("grab", "pick", "snatch")
	var/fruit_type = "apple"
	var/gen_cost = 0.5

/obj/item/organ/internal/fruitgland/Initialize(mapload)
	. = ..()
	create_reagents(usable_volume)

/obj/item/organ/internal/fruitgland/process(delta_time)
	if(!owner)
		return
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	var/before_gen
	if(parent && generated_reagents && owner) //Is it in the chest/an organ, has reagents, and is 'activated'
		before_gen = reagents.total_volume
		if(reagents.total_volume < reagents.maximum_volume)
			if(owner.nutrition >= gen_cost)
				do_generation()

	if(reagents)
		if(reagents.total_volume == reagents.maximum_volume * 0.05)
			to_chat(owner, SPAN_NOTICE("[pick(empty_message)]"))
		else if(reagents.total_volume == reagents.maximum_volume && before_gen < reagents.maximum_volume)
			to_chat(owner, SPAN_WARNING("[pick(full_message)]"))

/obj/item/organ/internal/fruitgland/proc/do_generation()
	owner.nutrition -= gen_cost
	for(var/reagent in generated_reagents)
		reagents.add_reagent(reagent, generated_reagents[reagent])
