//This is in the material folder because it's used by them...
//Actual name may need to change
//All of the important code is in material_weapons.dm
/obj/item/whetstone
	name = "whetstone"
	desc = "A simple, fine grit stone, useful for sharpening dull edges and polishing out dents."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "whetstone"
	damage_force = 3
	w_class = ITEMSIZE_SMALL
	var/repair_amount = 5
	var/repair_time = 40

/obj/item/whetstone/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/M = I
		if(M.amount >= 5)
			to_chat(user, "You begin to refine the [src] with [M]...")
			if(do_after(user, 70))
				M.use(5)
				var/obj/item/SK
				SK = new /obj/item/material/sharpeningkit(get_turf(user), M.material.name)
				to_chat(user, "You sharpen and refine the [src] into \a [SK].")
				qdel(src)
				if(SK)
					user.put_in_hands(SK)
		else
			to_chat(user, "You need 5 [src] to refine it into a sharpening kit.")

/obj/item/whetstone/ashlander
	name = "ashen whetstone"
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "sandwhetstone"

/obj/item/whetstone/ashlander/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/material/bone))
		var/obj/item/stack/material/bone/B = I
		if(B.amount >= 5)
			to_chat(user, "You begin to refine the [src] with [B]...")
			if(do_after(user, 70))
				B.use(5)
				var/obj/item/SK
				SK = new /obj/item/material/sharpeningkit(get_turf(user), B.material.name)
				to_chat(user, "You sharpen and refine the [src] into \a [SK].")
				qdel(src)
				if(SK)
					user.put_in_hands(SK)
		else
			to_chat(user, "You need 5 [src] to refine it into a sharpening kit.")

/obj/item/material/sharpeningkit
	name = "sharpening kit"
	desc = "A refined, fine grit whetstone, useful for sharpening dull edges, polishing out dents, and, with extra material, replacing an edge."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "sharpener"
	attack_sound = 'sound/weapons/genhit3.ogg'
	force_divisor = 0.7
	thrown_force_divisor = 1
	var/repair_amount = 5
	var/repair_time = 40
	var/sharpen_time = 100
	var/uses = 0

/obj/item/material/sharpeningkit/examine(mob/user, distance)
	. = ..()
	. += "There's [uses] pieces of material left for usage."

/obj/item/material/sharpeningkit/update_material_single(datum/material/material)
	. = ..()
	repair_amount = clamp(material.regex_this_hardness * 0.5 + 10, 10, 200)
	repair_time = min(10 SECONDS, material.relative_weight * 15)
	sharpen_time = min(10 SECONDS, material.relative_weight * 15)

/obj/item/material/sharpeningkit/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material))
		var/obj/item/stack/material/S = W
		if(S.material.id == get_primary_material_id())
			S.use(1)
			uses += 1
			to_chat(user, "You add a [S.material.name] [S.material.sheet_singular_name] to [src].")
			return

	if(istype(W, /obj/item/material))
		if(istype(W, /obj/item/material/sharpeningkit))
			to_chat(user, "Really? Sharpening a [W] with [src]? You goofball.")
			return
		var/obj/item/material/M = W
		if(uses >= M.w_class*2)
			if(M.sharpen(get_primary_material_id(), sharpen_time, src, user))
				uses -= M.w_class*2
				return
		else
			to_chat(user, "Not enough material to sharpen [M]. You need [M.w_class*2] [M.get_material_part(MATERIAL_PART_DEFAULT).sheet_plural_name].")
			return
	else
		to_chat(user, "You can't sharpen [W] with [src]!")
