/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE
	var/bottle = 0
	var/cups = 0
	var/cupholder = 0

/obj/structure/reagent_dispensers/water_cooler/full
	bottle = 1
	cupholder = 1
	cups = 10

/obj/structure/reagent_dispensers/water_cooler/Initialize(mapload)
	. = ..()
	if(bottle)
		reagents.add_reagent(/datum/reagent/water, 120)
	update_icon()

/obj/structure/reagent_dispensers/water_cooler/examine(mob/user, dist)
	. = ..()
	if(cupholder)
		. += "<span class='notice'>There are [cups] cups in the cup dispenser.</span>"

/obj/structure/reagent_dispensers/water_cooler/verb/rotate_clockwise()
	set name = "Rotate Cooler Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	setDir(turn(dir, 270))
	return 1

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/I as obj, mob/user as mob)
	if(I.is_wrench())
		src.add_fingerprint(user)
		if(bottle)
			playsound(src, I.tool_sound, 50, 1)
			if(do_after(user, 20) && bottle)
				to_chat(user, "<span class='notice'>You unfasten the jug.</span>")
				var/obj/item/reagent_containers/glass/cooler_bottle/G = new /obj/item/reagent_containers/glass/cooler_bottle( src.loc )
				for(var/datum/reagent/R in reagents.reagent_list)
					var/total_reagent = reagents.get_reagent_amount(R.id)
					G.reagents.add_reagent(R.id, total_reagent)
				reagents.clear_reagents()
				bottle = 0
				update_icon()
		else
			if(anchored)
				user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
			else
				user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
			if(do_after(user, 20 * I.tool_speed, src))
				if(!src) return
				to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
				anchored = !anchored
				playsound(src, I.tool_sound, 50, 1)
		return

	if(I.is_screwdriver())
		if(cupholder)
			playsound(src, I.tool_sound, 50, 1)
			to_chat(user, "<span class='notice'>You take the cup dispenser off.</span>")
			new /obj/item/stack/material/plastic( src.loc )
			if(cups)
				for(var/i = 0 to cups)
					new /obj/item/reagent_containers/food/drinks/sillycup(src.loc)
			cups = 0
			cupholder = 0
			update_icon()
			return
		if(!bottle && !cupholder)
			playsound(src, I.tool_sound, 50, 1)
			to_chat(user, "<span class='notice'>You start taking the water-cooler apart.</span>")
			if(do_after(user, 20 * I.tool_speed) && !bottle && !cupholder)
				to_chat(user, "<span class='notice'>You take the water-cooler apart.</span>")
				new /obj/item/stack/material/plastic( src.loc, 4 )
				qdel(src)
		return

	if(istype(I, /obj/item/reagent_containers/glass/cooler_bottle))
		src.add_fingerprint(user)
		if(!bottle)
			if(anchored)
				var/obj/item/reagent_containers/glass/cooler_bottle/G = I
				to_chat(user, "<span class='notice'>You start to screw the bottle onto the water-cooler.</span>")
				if(do_after(user, 20) && !bottle && anchored)
					bottle = 1
					update_icon()
					to_chat(user, "<span class='notice'>You screw the bottle onto the water-cooler!</span>")
					for(var/datum/reagent/R in G.reagents.reagent_list)
						var/total_reagent = G.reagents.get_reagent_amount(R.id)
						reagents.add_reagent(R.id, total_reagent)
					qdel(G)
			else
				to_chat(user, "<span class='warning'>You need to wrench down the cooler first.</span>")
		else
			to_chat(user, "<span class='warning'>There is already a bottle there!</span>")
		return 1

	if(istype(I, /obj/item/stack/material/plastic))
		if(!cupholder)
			if(anchored)
				var/obj/item/stack/material/plastic/P = I
				src.add_fingerprint(user)
				to_chat(user, "<span class='notice'>You start to attach a cup dispenser onto the water-cooler.</span>")
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && !cupholder && anchored)
					if (P.use(1))
						to_chat(user, "<span class='notice'>You attach a cup dispenser onto the water-cooler.</span>")
						cupholder = 1
						update_icon()
			else
				to_chat(user, "<span class='warning'>You need to wrench down the cooler first.</span>")
		else
			to_chat(user, "<span class='warning'>There is already a cup dispenser there!</span>")
		return

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/user)
	if(cups)
		new /obj/item/reagent_containers/food/drinks/sillycup(src.loc)
		cups--
		flick("[icon_state]-vend", src)
		return

/obj/structure/reagent_dispensers/water_cooler/update_icon()
	icon_state = "water_cooler"
	cut_overlays()
	var/image/I
	if(bottle)
		I = image(icon, "water_cooler_bottle")
		add_overlay(I)
