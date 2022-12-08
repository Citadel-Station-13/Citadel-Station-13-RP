//TODO: MURDER THIS WITH NEW SMOOTHING
var/global/list/stool_cache = list() //haha stool

/obj/item/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/structures/furniture_vr.dmi'
	icon_state = "stool_preview" //set for the map
	base_icon_state = "stool_base"
	force = 10
	throw_force = 10
	w_class = ITEMSIZE_HUGE
	var/datum/material/material = /datum/material/solid/metal/steel
	var/datum/material/reinf_material

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/item/stool/Initialize(mapload, new_material, new_padding_material)
	. = ..(mapload)
	if(!new_material)
		new_material = /datum/material/solid/metal/steel
	material = GET_MATERIAL_REF(new_material)
	if(new_padding_material)
		reinf_material = GET_MATERIAL_REF(new_padding_material)
	if(!istype(material))
		qdel(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	update_appearance()

/obj/item/stool/padded
	reinf_material = /datum/material/solid/cloth/red

/obj/item/stool/update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/datum/material/reinf_mat_ref
	if(reinf_material)
		reinf_mat_ref = GET_MATERIAL_REF(reinf_material)
	var/cache_key = "stool-[material.name]-[reinf_material ? reinf_mat_ref.name : "none"]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon_state)
		I.color = material.color
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]
	// Padding overlay.
	if(reinf_material)
		var/padding_cache_key = "stool-padding-[reinf_mat_ref.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "stool_padding")
			I.color = reinf_mat_ref.color
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]


/obj/item/stool/update_name(updates)
	. = ..()
	var/datum/material/reinf_mat_ref
	if(reinf_material)
		reinf_mat_ref = GET_MATERIAL_REF(reinf_material)
	if(ispath(reinf_mat_ref, /datum/material))
		name = "[reinf_mat_ref.display_name] [initial(name)]" //this is not perfect but it will do for now.
	else
		name = "[material.display_name] [initial(name)]"

/obj/item/stool/update_desc(updates)
	. = ..()
	if(!reinf_material)
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."
		return

	var/datum/material/reinf_mat_ref
	if(reinf_material)
		reinf_mat_ref = GET_MATERIAL_REF(reinf_material)
	if(ispath(reinf_mat_ref, /datum/material))
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [reinf_mat_ref.use_name]."


/obj/item/stool/proc/add_padding(padding_type)
	reinf_material = GET_MATERIAL_REF(padding_type)
	update_appearance()

/obj/item/stool/proc/remove_padding()
	if(reinf_material)
		reinf_material.place_sheet(get_turf(src))
		reinf_material = null
	update_appearance()

/obj/item/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message(SPAN_DANGER("[user] breaks [src] over [M]'s back!"))
		user.setClickCooldown(user.get_attack_speed())
		user.do_attack_animation(M)
		user.drop_item_to_ground(src, INV_OP_FORCE)
		dismantle()
		qdel(src)
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()

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
	if(reinf_material)
		reinf_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/stool/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.tool_sound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(reinf_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.legacy_flags & MATERIAL_PADDING))
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
		if(!reinf_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src.loc, W.tool_sound, 50, 1)
		remove_padding()
	else
		..()
