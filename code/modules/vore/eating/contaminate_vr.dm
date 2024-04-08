var/list/gurgled_overlays = list(
								"green" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "green"),
								"white" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "white"),
								"black" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "black"),
								"grey" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "grey"),
								"yellow" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "yellow"),
								"red" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "red"),
								"blue" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "blue"),
								"orange" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "orange"),
								"purple" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "purple"),
								"lime" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "lime"),
								"brown" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "brown"),
								"darkred" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "darkred"),
								"cyan" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "cyan"),
								"beige" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "beige"),
								"pink" = image('icons/effects/sludgeoverlay_vr.dmi', icon_state = "pink")
								)

/obj/item
	var/gurgled = FALSE
	var/cleanname
	var/cleandesc
	var/gurgled_color

/obj/item/proc/gurgle_contaminate(var/atom/movable/item_storage = null, var/contamination_flavor = "Generic", var/contamination_color = "green")
	if(!can_gurgle())
		return FALSE

	if(gurgled && !(gurgled_color == contamination_color))
		decontaminate()

	if(!gurgled)
		gurgled = TRUE
		gurgled_color = contamination_color
		add_overlay(gurgled_overlays[gurgled_color])
		var/list/pickfrom = contamination_flavors[contamination_flavor]
		var/gurgleflavor = pick(pickfrom)
		cleanname = src.name
		cleandesc = src.desc
		name = "[gurgleflavor] [cleanname]"
		desc = "[cleandesc] It seems to be covered in ominously foul residue and needs a wash."
//		for(var/obj/item/O in contents)			//Yeah, no. This contaminates stuff that should never be contaminated in places that should not be reached. Handle it for specific cases instead.
//			O.gurgle_contaminate(item_storage, contamination_flavor, contamination_color)
		return TRUE

/obj/item/proc/can_gurgle()
	if(atom_flags & PHORONGUARD)
		return FALSE
	else if(integrity_flags & INTEGRITY_ACIDPROOF)
		return FALSE
	else
		return TRUE

/obj/item/decontaminate() //Decontaminate the sogginess as well.
	..()
	gurgled = FALSE
	cut_overlay(gurgled_overlays[gurgled_color])
	if(cleanname)
		name = cleanname
	if(cleandesc)
		desc = cleandesc

/obj/item/clean_blood() //Make this type of contamination sink washable as well.
	..()
	if(gurgled)
		decontaminate()

/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob) //Wash the soggy item before it can interact with the sink.
	if(O.gurgled)
		var/turf/location = user.loc
		if(!isturf(location)) return

		var/obj/item/I = O
		if(!I || !istype(I,/obj/item)) return

		to_chat(usr, "<span class='notice'>You start washing \the [I].</span>")

		busy = TRUE
		sleep(40)
		busy = FALSE

		if(user.loc != location) return				//User has moved
		if(!I) return 								//Item's been destroyed while washing
		if(user.get_active_held_item() != I) return		//Person has switched hands or the item in their hands

		O.clean_blood()
		user.visible_message( \
			"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
			"<span class='notice'>You wash \a [I] using \the [src].</span>")
	else
		..()

/obj/item/card/id/gurgle_contaminate(var/atom/movable/item_storage = null)
	digest_act(item_storage) //Digesting these anyway
	return TRUE

/obj/item/pda/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/reagent_containers/food/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/holder/gurgle_contaminate(var/atom/movable/item_storage = null)
	if(isbelly(loc))
		digest_act(item_storage)
		return TRUE
	return FALSE

/obj/item/organ/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/cell/gurgle_contaminate(var/atom/movable/item_storage = null)
	if(!gurgled)
	//Don't make them wet, just drain
		var/obj/item/cell/C = src
		C.charge = 0
	return TRUE

// todo: i just backspaced out backpack handling on storage refactor because frankly i'm not a vore coder and this isn't my problem ~silicons
