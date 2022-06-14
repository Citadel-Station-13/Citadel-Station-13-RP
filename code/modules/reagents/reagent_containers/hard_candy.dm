/obj/item/reagent_containers/hard_candy
	name = "hard candy"
	desc = "You shouldn't be seeing this. Contact an Admin or Maintainer!"
	icon = 'icons/obj/food.dmi'
	icon_state = "lollipop_stick"
	item_state = "lollipop_stick"
	slot_flags = SLOT_MASK | SLOT_EARS
	throw_speed = 0.5
	attack_verb = list("bapped", "stuck")
	var/nutriment_amt = 0
	var/nutriment_desc = list()
	var/bitesize = 5
	var/succsize = 1
	var/bitecount = 0
	var/succcount = 0
	var/trash = null
	var/succ_int = 500
	var/next_succ = 0
	var/survivalfood = FALSE
	var/mob/living/carbon/owner
	var/mutable_appearance/head
	var/headcolor = rgb(0, 0, 0)
	sprite_sheets = list(INV_MASK_DEF_ICON)
	volume = 20

/obj/item/reagent_containers/hard_candy/Initialize(mapload)
	. = ..()

/obj/item/reagent_containers/hard_candy/proc/On_Consume(var/mob/M)
	if(!usr)
		usr = M
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
		usr.drop_from_inventory(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_containers/hard_candy/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/hard_candy/attack(mob/M as mob, mob/user as mob, def_zone)
	if(reagents && !reagents.total_volume)
		to_chat(user, "<span class='danger'>None of [src] left!</span>")
		user.drop_from_inventory(src)
		qdel(src)
		return 0

	if(istype(M, /mob/living/carbon))
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(M == user)								//If you're eating it yourself
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
					return
				var/obj/item/blocked = null
				if(survivalfood)
					blocked = H.check_mouth_coverage_survival()
				else
					blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

			user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
			if (fullness <= 100)
				to_chat(M, "<span class='danger'>You hungrily chew out a piece of [src] and gobble it!</span>")
			if (fullness > 100 && fullness <= 300)
				to_chat(M, "<span class='notice'>You hungrily begin to eat [src].</span>")
			if (fullness > 300 && fullness <= 700)
				to_chat(M, "<span class='notice'>You take a bite of [src].</span>")
			if (fullness > 700 && fullness <= 1100)
				to_chat(M, "<span class='notice'>You unwillingly chew a bit of [src].</span>")
			if (fullness > 1100 && fullness <= 1300)
				to_chat(M, "<span class='notice'>You swallow some more of the [src], causing your belly to swell out a little.</span>")
			if (fullness > 1300 && fullness <= 1500)
				to_chat(M, "<span class='notice'>You stuff yourself with the [src]. Your stomach feels very heavy.</span>")
			if (fullness > 1500 && fullness <= 1700)
				to_chat(M, "<span class='notice'>You gluttonously swallow down the hunk of [src]. You're so gorged, it's hard to stand.</span>")
			if (fullness > 1700 && fullness <= 1900)
				to_chat(M, "<span class='danger'>You force the piece of [src] down your throat. You can feel your stomach getting firm as it reaches its limits.</span>")
			if (fullness > 1900 && fullness <= 2100)
				to_chat(M, "<span class='danger'>You barely glug down the bite of [src], causing undigested food to force into your intestines. You can't take much more of this!</span>")
			if (fullness > 2100) // There has to be a limit eventually.
				to_chat(M, "<span class='danger'>Your stomach blorts and aches, prompting you to stop. You literally cannot force any more of [src] to go down your throat.</span>")
				return 0
			/*if (fullness > (550 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				to_chat(M, "<span class='danger'>You cannot force any more of [src] to go down your throat.</span>")
				return 0*/

		else
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

			if(!istype(M, /mob/living/carbon/slime)) // If you're feeding it to someone else.

				user.visible_message(SPAN_DANGER("[user] attempts to feed [M] [src]."))

				user.setClickCooldown(user.get_attack_speed(src))
				if(!do_mob(user, M)) return

				//Do we really care about this
				add_attack_logs(user,M,"Fed with [src.name] containing [reagentlist(src)]", admin_notify = FALSE)

				user.visible_message("<span class='danger'>[user] feeds [M] [src].</span>")

			else
				to_chat(user, "This creature does not seem to have a mouth!")
				return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(reagents.total_volume)
				if(reagents.total_volume > bitesize)
					reagents.trans_to_mob(M, bitesize, CHEM_INGEST)
				else
					reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
				bitecount++
				On_Consume(M)
			return 1

	return 0

/obj/item/reagent_containers/hard_candy/process()
	if(!owner)
		stack_trace("candy processing without an owner")
		return PROCESS_KILL
	if(!reagents)
		stack_trace("candy processing without a reagents datum")
		return PROCESS_KILL
	if(owner.stat == DEAD)
		return PROCESS_KILL
	if(next_succ <= world.time)
		succ()
		next_succ = world.time + succ_int

/obj/item/reagent_containers/hard_candy/equipped(mob/user, var/slot)
	. = ..()
	if(!iscarbon(user))
		return
	if(slot != slot_wear_mask)
		owner = null
		STOP_PROCESSING(SSobj, src) //equipped is triggered when moving from hands to mouth and vice versa
		return
	owner = user
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/hard_candy/proc/succ()
	if(reagents.total_volume)
		if(reagents.total_volume > succsize)
			reagents.trans_to_mob(owner, succsize, CHEM_INGEST)
		else
			reagents.trans_to_mob(owner, reagents.total_volume, CHEM_INGEST)
		succcount++
		On_Consume(owner)

/obj/item/reagent_containers/hard_candy/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/reagent_containers/hard_candy/proc/change_head_color(C)
	headcolor = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

//Lollipops

/obj/item/reagent_containers/hard_candy/lollipop
	name = "lollipop"
	desc = "A delicious lollipop."
	icon = 'icons/obj/food.dmi'
	icon_state = "lollipop_stick"
	item_state = "lollipop_stick"
	trash = /obj/item/trash/lollipop_stick

/obj/item/reagent_containers/hard_candy/lollipop/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sugar", 4)
	reagents.add_reagent("nutriment", 1)
	head = mutable_appearance('icons/obj/food.dmi', "lollipop_head")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))

