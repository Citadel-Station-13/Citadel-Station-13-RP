/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0_1"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	var/obj/item/implant/imp = null
	var/active = 1

/obj/item/implanter/attack_self(mob/user)
	. = ..()
	if(.)
		return
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "de"]activate \the [src].</span>")
	update()

/obj/item/implanter/verb/remove_implant(var/mob/user)
	set category = "Object"
	set name = "Remove Implant"
	set src in usr

	if(!imp)
		return
	imp.loc = get_turf(src)
	user.put_in_hands(imp)
	to_chat(user, "<span class='notice'>You remove \the [imp] from \the [src].</span>")
	name = "implanter"
	imp = null
	update()

	return

/obj/item/implanter/proc/update()
	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	src.icon_state += "_[active]"
	return

/obj/item/implanter/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if (!istype(target, /mob/living/carbon))
		return ..()
	if(active)
		if (imp)
			target.visible_message("<span class='warning'>[user] is attempting to implant [target].</span>")

			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(target)

			var/turf/T1 = get_turf(target)
			if (T1 && ((target == user) || do_after(user, 50)))
				if(user && target && (get_turf(target) == T1) && src && src.imp)
					target.visible_message("<span class='warning'>[target] has been implanted by [user].</span>")

					add_attack_logs(user,target,"Implanted with [imp.name] using [name]")

					if(imp.handle_implant(target))
						imp.post_implant(target)

						if(ishuman(target))
							var/mob/living/carbon/human/H = target
							H.update_hud_sec_implants()
					src.imp = null
					update()
	else
		to_chat(user, "<span class='warning'>You need to activate \the [src.name] first.</span>")

/obj/item/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/implanter/loyalty/Initialize(mapload)
	src.imp = new /obj/item/implant/loyalty( src )
	return ..()

/obj/item/implanter/explosive
	name = "implanter (E)"

/obj/item/implanter/explosive/Initialize(mapload)
	src.imp = new /obj/item/implant/explosive( src )
	return ..()

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/implanter/adrenalin/Initialize(mapload)
	src.imp = new /obj/item/implant/adrenalin(src)
	return ..()

/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

/obj/item/implanter/compressed/Initialize(mapload)
	imp = new /obj/item/implant/compressed( src )
	return ..()

/obj/item/implanter/compressed/update()
	if (imp)
		var/obj/item/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/implanter/compressed/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/obj/item/implant/compressed/c = imp
	if (!c)
		return
	if (c.scanned == null)
		to_chat(user, "Please scan an object with the implanter first.")
		return
	return ..()

/obj/item/implanter/compressed/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(!active)
		to_chat(user, "<span class='warning'>Activate \the [src.name] first.</span>")
		return
	if(istype(target, /obj/item) && istype(imp, /obj/item/implant/compressed))
		var/obj/item/implant/compressed/c = imp
		if (c.scanned)
			to_chat(user, "<span class='warning'>Something is already scanned inside the implant!</span>")
			return
		if(istype(I, /obj/item/storage))
			to_chat(user, "<span class='warning'>You can't store [I] in this!</span>")
			return
		c.scanned = target
		target.forceMove(src)
		update()

/// Universal translator implant.
/obj/item/implanter/uni_translator
	name = "implanter-language"

/obj/item/implanter/uni_translator/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/uni_translator( src )
	update()

/obj/item/implanter/restrainingbolt
	name = "implanter (bolt)"

/obj/item/implanter/restrainingbolt/New()
	src.imp = new /obj/item/implant/restrainingbolt( src )
	..()
	update()
	return
