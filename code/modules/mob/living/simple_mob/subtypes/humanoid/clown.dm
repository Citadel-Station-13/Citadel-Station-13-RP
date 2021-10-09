/datum/category_item/catalogue/fauna/clown
	name = "Clown"
	desc = "The Clown is truly a galactic phenomenon. Those who travel to \
	Clown Planet to train in the comedic arts sometimes undergo a curious \
	revelation. Becoming fully devoted to the Honkmother, these fantatical \
	jesters roam the Frontier on missions of mayhem and hilarity. Just because \
	they're smiling, it doesn't mean they aren't deadly. Watch where you step."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/humanoid/clown
	name = "clown"
	desc = "A denizen of clown planet."
	tt_desc = "E Homo sapiens corydon" //this is an actual Clown, as opposed to someone dressed up as one
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/clown)

	faction = "clown"

	loot_list = list(/obj/item/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("attacked")
	attack_sound = 'sound/items/bikehorn.ogg'

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks")

/mob/living/simple_mob/humanoid/clown/ranged
	name = "clown"
	desc = "A denizen of clown planet. I wonder if that's a real gun."

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

	projectiletype = /obj/item/projectile/bullet/honker/lethal
	projectilesound = 'sound/items/bikehorn.ogg'
	needs_reload = TRUE
	reload_max = 30

/mob/living/simple_mob/humanoid/clown/ranged/prankster
	name = "clown"
	desc = "A denizen of clown planet. I wonder if that's a real gun."

	projectiletype = /obj/item/projectile/bullet/honker
	needs_reload = FALSE
