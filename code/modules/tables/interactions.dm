/obj/structure/table/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return
	if(istype(mover,/obj/item/projectile))
		return check_cover(mover,target)
	if(flipped == 1)
		if(get_dir(mover, target) & turn(dir, 180))
			return FALSE
		return TRUE
	for(var/obj/structure/table/T in get_turf(mover))
		if(istype(T, /obj/structure/table/bench))
			continue
		if(T.flipped == 1)
			continue
		return TRUE

/obj/structure/table/CheckExit(atom/movable/AM, atom/newLoc)
	if(check_standard_flag_pass(AM))
		return TRUE
	if(flipped == -1 || !flipped)
		return TRUE
	return !density || !(get_dir(loc, newLoc) & dir)

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	if(flipped==1)
		cover = get_turf(src)
	else if(flipped==0)
		cover = get_step(loc, get_dir(from, loc))
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped==1)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				break_to_parts()
				return 1
	return 1

/obj/structure/table/attackby(obj/item/W, mob/user, params)
	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
				return
			if(!user.Adjacent(M))
				return
			if (G.state < 2)
				if(user.a_intent == INTENT_HARM)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = BP_HEAD)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					if(material)
						playsound(loc, material.tableslam_noise, 50, 1)
					else
						playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					var/list/L = take_damage(rand(1,5))
					// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
					for(var/obj/item/material/shard/S in L)
						if(prob(50))
							M.visible_message("<span class='danger'>\The [S] slices [M]'s face messily!</span>",
							                   "<span class='danger'>\The [S] slices your face messily!</span>")
							M.apply_damage(10, def_zone = BP_HEAD)
							if(prob(2))
								M.embed(S, def_zone = BP_HEAD)
				else
					to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
					return
			else if(G.state > GRAB_AGGRESSIVE || world.time >= (G.last_action + UPGRADE_COOLDOWN))
				M.forceMove(get_turf(src))
				M.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
			return

	if(istype(W, /obj/item/melee/energy/blade))
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src, "sparks", 50, 1)
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		break_to_parts()
		return CLICKCHAIN_DO_NOT_PROPAGATE

	if(istype(W, /obj/item/melee/changeling/arm_blade))
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		break_to_parts()
		return CLICKCHAIN_DO_NOT_PROPAGATE

	if(can_plate && !material)
		to_chat(user, "<span class='warning'>There's nothing to put \the [W] on! Try adding plating to \the [src] first.</span>")
		return CLICKCHAIN_DO_NOT_PROPAGATE

/*
	if(user.a_intent != INTENT_HARM && !(I.clothing_flags & ITEM_ABSTRACT))
		if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			I.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			I.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
			AfterPutItemOnTable(I, user)
			return TRUE
	else
		return ..()
*/

	if(item_place && (user.a_intent != INTENT_HARM))
		. = CLICKCHAIN_DO_NOT_PROPAGATE
		if(!user.transfer_item_to_loc(W, loc))
			return
		if(item_pixel_place)
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			W.pixel_x = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			W.pixel_y = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
		return
	return ..()

/obj/structure/table/attack_tk() // no telehulk sorry
	return
