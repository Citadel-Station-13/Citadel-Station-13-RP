//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//TODO: Make these simple_mobs
//Commented out as reference for future reproduction methods, or addition later if needed. - Mech

//TODO (Cap):
/*
- Rand movement for huggers.
- Fix implantation/impregnation.
*/

var/const/MIN_IMPREGNATION_TIME = 100 //time it takes to impregnate someone
var/const/MAX_IMPREGNATION_TIME = 150

var/const/MIN_ACTIVE_TIME = 200 //time between being dropped and going idle
var/const/MAX_ACTIVE_TIME = 400

/obj/item/clothing/mask/facehugger
	name = "alien"
	desc = "It has some sort of a tube at the end of its tail."
	//icon = 'icons/mob/alien.dmi'
	icon_state = "facehugger"
	item_state = "facehugger"
	w_class = 3 //note: can be picked up by aliens unlike most other items of w_class below 4
	flags = PROXMOVE
	body_parts_covered = FACE|EYES
	throw_range = 5

	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/sterile = 0
	var/strength = 5
	var/attached = 0

/obj/item/clothing/mask/facehugger/attack_hand(user as mob)

	if((stat == CONSCIOUS && !sterile))
		if(Attach(user))
			return

	..()

/obj/item/clothing/mask/facehugger/attack(mob/living/M as mob, mob/user as mob)
	..()
	user.drop_from_inventory(src)
	Attach(M)

//Bypasses the config check because it's completely blocking spawn.
/*
/obj/item/clothing/mask/facehugger/Initialize(mapload)
	if(config_legacy.aliens_allowed)
		return ..()
	else
		return INITIALIZE_HINT_QDEL
*/

/obj/item/clothing/mask/facehugger/examine(mob/user)
	..(user)
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			to_chat(user, "<span class='danger'><b>[src] is not moving.</b></span>")
		if(CONSCIOUS)
			to_chat(user, "<span class='danger'><b>[src] seems to be active.</b></span>")
	if (sterile)
		to_chat(user, "<span class='danger'><b>It looks like the proboscis has been removed.</b></span>")
	return

/obj/item/clothing/mask/facehugger/attackby(obj/item/I, mob/user)
	if(I.force)
		user.do_attack_animation(src)
		Die()
	return

/obj/item/clothing/mask/facehugger/bullet_act()
	Die()
	return

/obj/item/clothing/mask/facehugger/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C+80)
		Die()
	return

/obj/item/clothing/mask/facehugger/equipped(mob/M)
	..()
	Attach(M)

/obj/item/clothing/mask/facehugger/Crossed(atom/target)
	..()
	HasProximity(target)
	return

/obj/item/clothing/mask/facehugger/on_found(mob/finder as mob)
	if(stat == CONSCIOUS)
		HasProximity(finder)
		return 1
	return

/obj/item/clothing/mask/facehugger/HasProximity(atom/movable/AM as mob|obj)
	if(CanHug(AM))
		Attach(AM)

/obj/item/clothing/mask/facehugger/throw_at(atom/target, range, speed)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		spawn(15)
			if(icon_state == "[initial(icon_state)]_thrown")
				icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/facehugger/throw_impact(atom/hit_atom)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		throwing = 0
	GoIdle(30,100) //stunned for a few seconds - allows throwing them to be useful for positioning but not as an offensive action (unless you're setting up a trap)

/obj/item/clothing/mask/facehugger/proc/Attach(M as mob)

	if((!iscorgi(M) && !iscarbon(M)))
		return

	if(attached)
		return

	var/mob/living/carbon/C = M
	if(istype(C) && locate(/obj/item/organ/internal/xenos/hivenode) in C.internal_organs)
		return


	attached++
	spawn(MAX_IMPREGNATION_TIME)
		attached = 0

	var/mob/living/L = M //just so I don't need to use :

	if(loc == L) return
	if(stat != CONSCIOUS)	return
	if(!sterile) L.take_organ_damage(strength,0) //done here so that even borgs and humans in helmets take damage

	L.visible_message("<span class='danger'><b> [src] leaps at [L]'s face!</b></span>")

	if(iscarbon(M))
		var/mob/living/carbon/target = L

		if(target.wear_mask)
			if(prob(20))	return
			var/obj/item/clothing/W = target.wear_mask
			if(!W.canremove)	return
			target.drop_from_inventory(W)

			target.visible_message("<span class='danger'><b> [src] tears [W] off of [target]'s face!</b></span>")

		target.equip_to_slot(src, slot_wear_mask)
		target.contents += src // Monkey sanity check - Snapshot

		if(!sterile) L.Paralyse(MAX_IMPREGNATION_TIME/6) //something like 25 ticks = 20 seconds with the default settings

	GoIdle() //so it doesn't jump the people that tear it off

	spawn(rand(MIN_IMPREGNATION_TIME,MAX_IMPREGNATION_TIME))
		Impregnate(L)

	return

