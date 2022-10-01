GLOBAL_LIST_BOILERPLATE(all_mops, /obj/item/mop)
#define MOPMODE_TILE 1
#define MOPMODE_SWEEP 2

/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 5.0
	throw_force = 10.0
	throw_speed = 5
	throw_range = 10
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	matter = list(MAT_PLASTIC = 3)
	var/mopping = 0
	var/mopcount = 0
	var/mopspeed = 23

	var/mopmode = MOPMODE_TILE
	var/sweep_time = 7

/obj/item/mop/Initialize(mapload)
	. = ..()
	create_reagents(30)


/obj/item/mop/attack_self(var/mob/user)
	.=..()
	if (mopmode == MOPMODE_TILE)
		mopmode = MOPMODE_SWEEP
		to_chat(user, "<span class='warning'>You will now clean with broad sweeping motions</span>")
	else if (mopmode == MOPMODE_SWEEP)
		mopmode = MOPMODE_TILE
		to_chat(user, "<span class='warning'>You will now thoroughly clean a single tile at a time</span>")

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /turf) || istype(A, /obj/effect/debris/cleanable) || istype(A, /obj/effect/overlay))
		if(reagents.total_volume < 1)
			to_chat(user, "<span class='warning'>Your mop is dry!</span>")
			return
		var/turf/T = get_turf(A)
		if(!T)
			return
		spawn()
			user.do_attack_animation(T)
		if (mopmode == MOPMODE_TILE)
			//user.visible_message(SPAN_WARNING("[user] begins to clean \the [T]."))
			user.setClickCooldown(3)
			if(do_after(user, mopspeed, T))
				if(T)
					T.clean(src, user)
				to_chat(user, "<span class='warning'>You have finished mopping!</span>")
		//Sweep mopmode. Light and fast aoe cleaning
		else if (mopmode == MOPMODE_SWEEP)
			sweep(user, T)
	else
		makeWet(A, user)

// TO DO : MAKE SWEEPING WORK

/obj/item/mop/proc/sweep(var/mob/user, var/turf/target)
	user.setClickCooldown(sweep_time)
	var/direction = get_dir(get_turf(src),target)
	var/list/turfs
	if (direction in GLOB.cardinal)
		turfs = list(target, get_step(target,turn(direction, 90)), get_step(target,turn(direction, -90)))
	else
		turfs = list(target, get_step(target,turn(direction, 135)), get_step(target,turn(direction, -135)))

	//Lets do a fancy animation of the mop sweeping over the tiles. Code copied from attack animation
	var/turf/start = turfs[2]
	var/turf/end = turfs[3]
	var/obj/effect/mopimage = new /obj/effect(start)
	mopimage.appearance = appearance
	mopimage.alpha = 200
	// Who can see the attack?
	var/list/viewing = list()
	for (var/mob/M in viewers(start))
		if (M.client)
			viewing |= M.client
	//flick_overlay(I, viewing, 5) // 5 ticks/half a second
	// Scale the icon.
	mopimage.transform *= 0.75
	// And animate the attack!
	animate(mopimage, alpha = 50, time = sweep_time*1.2)
	var/sweep_step = (sweep_time - 1) * 0.5
	spawn(1)
		mopimage.forceMove(target, sweep_step)
		sleep(sweep_step)
		mopimage.forceMove(end, sweep_step)
	spawn(sweep_time+1)
		qdel(mopimage)

	if(!do_after(user, sweep_time,target))
		to_chat(user, "<span class='warning'>Mopping cancelled</span>")
		return

	for (var/t in turfs)
		var/turf/T = t

		//Get out of the way, ankles!
		for (var/mob/living/L in T)
			attack(L)

		if (!is_blocked_turf(T))
			T.clean(src, user, 1)

		else if (user)
			//You hit a wall!
			user.setClickCooldown(2)
			user.Stun(2)
			shake_camera(user, 1, 1)
			playsound(T,"thud", 20, 1, -3)
			to_chat(user, "<span class='warning'>There's not enough space for broad sweeps here!</span>")
			return

/obj/item/mop/proc/makeWet(atom/A, mob/user)
	if(A.is_open_container())
		if(A.reagents)
			if(A.reagents.total_volume < 1)
				to_chat(user, "<span class='warning'>\The [A] is out of water!</span>")
				return
			A.reagents.trans_to_obj(src, reagents.maximum_volume)
		else
			reagents.add_reagent("water", reagents.maximum_volume)

		to_chat(user, "<span class='warning'>You wet \the [src] with \the [A].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)



/obj/effect/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	..()

/obj/item/mop/advanced
	desc = "The most advanced tool in a custodian's arsenal, with a cleaner synthesizer to boot! Just think of all the viscera you will clean up with this!"
	name = "advanced mop"
	icon_state = "advmop"
	item_state = "mop"
	force = 6
	throw_force = 11
	mopspeed = 15
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 1 //Rate per process() tick mop refills itself
	var/refill_reagent = "cleaner" //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/AltClick(var/mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, "<span class='notice'>You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position.</span>")
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/mop/advanced/process(delta_time)
	if(reagents.total_volume < 30)
		reagents.add_reagent(refill_reagent, refill_rate)

/obj/item/mop/advanced/examine(mob/user)
	. = ..()
	. += "The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>."

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

#undef MOPMODE_TILE
#undef MOPMODE_SWEEP
