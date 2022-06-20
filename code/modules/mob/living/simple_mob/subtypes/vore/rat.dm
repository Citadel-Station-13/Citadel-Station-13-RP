/datum/category_item/catalogue/fauna/rat		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - Rat"
	desc = "A massive rat, some sort of mutated descendant of normal Earth rats. These ones seem particularly hungry, \
	and are able to pounce and stun their targets - presumably to eat them. Their bodies are long and greyfurred, \
	with a pink nose and large teeth, just like their regular-sized counterparts."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/aggressive/rat
	name = "giant rat"
	desc = "In what passes for a hierarchy among verminous rodents, this one is king."
	tt_desc = "Mus muscular"
	catalogue_data = list(/datum/category_item/catalogue/fauna/rat)

	icon_state = "rous"
	icon_living = "rous"
	icon_dead = "rous-dead"
	icon_rest = "rous_rest"
	faction = "mouse"
	icon = 'icons/mob/vore64x32.dmi'

	maxHealth = 150
	health = 150
	randomized = TRUE

	melee_damage_lower = 2
	melee_damage_upper = 7
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("ravaged")
	friendly = list("nuzzles", "licks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 10

	vore_active = TRUE
	vore_capacity = 1
	vore_pounce_chance = 45
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

	var/life_since_foodscan = 0

	say_list_type = /datum/say_list/rat
	ai_holder_type = /datum/ai_holder/simple_mob/melee/rat

/mob/living/simple_mob/vore/aggressive/rat/tame		//not quite tame but does not attack on sight
	name = "curious giant rat"
	desc = "In what passes for a hierarchy among verminous rodents, this one is king. It seems to be more interested on scavenging."
	var/mob/living/carbon/human/food
	var/hunger = 0

/mob/living/simple_mob/vore/aggressive/rat/maurice
	name = "Maurice"
	desc = "The station's resident vermin supreme, he makes the rules for all maintnence rodents. \
	He appears to have grown quite chubby off gifts of trash and cheese from the crew."

	randomized = FALSE

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

/mob/living/simple_mob/vore/aggressive/rat/death()
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 50, 1)
	..()

/mob/living/simple_mob/vore/aggressive/rat/phoron
	name = "phoron rat"
	desc = "In what passes for a hierarchy among verminous rodents, this one is alien overlord."
	tt_desc = "Mus muscular phoronis"

	icon_state = "phorous" //TODO: proper phoron rat sprites
	icon_living = "phorous"
	icon_dead = "phorous-dead"
	icon_rest = "phorous_rest"

	maxHealth = 175
	health = 175

	melee_damage_lower = 8
	melee_damage_upper = 16

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/datum/say_list/rat
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	say_maybe_target = list("Squeek?")
	say_got_target = list("SQUEEK!")

/datum/ai_holder/simple_mob/melee/rat
	speak_chance = 3
