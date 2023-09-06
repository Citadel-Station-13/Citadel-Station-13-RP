// This is specifically for slimes since we don't have a 'normal' processor now.
// Feel free to rename it if that ever changes.

/obj/machinery/processor
	name = "slime processor"
	desc = "An industrial grinder used to automate the process of slime core extraction.  It can also recycle biomatter."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "processor1"
	density = TRUE
	anchored = TRUE
	/// Autointaking
	var/auto_mode = FALSE
	var/processing = FALSE // So I heard you like processing.
	var/list/to_be_processed = list()
	var/monkeys_recycled = 0
	var/monkeys_needed = 4 //How many monkeys needed to recycle to get a new cube - reduced through upgrading manipulator.
	var/process_time = 10 //Time it takes to process each process within - reduced through upgrading laser.
	var/let_slimes_pass = FALSE //Living slimes can pass through the processor if this is true. Made true through upgrading matter bin to T3 or above.
	description_info = "Clickdrag dead slimes or monkeys to it to insert them.  It will make a new monkey cube for every four monkeys it processes. Alt click to enable auto-intake."
	circuit = /obj/item/circuitboard/processor

/obj/machinery/processor/examine(mob/user, dist)
	. = ..()
	. += SPAN_BOLDNOTICE("The automatic intake switch is in the [auto_mode? "On" : "Off"] position.")
	if(let_slimes_pass)
		. += SPAN_BOLDNOTICE("It looks slick enough to let slimes glide over it.")

/obj/machinery/processor/attack_hand(mob/user, list/params)
	if(processing)
		to_chat(user, SPAN_WARNING("The processor is in the process of processing!"))
		return
	if(to_be_processed.len)
		spawn(1)
			begin_processing()
	else
		to_chat(user, SPAN_WARNING("The processor is empty."))
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return

/obj/machinery/processor/RefreshParts()
	//defaults, in the event of someone fucking something up.
	let_slimes_pass = FALSE
	monkeys_needed = 4
	process_time = 10
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		if(M.rating >= 3)
			let_slimes_pass = TRUE
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		monkeys_needed = max(4 - M.rating, 1) //4 @ T1. 1 @ T4. no effect at higher tiers. (else it'd be grey goo: monke edition lol)
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		process_time = max(12.5 - (M.rating * 2.5), 1) //1 sec @ T1. 0.25 sec @ T4. 0.1 sec @ T5.

/obj/machinery/processor/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(processing)
		to_chat(user, SPAN_WARNING("The processor is in the process of processing!"))
		return
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(default_unfasten_wrench(user, I, 40))
		return
	if(istype(I, /obj/item/holder))
		var/obj/item/holder/mob_holder = I
		if(!ishuman(mob_holder.held_mob))
			return
		var/mob/living/carbon/human/H = mob_holder.held_mob
		if(!istype(H.species, /datum/species/monkey))
			return
		if(!IS_DEAD(H))
			user.action_feedback(SPAN_WARNING("[H] is still alive."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!insert(H, user))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		qdel(mob_holder)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

// Verb to remove everything.
/obj/machinery/processor/verb/eject()
	set category = "Object"
	set name = "Eject Processor"
	set src in oview(1)

	if(CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return
	empty()
	add_fingerprint(usr)
	return

/obj/machinery/processor/AltClick(mob/user)
	. = ..()
	if(user.stat || user.incapacitated(INCAPACITATION_DISABLED) || !Adjacent(user))
		return
	auto_mode = !auto_mode
	to_chat(user, SPAN_NOTICE("You turn the automatic intake [auto_mode? "On" : "Off"]."))
	if(auto_mode)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

// Ejects all the things out of the machine.
/obj/machinery/processor/proc/empty()
	for(var/atom/movable/AM in to_be_processed)
		to_be_processed.Remove(AM)
		AM.forceMove(get_turf(src))

// Ejects all the things out of the machine.
/obj/machinery/processor/proc/insert(var/atom/movable/AM, var/mob/living/user)
	if((!Adjacent(user) && !Adjacent(AM)) || !user.Adjacent(AM))
		return FALSE
	if(!can_insert(AM))
		to_chat(user, SPAN_NOTICE("\The [src] cannot process \the [AM] at this time."))
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
		return FALSE
	to_be_processed.Add(AM)
	AM.forceMove(src)
	visible_message(SPAN_NOTICE("\the [user] places [AM] inside \the [src]."))
	return TRUE

/obj/machinery/processor/proc/auto_insert(atom/movable/AM)
	if(!can_insert(AM) || !isturf(AM.loc))
		return
	to_be_processed.Add(AM)
	AM.forceMove(src)
	visible_message(SPAN_NOTICE("[src] sucks up [AM]."))

/obj/machinery/processor/process(delta_time)
	if(!auto_mode)
		return PROCESS_KILL
	for(var/mob/living/simple_mob/slime/AM in range(1, src))
		auto_insert(AM)
	for(var/mob/living/carbon/human/AM in range(1, src))
		auto_insert(AM)

/obj/machinery/processor/proc/begin_processing()
	if(processing)
		return // Already doing it.
	processing = TRUE
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
	for(var/atom/movable/AM in to_be_processed)
		extract(AM)
		sleep(process_time)

	while(monkeys_recycled >= monkeys_needed)
		new /obj/item/reagent_containers/food/snacks/monkeycube(get_turf(src))
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		monkeys_recycled -= 4
		sleep(process_time)

	processing = FALSE
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)

/obj/machinery/processor/proc/extract(var/atom/movable/AM)
	if(istype(AM, /mob/living/simple_mob/slime))
		var/mob/living/simple_mob/slime/S = AM
		while(S.cores)
			new S.coretype(get_turf(src))
			playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
			S.cores--
			sleep(process_time)
		to_be_processed.Remove(S)
		qdel(S)

	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = AM
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		to_be_processed.Remove(M)
		qdel(M)
		monkeys_recycled++
		sleep(process_time)

/obj/machinery/processor/proc/can_insert(var/atom/movable/AM)
	if(AM.loc == src)
		return FALSE
	if(istype(AM, /mob/living/simple_mob/slime))
		var/mob/living/simple_mob/slime/S = AM
		if(S.stat != DEAD)
			return FALSE
		return TRUE
	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if(!istype(H.species, /datum/species/monkey))
			return FALSE
		if(H.stat != DEAD)
			return FALSE
		return TRUE
	return FALSE

/obj/machinery/processor/MouseDroppedOnLegacy(var/atom/movable/AM, var/mob/living/user)
	if(user.stat || user.incapacitated(INCAPACITATION_DISABLED) || !istype(user))
		return
	insert(AM, user)

/obj/machinery/processor/CanAllowThrough(atom/movable/mover, turf/target)
	if(isslime(mover) && let_slimes_pass)
		return TRUE
	return ..()

/obj/machinery/processor/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(isslime(blocker) && let_slimes_pass)
		return TRUE
	return ..()
