
/**********************Ore box**************************/
//Why the hell is this file called satchel_ore_boxdm.dm? -CK
/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = 1
	var/last_update = 0
	var/list/stored_ore = list()

/obj/structure/ore_box/ex_act(severity)
	return //if an overstuffed ore box explodes it crashes the server, thank you GC

/obj/structure/ore_box/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/ore))
		user.remove_from_mob(W)
		take(W)

	else if (istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(!S.contents.len)
			return
		S.hide_from(usr)
		for(var/obj/item/ore/O in S.contents)
			S.remove_from_storage(O, src) //This will move the item to this item's contents

/obj/structure/ore_box/examine(mob/user)
	. = ..()

	to_chat(user,"It holds:")
	for(var/ore in stored_ore)
		var/obj/item/ore/O = ore
		to_chat(user,"- [stored_ore[ore]] [initial(O.name)]")

/// Sigh.
/obj/structure/ore_box/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(istype(AM, /obj/item/ore))
		take(AM)

/obj/structure/ore_box/proc/take(obj/item/ore/O)
	if(!istype(O))
		return
	if(!stored_ore[O.type])
		stored_ore[O.type] = 1
	else
		stored_ore[O.type]++
	qdel(O)

/obj/structure/ore_box/proc/deposit(atom/newloc)
	if(isEmpty())
		return FALSE
	var/path = stored_ore[1]
	new path(newloc)
	stored_ore[path]--
	if(stored_ore[path] <= 0)
		stored_ore -= path
	return TRUE

/obj/structure/ore_box/proc/isEmpty()
	return !length(stored_ore)

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

	if(isEmpty())
		to_chat(usr,"<span class='warning'>The ore box is empty.</span>")
		return
	
	var/mob/living/user = usr
	to_chat(user, "<span class='notice'>You begin emptying the ore box.</span>")

	if(do_after(usr,15,src))
		while(!isEmpty())
			if(!do_after(user, 5, src))
				to_chat(user,"<span class='notice'>You stop emptying the ore box.</span>")
				return
			var/atom/A = drop_location()
			if(!A || (length(A.contents) > 1000))
				to_chat(user, "<span class='warning'>The area under the box is too full.</span>")
				return
			for(var/i in 1 to 20)
				deposit(A)
