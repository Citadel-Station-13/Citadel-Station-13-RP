///amount of health regained per stack amount used
#define DOOR_REPAIR_AMOUNT 50

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	armor_type = /datum/armor/door
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	CanAtmosPass = ATMOS_PASS_PROC
	layer = DOOR_OPEN_LAYER
	rad_flags = RAD_BLOCK_CONTENTS
	// todo: rad_insulation_open/closed
	pass_flags_self = NONE

	integrity = 300
	integrity_max = 300
	integrity_failure = 100

	hit_sound_brute = 'sound/weapons/smash.ogg'

	var/mineral
	var/open_layer = DOOR_OPEN_LAYER
	var/closed_layer = DOOR_CLOSED_LAYER

	var/visible = 1
	var/p_open = 0//[bool]is the door open?
	var/operating = 0//[bool]Is the door opening or closing?
	var/autoclose = 0//[bool]should the door close automaticly
	var/glass = 0
	var/normalspeed = 1
	var/heat_resistance = 1000 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/repairing = 0
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/close_door_at = 0 //When to automatically close the door, if possible

	//Multi-tile doors
	var/width = 1
	var/autoset_dir = TRUE

	// turf animation
	var/atom/movable/overlay/c_animation = null

	var/reinforcing = 0
	var/tintable = 0
	var/icon_tinted
	var/id_tint

/obj/machinery/door/Initialize(mapload, newdir)
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0

	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = world.icon_size
			bound_height = width * world.icon_size
		else
			bound_width = width * world.icon_size
			bound_height = world.icon_size

	update_icon()

	update_nearby_tiles()
	if(autoset_dir)
		setDir(dir)

/obj/machinery/door/Destroy()
	density = FALSE
	update_nearby_tiles()
	. = ..()

/obj/machinery/door/process(delta_time)
	if(close_door_at && world.time >= close_door_at)
		if(autoclose)
			close_door_at = next_close_time()
			spawn(0)
				close()
		else
			close_door_at = 0

/obj/machinery/door/proc/can_open()
	if(!density || operating || !SSticker)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating || !SSticker)
		return 0
	return 1

/obj/machinery/door/Bumped(atom/AM)
	. = ..()
	if(p_open || operating)
		return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10)
			return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(M.restrained() && !check_access(null))
			return
		else if(istype(M, /mob/living/simple_mob/animal/passive/mouse) && !(M.ckey))
			return
		else
			bumpopen(M)


	if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /obj/mecha))
		var/obj/mecha/mecha = AM
		if(density)
			if(mecha.occupant && (src.allowed(mecha.occupant) || src.check_access_list(mecha.operation_req_access)))
				open()
			else
				do_animate(DOOR_ANIMATION_DENY)
		return
	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate(DOOR_ANIMATION_DENY)

/obj/machinery/door/CanAllowThrough(atom/movable/mover, turf/target)
	if(!opacity && mover.check_pass_flags(ATOM_PASS_GLASS))
		return TRUE
	return ..()

/obj/machinery/door/CanAtmosPass(turf/T, d)
	if(density)
		return ATMOS_PASS_AIR_BLOCKED
	if(block_air_zones)
		return ATMOS_PASS_ZONE_BLOCKED
	return ATMOS_PASS_NOT_BLOCKED

/obj/machinery/door/proc/bumpopen(mob/user as mob)
	CACHE_VSC_PROP(atmos_vsc, /atmos/airflow/retrigger_delay, airflow_delay)
	if(operating)
		return
	if(user.last_airflow > world.time - airflow_delay)
		return
	src.add_fingerprint(user)
	if(density)
		if(allowed(user))
			open()
		else
			do_animate(DOOR_ANIMATION_DENY)

