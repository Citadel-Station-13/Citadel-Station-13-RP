// TODO: allow different tile types in storage??
/obj/machinery/floorlayer
	name = "automatic floor layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	var/turf/old_turf
	var/on = FALSE
	var/obj/item/stack/tile/T

	var/list/mode = list(
		"dismantle" = FALSE,
		"laying" = FALSE,
		"collect" = FALSE
		)

/obj/machinery/floorlayer/Initialize(mapload, newdir)
	. = ..()
	T = new /obj/item/stack/tile/floor(src)

/obj/machinery/floorlayer/Moved(atom/oldloc)
	. = ..()
	if(on)
		if(mode["dismantle"])
			dismantleFloor(old_turf)

		if(mode["laying"])
			layFloor(old_turf)

		if(mode["collect"])
			CollectTiles(old_turf)

	old_turf = isturf(loc)? loc : null

/obj/machinery/floorlayer/attack_hand(mob/user)
	on=!on
	user.visible_message( \
		SPAN_NOTICE("[user] has [!on?"de":""]activated \the [src]."), \
		SPAN_NOTICE("You [!on?"de":""]activate \the [src]."))
	return

/obj/machinery/floorlayer/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.is_wrench())
		var/m = tgui_input_list(usr, "Choose work mode", "Mode", mode)
		mode[m] = !mode[m]
		var/O = mode[m]
		user.visible_message( \
			SPAN_NOTICE("[usr] has set \the [src] [m] mode [!O?"off":"on"]."), \
			SPAN_NOTICE("You set \the [src] [m] mode [!O?"off":"on"]."))
		return

	if(istype(W, /obj/item/stack/tile))
		to_chat(user, SPAN_NOTICE("\The [W] successfully loaded."))
		user.drop_item(T)
		TakeTile(T)
		return

	if(W.is_crowbar())
		if(!length(contents))
			to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		else
			var/obj/item/stack/tile/E = tgui_input_list(usr, "Choose remove tile type.", "Tiles", contents)
			if(E)
				to_chat(user, SPAN_NOTICE("You remove \the [E] from \the [src]."))
				E.loc = src.loc
				T = null
		return

	if(W.is_screwdriver())
		T = tgui_input_list(usr, "Choose tile type.", "Tiles", contents)
		return
	..()

/obj/machinery/floorlayer/examine(mob/user)
	. = ..()
	var/dismantle = mode["dismantle"]
	var/laying = mode["laying"]
	var/collect = mode["collect"]
	. += SPAN_NOTICE("\The [src] [!T?"don't ":""]has [!T?"":"[T.get_amount()] [T] "]tile\s, dismantle is [dismantle?"on":"off"], laying is [laying?"on":"off"], collect is [collect?"on":"off"].")

/obj/machinery/floorlayer/proc/reset()
	on=0
	return

/obj/machinery/floorlayer/proc/dismantleFloor(turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			T.make_plating(!(T.broken || T.burnt))
	return new_turf.is_plating()

/obj/machinery/floorlayer/proc/TakeNewStack()
	for(var/obj/item/stack/tile/tile in contents)
		T = tile
		return TRUE
	return FALSE

/obj/machinery/floorlayer/proc/layFloor(turf/w_turf)
	if(!T)
		if(!TakeNewStack())
			return FALSE
	w_turf.attackby(T , src)
	return TRUE

/obj/machinery/floorlayer/proc/TakeTile(obj/item/stack/tile/tile)
	if(!T)
		T = tile
		tile.forceMove(src)
	else
		tile.merge(T)

/obj/machinery/floorlayer/proc/CollectTiles(turf/w_turf)
	for(var/obj/item/stack/tile/tile in w_turf)
		TakeTile(tile)
