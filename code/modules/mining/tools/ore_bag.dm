/obj/item/storage/bag/ore
	name = "mining satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/ore)
	var/stored_ore = list()
	var/last_update = 0

/obj/item/storage/bag/ore/update_w_class()
	return

/obj/item/storage/bag/ore/gather_all(turf/T as turf, mob/user as mob, var/silent = 0)
	var/success = 0
	var/failure = 0
	for(var/obj/item/ore/I in T) //Only ever grabs ores. Doesn't do any extraneous checks, as all ore is the same size. Tons of checks means it causes hanging for up to three seconds.
		if(contents.len >= max_storage_space)
			failure = 1
			break
		I.forceMove(src)
		success = 1
	if(success && !failure && !silent)
		if(world.time >= last_message == 0)
			to_chat(user, "<span class='notice'>You put everything in [src].</span>")
			last_message = world.time + 10
	else if(success && (!silent || (silent && contents.len >= max_storage_space)))
		to_chat(user, "<span class='notice'>You fill the [src].</span>")
		last_message = world.time + 10
	else if(!silent)
		if(world.time >= last_message == 0)
			to_chat(user, "<span class='notice'>You fail to pick anything up with \the [src].</span>")
			last_message = world.time + 90
	if(istype(user.pulling, /obj/structure/ore_box)) // buffy fix with last_message, no more spam
		var/obj/structure/ore_box/O = user.pulling
		O.attackby(src, user)

/obj/item/storage/bag/ore/equipped(mob/user, slot, flags)
	. = ..()
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/autoload, override = TRUE)

/obj/item/storage/bag/ore/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/storage/bag/ore/proc/autoload(datum/source, atom/oldLoc, dir, forced)
	var/obj/item/ore/O = locate() in get_turf(src)
	if(O)
		gather_all(get_turf(src), ismob(source)? source : null)

/obj/item/storage/bag/ore/examine(mob/user)
	. = ..()
	if(!Adjacent(user)) //Can only check the contents of ore bags if you can physically reach them.
		return
	if(istype(user, /mob/living))
		add_fingerprint(user)
	if(!contents.len)
		. += "It is empty."
		return

	if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time

	. += "<span class='notice'>It holds:</span>"
	for(var/id in stored_ore)
		var/datum/ore/O = SSmaterials.get_ore(id)
		. += "<span class='notice'>- [stored_ore[id]] [O.ore_name]</span>"

/obj/item/storage/bag/ore/open(mob/user as mob) //No opening it for the weird UI of having shit-tons of ore inside it.
	if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time
		examine(user)

/obj/item/storage/bag/ore/proc/update_ore_count() //Stolen from ore boxes.
	stored_ore = list()
	for(var/obj/item/ore/O in contents)
		if(stored_ore[O.ore_id])
			stored_ore[O.ore_id]++
		else
			stored_ore[O.ore_id] = 1