/obj/item/clothing/mask/facehugger/proc/Impregnate(mob/living/target as mob)
	if(!target || target.wear_mask != src || target.stat == DEAD) //was taken off or something
		return

	if(!sterile)
		new /obj/item/alien_embryo(target)
		target.status_flags |= TRAIT_XENO_HOST
		target.visible_message("<span class='danger'><b> [src] falls limp after violating [target]'s face!</b></span>")
		icon_state = "[initial(icon_state)]_impregnate"
		Die()
	else
		target.visible_message("<span class='danger'><b> [src] violates [target]'s face!</b></span>")
	return

/obj/item/clothing/mask/facehugger/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

	return

/obj/item/clothing/mask/facehugger/proc/GoIdle(var/min_time=MIN_ACTIVE_TIME, var/max_time=MAX_ACTIVE_TIME)
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	spawn(rand(min_time,max_time))
		GoActive()
		return

	stat = DEAD
	src.visible_message("<span class='danger'><b>[src] curls up into a ball!</b></span>")
	Die()
	return

/proc/CanHug(var/mob/M)

	if(iscorgi(M))
		return 1

	if(!iscarbon(M))
		return 0

	var/mob/living/carbon/C = M
	if(istype(C) && locate(/obj/item/organ/internal/xenos/hivenode) in C.internal_organs)
		return 0

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.head && (H.head.body_parts_covered & FACE) && !(H.head.item_flags & FLEXIBLEMATERIAL))
			return 0
	return 1



//Copies Spiderling movement code to try and animate the Hugger. Also adds missing procs that might be important.

/obj/item/clothing/mask/facehugger/Initialize(mapload, atom/parent)
	. = ..()
	pixel_x = rand(6,-6)
	pixel_y = rand(6,-6)
	START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/facehugger/Destroy()
	STOP_PROCESSING(SSobj, src)
	walk(src, 0) // Because we might have called walk_to, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/item/clothing/mask/facehugger/Bump(atom/user)
	if(istype(user, /obj/structure/table))
		src.loc = user.loc
	else
		..()

/obj/item/clothing/mask/facehugger/proc/Die()
	if(stat != DEAD)
		visible_message("<span class='alert'>[src] dies!</span>")
		stat = DEAD
	STOP_PROCESSING(SSobj, src)
	walk(src, 0)
	DeathIcon()
	return

/obj/item/clothing/mask/facehugger/proc/DeathIcon()
	if (src.icon_state == "[initial(icon_state)]_impregnate")
		return
	else
		src.icon_state = "[initial(icon_state)]_dead"
	update_icon()

/obj/item/clothing/mask/facehugger/process(delta_time)
	if(isturf(loc))
		crawl()

/obj/item/clothing/mask/facehugger/proc/crawl()
	if(isturf(loc))
		if(prob(25))
			var/list/nearby = trange(5, src) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(25))
					src.visible_message("<span class='notice'>\The [src] skitters[pick(" away"," around","")].</span>")

