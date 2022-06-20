/datum/category_item/catalogue/fauna/mouse_army
	name = "R.A.T.S."
	desc = "First observed in limited engagements during the Phoron Wars, \
	Rodents of Abnormal Technical Sophistication are the product of Donk Co \
	research initiatives. Originally designed to serve as covert reconnaissance \
	and surveilance drones, the project quickly ballooned into a mobile force of \
	armored, mechanized rodents. The project failed spectacularly due to budgetary \
	and efficacy reasons. Recently, however, R.A.T.S. assets have been utilized by \
	an unidentified entity for as-yet-unknown purposes."
	value = CATALOGUER_REWARD_EASY
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/mouse_army)

// Obtained by scanning all R.A.T.S.
/datum/category_item/catalogue/fauna/all_mouse_army
	name = "Collection - R.A.T.S."
	desc = "You have scanned a large array of different types of R.A.T.S., \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/mouse_army/operative,
		/datum/category_item/catalogue/fauna/mouse_army/pyro,
		/datum/category_item/catalogue/fauna/mouse_army/ammo,
		/datum/category_item/catalogue/fauna/mouse_army/stealth
		)

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
	faction = "mouse_army"

	maxHealth = 50
	health = 50
	randomized = TRUE
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

	meat_amount = 1
	bone_amount = 1
	hide_amount = 1
	hide_type = /obj/item/stack/hairlesshide

	say_list_type = /datum/say_list/mouse

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	var/rank //pyro, operative, ammo, stealth. more to come. Do not leave blank.

/mob/living/simple_mob/animal/space/mouse_army/Initialize(mapload)
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!rank)
		rank = pick( list("operative","pyro", "ammo", "stealth") )
	icon_state = "mouse_[rank]"
	item_state = "mouse_[rank]"
	icon_living = "mouse_[rank]"
	icon_dead = "mouse_[rank]_dead"
	icon_rest = "mouse_[rank]_sleep"

/mob/living/simple_mob/animal/space/mouse_army/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(ishuman(AM))
		if(!stat)
			var/mob/M = AM
			M.visible_message(SPAN_NOTICE("[icon2html(thing = src, target = world)] Squeek!"))
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
	src.set_stat(DEAD)
	src.icon_dead = "mouse_[rank]_splat"
	src.icon_state = "mouse_[rank]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

//Base ported from vgstation. Operative Mice.
//Icon artists: DeityLink and plosky1

/datum/category_item/catalogue/fauna/mouse_army/operative
	name = "R.A.T.S. - Operative"
	desc = "The baseline unit of a R.A.T.S. team, the Operative was designed \
	to move covertly through tunnel systems. Except for the implanted nano-RIG \
	grafted to their spines, these mice are meant to appear normal when not activated. \
	When active, the miniaturized hardsuit deploys around the mouse and engages its \
	onboard control programming, which fully takes over the rodent's body."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/mouse_army/operative
	name = "operative mouse"
	desc = "Where did it get that? Oh no..."
	tt_desc = "E Mus sinister"
	rank = "operative"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mouse_army/operative)

	shock_resist = 1
	armor = list(
				"melee" = 40,
				"bullet" = 40,
				"laser" = 30,
				"energy" = 15,
				"bomb" = 35,
				"bio" = 100,
				"rad" = 100)	//Mercenary Voidsuit Resistances, slightly downscaled, due to size.

//Pyro Mouse

/datum/category_item/catalogue/fauna/mouse_army/pyro
	name = "R.A.T.S. - Pyro"
	desc = "Designed to serve as miniature sabotage units, Pyro\
	mice are saddled with a purpose-built fuel tank and projector \
	system. Managed by the onboard control program, the unit's size \
	makes it prone to catastrophic rupturing in the field."
	value = CATALOGUER_REWARD_MEDIUM
/mob/living/simple_mob/animal/space/mouse_army/pyro
	name = "pyro mouse"
	desc = "What kind of madman would strap this to a mouse?"
	tt_desc = "E Mus phlogiston"
	rank = "pyro"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mouse_army/pyro)

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
				"rad" = 100)

	projectiletype = /obj/item/projectile/bullet/incendiary/flamethrower
	base_attack_cooldown = 10

	ai_holder_type = /datum/ai_holder/simple_mob/ranged

	var/datum/effect_system/spark_spread/spark_system
	var/ruptured = FALSE

/mob/living/simple_mob/animal/space/mouse_army/pyro/death()
	visible_message("<span class='critical'>\The [src]'s tank groans!</span>")
	var/delay = rand(1, 3)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#000000"
			else
				color = "#FF0000"
			sleep(1)
	..()

	var/turf/simulated/T = get_turf(src)
	if(!T)
		return
	var/datum/gas_mixture/GM = new
	if(prob(10))
		T.assume_gas(/datum/gas/phoron, 100, 1500+T0C)
		T.visible_message("<span class='critical'>\The [src]'s tank vents a cloud of heated gas!</span>")
	else
		T.assume_gas(/datum/gas/phoron, 5, istype(T) ? T.air.temperature : T20C)
		visible_message("<span class='critical'>\The [src]'s tank ruptures!</span>")
	T.assume_air(GM)
	return

