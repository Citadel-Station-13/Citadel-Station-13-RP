//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	tt_desc = "E Felis silvestris catus"
	intelligence_level = SA_ANIMAL
	icon_state = "cat2"
	item_state = "cat2"
	icon_living = "[initial(icon_state)]"
	icon_dead = "[initial(icon_state)]_dead"
	icon_rest = "[initial(icon_state)]_rest"

	investigates = 1
	specific_targets = 1 //Only targets with Found()
	run_at_them = 0 //DOMESTICATED
	view_range = 5

	turns_per_move = 5
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius

	holder_type = /obj/item/holder/cat
	mob_size = MOB_SMALL

	has_langs = list("Cat")
	speak_chance = 1
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	say_maybe_target = list("Meow?","Mew?","Mao?")
	say_got_target = list("MEOW!","HSSSS!","REEER!")

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	var/turns_since_scan = 0
	var/mob/flee_target

/mob/living/simple_animal/cat/Life()
	. = ..()
	if(!.) return

	if(prob(2)) //spooky
		var/mob/observer/dead/spook = locate() in range(src,5)
		if(spook)
			var/turf/T = spook.loc
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

	handle_flee_target()

/mob/living/simple_animal/cat/PunchTarget()
	if(ismouse(target_mob))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = target_mob
		mouse.splat()
		visible_emote(pick("bites \the [mouse]!","toys with \the [mouse].","chomps on \the [mouse]!"))
		return mouse
	else
		..()

/mob/living/simple_animal/cat/Found(var/atom/found_atom)
	if(ismouse(found_atom) && SA_attackable(found_atom))
		return found_atom

/mob/living/simple_animal/cat/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target in ListTargets(view_range)))
		flee_target = null
		GiveUpMoving()

	if (flee_target && !stat && !buckled)
		if (resting)
			lay_down()
		if(prob(25)) say("HSSSSS")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/cat/react_to_attack(var/atom/A)
	if(A == src) return
	flee_target = A
	turns_since_scan = 5

/mob/living/simple_animal/cat/ex_act()
	. = ..()
	react_to_attack(src.loc)

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null
	var/friend_name = null

/mob/living/simple_animal/cat/fluff/Life()
	. = ..()
	if(!. || ai_inactive || !friend) return

	var/friend_dist = get_dist(src,friend)

	if (friend_dist <= 4)
		if(stance == STANCE_IDLE)
			if(set_follow(friend))
				handle_stance(STANCE_FOLLOW)

	if (friend_dist <= 1)
		if (friend.stat >= DEAD || friend.health <= config_legacy.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "purrs."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/cat/fluff/verb/become_friends()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(!friend)
		var/mob/living/carbon/human/H = usr
		if(istype(H) && (!befriend_job || H.job == befriend_job) && (!friend_name || H.real_name == friend_name))
			friend = usr
			. = 1
	else if(usr == friend)
		. = 1 //already friends, but show success anyways

	if(.)
		setDir(get_dir(src, friend))
		visible_emote(pick("nuzzles [friend].",
						   "brushes against [friend].",
						   "rubs against [friend].",
						   "purrs."))
	else
		to_chat(usr, "<span class='notice'>[src] ignores you.</span>")
	return

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	tt_desc = "E Felis silvestris medicalis" //a hypoallergenic breed produced by NT for... medical purposes? Sure.
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	befriend_job = "Chief Medical Officer"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	gender = NEUTER

// Leaving this here for now.
/obj/item/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/mob/living/simple_animal/cat/fluff/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	holder_type = /obj/item/holder/cat/fluff/bones
	friend_name = "Erstatz Vryroxes"

/mob/living/simple_animal/cat/kitten/New()
	gender = pick(MALE, FEMALE)
	..()

/mob/living/simple_mob/cat/fluff/Runtime/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "The slimy wet insides of Runtime! Not quite as clean as the cat on the outside."

	B.emote_lists[DM_HOLD] = list(
		"Runtime's stomach kneads gently on you and you're fairly sure you can hear her start purring.",
		"Most of what you can hear are slick noises, Runtime breathing, and distant purring.",
		"Runtime seems perfectly happy to have you in there. She lays down for a moment to groom and squishes you against the walls.",
		"The CMO's pet seems to have found a patient of her own, and is treating them with warm, wet kneading walls.",
		"Runtime mostly just lazes about, and you're left to simmer in the hot, slick guts unharmed.",
		"Runtime's master might let you out of this fleshy prison, eventually. Maybe. Hopefully?")

	B.emote_lists[DM_DIGEST] = list(
		"Runtime's stomach is treating you rather like a mouse, kneading acids into you with vigor.",
		"A thick dollop of bellyslime drips from above while the CMO's pet's gut works on churning you up.",
		"Runtime seems to have decided you're food, based on the acrid air in her guts and the pooling fluids.",
		"Runtime's stomach tries to claim you, kneading and pressing inwards again and again against your form.",
		"Runtime flops onto their side for a minute, spilling acids over your form as you remain trapped in them.",
		"The CMO's pet doesn't seem to think you're any different from any other meal. At least, their stomach doesn't.")

	B.digest_messages_prey = list(
		"Runtime's stomach slowly melts your body away. Her stomach refuses to give up it's onslaught, continuing until you're nothing more than nutrients for her body to absorb.",
		"After an agonizing amount of time, Runtime's stomach finally manages to claim you, melting you down and adding you to her stomach.",
		"Runtime's stomach continues to slowly work away at your body before tightly squeezing around you once more, causing the remainder of your body to lose form and melt away into the digesting slop around you.",
		"Runtime's slimy gut continues to constantly squeeze and knead away at your body, the bulge you create inside of her stomach growing smaller as time progresses before soon dissapearing completely as you melt away.",
		"Runtime's belly lets off a soft groan as your body finally gives out, the cat's eyes growing heavy as it settles down to enjoy it's good meal.",
		"Runtime purrs happily as you slowly slip away inside of her gut, your body's nutrients are then used to put a layer of padding on the now pudgy cat.",
		"The acids inside of Runtime's stomach, aided by the constant motions of the smooth walls surrounding you finally manage to melt you away into nothing more mush. She curls up on the floor, slowly kneading the air as her stomach moves its contents — including you — deeper into her digestive system.",
		"Your form begins to slowly soften and break apart, rounding out Runtime's swollen belly. The carnivorous cat rumbles and purrs happily at the feeling of such a filling meal.")
