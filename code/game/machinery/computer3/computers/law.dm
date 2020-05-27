/obj/machinery/computer3/aiupload
	name = "AI Upload"
	desc = "Used to upload laws to the AI."
	icon_state = "frame-rnd"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = FALSE

/obj/machinery/computer3/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)
	if(!Adjacent(usr) || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon) || !istype(usr, /mob/living))
		return

	opened = !opened
	if(opened)
		to_chat(usr, "<span class='notice'>The access panel is now open.</span>")
	else
		to_chat(usr, "<span class='notice'>The access panel is now closed.</span>")
	return


/obj/machinery/computer3/aiupload/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		if(!current)
			to_chat(user, "<span class='caution'>You haven't selected anything to transmit laws to!</span>")
			return
		if(current.stat == DEAD || current.control_disabled)
			to_chat(user, "<span class='caution'>Upload failed!</span> Check to make sure [current.name] is functioning properly.")
			current = null
			return
		//var/turf/currentloc = get_turf(current)
		if(user.z > 6)//if(currentloc && user.z != currentloc.z)
			to_chat(user, "<span class='caution'>Upload failed!</span> Unable to establish a connection to [current.name]. You're too far away!")
			current = null
			return
		M.install(src, user)
	else
		return ..()

/obj/machinery/computer3/aiupload/attack_hand(mob/user)
	if(CHECK_BITFIELD(stat, NOPOWER))
		to_chat(user, "The upload computer has no power!")
		return
	if(CHECK_BITFIELD(stat, BROKEN))
		to_chat(user, "The upload computer is broken!")
		return

	current = select_active_ai(user)

	if(!current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")

/obj/machinery/computer3/borgupload
	name = "Cyborg Upload"
	desc = "Used to upload laws to Cyborgs."
	icon_state = "frame-rnd"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null

/obj/machinery/computer3/borgupload/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		if(!current)
			to_chat(user, "<span class='caution'>You haven't selected anything to transmit laws to!</span>")
			return
		if(current.stat == DEAD || current.control_disabled)
			to_chat(user, "<span class='caution'>Upload failed!</span> Check to make sure [current.name] is functioning properly.")
			current = null
			return
		//var/turf/currentloc = get_turf(current)
		if(GLOB.using_map && !(user.z in GLOB.using_map.contact_levels))//if(currentloc && user.z != currentloc.z)
			to_chat(user, "<span class='caution'>Upload failed!</span> Unable to establish a connection to [current.name]. You're too far away!")
			current = null
			return
		M.install(src, user)
	else
		return ..()

/obj/machinery/computer3/borgupload/attack_hand(var/mob/user as mob)
	if(CHECK_BITFIELD(stat, NOPOWER)) //*AAAAAA*
		to_chat(user, "The upload computer has no power!")
		return
	if(CHECK_BITFIELD(stat, BROKEN))
		to_chat(user, "The upload computer is broken!")
		return

	current = active_free_borgs(user)

	if(!current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[current.name] selected for law changes.")