// Simple Mob Conversion. Leaving this commented out because I really don't want to actually have to convert this.
/*

/mob/living/simple_mob/animal/space/alien/facehugger
	name = "facehugger"
	desc = "There's something unsettling about this creature's mouth."
	icon = 'icons/mob/alien.dmi'
	icon_state = "facehugger"
	item_state = "facehugger"
	icon_living = "facehugger"
	icon_dead = "facehugger_dead"
	icon_rest = "facehugger_inactive"
	faction = "xeno"

	mob_class = MOB_CLASS_ABERRATION

	maxHealth = 50
	health = 50

	attacktext = list("grasped")

	var/stat = CONSCIOUS //UNCONSCIOUS is the idle state in this case
	var/sterile = 0
	var/strength = 5
	var/attached = 0

/mob/living/simple_mob/animal/space/alien/facehugger/attack_hand(user as mob)

	if((stat == CONSCIOUS && !sterile))
		if(Attach(user))
			return

	..()

/mob/living/simple_mob/animal/space/alien/facehugger/attack(mob/living/M as mob, mob/user as mob)
	..()
	user.drop_from_inventory(src)
	Attach(M)

/mob/living/simple_mob/animal/space/alien/facehugger/Initialize(mapload)
	if(config_legacy.aliens_allowed)
		return ..()
	else
		return INITIALIZE_HINT_QDEL

/mob/living/simple_mob/animal/space/alien/facehugger/examine(mob/user)
	..(user)
	switch(stat)
		if(DEAD,UNCONSCIOUS)
			to_chat(user, "<span class='danger'><b>[src] is not moving.</b></span>")
		if(CONSCIOUS)
			to_chat(user, "<span class='danger'><b>[src] seems to be active.</b></span>")
	if (sterile)
		to_chat(user, "<span class='danger'><b>It looks like the proboscis has been removed.</b></span>")
	return

/mob/living/simple_mob/animal/space/alien/facehugger/attackby(obj/item/I, mob/user)
	if(I.force)
		user.do_attack_animation(src)
		Die()
	return

/mob/living/simple_mob/animal/space/alien/facehugger/bullet_act()
	Die()
	return

/mob/living/simple_mob/animal/space/alien/facehugger/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C+80)
		Die()
	return

/obj/item/clothing/mask/facehugger/equipped(mob/M)
	..()
	Attach(M)

/obj/item/clothing/mask/facehugger/Crossed(atom/target)
	..()
	HasProximity(target)
	return

/obj/item/clothing/mask/facehugger/on_found(mob/finder as mob)
	if(stat == CONSCIOUS)
		HasProximity(finder)
		return 1
	return

/obj/item/clothing/mask/facehugger/HasProximity(atom/movable/AM as mob|obj)
	if(CanHug(AM))
		Attach(AM)

/obj/item/clothing/mask/facehugger/throw_at(atom/target, range, speed)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_thrown"
		spawn(15)
			if(icon_state == "[initial(icon_state)]_thrown")
				icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/facehugger/throw_impact(atom/hit_atom)
	..()
	if(stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]"
		throwing = 0
	GoIdle(30,100) //stunned for a few seconds - allows throwing them to be useful for positioning but not as an offensive action (unless you're setting up a trap)

/obj/item/clothing/mask/facehugger/proc/Attach(M as mob)

	if((!iscorgi(M) && !iscarbon(M)))
		return

	if(attached)
		return

	var/mob/living/carbon/C = M
	if(istype(C) && locate(/obj/item/organ/internal/xenos/hivenode) in C.internal_organs)
		return


	attached++
	spawn(MAX_IMPREGNATION_TIME)
		attached = 0

	var/mob/living/L = M //just so I don't need to use :

	if(loc == L) return
	if(stat != CONSCIOUS)	return
	if(!sterile) L.take_organ_damage(strength,0) //done here so that even borgs and humans in helmets take damage

	L.visible_message("<span class='danger'><b> [src] leaps at [L]'s face!</b></span>")

	if(iscarbon(M))
		var/mob/living/carbon/target = L

		if(target.wear_mask)
			if(prob(20))	return
			var/obj/item/clothing/W = target.wear_mask
			if(!W.canremove)	return
			target.drop_from_inventory(W)

			target.visible_message("<span class='danger'><b> [src] tears [W] off of [target]'s face!</b></span>")

		target.equip_to_slot(src, slot_wear_mask)
		target.contents += src // Monkey sanity check - Snapshot

		if(!sterile) L.Paralyse(MAX_IMPREGNATION_TIME/6) //something like 25 ticks = 20 seconds with the default settings

	GoIdle() //so it doesn't jump the people that tear it off

	spawn(rand(MIN_IMPREGNATION_TIME,MAX_IMPREGNATION_TIME))
		Impregnate(L)

	return

/obj/item/clothing/mask/facehugger/proc/Impregnate(mob/living/target as mob)
	if(!target || target.wear_mask != src || target.stat == DEAD) //was taken off or something
		return

	if(!sterile)
		new /obj/item/alien_embryo(target)
		target.status_flags |= TRAIT_XENO_HOST

		target.visible_message("<span class='danger'><b> [src] falls limp after violating [target]'s face!</b></span>")

		Die()
		icon_state = "[initial(icon_state)]_impregnated"

	else
		target.visible_message("<span class='danger'><b> [src] violates [target]'s face!</b></span>")
	return

/obj/item/clothing/mask/facehugger/proc/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return

	stat = CONSCIOUS
	icon_state = "[initial(icon_state)]"

	return

/obj/item/clothing/mask/facehugger/proc/GoIdle(var/min_time=MIN_ACTIVE_TIME, var/max_time=MAX_ACTIVE_TIME)
	if(stat == DEAD || stat == UNCONSCIOUS)
		return

/*		RemoveActiveIndicators()	*/

	stat = UNCONSCIOUS
	icon_state = "[initial(icon_state)]_inactive"

	spawn(rand(min_time,max_time))
		GoActive()
	return

/obj/item/clothing/mask/facehugger/proc/Die()
	if(stat == DEAD)
		return

/*		RemoveActiveIndicators()	*/

	icon_state = "[initial(icon_state)]_dead"
	stat = DEAD

	src.visible_message("<span class='danger'><b>[src] curls up into a ball!</b></span>")

	return

/proc/CanHug(var/mob/M)

	if(iscorgi(M))
		return 1

	if(!iscarbon(M))
		return 0

	var/mob/living/carbon/C = M
	if(istype(C) && locate(/obj/item/organ/internal/xenos/hivenode) in C.internal_organs)
		return 0

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.head && (H.head.body_parts_covered & FACE) && !(H.head.item_flags & FLEXIBLEMATERIAL))
			return 0
	return 1
*/
