/datum/category_item/catalogue/fauna/jelly
	name = "Jelly Blob"
	desc = "These curious creatures are native to the caustic surface of Virgo 2. \
	Although docile, their undulating bodies can sometimes get in the way of attacks \
	meant for more dangerous fauna. When struck, jelly blobs react violently, although \
	their soft exterior does not lend itself well to combat."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/space/jelly
	name = "jelly blob"
	desc = "Some sort of undulating blob of slime!"
	catalogue_data = list(/datum/category_item/catalogue/fauna/jelly)

	icon_dead = "jelly_dead"
	icon_living = "jelly"
	icon_state = "jelly"
	icon = 'icons/mob/vore.dmi'

	faction = "virgo2"
	maxHealth = 50
	health = 50
<<<<<<< HEAD

	melee_damage_lower = 2
	melee_damage_upper = 7
=======
>>>>>>> parent of f4584a80d (The Great Randoming)

	melee_damage_lower = 2
	melee_damage_upper = 7

	say_list_type = /datum/say_list/jelly
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/jelly

<<<<<<< HEAD

=======
>>>>>>> parent of f4584a80d (The Great Randoming)
// Activate Noms!
/mob/living/simple_mob/animal/space/jelly
	vore_active = 1
	vore_pounce_chance = 0
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.

/datum/say_list/jelly
	emote_hear = list("squishes","spluts","splorts","sqrshes","makes slime noises")
	emote_see = list("undulates quietly")

/datum/ai_holder/simple_mob/retaliate/jelly
	speak_chance = 2
<<<<<<< HEAD

// Talon's Pet, Wiggleblob!
/mob/living/simple_mob/animal/space/jelly/wiggleblob
	name = "Mr. Wiggleblob."
	desc = "Mr. Wiggleblob! The official mascot of the Talon. So huggable. So squishable. Just try not to get eaten!"

	size_multiplier = 1.25
<<<<<<< HEAD
=======
	movement_cooldown = 5
>>>>>>> parent of 4a597abb2 (Trailing Newline)
=======
>>>>>>> parent of f4584a80d (The Great Randoming)
