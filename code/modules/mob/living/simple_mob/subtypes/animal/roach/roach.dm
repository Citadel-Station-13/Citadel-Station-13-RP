/*
	This is the first stage of porting roaches from Eris.
	The intent is to eventually supplement mice and spiders with another class of pest.
	Currently the code for these mobs will be somewhat basic, but with wide potential for further development.
*/

// Obtained by scanning any roach.
/datum/category_item/catalogue/fauna/roach/roach
	name = "Roaches"
	desc = "This hardy species of insect existed on earth for Millions of years prior to humanity,\
	and attained a demonstrable measure of evolutionary 'perfection', as evidenced by their longevity.\
	Prior to the Final War, many humans speculated that the common roach might survive such a cataclysm.\
	Although none who once posited the idea are still around, they have since been vindicated.\
	It is not known exactly how roaches migrated from Earth, but true to form, they have become ubiquitous,\
	infesting stations and vessels across the galaxy.\
	Some xeno species consider roaches to be a delicacy, and have engaged in cultivation practices.\
	Some manner of speciation has been detected amongst roaches in the modern galaxy,\
	leading to an as yet unknown number of varieties and mutations."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/roach)

// Obtained by scanning all roach types.
/datum/category_item/catalogue/fauna/all_roaches
	name = "Collection - Roaches"
	desc = "You have scanned a large array of different types of roaches, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/roach/roach,
		/datum/category_item/catalogue/fauna/roach/roachling,
		//Reminder: add rest
		)

/mob/living/simple_mob/animal/roach
	name = "roach"
	real_name = "roach"
	desc = "A hardy pest native to Terra. It somehow survived the Final War and spread among the stars."
	tt_desc = "Periplaneta australasiae"
	icon_state = "roach"
	item_state = "roach"
	icon_living = "roach"
	icon_dead = "roach_dead"

	maxHealth = 15
	health = 15

	see_in_dark = 6
	universal_understand = 1

	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
//	can_pull_size = ITEMSIZE_TINY
//	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "strokes"
	response_disarm = "awkwardly scoots past"
	response_harm   = "stomps on"

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_edge = 1
	attacktext = list("bit", "scratched","clawed")
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	minbodytemp = 150
	maxbodytemp = 323

	speak_emote = list("chitters")
	say_list_type = /datum/say_list/spider

	holder_type = /obj/item/holder/roach
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

/mob/living/simple_mob/animal/roach/Initialize(mapload)
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

/mob/living/simple_mob/animal/roach/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M.visible_message("<font color='blue'>[icon2html(thing = src, target = world)] Chk chk!</font>")
			SEND_SOUND(M, sound('sound/effects/squelch1.ogg'))
	..()

/*
 * Special Roach types.
 */

//How DARE you!
/mob/living/simple_mob/animal/roach/Greta
	name = "Greta"
	desc = "Legend has it this roach sailed across the Eagle Nebula to protest bug burgers."

/mob/living/simple_mob/animal/roach/Greta/Initialize(mapload)
	. = ..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)

//Baby Roaches? Baby Roaches.

/datum/category_item/catalogue/fauna/roach/roachling
	name = "Roachling"
	desc = "Every life begins somewhere, and the juvenile roach, commonly referred to as a 'roachling',\
	serves as one of the first signs of a budding roach infestation. If you see one, there are more.\
	Attentive crews will take the sign of a single roachling as a warning to dock and pull up panels."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/roachling
	name = "roachling"
	real_name = "roachling"
	desc = "A hardy pest native to Terra. This one's just a baby."
	icon_state = "roachling"
	item_state = "roachling"
	icon_living = "roachling"
	icon_dead = "roachling_dead"

	maxHealth = 5
	health = 5

	melee_damage_lower = 2
	melee_damage_upper = 3
