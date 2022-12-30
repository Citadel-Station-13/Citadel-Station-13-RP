/datum/category_item/catalogue/fauna/snake
	name = "Snake"
	desc = "An Earth reptile with a distinct lack of limbs, \
	snakes ambulate by slithering across the ground. Snakes \
	possess a wide variety of colorations and patterns, and are \
	sometimes owned as pets by enthusiasts. Many are venemous, \
	although there are harmless species, as well as species which \
	consume their prey via more specific techniques, such as \
	constriction."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/snake
	name = "snake"
	desc = "A big thick snake."
	catalogue_data = list(/datum/category_item/catalogue/fauna/snake)

	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"
	icon = 'icons/mob/snake_vr.dmi'

	maxHealth = 20
	health = 20
	randomized = TRUE

	movement_cooldown = 8 // SLOW-ASS MUTHAFUCKA, I hope.

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "kicks"

	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = list("bitten")

	say_list_type = /datum/say_list/snake
	ai_holder_type = /datum/ai_holder/simple_mob/passive

	bone_amount = 5
	hide_amount = 1
	hide_type = /obj/item/stack/hairlesshide

/datum/say_list/snake
	emote_hear = list("hisses")

//NOODLE IS HERE! SQUEEEEEEEE~
/mob/living/simple_mob/animal/passive/snake/noodle
	name = "Noodle"
	desc = "This snake is particularly chubby and demands nothing but the finest of treats."

	makes_dirt = FALSE

	var/turns_since_scan = 0
	var/obj/movement_target
	randomized = FALSE

/mob/living/simple_mob/animal/passive/snake/noodle/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	//Not replacing with SA FollowTarget mechanics because Ian behaves... very... specifically.

	//Feeding, chasing food, FOOOOODDDD
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				for(var/obj/item/reagent_containers/food/snacks/snakesnack/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						visible_emote("turns towards \the [movement_target] and slithers towards it.")
						break
			if(movement_target)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)

				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						setDir(WEST)
					else if (movement_target.loc.x > src.x)
						setDir(EAST)
					else if (movement_target.loc.y < src.y)
						setDir(SOUTH)
					else if (movement_target.loc.y > src.y)
						setDir(NORTH)
					else
						setDir(SOUTH)

					if(isturf(movement_target.loc) )
						UnarmedAttack(movement_target)
					else if(ishuman(movement_target.loc) && prob(20))
						visible_emote("stares at the [movement_target] that [movement_target.loc] has with an unknowable reptilian gaze.")

/* old eating code, couldn't figure out how to make the "swallows food" thing so I'm keeping this here incase someone wants legacy"
/mob/living/simple_mob/animal/passive/snake/noodle/Life(seconds, times_fired) //stolen from Ian in corgi.dm
	if(!..())
		return 0

	if(!stat && !resting && !buckled && !ai_inactive)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if(movement_target && !(isturf(movement_target.loc) || ishuman(movement_target.loc)))
				movement_target = null
				stop_automated_movement = 0
			if(!movement_target || !(movement_target.loc in oview(src, 5)) )
				movement_target = null
				stop_automated_movement = 0
				walk(src,0)
				for(var/obj/item/reagent_containers/food/snacks/snakesnack/S in oview(src,3))
					if(isturf(S.loc))
						movement_target = S
						visible_emote("turns towards \the [movement_target] and slithers towards it.")
						break

		if(movement_target)
			stop_automated_movement = 1
			walk_to(src, movement_target, 0, 5)
			spawn(10)
				if(Adjacent(movement_target))
					visible_message("<span class='notice'>[src] swallows the [movement_target] whole!</span>")
					qdel(movement_target)
					walk(src,0)
				else if(ishuman(movement_target.loc) && prob(20))
					visible_emote("stares at the [movement_target] that [movement_target.loc] has with an unknowable reptilian gaze.")
*/

/mob/living/simple_mob/animal/passive/snake/noodle/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("swallows \the [mouse] whole!"))
	else
		..()

/mob/living/simple_mob/animal/passive/snake/noodle/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/reagent_containers/food/snacks/snakesnack))
		visible_message("<span class='notice'>[user] feeds \the [O] to [src].</span>")
		qdel(O)
	else
		return ..()

//Special snek-snax for Noodle!
/obj/item/reagent_containers/food/snacks/snakesnack
	name = "sugar mouse"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these!"
	var/snack_colour
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snack_yellow"
	nutriment_amt = 1
	nutriment_desc = list("sugar" = 1)

/obj/item/reagent_containers/food/snacks/snakesnack/Initialize(mapload)
	. = ..()
	if(!snack_colour)
		snack_colour = pick( list("yellow","green","pink","blue") )
	icon_state = "snack_[snack_colour]"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these! This one is [snack_colour]."
	reagents.add_reagent("sugar", 2)

/obj/item/storage/box/snakesnackbox
	name = "box of Snake Snax"
	desc = "A box containing Noodle's special sugermouse treats."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "sneksnakbox"
	storage_slots = 7

/obj/item/storage/box/snakesnackbox/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
