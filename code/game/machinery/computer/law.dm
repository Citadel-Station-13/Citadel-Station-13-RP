
/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = 0


/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)
	if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon))
		return

	opened = !opened
	if(opened)
		to_chat(usr, "<span class='notice'>The access panel is now open.</span>")
	else
		to_chat(usr, "<span class='notice'>The access panel is now closed.</span>")
	return


/obj/machinery/computer/aiupload/attackby(obj/item/O, mob/user)
	if (GLOB.using_map && !(user.z in GLOB.using_map.contact_levels))
		to_chat(user, "<span class='danger'>Unable to establish a connection:</span> You're too far away from the station!")
		return
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		M.install(src, user)
	else
		..()


/obj/machinery/computer/aiupload/attack_hand(mob/user)
	if(machine_stat & NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return
	if(machine_stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return

	src.current = select_active_ai(user)

	if (!src.current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")
	return

/obj/machinery/computer/aiupload/attack_ghost(mob/user)
	. = ..()
	return TRUE

/obj/machinery/computer/borgupload
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


/obj/machinery/computer/borgupload/attackby(obj/item/aiModule/module, mob/user)
	if(istype(module, /obj/item/aiModule))
		module.install(src, user)
	else
		return ..()


/obj/machinery/computer/borgupload/attack_hand(mob/user)
	if(machine_stat& NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return
	if(machine_stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return

	src.current = freeborg()

	if (!src.current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")
	return

/obj/machinery/computer/borgupload/attack_ghost(mob/user)
	. = ..()
	return 1
