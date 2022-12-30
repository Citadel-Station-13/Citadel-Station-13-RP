/**
 * ore box
 * used to store ores
 *
 * does not currently drop ores on breakage, because that would probably
 * crash the server.
 */
/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = TRUE
	pass_flags_self = ATOM_PASS_OVERHEAD_THROW
	var/list/stored

/obj/structure/ore_box/Initialize(mapload)
	. = ..()
	stored = list()

/obj/structure/ore_box/examine(mob/user)
	. = ..()
	. += "It holds: "
	for(var/id in stored)
		var/datum/ore/O = SSmaterials.get_ore(id)
		. += " - [stored[id]] [O.display_name]"

/**
 * takes amt of ores sequentially
 */
/obj/structure/ore_box/proc/extract_sequential(atom/newLoc, amt)
	amt = min(amt, 50)	// let's not crash the server
	if(is_empty())
		return
	var/id = stored[1]
	var/datum/ore/O = SSmaterials.get_ore(id)
	if(!O)
		stored -= id
		CRASH("invalid id [id]")
	var/making = min(stored[id], amt)
	stored[id] -= making
	amt -= making
	if(stored[id] <= 0)
		stored -= id
	O.create_ore(newLoc, amt)
	if(amt)
		// get the next type
		extract_sequential(newLoc, amt)

/**
 * randomly takes amt of ores
 * warning: unoptimized
 */
/obj/structure/ore_box/proc/extract_random(atom/newLoc, amt)
	amt = min(amt, 50)	// let's not crash the server
	if(is_empty())
		return
	var/id = pick(stored)
	var/datum/ore/O = SSmaterials.get_ore(id)
	if(!O)
		stored -= id
		CRASH("invalid id [id]")
	var/making = min(stored[id], amt)
	--stored[id]
	if(stored[id] <= 0)
		stored -= id
	O.create_ore(newLoc, amt)
	if(amt)
		// get the next type
		extract_random(newLoc, amt - 1)

/obj/structure/ore_box/proc/insert(obj/item/ore/O)
	if(QDELETED(O))
		CRASH("ore was already deleted?")
	++stored[O.ore_id]
	qdel(O)

/obj/structure/ore_box/proc/is_empty()
	return !length(stored)

/obj/structure/ore_box/legacy_ex_act(severity)
	return //if an overstuffed ore box explodes it crashes the server, thank you GC

/obj/structure/ore_box/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/ore))
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		insert(W)

	else if (istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(!S.contents.len)
			return
		S.hide_from(usr)
		for(var/obj/item/ore/O in S.contents)
			S.remove_from_storage(O, src) //This will move the item to this item's contents

/// Sigh.
/obj/structure/ore_box/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(istype(AM, /obj/item/ore))
		insert(AM)

/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
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

	if(is_empty())
		to_chat(usr,"<span class='warning'>The ore box is empty.</span>")
		return

	var/mob/living/user = usr
	to_chat(user, "<span class='notice'>You begin emptying the ore box.</span>")
	if(do_after(user, 15, src))
		while(!is_empty())
			if(!do_after(user, 5, src))
				to_chat(user,"<span class='notice'>You stop emptying the ore box.</span>")
				return
			var/atom/A = drop_location()
			if(!A || A.cluttered())
				to_chat(user, "<span class='warning'>The area under the box is too full.</span>")
				return
			extract_random(A, 20)
