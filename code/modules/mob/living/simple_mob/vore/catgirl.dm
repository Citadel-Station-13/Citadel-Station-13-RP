/mob/living/simple_mob/humanoid/catgirl
	name = "catgirl"
	desc = "Her hobbies are catnaps, knocking things over, and headpats."
	tt_desc = "Homo felinus"
	icon = 'icons/mob/vore.dmi'
	icon_state = "catgirl"

	movement_cooldown = 5

	ai_holder_type = /datum/ai_holder/simple_mob/passive

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10

	response_help = "pets the"
	response_disarm = "gently baps the"
	response_harm = "hits the"

	attacktext = list("swatted","bapped")
	vore_active = 1
	vore_bump_chance = 5
	vore_pounce_chance = 50
	vore_standing_too = 1
	vore_ignores_undigestable = 0 // Catgirls just want to eat yoouuu
	vore_default_mode = DM_HOLD // Chance that catgirls just wanna bellycuddle yoouuuu!
	vore_digest_chance = 25 // But squirming might make them gurgle...
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

	var/random_skin = 1
	var/list/skins = list(
		"catgirl",
		"catgirlnude",
		"catgirlbikini",
		"catgirlrednude",
		"catgirlredbikini",
		"catgirlblacknude",
		"catgirlblackbikini",
		"catgirlbrownnude",
		"catgirlbrownbikini",
		"catgirlred",
		"catgirlblack",
		"catgirlbrown"
	)

	say_list_type = /datum/say_list/catgirl

/datum/say_list/catgirl
	speak = list("Meow!","Esp!","Purr!","HSSSSS","Mew?","Nya~")
	speak_emote = list("purrs","meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes her head","shivers","stretches","grooms herself")

/mob/living/simple_mob/humanoid/catgirl/Initialize()
	. = ..()
	if(random_skin)
		icon_living = pick(skins)
		icon_rest = "[icon_living]asleep"
		icon_dead = "[icon_living]-dead"
		update_icon()

/mob/living/simple_mob/humanoid/catgirl/retaliate
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative
