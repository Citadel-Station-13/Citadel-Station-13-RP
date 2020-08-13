/mob/living/simple_mob/animal/passive/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	tt_desc = "E Mus musculus"
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"

	maxHealth = 5
	health = 5

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
//	can_pull_size = ITEMSIZE_TINY
//	can_pull_mobs = MOB_PULL_NONE
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
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	say_list_type = /datum/say_list/mouse

	var/body_color //brown, gray and white, leave blank for random

/mob/living/simple_mob/animal/passive/mouse/New()
	..()

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

/mob/living/simple_mob/animal/passive/mouse/Crossed(AM as mob|obj)
	//VOREStation Edit begin: SHADEKIN
	var/mob/SK = AM
	if(istype(SK))
		if(SK.shadekin_phasing_check())
			return
	//VOREStation Edit end: SHADEKIN
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M.visible_message("<font color='blue'>\icon[src] Squeek!</font>")
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
	src.stat = DEAD
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

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/animal/passive/mouse/rat/Initialize()
	..()
	adjust_scale(1.2)

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_mob/animal/passive/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_mob/animal/passive/mouse/brown/Tom/New()
	..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)


// Mouse noises
/datum/say_list/mouse
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")

//Base ported from vgstation. Operative Mice.
//Icon artists: DeityLink and plosky1
/mob/living/simple_mob/animal/passive/mouse/mouse_op
	name = "mouse operative"
	desc = "Oh no..."
	tt_desc = "E Mus sinister"
	icon_state = "mouse_operative"
	item_state = "mouse_operative"
	icon_living = "mouse_operative"
	icon_dead = "mouse_operative_dead"

	maxHealth = 50
	health = 50
	universal_understand = 1

	min_oxy = 0
	minbodytemp = 0
	maxbodytemp = 5000

	taser_kill = 0

	//Mob melee settings
	melee_damage_lower = 5
	melee_damage_upper = 15
	list/attacktext = list("attacked", "chomped", "gnawed on")
	list/friendly = list("baps", "nuzzles")
	attack_armor_type = "melee"
	attack_sharp = 1
	attack_edge = 1

	//Damage resistances
	shock_resist = 1
	armor = list(
				"melee" = 40,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/animal/passive/mouse/pyro
	name = "pyro mouse"
	desc = "What kind of madman would strap this to a mouse?"
	tt_desc = "E Mus phlogiston"
	icon_state = "mouse_ash"
	item_state = "mouse_ash"
	icon_living = "mouse_ash"
	icon_dead = "mouse_ash_dead"

	maxHealth = 30
	health = 30
	universal_understand = 1

	min_oxy = 0
	minbodytemp = 0
	maxbodytemp = 5000

	taser_kill = 0

	//Mob melee settings
	melee_damage_lower = 5
	melee_damage_upper = 10
	list/attacktext = list("attacked", "chomped", "gnawed on")
	list/friendly = list("baps", "nuzzles")
	attack_armor_type = "melee"
	attack_sharp = 0
	attack_edge = 0

	var/exploded = FALSE
	var/explosion_dev_range		= 0
	var/explosion_heavy_range	= 0
	var/explosion_light_range	= 2
	var/explosion_flash_range	= 4 // This doesn't do anything iirc.

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 3 SECONDS	// Upper bound.


	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 10,
				"bullet" = 0,
				"laser" = 40,
				"energy" = 30,
				"bomb" = 90,
				"bio" = 100,
				"rad" = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/animal/passive/mouse/pyro/death()
	visible_message("<span class='critical'>\The [src]'s body begins to rupture!</span>")
	var/delay = rand(1, 3)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#000000"
			else
				color = "#FF0000"
			sleep(1)

	spawn(rand(1,5))
		if(src && !exploded)
			visible_message("<span class='critical'>\The [src]'s body detonates!</span>")
			exploded = 1
			explosion(src.loc, 0, 0, 2, 4)
	return ..()
