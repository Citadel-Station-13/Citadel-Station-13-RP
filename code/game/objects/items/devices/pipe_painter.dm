/obj/item/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR
	var/list/modes
	var/mode

/obj/item/pipe_painter/Initialize(mapload)
	. = ..()
	modes = new()
	for(var/C in pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/pipe_painter/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return

	if(!istype(target,/obj/machinery/atmospherics/pipe) || istype(target,/obj/machinery/atmospherics/pipe/tank) || istype(target,/obj/machinery/atmospherics/pipe/vent) || istype(target,/obj/machinery/atmospherics/pipe/simple/heat_exchanging) || istype(target,/obj/machinery/atmospherics/pipe/simple/insulated) || !in_range(user, target))
		return
	var/obj/machinery/atmospherics/pipe/P = target

	P.change_color(pipe_colors[mode])

/obj/item/pipe_painter/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	mode = input("Which colour do you want to use?", "Pipe painter", mode) in modes

/obj/item/pipe_painter/examine(mob/user, dist)
	. = ..()
	. += "<span class = 'notice'>It is in [mode] mode.</span>"
