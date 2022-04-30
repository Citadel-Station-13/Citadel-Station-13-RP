/datum/category_item/catalogue/fauna/mouse
	name = "Mouse"
	desc = "An ancient Old Earth rodent, mice have served as both pest and pet \
	to Humanity for millenia. Originally brought into space for scientific testing \
	due to genetic similarities with Humans, mice have since bred their way back \
	to pest status, and spread freely across the Frontier."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "A small rodent, often seen hiding in maintenance areas and making a nuisance of itself. And stealing cheese, or annoying the chef. SQUEAK! <3"
	tt_desc = "E Mus musculus"
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mouse)

	maxHealth = 5
	health = 5
	randomized = TRUE

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
	can_pull_size = ITEMSIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius

	has_langs = list("Mouse")

	holder_type = /obj/item/holder/mouse

	meat_amount = 1
	bone_amount = 1
	hide_amount = 1

	say_list_type = /datum/say_list/mouse

	var/body_color //brown, gray and white, leave blank for random

	nutrition = 20	//To prevent draining maint mice for infinite food. Low nutrition has no mechanical effect on simplemobs, so wont hurt mice themselves.

	no_vore = 1 //Mice can't eat others due to the amount of bugs caused by it.
	vore_taste = "cheese"

/mob/living/simple_mob/animal/passive/mouse/Initialize(mapload)
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	icon_rest = "mouse_[body_color]_sleep"
	desc = "A small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_mob/animal/passive/mouse/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M.visible_message("<font color=#4F49AF>[icon2html(thing = src, target = world)] Squeek!</font>")
			playsound(src, 'sound/effects/mouse_squeak.ogg', 35, 1)
	..()

/mob/living/simple_mob/animal/passive/mouse/death()
	layer = MOB_LAYER
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 35, 1)
	if(client)
		client.time_died_as_mouse = world.time
	..()

/mob/living/simple_mob/animal/passive/mouse/cannot_use_vents()
	return

/mob/living/simple_mob/animal/passive/mouse/proc/splat()
	src.health = 0
	src.set_stat(DEAD)
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

/*
 * Mouse types
 */

/mob/living/simple_mob/animal/passive/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple_mob/animal/passive/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_mob/animal/passive/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

/mob/living/simple_mob/animal/passive/mouse/rat
	name = "rat"
	maxHealth = 20
	health = 20

	mod_min = 90
	mod_max = 120

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_mob/animal/passive/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
	randomized = FALSE

/mob/living/simple_mob/animal/passive/mouse/brown/Tom/Initialize(mapload)
	. = ..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)


// Mouse noises
/datum/say_list/mouse
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")

/mob/living/simple_mob/animal/passive/mouse/attack_hand(mob/living/hander)
	if(hander.a_intent == INTENT_HELP) //if lime intent
		get_scooped(hander) //get scooped
	else
		..()

/obj/item/holder/mouse/attack_self(var/mob/U)
	for(var/mob/living/simple_mob/M in src.contents)
		if((INTENT_HELP) && U.canClick()) //a little snowflakey, but makes it use the same cooldown as interacting with non-inventory objects
			U.setClickCooldown(U.get_attack_speed()) //if there's a cleaner way in baycode, I'll change this
			U.visible_message("<span class='notice'>[U] [M.response_help] \the [M].</span>")