//Ammo Mouse

/datum/category_item/catalogue/fauna/mouse_army/ammo
	name = "R.A.T.S. - Ammo Bearer"
	desc = "Ammo Bearing operative mice have sometimes been \
	observed in the field, serving as logistical support to the \
	exotic tanks sometimes fielded by R.A.T.S. forces. Due to the \
	size of their armaments, these mice are vulnerable to violently \
	exploding if their supplies cook off."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/mouse_army/ammo
	name = "ammo mouse"
	desc = "Aww! It's carrying a bunch of tiny bullets!"
	tt_desc = "E Mus tela"
	rank = "ammo"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mouse_army/ammo)

	maxHealth = 30
	health = 30

	//Mob melee settings
	melee_damage_lower = 1
	melee_damage_upper = 5
	attack_sharp = 0
	attack_edge = 0

	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 40,
				"bullet" = 30,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 15,
				"bio" = 100,
				"rad" = 100)

	var/exploded = FALSE
	var/explosion_dev_range		= 0
	var/explosion_heavy_range	= 0
	var/explosion_light_range	= 2
	var/explosion_flash_range	= 4 // This doesn't do anything iirc.

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 3 SECONDS	// Upper bound.

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/animal/space/mouse_army/ammo/death()
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


/datum/category_item/catalogue/fauna/mouse_army/stealth
	name = "R.A.T.S. - Stealth"
	desc = "Stealth operatives carry shockingly expensive integrated \
	gear. Cloaking a rodent is less energy intensive at full scale, \
	but to make the technology miniaturized and portable like this reveals \
	how inflated the project's budget was. Even with such advanced technology, \
	simple movements or attacks were too much for this miniaturized cloak \
	to bear, providing its one major vulnerability."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/space/mouse_army/stealth
	name = "stealth mouse"
	desc = "I bet you thought the normal ones were scary!"
	tt_desc = "E Mus insidiis"
	rank = "stealth"
	catalogue_data = list(/datum/category_item/catalogue/fauna/mouse_army/stealth)

	//Mob melee settings
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_sharp = 1
	attack_edge = 1

	//Damage resistances
	shock_resist = 0.6
	armor = list(
				"melee" = 50,
				"bullet" = 10,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

	player_msg = "You have an imperfect, but automatic stealth. If you attack something while 'hidden', then \
	you will do bonus damage, stun the target, and unstealth for a period of time.<br>\
	Getting attacked will also break your stealth."

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

	var/stealthed = FALSE
	var/stealthed_alpha = 45			// Lower = Harder to see.
	var/stealthed_bonus_damage = 20	// This is added on top of the normal melee damage.
	var/stealthed_weaken_amount = 3	// How long to stun for.
	var/stealth_cooldown = 10 SECONDS	// Amount of time needed to re-stealth after losing it.
	var/last_unstealth = 0			// world.time


/mob/living/simple_mob/animal/space/mouse_army/stealth/proc/stealth()
	if(stealthed)
		return
	animate(src, alpha = stealthed_alpha, time = 1 SECOND)
	stealthed = TRUE


/mob/living/simple_mob/animal/space/mouse_army/stealth/proc/unstealth()
	last_unstealth = world.time // This is assigned even if it isn't stealthed already, to 'reset' the timer if the spider is continously getting attacked.
	if(!stealthed)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	stealthed = FALSE


// Check if stealthing if possible.
/mob/living/simple_mob/animal/space/mouse_army/stealth/proc/can_stealth()
	if(stat)
		return FALSE
	if(last_unstealth + stealth_cooldown > world.time)
		return FALSE

	return TRUE


// Called by things that break stealths, like Technomancer wards.
/mob/living/simple_mob/animal/space/mouse_army/stealth/break_cloak()
	unstealth()


/mob/living/simple_mob/animal/space/mouse_army/stealth/is_cloaked()
	return stealthed


// Cloaks the spider automatically, if possible.
/mob/living/simple_mob/animal/space/mouse_army/stealth/handle_special()
	if(!stealthed && can_stealth())
		stealth()


// Applies bonus base damage if stealthed.
/mob/living/simple_mob/animal/space/mouse_army/stealth/apply_bonus_melee_damage(atom/A, damage_amount)
	if(stealthed)
		return damage_amount + stealthed_bonus_damage
	return ..()

// Applies stun, then unstealths.
/mob/living/simple_mob/animal/space/mouse_army/stealth/apply_melee_effects(atom/A)
	if(stealthed)
		if(isliving(A))
			var/mob/living/L = A
			L.Weaken(stealthed_weaken_amount)
			to_chat(L, SPAN_DANGER("\The [src] ambushes you!"))
			playsound(L, 'sound/weapons/spiderlunge.ogg', 75, 1)
	unstealth()
	..() // For the poison.

// Force unstealthing if attacked.
/mob/living/simple_mob/animal/space/mouse_army/stealth/bullet_act(obj/item/projectile/P)
	. = ..()
	break_cloak()

/mob/living/simple_mob/animal/space/mouse_army/stealth/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()


// Mouse noises
/datum/say_list/mouse
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
