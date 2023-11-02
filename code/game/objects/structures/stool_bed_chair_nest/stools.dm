//Todo: add leather and cloth for arbitrary coloured stools.
var/global/list/stool_cache = list() //haha stool

/obj/item/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture_vr.dmi'
	icon_state = "stool_preview" //set for the map
	damage_force = 10
	throw_force = 10
	w_class = ITEMSIZE_HUGE
	material_parts = MATERIAL_DEFAULT_ABSTRACTED
	material_primary = "base"
	var/base_icon = "stool_base"
	var/datum/material/material_base
	var/datum/material/material_padding

/obj/item/stool/Initialize(mapload, new_material, new_material_padding)
	if(!isnull(new_material))
		material_base = new_material
	if(!isnull(new_material_padding))
		material_padding = new_material_padding
	return ..()

/obj/item/stool/update_material_multi(list/parts)
	. = ..()
	update_appearance()

/obj/item/stool/material_get_part(part)
	switch(part)
		if("base")
			return material_base
		if("padding")
			return material_padding

/obj/item/stool/material_set_part(part, datum/material/material)
	var/datum/material/old
	var/primary = part == "base"
	switch(part)
		if("base")
			old = material_base
			material_base = material
		if("padding")
			old = material_padding
			material_padding = material
	if(old != material)
		unregister_material(old, primary)
		register_material(material, primary)

/obj/item/stool/material_get_parts()
	return list(
		"base" = material_base,
		"padding" = material_padding,
	)

/obj/item/stool/material_init_parts()
	material_base = SSmaterials.resolve_material(material_base)
	material_padding = SSmaterials.resolve_material(material_padding)
	register_material(material_base, TRUE)
	register_material(material_padding, FALSE)

/obj/item/stool/update_icon()
	if(isnull(material_base))
		return
	// Prep icon.
	icon_state = ""
	cut_overlays()
	var/list/overlays_to_add = list()
	// Base icon.
	var/cache_key = "stool-[material_base.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		I.color = material_base.icon_colour
		stool_cache[cache_key] = I
	overlays_to_add += stool_cache[cache_key]
	// Padding overlay.
	if(material_padding)
		var/padding_cache_key = "stool-padding-[material_padding.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "stool_padding")
			I.color = material_padding.icon_colour
			stool_cache[padding_cache_key] = I
		overlays_to_add += stool_cache[padding_cache_key]
	// Strings.
	if(material_padding)
		name = "[material_padding.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material_base.use_name] and covered with [material_padding.use_name]."
	else
		name = "[material_base.display_name] [initial(name)]"
		desc = "A stool. Apply butt with care. It's made of [material_base.use_name]."

	add_overlay(overlays_to_add)

/obj/item/stool/proc/add_padding(var/padding_type)
	set_material_part("padding", SSmaterials.resolve_material(padding_type))

/obj/item/stool/proc/remove_padding()
	if(material_padding)
		material_padding.place_sheet(get_turf(src))
		set_material_part("padding", null)

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
		T.afflict_paralyze(20 * 10)
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
	if(material_base)
		material_base.place_sheet(get_turf(src))
	if(material_padding)
		material_padding.place_sheet(get_turf(src))
	qdel(src)

/obj/item/stool/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.tool_sound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(material_padding)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
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
		if(!material_padding)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src.loc, W.tool_sound, 50, 1)
		remove_padding()
	else
		..()

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map
	material_base = /datum/material/steel
	material_padding = /datum/material/carpet
