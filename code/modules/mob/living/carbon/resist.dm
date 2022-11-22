/mob/living/carbon/resist_fire()
	adjust_fire_stacks(-1.2)
	Weaken(3)
	spin(32,2)
	visible_message(
		SPAN_DANGER("[src] rolls on the floor, trying to put themselves out!"),
		SPAN_NOTICE("You stop, drop, and roll!")
		)
	sleep(30)
	if(fire_stacks <= 0)
		visible_message(
			SPAN_DANGER("[src] has successfully extinguished themselves!"),
			SPAN_NOTICE("You extinguish yourself.")
			)
		ExtinguishMob()
	return TRUE

/mob/living/carbon/resist_restraints()
	var/obj/item/I = null
	if(handcuffed)
		I = handcuffed
	else if(legcuffed)
		I = legcuffed

	if(I)
		setClickCooldown(100)
		cuff_resist(I, cuff_break = can_break_cuffs())

/mob/living/carbon/proc/reduce_cuff_time()
	return FALSE

/mob/living/carbon/proc/cuff_resist(obj/item/handcuffs/I, breakouttime = 1200, cuff_break = 0)

	if(istype(I))
		breakouttime = I.breakouttime

	var/displaytime = breakouttime / 10

	var/reduceCuffTime = reduce_cuff_time()
	if(reduceCuffTime)
		breakouttime /= reduceCuffTime
		displaytime /= reduceCuffTime

	if(cuff_break)
		visible_message(
			SPAN_DANGER("[src] is trying to break [I]!"),
			SPAN_WARNING("You attempt to break your [I]. (This will take around 5 seconds and you need to stand still)"))

		if(do_after(src, 5 SECONDS, target = src, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
			if(!I || buckled)
				return
			visible_message(
				SPAN_DANGER("[src] manages to break [I]!"),
				SPAN_WARNING("You successfully break your [I]."))
			say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))

			if(I == handcuffed)
				handcuffed = null
				update_handcuffed()
			else if(I == legcuffed)
				legcuffed = null
				update_inv_legcuffed()

			buckled?.buckled_reconsider_restraints()

			qdel(I)
		else
			to_chat(src, SPAN_WARNING("You fail to break [I]."))
		return

	visible_message(
		SPAN_DANGER("[src] attempts to remove [I]!"),
		SPAN_WARNING("You attempt to remove [I]. (This will take around [displaytime] seconds and you need to stand still)"))
	if(do_after(src, breakouttime, target = src, incapacitation_flags = INCAPACITATION_DISABLED & INCAPACITATION_KNOCKDOWN))
		visible_message(
			SPAN_DANGER("[src] manages to remove [I]!"),
			SPAN_NOTICE("You successfully remove [I]."))
		drop_item_to_ground(I, INV_OP_FORCE)

/mob/living/carbon/proc/can_break_cuffs()
	if(MUTATION_HULK in mutations)
		return TRUE
