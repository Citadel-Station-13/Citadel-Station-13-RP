/**************
 *! Sif Flora *
 **************/

/obj/structure/flora/sif
	icon = 'icons/obj/flora/sifflora.dmi'

/obj/structure/flora/sif/attack_hand(mob/user)
	if (user.a_intent == INTENT_HARM)
		if(do_after(user, 5 SECONDS))
			user.visible_message("\The [user] digs up \the [src.name].", "You dig up \the [src.name].")
			qdel(src)
	else
		user.visible_message("\The [user] pokes \the [src.name].", "You poke \the [src.name].")

/datum/category_item/catalogue/flora/subterranean_bulbs
	name = "Sivian Flora - Subterranean Bulbs"
	desc = "A plant which is native to Sif, it continues the trend of being a bioluminescent specimen. These plants \
	are generally suited for conditions experienced in caverns, which are generally dark and cold. It is not \
	known why this plant evolved to be bioluminescent, however this property has, unintentionally, allowed for \
	it to spread much farther than before, with the assistance of humans.\
	<br><br>\
	In Sif's early history, Sivian settlers found this plant while they were establishing mines. Their ability \
	to emit low, but consistant amounts of light made them desirable to the settlers. They would often cultivate \
	this plant inside man-made tunnels and mines to act as a backup source of light that would not need \
	electricity. This technique has saved many lost miners, and this practice continues to this day."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/sif/subterranean
	name = "subterranean plant"
	desc = "This is a subterranean plant. It's bulbous ends glow faintly."
	icon_state = "glowplant"
	light_range = 2
	light_power = 0.6
	light_color = "#FF6633"
	catalogue_data = list(/datum/category_item/catalogue/flora/subterranean_bulbs)

/obj/structure/flora/sif/subterranean/Initialize(mapload)
	icon_state = "[initial(icon_state)][rand(1,2)]"
	. = ..()


/datum/category_item/catalogue/flora/eyebulbs
	name = "Sivian Flora - Eyebulbs"
	desc = "A plant native to Sif. On the end of its stems are bulbs which visually resemble \
	eyes, which shrink when touched. One theory is that the bulbs are a result of mimicry, appearing as eyeballs to protect from predators.<br><br>\
	These plants have no known use."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/sif/eyes
	name = "mysterious bulbs"
	desc = "This is a mysterious looking plant. They kind of look like eyeballs. Creepy."
	icon_state = "eyeplant"
	catalogue_data = list(/datum/category_item/catalogue/flora/eyebulbs)

/obj/structure/flora/sif/eyes/Initialize(mapload)
	icon_state = "[initial(icon_state)][rand(1,3)]"
	. = ..()

/datum/category_item/catalogue/flora/mosstendrils
	name = "Sivian Flora - Moss Stalks"
	desc = "A plant native to Sif. The plant is most closely related to the common, dense moss found covering Sif's terrain. \
	It has evolved a method of camouflage utilizing white hairs on its dorsal sides to make it appear as a small mound of snow from \
	above. It has no known use, though it is a common furnishing in contemporary homes."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/structure/flora/sif/tendrils
	name = "stocky tendrils"
	desc = "A 'plant' made up of hardened moss. It has tiny hairs that bunch together to look like snow."
	icon_state = "grass"
	randomize_size = TRUE
	catalogue_data = list(/datum/category_item/catalogue/flora/mosstendrils)

/obj/structure/flora/sif/tendrils/Initialize(mapload)
	icon_state = "[initial(icon_state)][rand(1,3)]"
	. = ..()
