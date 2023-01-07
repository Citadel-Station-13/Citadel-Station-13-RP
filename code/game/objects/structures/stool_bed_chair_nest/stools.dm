//Todo: add leather and cloth for arbitrary coloured stools.
var/global/list/stool_cache = list() //haha stool

/obj/item/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture_vr.dmi'
	icon_state = "stool_preview" //set for the map
	force = 10
	throw_force = 10
	w_class = ITEMSIZE_HUGE
	var/base_icon = "stool_base"
	var/datum/material/material
	var/datum/material/padding_material

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/item/stool/Initialize(mapload, new_material, new_padding_material)
	. = ..(mapload)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	if(!istype(material))
		qdel(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	update_icon()

/obj/item/stool/padded/Initialize(mapload, new_material)
	. = ..(mapload, "steel", "carpet")

/obj/item/stool/update_icon()
	// Prep icon.
	icon_state = ""
	cut_overlays()
	var/list/overlays_to_add = list()
	// Base icon.
	var/cache_key = "stool-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		I.color = material.icon_colour
		stool_cache[cache_key] = I
	overlays_to_add += stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "stool-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "stool_padding")
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		overlays_to_add += stool_cache[padding_cache_key]
	// Strings.
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

	add_overlay(overlays_to_add)

/obj/item/stool/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/item/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/stool/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()

	var/mob/living/L = user
	if (prob(5) && istype(L) && istype(target, /mob/living))
		L.visible_message("<span class='danger'>[L] breaks [src] over [target]'s back!</span>")
		L.setClickCooldown(L.get_attack_speed())
		L.do_attack_animation(target)
		L.drop_item_to_ground(src, INV_OP_FORCE)
		dismantle()
		qdel(src)
		var/mob/living/T = target
		T.Weaken(10)
		T.apply_damage(20)
		return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/stool/legacy_ex_act(severity)
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

/obj/item/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/stool/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.tool_sound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		if(!istype(loc, /turf))
			user.drop_item_to_ground(src, INV_OP_FORCE)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return
	else if (W.is_wirecutter())
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src.loc, W.tool_sound, 50, 1)
		remove_padding()
	else
		..()
