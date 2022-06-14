var/global/list/ashtray_cache = list()

/obj/item/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/objects.dmi'
	icon_state = "blank"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	var/image/base_image
	var/max_butts = 10

/obj/item/material/ashtray/Initialize(mapload, material_name)
	. = ..(mapload, material_name)
	if(!material)
		qdel(src)
		return
	max_butts = round(material.hardness/5) //This is arbitrary but whatever.
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	update_icon()
	return

/obj/item/material/ashtray/update_icon()
	color = null
	overlays.Cut()
	var/cache_key = "base-[material.name]"
	if(!ashtray_cache[cache_key])
		var/image/I = image('icons/obj/objects.dmi',"ashtray")
		I.color = material.icon_colour
		ashtray_cache[cache_key] = I
	overlays |= ashtray_cache[cache_key]

	if (contents.len == max_butts)
		if(!ashtray_cache["full"])
			ashtray_cache["full"] = image('icons/obj/objects.dmi',"ashtray_full")
		overlays |= ashtray_cache["full"]
		desc = "It's stuffed full."
	else if (contents.len > max_butts/2)
		if(!ashtray_cache["half"])
			ashtray_cache["half"] = image('icons/obj/objects.dmi',"ashtray_half")
		overlays |= ashtray_cache["half"]
		desc = "It's half-filled."
	else
		desc = "An ashtray made of [material.display_name]."

/obj/item/material/ashtray/attackby(obj/item/I, mob/user)
	if(health <= 0)
		return
	if(istype(I, /obj/item/cigbutt) || istype(I, /obj/item/clothing/mask/smokable/cigarette) || istype(I, /obj/item/flame/match))
		if(contents.len >= max_butts)
			to_chat(user, "\The [src] is full.")
			return
		user.remove_from_mob(I)
		I.loc = src

		if (istype(I, /obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = I
			if (cig.lit == 1)
				src.visible_message("[user] crushes [cig] in \the [src], putting it out.")
				I = cig.extinguish(no_message = TRUE)
			else if (cig.lit == 0)
				to_chat(user, "You place [cig] in [src] without even smoking it. Why would you do that?")

		if(user.unEquip(I, src))
			visible_message("[user] places [I] in [src].")
			update_icon()
	else
		..()
		health = max(0,health - I.force)
		if (health < 1)
			shatter()

/obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (contents.len)
			src.visible_message(SPAN_DANGER("\The [src] slams into [hit_atom], spilling its contents!"))
		for (var/obj/item/clothing/mask/smokable/cigarette/O in contents)
			O.loc = src.loc
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()

/obj/item/material/ashtray/plastic/Initialize(mapload, material_key)
	return ..(mapload, "plastic")

/obj/item/material/ashtray/bronze/Initialize(mapload, material_key)
	return ..(mapload, "bronze")

/obj/item/material/ashtray/glass/Initialize(mapload, material_key)
	return ..(mapload, "glass")
