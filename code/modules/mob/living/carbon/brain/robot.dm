/datum/category_item/catalogue/fauna/brain/robotic
	name = "Heuristics - Robotic"
	desc = "Referred to as Intelligence Circuits, the complexity of these \
	chips is obfuscted by such simple language. RICs are self contained environments \
	hosting Artificial Intelligences. Although superficially similar to Positronic \
	brains, in reality they ethos and process behind creating these kinds of processors \
	is significantly different."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/item/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)
	catalogue_data = list(/datum/category_item/catalogue/fauna/brain/robotic)

/obj/item/mmi/digital/robot/Initialize(mapload)
	. = ..()
	src.brainmob.name = "[pick(list("ADA","DOS","GNU","MAC","WIN"))]-[rand(1000, 9999)]"
	src.brainmob.real_name = src.brainmob.name
	src.name = "robotic intelligence circuit ([src.brainmob.name])"

/obj/item/mmi/digital/robot/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Robotic Intelligence"
	to_chat(brainmob, "<span class='notify'>You feel slightly disoriented. That's normal when you're little more than a complex circuit.</span>")
	return

/obj/item/mmi/digital/robot/attack_self(mob/user as mob)
	return //This object is technically a brain, and should not be dumping brains out of itself like its parent object does.
