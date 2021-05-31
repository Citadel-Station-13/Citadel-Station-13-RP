
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
			take(O)

/obj/structure/ore_box/examine(mob/user)
	. = ..()

	to_chat(user,"It holds:")
	for(var/ore in stored_ore)
		var/obj/item/ore/O = ore
		to_chat(user,"- [stored_ore[ore]] [initial(O.name)]")

/obj/structure/ore_box/proc/take(obj/item/ore/O)
	if(!stored_ore[O.type])
		stored_ore[O.type] = 1
	else
		stored_ore[O.type]++
	qdel(O)

/obj/structure/ore_box/proc/deposit(atom/newloc)
	if(!length(stored_ore))
		return FALSE
	new stored_ore[1](newloc)
	stored_ore[stored_ore[1]]--
	if(stored_ore[stored_ore[1]] <= 0)
		stored_ore -= stored_ore[1]

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

	if(contents.len < 1)
		to_chat(usr,"<span class='warning'>The ore box is empty.</span>")
		return

	to_chat(usr,"<span class='notice'>You begin emptying the ore box.</span>")
	if(do_after(usr,15,src))
		while(!isEmpty())
			if(!do_after(usr,5,src))
				to_chat(usr,"<span class='notice'>You stop emptying the ore box.</span>")
				return
			for(var/i in 1 to 20)
				deposit(drop_location())
