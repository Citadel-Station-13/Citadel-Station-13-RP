/obj/item/inflatable
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall"
	w_class = ITEMSIZE_NORMAL
	var/deploy_path = /obj/structure/inflatable

/obj/item/inflatable/attack_self(mob/user)
	. = ..()
	if(.)
		return
	inflate(user,user.loc)

/obj/item/inflatable/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	..(target, user)
	if(!user)
		return
	if(!user.Adjacent(target))
		to_chat(user,"You can't reach!")
		return
	if(istype(target, /turf))
		inflate(user,target)

/obj/item/inflatable/CtrlClick(mob/user)
	inflate(user,src.loc)

/obj/item/inflatable/proc/inflate(var/mob/user,var/location)
	playsound(location, 'sound/items/zip.ogg', 75, 1)
	to_chat(user,"<span class='notice'>You inflate [src].</span>")
	var/obj/structure/inflatable/R = new deploy_path(location)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door"
	deploy_path = /obj/structure/inflatable/door
/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/inflate(mob/user, location)
	to_chat(user, "<span class='notice'>The inflatable wall is too torn to be inflated!</span>")
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/inflate(mob/user, location)
	to_chat(user, "<span class='notice'>The inflatable door is too torn to be inflated!</span>")
	add_fingerprint(user)

//* inflatable storage case

/obj/item/storage/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf_box"
	w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 7
	can_hold = list(/obj/item/inflatable)

/obj/item/storage/briefcase/inflatable/PopulateContents()
	. = ..()
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable(src)
	new /obj/item/inflatable(src)
	new /obj/item/inflatable(src)
	new /obj/item/inflatable(src)
