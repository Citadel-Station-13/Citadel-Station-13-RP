/datum/reagent/luminol
	name = "Luminol"
	id = "luminol"
	description = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	reagent_state = REAGENT_LIQUID
	color = "#F2F3F4"

/datum/reagent/luminol/on_touch_obj(obj/target, remaining, allocated, data)
	target.reveal_blood()
	return ..()

/datum/reagent/luminol/on_touch_mob(mob/target, remaining, allocated, data, zone)
	target.reveal_blood()
	return ..()
