
/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = 1
	climb_allowed = TRUE //it's a fuckin' box.
	var/last_update = 0
	var/list/stored_ore = list()

/obj/structure/ore_box/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if (istype(I, /obj/item/stack/ore))
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		user.visible_message(SPAN_NOTICE("[user] drops [I] into [src]."), SPAN_NOTICE("You drop [I] into [src]."))
	else if (istype(I, /obj/item/storage/bag/ore)) //it works differently now
		var/offloaded = FALSE
		for(var/obj/item/stack/ore/ore in I)
			ore.forceMove(src)
			offloaded = TRUE
		I.obj_storage?.ui_queue_refresh()
		if(offloaded)
			user.visible_message(SPAN_NOTICE("[user] offloads ores from [I] into [src]."), SPAN_NOTICE("You offload the ores in [I] into [src]."))
	else if (istype(I, /obj/item/storage))
		var/obj/item/storage/S = I
		if(!S.contents.len)
			return
		S.obj_storage?.hide(user)
		for(var/obj/item/stack/ore/O in S.contents)
			S.forceMove(src)
		user.visible_message(SPAN_NOTICE("[user] offloads ores from [I] into [src]."), SPAN_NOTICE("You offload the ores in [I] into [src]."))

/obj/structure/ore_box/examine(mob/user, dist)
	. = ..()
	if(isEmpty())
		. += SPAN_NOTICE("It is empty.")
		return
	. += SPAN_NOTICE("It holds:")
	for(var/ore in stored_ore)
		var/obj/item/stack/ore/O = ore
		. += SPAN_NOTICE("- [stored_ore[ore]] [initial(O.name)]")

/// Sigh.
/obj/structure/ore_box/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(istype(AM, /obj/item/stack/ore))
		take(AM)

/obj/structure/ore_box/drop_products(method, atom/where)
	. = ..()
	var/i = 0
	while(!isEmpty() && i < 200) //may be laggy as hell if they're carrying 2,000+ sand, so capping it at 200 items dropped.
		deposit(where, 50)
		i++

	new /obj/item/stack/material/wood/hard(where, 5)

/obj/structure/ore_box/proc/take(obj/item/stack/ore/O)
	if(!istype(O))
		return
	if(!stored_ore[O.type])
		stored_ore[O.type] = O.amount
	else
		stored_ore[O.type] += O.amount
	qdel(O)

/obj/structure/ore_box/proc/deposit(atom/newloc, amount = 50)
	if(isEmpty())
		return FALSE
	var/path = stored_ore[1]
	if(amount > stored_ore[path])
		amount = stored_ore[path]
	new path(newloc, amount)
	stored_ore[path] -= amount
	if(stored_ore[path] <= 0)
		stored_ore -= path
	return TRUE

/obj/structure/ore_box/proc/isEmpty()
	return !length(stored_ore)

/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = VERB_CATEGORY_OBJECT
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human) && !istype(usr, /mob/living/silicon/robot)) //Only living, intelligent creatures with gripping aparatti can empty ore boxes.
		to_chat(usr,"<span class='warning'>You are physically incapable of emptying the ore box.</span>")
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr,"You cannot reach the ore box.")
		return

	add_fingerprint(usr)

	if(isEmpty())
		to_chat(usr, SPAN_WARNING("[src] is empty."))
		return

	var/mob/living/user = usr
	to_chat(user, SPAN_NOTICE("You begin emptying [src]."))

	if(do_after(usr,10,src))
		while(!isEmpty())
			if(!do_after(user, 2, src))
				to_chat(user,SPAN_NOTICE("You stop emptying [src]."))
				return
			var/atom/A = drop_location()
			if(!A || (length(A.contents) > 200))
				to_chat(user, SPAN_WARNING("The area under [src] is too full."))
				return
			deposit(A,50)
		to_chat(user,SPAN_NOTICE("You finish emptying [src]."))
