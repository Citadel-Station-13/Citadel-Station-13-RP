/obj/item/gun/projectile/ballistic/proc/legacy_emit_chambered_residue()
	if(!chamber)
		return
	if(chamber.leaves_residue)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			if(!istype(H.gloves, /obj/item/clothing))
				H.gunshot_residue = chamber.get_caliber_string()
			else
				var/obj/item/clothing/G = H.gloves
				G.gunshot_residue = chamber.get_caliber_string()

/obj/item/gun/projectile/ballistic/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if(suppressible)
		if(istype(A, /obj/item/silencer))
			if(!user.is_holding(src))	//if we're not in his hands
				to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(!user.attempt_insert_item_for_installation(A, src))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			to_chat(user, "<span class='notice'>You screw [A] onto [src].</span>")
			silenced = TRUE
			set_weight_class(WEIGHT_CLASS_NORMAL)
			update_icon()
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else if(istype(A, /obj/item/tool/wrench))
			if(silenced)
				var/obj/item/silencer/S = new (get_turf(user))
				to_chat(user, "<span class='notice'>You unscrew [S]] from [src].</span>")
				user.put_in_hands(S)
				silenced = FALSE
				set_weight_class(WEIGHT_CLASS_SMALL)
				update_icon()
