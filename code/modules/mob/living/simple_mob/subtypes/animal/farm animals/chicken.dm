GLOBAL_VAR_CONST(MAX_CHICKENS, 50)	// How many chickens CAN we have?
GLOBAL_VAR_INIT(chicken_count, 0)	// How mant chickens DO we have?

/datum/category_item/catalogue/fauna/livestock
	name = "Livestock"
	desc = "Organisms raised and traded across the galaxy for utility purposes, \
	such as labor, material harvesting, and most often - food. Many forms of livestock \
	imported to the Frontier come from Confederation space, and trace their genetic \
	origin points back to Earth."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/livestock)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_livestock
	name = "Collection - Livestock"
	desc = "You have scanned a large array of different types of Livestock, \
	and therefore you have been granted a small sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_EASY
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/livestock/chicken,
		/datum/category_item/catalogue/fauna/livestock/cow,
		/datum/category_item/catalogue/fauna/livestock/goat
		)

/datum/category_item/catalogue/fauna/livestock/chicken
	name = "Livestock - Chicken"
	desc = "An avian species hailing from Earth, chickens are actually \
	the descendants of an ancient Earth clade known as Dinosaurs. Often regarded \
	as a previously dominant life form, these creatures were largely driven to \
	extinction by climate change. Chickens are popular Frontier livestock due to \
	their edible ovum and their own versatility as a meat product."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/chicken
	name = "chicken"
	desc = "Hopefully the eggs are good this season."
	tt_desc = "E Gallus gallus"
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/livestock/chicken)

	health = 10
	maxHealth = 10

	randomized = TRUE

	pass_flags = PASSTABLE
	mob_size = MOB_SMALL

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = list("kicked")

	has_langs = list("Bird")

	say_list_type = /datum/say_list/chicken

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	bone_amount = 1

	var/eggsleft = 0
	var/body_color

/mob/living/simple_mob/animal/passive/chicken/Initialize(mapload)
	. = ..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.chicken_count += 1

/mob/living/simple_mob/animal/passive/chicken/Destroy()
	GLOB.chicken_count -= 1
	return ..()

/mob/living/simple_mob/animal/passive/chicken/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/reagent_containers/food/snacks/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "wheat")
			if(!stat && eggsleft < 8)
				user.visible_message("<font color=#4F49AF>[user] feeds [O] to [name]! It clucks happily.</font>","<font color=#4F49AF>You feed [O] to [name]! It clucks happily.</font>")
				user.drop_item()
				qdel(O)
				eggsleft += rand(1, 4)
			else
				to_chat(user, "<font color=#4F49AF>[name] doesn't seem hungry!</font>")
		else
			to_chat(user, "[name] doesn't seem interested in that.")
	else
		..()

/mob/living/simple_mob/animal/passive/chicken/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if((stat != DEAD) && prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/reagent_containers/food/snacks/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(GLOB.chicken_count < GLOB.MAX_CHICKENS && prob(10))
			START_PROCESSING(SSobj, E)

/obj/item/reagent_containers/food/snacks/egg/var/amount_grown = 0

// This only starts normally if there are less than MAX_CHICKENS chickens
/obj/item/reagent_containers/food/snacks/egg/process(delta_time)
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_mob/animal/passive/chick(get_turf(src))
			STOP_PROCESSING(SSobj, src)
			qdel(src)
	else
		STOP_PROCESSING(SSobj, src)







/mob/living/simple_mob/animal/passive/chick
	name = "chick"
	desc = "Adorable! They make such a racket though."
	tt_desc = "E Gallus gallus"
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"

	health = 1
	maxHealth = 1

	pass_flags = PASSTABLE | PASSGRILLE
	mob_size = MOB_MINISCULE

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = list("kicked")

	has_langs = list("Bird")

	say_list_type = /datum/say_list/chick

	meat_amount = 1

	var/amount_grown = 0

/mob/living/simple_mob/animal/passive/chick/Initialize(mapload)
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_mob/animal/passive/chick/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_mob/animal/passive/chicken(src.loc)
			qdel(src)

// Say Lists
/datum/say_list/chicken
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	emote_hear = list("clucks","croons")
	emote_see = list("pecks at the ground","flaps its wings viciously")

/datum/say_list/chick
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")
