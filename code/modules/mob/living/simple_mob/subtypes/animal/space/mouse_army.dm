/mob/living/simple_mob/animal/space/mouse_army
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small militarized rodent."
	tt_desc = "E Mus musculus"
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"

	maxHealth = 50
	health = 50
	universal_understand = 1

	taser_kill = 0

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
//	can_pull_size = ITEMSIZE_TINY
//	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"

	min_oxy = 0 //Require atleast 16kPA oxygen
	minbodytemp = 0		//Below -50 Degrees Celcius
	maxbodytemp = 5000	//Above 50 Degrees Celcius

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
				"melee" = 30,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 0,
				"rad" = 0)	//Standard armor vest stats, slightly dropped due to scale.

	has_langs = list("Mouse")

	holder_type = /obj/item/holder/mouse
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	say_list_type = /datum/say_list/mouse

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	var/rank //pyro, operative, more to come. Do not leave blank.

/mob/living/simple_mob/animal/space/mouse_army/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!rank)
		rank = pick( list("operative","pyro") )
	icon_state = "mouse_[rank]"
	item_state = "mouse_[rank]"
	icon_living = "mouse_[rank]"
	icon_dead = "mouse_[rank]_dead"
	icon_rest = "mouse_[rank]_sleep"

/mob/living/simple_mob/animal/space/mouse_army/Crossed(AM as mob|obj)
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

/mob/living/simple_mob/animal/space/mouse_army/death()
	layer = MOB_LAYER
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 35, 1)
	if(client)
		client.time_died_as_mouse = world.time
	..()

/mob/living/simple_mob/animal/space/mouse_army/cannot_use_vents()
	return

/mob/living/simple_mob/animal/space/mouse_army/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_[rank]_splat"
	src.icon_state = "mouse_[rank]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

//Base ported from vgstation. Operative Mice.
//Icon artists: DeityLink and plosky1
/mob/living/simple_mob/animal/space/mouse_army/operative
	name = "operative mouse"
	desc = "Where did it get that? Oh no..."
	tt_desc = "E Mus sinister"
	rank = "operative"

	shock_resist = 1
	armor = list(
				"melee" = 40,
				"bullet" = 40,
				"laser" = 30,
				"energy" = 15,
				"bomb" = 35,
				"bio" = 100,
				"rad" = 100)	//Mercenary Voidsuit Resistances, slightly downscaled, due to size.

/mob/living/simple_mob/animal/space/mouse_army/pyro
	name = "pyro mouse"
	desc = "What kind of madman would strap this to a mouse?"
	tt_desc = "E Mus phlogiston"
	rank = "pyro"

	maxHealth = 30
	health = 30

	//Mob melee settings
	melee_damage_lower = 5
	melee_damage_upper = 10
	attack_sharp = 0
	attack_edge = 0

	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 20,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 20,
				"bomb" = 90,
				"bio" = 100,
				"rad" = 100)	//Merc suits that have been strategically weakened. They need to be safe until they close in, then it doesn't matter.

	var/exploded = FALSE
	var/explosion_dev_range		= 0
	var/explosion_heavy_range	= 0
	var/explosion_light_range	= 2
	var/explosion_flash_range	= 4 // This doesn't do anything iirc.

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 3 SECONDS	// Upper bound.

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/animal/space/mouse_army/pyro/death()
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
			qdel(src)
	return ..()

// Mouse noises
/datum/say_list/mouse
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