/obj/machinery/door/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/door/attack_hand(mob/user, list/params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	return src.attackby(user, user)

/obj/machinery/door/attack_tk(mob/user as mob)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	src.add_fingerprint(user, 0, I)

	if(istype(I))
		if(attackby_vr(I, user))
			return
		if(mineral && I.is_material_stack_of(mineral))
			if(machine_stat & BROKEN)
				to_chat(user, "<span class='notice'>It looks like \the [src] is pretty busted. It's going to need more than just patching up now.</span>")
				return
			if(integrity >= integrity_max)
				to_chat(user, "<span class='notice'>Nothing to fix!</span>")
				return
			if(!density)
				to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
				return

			//figure out how much metal we need
			var/amount_needed = (integrity_max - integrity) / DOOR_REPAIR_AMOUNT
			amount_needed = (round(amount_needed) == amount_needed)? amount_needed : round(amount_needed) + 1 //Why does BYOND not have a ceiling proc?

			var/obj/item/stack/stack = I
			var/amount_given = amount_needed - repairing
			var/mats_given = stack.get_amount()
			if(repairing && amount_given <= 0)
				to_chat(user, "<span class='warning'>You must weld or remove \the [mineral? mineral : "plating"] from \the [src] before you can add anything else.</span>")
			else
				if(mats_given >= amount_given)
					if(stack.use(amount_given))
						repairing += amount_given
				else
					if(stack.use(mats_given))
						repairing += mats_given
						amount_given = mats_given
			if(amount_given)
				to_chat(user, "<span class='notice'>You fit [amount_given] [stack.singular_name]\s to damaged and broken parts on \the [src].</span>")

			return

		if(repairing && istype(I, /obj/item/weldingtool))
			if(!density)
				to_chat(user, "<span class='warning'>\The [src] must be closed before you can repair it.</span>")
				return

			var/obj/item/weldingtool/welder = I
			if(welder.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You start to fix dents and weld \the [mineral? mineral : "plating"] into place.</span>")
				playsound(src, welder.tool_sound, 50, 1)
				if(do_after(user, (5 * repairing) * welder.tool_speed) && welder && welder.isOn())
					to_chat(user, "<span class='notice'>You finish repairing the damage to \the [src].</span>")
					integrity = clamp(integrity + repairing * DOOR_REPAIR_AMOUNT, 0, integrity_max)
					update_icon()
					repairing = 0
			return

		if(repairing && I.is_crowbar())
			var/datum/material/M = SSmaterials.resolve_material(mineral)
			var/obj/item/stack/material/repairing_sheet = M.place_sheet(loc)
			repairing_sheet.amount += repairing-1
			repairing = 0
			to_chat(user, "<span class='notice'>You remove \the [repairing_sheet].</span>")
			playsound(src, I.tool_sound, 100, 1)

	if(src.operating > 0 || isrobot(user))
		return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating)
		return

	if(src.allowed(user) && operable())
		if(src.density)
			open()
		else
			close()
		return

	if(src.density)
		do_animate(DOOR_ANIMATION_DENY)
	return

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate(DOOR_ANIMATION_SPARK)
		sleep(6)
		open()
		operating = -1
		return 1

/obj/machinery/door/damage_integrity(amount, gradual, do_not_break)
	var/initial_integrity = integrity
	. = ..()
	if(gradual)
		update_appearance(UPDATE_ICON)
		return
	if(integrity < integrity_max / 4 && initial_integrity >= integrity_max / 4)
		visible_message("[src] looks like it's about to break!" )
		update_appearance(UPDATE_ICON)
	else if(integrity < integrity_max / 2 && initial_integrity >= integrity_max / 2)
		visible_message("[src] looks seriously damaged!" )
		update_appearance(UPDATE_ICON)
	else if(integrity < integrity_max * 3/4 && initial_integrity >= integrity_max * 3/4 && integrity > 0)
		visible_message("[src] shows signs of damage!" )
		update_appearance(UPDATE_ICON)

/obj/machinery/door/atom_break()
	. = ..()
	// todo: this is shitcode
	if(!istype(src, /obj/machinery/door/airlock))
		for (var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message("[src.name] breaks!" )
	update_icon()

/obj/machinery/door/atom_fix()
	. = ..()
	machine_stat &= (~BROKEN)
	update_icon()

/obj/machinery/door/emp_act(severity)
	if(prob(20/severity) && (istype(src,/obj/machinery/door/airlock) || istype(src,/obj/machinery/door/window)) )
		spawn(0)
			open()
	..()

/obj/machinery/door/update_icon()
	if(density)
		icon_state = "door1"
	else
		icon_state = "door0"

/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if(DOOR_ANIMATION_OPEN)
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if(DOOR_ANIMATION_CLOSE)
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if(DOOR_ANIMATION_SPARK)
			if(density)
				flick("door_spark", src)
		if(DOOR_ANIMATION_DENY)
			if(density && !(machine_stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)

/obj/machinery/door/proc/open(var/forced = 0)
	if(!can_open(forced))
		return
	operating = 1

	do_animate(DOOR_ANIMATION_OPEN)
	set_opacity(0)
	sleep(3)
	src.density = 0
	update_nearby_tiles()
	sleep(7)
	src.layer = open_layer
	explosion_resistance = 0
	update_icon()
	set_opacity(0)
	rad_insulation = RAD_INSULATION_NONE
	operating = 0

	if(autoclose)
		close_door_at = next_close_time()

	return 1

/obj/machinery/door/proc/next_close_time()
	return world.time + (normalspeed ? 150 : 5)

/obj/machinery/door/proc/close(var/forced = 0)
	if(!can_close(forced))
		return
	operating = 1

	close_door_at = 0
	do_animate(DOOR_ANIMATION_CLOSE)
	sleep(3)
	src.density = 1
	explosion_resistance = initial(explosion_resistance)
	src.layer = closed_layer
	update_nearby_tiles()
	sleep(7)
	update_icon()
	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	rad_insulation = initial(rad_insulation)
	operating = 0

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/atom/movable/fire/fire = locate() in loc
	if(fire)
		qdel(fire)

	return 1

/obj/machinery/door/proc/toggle_open(var/forced)
	if(density)
		open(forced)
	else
		close(forced)

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		turf.queue_zone_update()

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || (heat_resistance > initial(heat_resistance))))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(new_loc, new_dir)
	//update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

//Flesh Door
/obj/machinery/door/flesh_door
	name = "flesh door"
	desc = "This door pulses and twitches as if it's alive. It is."

	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "fleshclosed"