//Pre-Made Medicated lollipops.
/obj/item/reagent_containers/hard_candy/lollipop/bicard
	name = "Bicari-pop"
	desc = "A candy perfect for those stingy ouchies. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/bicard/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bicaridine", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((210), (55), (45)))

/obj/item/reagent_containers/hard_candy/lollipop/citalopram
	name = "Happy-pop"
	desc = "A candy perfect for those frowny feelings. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/citalopram/Initialize(mapload)
	. = ..()
	reagents.add_reagent("citalopram", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((250), (115), (235)))

/obj/item/reagent_containers/hard_candy/lollipop/combat
	name = "Commed-pop"
	desc = "A lolipop devised to heal wounds overtime, with a slower amount of reagent use. Can be eaten or put in the mask slot"

/obj/item/reagent_containers/hard_candy/lollipop/combat/Initialize(mapload)
	. = ..()
	reagents.add_reagent("bicaridine", 5)
	reagents.add_reagent("kelotane", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((200), (0), (255)))

/obj/item/reagent_containers/hard_candy/lollipop/dexalin
	name = "Dexa-pop"
	desc = "A candy perfect for those raspy gaspies. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/dexalin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dexalin", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((10), (150), (220)))

/obj/item/reagent_containers/hard_candy/lollipop/dylovene
	name = "Dylo-pop"
	desc = "A candy perfect for keeping your blood sweet. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/dylovene/Initialize(mapload)
	. = ..()
	reagents.add_reagent("dylovene", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((35), (160), (80)))

/obj/item/reagent_containers/hard_candy/lollipop/ethylredoxrazine
	name = "Ethylredox-a-pop"
	desc = "A candy perfect for the functional alcoholic. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/ethylredoxrazine/Initialize(mapload)
	. = ..()
	reagents.add_reagent("ethylredoxrazine", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((140), (110), (90)))

/obj/item/reagent_containers/hard_candy/lollipop/hyronalin
	name = "Hyrona-pop"
	desc = "A candy perfect for keeping your cells from melting. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/hyronalin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("hyronalin", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((70), (120), (25)))

/obj/item/reagent_containers/hard_candy/lollipop/kelotane
	name = "Kelo-pop"
	desc = "A candy perfect for those sizzly wizzlies. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/kelotane/Initialize(mapload)
	. = ..()
	reagents.add_reagent("kelotane", 5)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((250), (180), (40)))

/obj/item/reagent_containers/hard_candy/lollipop/tramadol
	name = "Tram-pop"
	desc = "Your reward for behaving so well in the medbay. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)

/obj/item/reagent_containers/hard_candy/lollipop/tramadol/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tramadol", 4)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((210), (50), (195)))
/obj/item/reagent_containers/hard_candy/lollipop/tricord
	name = "Tricord-pop"
	desc = "A lolipop laced with tricordazine, a slow healing reagent. Can be eaten or put in the mask slot."
	nutriment_desc = list("cough syrup" = 1, "artificial sweetness" = 1)
	volume = 15

/obj/item/reagent_containers/hard_candy/lollipop/tricord/Initialize(mapload)
	. = ..()
	reagents.add_reagent("tricordrazine", 10)
	reagents.add_reagent("sugar", 1)
	change_head_color(rgb((200), (0), (255)))
