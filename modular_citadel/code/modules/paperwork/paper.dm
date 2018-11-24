/obj/item/weapon/paper
	var/list/stamp_sounds = list(
		'modular_citadel/sound/items/stamp1.ogg',
		'modular_citadel/sound/items/stamp2.ogg',
		'modular_citadel/sound/items/stamp3.ogg'
		)

/obj/item/weapon/paper/attackby(obj/item/weapon/P as obj, mob/user as mob)
	. = ..()
	if(istype(P, /obj/item/weapon/stamp))
		if((!in_range(src, usr) && loc != user && !( istype(loc, /obj/item/weapon/clipboard) ) && loc.loc != user && user.get_active_hand() != P))
			return
		playsound(P, pick(stamp_sounds), 30, 1, -1)
	return