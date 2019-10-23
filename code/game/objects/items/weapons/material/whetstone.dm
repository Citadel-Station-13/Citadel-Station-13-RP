//This is in the material folder because it's used by them...
//Actual name may need to change
//All of the important code is in material_weapons.dm
/obj/item/weapon/whetstone
	name = "whetstone"
	desc = "A simple, fine grit stone, useful for sharpening dull edges and polishing out dents."
	icon_state = "whetstone"
	force = 3
	w_class = ITEMSIZE_SMALL
	var/repair_amount = 5
	var/repair_time = 40

/obj/item/weapon/whetstone/attackby(obj/item/I, mob/usr)
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/M = I
		if(M.amount >= 5)
			to_chat(usr, "You begin to refine \the [src] with \the [M]...")
			if(do_after(usr, 70))
				M.use(5)
				var/obj/item/SK
				SK = new /obj/item/weapon/material/sharpeningkit(get_turf(usr), M.material.name)
				to_chat(usr, "You sharpen and refine \the [src] into \a [SK].")
				qdel(src)
				if(SK)
					usr.put_in_hands(SK)
		else
			to_chat(usr, "You need 5 [src] to refine it into a sharpening kit.")
	return


/obj/item/weapon/material/sharpeningkit
	name = "sharpening kit"
	desc = "A refined, fine grit whetstone, useful for sharpening dull edges, polishing out dents, and, with extra material, replacing an edge."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "sharpener"
	hitsound = 'sound/weapons/genhit3.ogg'
	force_divisor = 0.7
	thrown_force_divisor = 1
	var/repair_amount = 5
	var/repair_time = 40
	var/sharpen_time = 100
	var/uses = 0

/obj/item/weapon/material/sharpeningkit/examine(mob/user, distance)
	. = ..()
	to_chat(user, "There [uses == 1 ? "is" : "are"] [uses] [material] [uses == 1 ? src.material.sheet_singular_name : src.material.sheet_plural_name] left for use.")


/obj/item/weapon/material/sharpeningkit/Initialize()
	. = ..()
	setrepair()

/obj/item/weapon/material/sharpeningkit/proc/setrepair()
	repair_amount = material.hardness * 0.1
	repair_time = material.weight * 0.5
	sharpen_time = material.weight * 3
	return

/obj/item/weapon/material/sharpeningkit/attackby(obj/item/weapon/W, mob/usr)
	if(istype(W, /obj/item/stack/material))
		var/obj/item/stack/material/S = W
		if(S.material == material)
			S.use(1)
			uses += 1
			to_chat(usr, "You add a [S.material.name] [S.material.sheet_singular_name] to \the [src].")
			return

	if(istype(W, /obj/item/weapon/material))
		if(istype(W, /obj/item/weapon/material/sharpeningkit))
			to_chat(usr, "You can't sharpen \the [W], you goofball.")
			return
		var/obj/item/weapon/material/M = W
		if(uses >= M.w_class*2)
			if(M.sharpen(src.material.name, sharpen_time, src, usr))
				uses -= M.w_class*2
				return
		else
			to_chat(usr, "Not enough material to sharpen \the [M]. You need [M.w_class*2] [M.material.sheet_plural_name].")
			return
	else
		to_chat(usr, "You can't sharpen \the [W] with \the [src]!")
		return