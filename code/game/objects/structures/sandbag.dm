/obj/structure/sandbag
	name = "sandbag barricade"
	desc = "A barrier made of stacked sandbags."
	icon = 'icons/obj/structures/sandbags.dmi'
	icon_state = "sandbags-0"
	base_icon_state = "sandbags"
	anchored = TRUE
	density = TRUE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_THROWN | ATOM_PASS_CLICK
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_SANDBAGS)
	canSmoothWith = (SMOOTH_GROUP_SANDBAGS)
	integrity = 200
	integrity_max = 200

	var/vestigial = TRUE

/obj/structure/sandbag/Initialize(mapload)
	. = ..()
	for(var/obj/structure/sandbag/S in loc)
		if(S != src)
			break_to_parts(full_return = 1)
			return
	if(mapload)
		return INITIALIZE_HINT_LATELOAD
	else
		//update_connections(TRUE)
		update_icon()

/obj/structure/sandbag/LateInitialize()
	//update_connections(FALSE)
	update_icon()

/obj/structure/sandbag/Destroy()
	//update_connections(TRUE)
	. = ..()

/obj/structure/sandbag/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldownLegacy(user.get_attack_speed(W))
	if(istype(W, /obj/item/stack/sandbags))
		var/obj/item/stack/sandbags/S = W
		if(integrity < integrity_max)
			if(S.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sandbag to repair \the [src].</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20) && integrity < integrity_max)
				if(S.use(1))
					integrity = integrity_max
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/structure/sandbag/proc/break_to_parts(full_return = 0)
	if(full_return || prob(20))
		new /obj/item/stack/sandbags(src.loc)
	else
		new /obj/item/stack/material/cloth(src.loc)
		new /obj/item/stack/ore/glass(src.loc)
	qdel(src)
