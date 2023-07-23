var/global/list/ashtray_cache = list()

/obj/item/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/objects.dmi'
	icon_state = "blank"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	materials_base = list(MAT_STEEL = 4000)
	material_parts = /datum/material/steel
	var/image/base_image
	var/max_butts = 10

/obj/item/material/ashtray/Initialize(mapload, material_name)
	. = ..(mapload, material_name)
	if(!material)
		qdel(src)
		return
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	update_icon()

/obj/item/material/ashtray/update_icon()
	color = null

	cut_overlays()
	var/list/overlays_to_add = list()

	var/cache_key = "base-[material.name]"
	if(!ashtray_cache[cache_key])
		var/image/I = image('icons/obj/objects.dmi',"ashtray")
		I.color = material.icon_colour
		ashtray_cache[cache_key] = I
	overlays_to_add += ashtray_cache[cache_key]

	if (contents.len == max_butts)
		if(!ashtray_cache["full"])
			ashtray_cache["full"] = image('icons/obj/objects.dmi',"ashtray_full")
		overlays_to_add += ashtray_cache["full"]
		desc = "It's stuffed full."
	else if (contents.len > max_butts/2)
		if(!ashtray_cache["half"])
			ashtray_cache["half"] = image('icons/obj/objects.dmi',"ashtray_half")
		overlays_to_add += ashtray_cache["half"]
		desc = "It's half-filled."
	else
		desc = "An ashtray made of [material.display_name]."

	add_overlay(overlays_to_add)

/obj/item/material/ashtray/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if (istype(I,/obj/item/cigbutt) || istype(I,/obj/item/clothing/mask/smokable/cigarette) || istype(I, /obj/item/flame/match))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if (contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return

		if (istype(I,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = I
			if (cig.lit == 1)
				src.visible_message("[user] crushes [cig] in \the [src], putting it out.")
				STOP_PROCESSING(SSobj, cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				qdel(cig)
				I = butt
				//spawn(1)
				//	TemperatureAct(150)
			else if (cig.lit == 0)
				to_chat(user, "You place [cig] in [src] without even smoking it. Why would you do that?")

		visible_message("[user] places [I] in [src].")
		add_fingerprint(user)
		update_icon()
		return
	return ..()

/obj/item/material/ashtray/plastic
	material_parts = /datum/material/plastic

/obj/item/material/ashtray/bronze
	material_parts = /datum/material/bronze

/obj/item/material/ashtray/glass
	material_parts = /datum/material/glass
