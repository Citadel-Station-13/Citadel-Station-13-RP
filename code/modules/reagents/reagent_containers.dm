/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = null
	w_class = ITEMSIZE_SMALL

	/// start reagent list. overrides reagent/volume. list(id = volume); volume must be specified.
	var/list/start_with
	/// start reagent id or path
	var/start_reagent
	/// start reagent amount. null for max.
	var/start_volume
	/// volume of our default reagents holder
	var/volume = 30
	/// automatically rename to [[start_reagent]]
	var/start_rename = FALSE

	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)

/obj/item/reagent_containers/Initialize(mapload)
	. = ..()
	if(!possible_transfer_amounts)
		remove_obj_verb(src, /obj/item/reagent_containers/verb/set_APTFT)
	create_reagents(volume)
	if(!isnull(start_with))
		for(var/id in start_with)
			reagents.add_reagent(id, start_with[id])
	else if(!isnull(start_reagent))
		reagents.add_reagent(start_reagent, isnull(start_volume)? volume : start_volume)
		if(start_rename)
			var/datum/reagent/R = start_reagent
			name = "[name] ([initial(R.name)])"

/obj/item/reagent_containers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/attack_self(mob/user, datum/event_args/clickchain/e_args)
	. = ..()
	if(.)
		return
	return

/obj/item/reagent_containers/proc/reagentlist() // For attack logs
	if(reagents)
		return reagents.get_reagents()
	return "No reagent holder"

/obj/item/reagent_containers/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, "<span class='notice'>[target] is empty.</span>")
		return 1

	if(reagents && !reagents.available_volume())
		to_chat(user, "<span class='notice'>[src] is full.</span>")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")
	return 1

/obj/item/reagent_containers/proc/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(target.reagents && !target.reagents.available_volume())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/contained = reagentlist()
	add_attack_logs(user,target,"Splashed with [src.name] containing [contained]")
	user.visible_message("<span class='danger'>[target] has been splashed with something by [user]!</span>", "<span class = 'notice'>You splash the solution onto [target].</span>")
	reagents.splash(target, reagents.total_volume)
	return 1

/obj/item/reagent_containers/proc/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You eat \the [src]</span>")

/obj/item/reagent_containers/proc/other_feed_message_start(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] is trying to feed [target] \the [src]!</span>")

/obj/item/reagent_containers/proc/other_feed_message_finish(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] has fed [target] \the [src]!</span>")

/obj/item/reagent_containers/proc/feed_sound(var/mob/user)
	return

/obj/item/reagent_containers/proc/standard_feed_mob(var/mob/user, var/mob/target) // This goes into attack
	if(!istype(target))
		return 0

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
		return 1

	if(target == user)
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return

		user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
		self_feed_message(user)
		reagents.trans_to_mob(user, issmall(user) ? CEILING(amount_per_transfer_from_this/2, 1) : amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return 1
	else
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			if(!H.check_has_mouth())
				to_chat(user, "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!")
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
				return

		other_feed_message_start(user, target)

		user.setClickCooldown(user.get_attack_speed(src))
		if(!do_mob(user, target))
			return

		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		add_attack_logs(user,target,"Fed from [src.name] containing [contained]")
		reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return 1

/obj/item/reagent_containers/proc/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.is_open_container() || !target.reagents)
		return 0

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(!target.reagents.available_volume())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You transfer [trans] units of the solution to [target].</span>")
	return 1
