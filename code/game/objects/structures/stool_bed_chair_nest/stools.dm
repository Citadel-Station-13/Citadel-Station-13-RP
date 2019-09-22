//Todo: add leather and cloth for arbitrary coloured stools.
GLOBAL_LIST_EMPTY(stool_icon_cache)

/obj/item/weapon/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture_vr.dmi' //VOREStation Edit - new Icons
	icon_state = "stool_preview" //set for the map
	force = 10
	throwforce = 10
	w_class = ITEMSIZE_HUGE
	material_primary = MATERIAL_ID_STEEL
	var/base_icon = "stool_base"
	var/datum/material/material_padding

/obj/item/weapon/stool/padded
	icon_state = "stool_padded_preview" //set for the map
	material_padding = MATERIAL_ID_CARPET

/obj/item/weapon/stool/Initialize(mapload, primary_material, padding_material)
	if(primary_material)
		material_primary = primary_material
	. = ..()
	AutoSetMaterial(padding_material || material_padding, MATINDEX_OBJ_PADDING)

/obj/structure/bed/GetMaterial(index)
	if(index == MATINDEX_OBJ_PADDING)
		return material_padding
	return ..()

/obj/structure/bed/SetMaterial(datum/material/M, index, updating)
	if(index == MATINDEX_OBJ_PADDING)
		material_padding = M
	return ..()

/obj/item/weapon/stool/update_icon()
	. = ..()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/cache_key = "stool-[material.name]"
	if(isnull(GLOB.stool_icon_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		I.color = material_primary.icon_colour
		GLOB.stool_icon_cache[cache_key] = I
	overlays |= GLOB.stool_icon_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "stool-padding-[padding_material.name]"
		if(isnull(GLOB.stool_icon_cache[padding_cache_key]))
			var/image/I =  image(icon, "stool_padding")
			I.color = material_padding.icon_colour
			GLOB.stool_icon_cache[padding_cache_key] = I
		overlays |= GLOB.stool_icon_cache[padding_cache_key]
	// Strings.
	if(material_padding)
		name = "[material_padding.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material_primary.use_name] and covered with [material_padding.use_name]."
	else
		name = "[material_primary.display_name] [initial(name)]"
		desc = "A stool. Apply butt with care. It's made of [material_primary.use_name]."

/obj/item/weapon/stool/proc/add_padding(padding_type)
	AutoSetMaterial(padding_type, MATINDEX_OBJ_PADDING)

/obj/item/weapon/stool/proc/remove_padding()
	material_padding?.place_sheet(drop_location())
	RemoveMaterial(material_padding)

/obj/item/weapon/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("<span class='danger'>[user] breaks [src] over [M]'s back!</span>")
		user.setClickCooldown(user.get_attack_speed())
		user.do_attack_animation(M)

		user.drop_from_inventory(src)

		user.remove_from_mob(src)
		dismantle()
		qdel(src)
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()

/obj/item/weapon/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/item/weapon/stool/proc/dismantle()
	material_primary?.place_sheet(get_turf(src))
	padding_material?.place_sheet(get_turf(src))
	qdel(src)

/obj/item/weapon/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.usesound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(material_padding)
			to_chat(user, "<span class='notice'>[src] is already padded.</span>")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = MATERIAL_ID_CARPET
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = [M.material.name
		if(!padding_type)
			to_chat(user, "<span class='warning'>You cannot pad [src] with that.</span>")
			return
		C.use(1)
		if(!isturf(loc))
			user.drop_from_inventory(src)
			forceMove(get_turf(src))
		to_chat(user, "<span class='notice'>You add padding to [src].</span>")
		add_padding(padding_type)
		return
	else if (W.is_wirecutter())
		if(!material_padding)
			to_chat(user, "<span class='warning'>[src] has no padding to remove.</span>")
			return
		to_chat(user, "<span class='notice'>You remove the padding from [src].</span>")
		playsound(src, W.usesound, 50, 1)
		remove_padding()
	else
		return ..()
