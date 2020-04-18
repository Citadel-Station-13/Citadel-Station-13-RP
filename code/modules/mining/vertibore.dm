
/obj/item/vertibore
	name = "portable shaft excavation device"
	desc = "A heavily modified shaft bore utilizing phorogenic blasts to tunnel vertically through rock. Much faster than a large industrial drill unit, but is very resource- and power-intensive."
	description_fluff = "A phoron bore used for rapidly digging through rock that has been modified to allow it to fire straight down at a much higher power. However, this has resulted in a loss of power and resource efficiency, compactness, and modularity as the proprietary capacitor and manipulator cannot be swapped."
	w_class = ITEMSIZE_NO_CONTAINER //haha harold can't powergame itemsize with BoHs if it doesn't even fit in a BoH
	//he's just going to locker it isn't he

	icon = 'icons/obj/mining.dmi'
	icon_state = "vertibore"
	item_state = "vertibore"


	var/obj/item/cell/cell //loaded cell
	var/power_cost = 1000 //10 shots off a highcap
	var/load_type = /obj/item/stack/material
	var/mat_storage = 0			// How much material is stored inside? Input in multiples of 2000 as per auto/protolathe.
	var/max_mat_storage = 50000	// 25 sheets
	var/mat_cost = 1000			//  100 shots off of a full stack.
	var/ammo_material = MAT_PHORON
	var/loading = FALSE

/obj/item/vertibore/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>The shaft excavator has [mat_storage]cm^3 of phoron inside, and can hold a maximum of [max_mat_storage].</span>")
	if(cell)
		to_chat(user, "<span class='notice'>The installed [cell.name] has a charge level of [round((cell.charge/cell.maxcharge)*100)]%.</span>")

/obj/item/vertibore/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/cell))
		if(cell)
		to_chat(user, "<span class='warning'>\The [src] already has \a [cell] installed.</span>")
			return
		cell = thing
		user.drop_from_inventory(cell)
		cell.forceMove(src)
		playsound(loc, 'sound/machines/click.ogg', 10, 1)
		user.visible_message("<span class='notice'>\The [user] slots \the [cell] into \the [src].</span>")
		update_icon()
		return
	if(thing.is_screwdriver())
		if(!cell)
			to_chat(user, "<span class='warning'>\The [src] has no cell installed.</span>")
			return
		cell.forceMove(get_turf(src))
		user.put_in_hands(cell)
		user.visible_message("<span class='notice'>\The [user] unscrews \the [cell.name] from \the [src].</span>")
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		cell = null
		update_icon()
		return
	if(istype(thing, load_type))
		loading = TRUE
		var/obj/item/stack/material/M = thing
		if(!M.material || M.material.name != ammo_material)
			return
		if(mat_storage + 2000 > max_mat_storage)
			to_chat(user, "<span class='warning'>\The [src] cannot hold more [ammo_material].</span>")
			return
		var/can_hold_val = 0
		while(can_hold_val < round(max_mat_storage / 2000))
			if(mat_storage + 2000 <= max_mat_storage && do_after(user,1.5 SECONDS))
				can_hold_val ++
				mat_storage += 2000
				playsound(loc, 'sound/effects/phasein.ogg', 15, 1)
			else
				loading = FALSE
				break
		M.use(can_hold_val)
		user.visible_message("<span class='notice'>\The [user] loads \the [src] with \the [M].</span>")
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	. = ..()

/obj/item/vertibore/attack_self(mob/user)
	if(mat_cost > mat_storage)
		to_chat(user, "<span class='notice'>The [src] shudders, the phoron feeding mechanism attempting to move things that aren't there.</span>")
		return
	if(power_cost > cell.charge))
		to_chat(user, "<span class='notice'>The [src] flashes a warning light, it doesn't have enough charge to dig.</span>")
		return
	if(cell.use(power_cost) && do_after(user, 2.5 SECONDS))
		var/turf/T = get_turf(user)
		T.ex_act(1)

/obj/item/vertibore/update_icon()
	var/list/overlays_to_add = list()
	if(cell)
		overlays_to_add += image(icon, "[icon_state]_cell")
	..()
