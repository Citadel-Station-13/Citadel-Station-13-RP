
/obj/vehicle_old/train/rover/trolley
	name = "Train trolley"
	desc = "A trolley designed to transport security equipment to a scene."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "secitemcarrierbot"
	anchored = 0
	passenger_allowed = 0
	locked = 0

	load_item_visible = 0
	load_offset_x = 0
	load_offset_y = 0
	mob_offset_y = 0

/obj/vehicle_old/train/rover/trolley/attackby(obj/item/W as obj, mob/user as mob)
	if(open && istype(W, /obj/item/tool/wirecutters))
		passenger_allowed = !passenger_allowed
		user.visible_message("<span class='notice'>[user] [passenger_allowed ? "cuts" : "mends"] a cable in [src].</span>","<span class='notice'>You [passenger_allowed ? "cut" : "mend"] the load limiter cable.</span>")
	else
		..()

//cargo trains are open topped, so there is a chance the projectile will hit the mob ridding the train instead
/obj/vehicle_old/train/rover/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	if(has_buckled_mobs() && prob(70))
		var/mob/buckled = pick(buckled_mobs)
		return proj.impact_redirect(buckled, args)
	return ..()

/obj/vehicle_old/train/rover/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/vehicle_old/train/rover/trolley/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle_old/train/rover/trolley/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	..()

/obj/vehicle_old/train/rover/trolley/RunOver(var/mob/living/M)
	..()
	attack_log += "\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey])</font>"

/obj/vehicle_old/train/rover/trolley/load(var/atom/movable/C)
	if(ismob(C) && !passenger_allowed)
		return 0
	if(!istype(C,/obj/machinery) && !istype(C,/obj/structure/closet) && !istype(C,/obj/structure/largecrate) && !istype(C,/obj/structure/reagent_dispensers) && !istype(C,/obj/structure/ore_box) && !istype(C, /mob/living/carbon/human))
		return 0

	//if there are any items you don't want to be able to interact with, add them to this check
	// ~no more shielded, emitter armed death trains
	if(istype(C, /obj/machinery))
		load_object(C)
	else
		..()

	if(load)
		return 1

/obj/vehicle_old/train/rover/trolley/proc/load_object(atom/movable/C)
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	var/datum/vehicle_dummy_load/dummy_load = new()
	load = dummy_load

	if(!load)
		return
	dummy_load.actual_load = C
	C.forceMove(src)

	if(load_item_visible)
		C.pixel_x += load_offset_x
		C.pixel_y += load_offset_y
		C.layer = layer

		add_overlay(C)

		//we can set these back now since we have already cloned the icon into the overlay
		C.pixel_x = initial(C.pixel_x)
		C.pixel_y = initial(C.pixel_y)
		C.layer = initial(C.layer)

/obj/vehicle_old/train/rover/trolley/unload(var/mob/user, var/direction)
	if(istype(load, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = load
		load = dummy_load.actual_load
		dummy_load.actual_load = null
		qdel(dummy_load)
		cut_overlay()
	..()

/obj/vehicle_old/train/rover/trolley/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	if(!lead && !tow)
		anchored = 0
	else
		anchored = 1
