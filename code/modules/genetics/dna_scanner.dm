// TODO: rename to /machinery/dna_scanner
/obj/machinery/dna_scannernew
	name = "\improper DNA modifier"
	desc = "It scans DNA structures."
	icon = 'icons/obj/medical/cryogenic2.dmi'
	icon_state = "scanner_0"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 50
	active_power_usage = 300
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_ALLOW_SILICON
	circuit = /obj/item/circuitboard/clonescanner

	var/locked = FALSE
	var/opened = FALSE
	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_containers/glass/beaker = null

/obj/machinery/dna_scannernew/relaymove(mob/user)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/dna_scannernew/verb/eject()
	set src in oview(1)
	set category = VERB_CATEGORY_OBJECT
	set name = "Eject DNA Scanner"

	if (usr.stat != 0)
		return

	eject_occupant()

	add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/proc/eject_occupant()
	src.go_out()
	for(var/obj/O in src)
		if((!istype(O,/obj/item/reagent_containers)) && (!istype(O,/obj/item/circuitboard/clonescanner)) && (!istype(O,/obj/item/stock_parts)) && (!istype(O,/obj/item/stack/cable_coil)))
			O.forceMove(get_turf(src))
	if(!occupant)
		for(var/mob/M in src)//Failsafe so you can get mobs out
			M.forceMove(get_turf(src))

/**
 *? Allows borgs to clone people without external assistance.
 */
/obj/machinery/dna_scannernew/MouseDroppedOnLegacy(mob/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	put_in(target)

/obj/machinery/dna_scannernew/verb/move_inside()
	set src in oview(1)
	set category = VERB_CATEGORY_OBJECT
	set name = "Enter DNA Scanner"

	if (usr.stat != 0)
		return
	if (!ishuman(usr) && !issmall(usr)) //Make sure they're a mob that has dna
		to_chat(usr, SPAN_NOTICE("Try as you might, you can not climb up into the scanner."))
		return
	if (src.occupant)
		to_chat(usr, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (usr.abiotic())
		to_chat(usr, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	usr.stop_pulling()
	usr.forceMove(src)
	usr.update_perspective()
	src.occupant = usr
	src.icon_state = "scanner_1"
	src.add_fingerprint(usr)
	return

/obj/machinery/dna_scannernew/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return
		if(!user.attempt_insert_item_for_installation(item, src))
			return
		beaker = item
		user.visible_message("\The [user] adds \a [item] to \the [src]!", "You add \a [item] to \the [src]!")
		return

	else if(istype(item, /obj/item/organ/internal/brain))
		if (src.occupant)
			to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
			return
		var/obj/item/organ/internal/brain/brain = item
		if(brain.clone_source)
			if(!user.attempt_insert_item_for_installation(brain, src))
				return
			put_in(brain.brainmob)
			src.add_fingerprint(user)
			user.visible_message("\The [user] adds \a [item] to \the [src]!", "You add \a [item] to \the [src]!")
			return
		else
			to_chat(user,"\The [brain] is not acceptable for genetic sampling!")

	else if (!istype(item, /obj/item/grab))
		return
	var/obj/item/grab/G = item
	if (!ismob(G.affecting))
		return
	if (src.occupant)
		to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (G.affecting.abiotic())
		to_chat(user, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	put_in(G.affecting)
	src.add_fingerprint(user)
	qdel(G)
	return

/obj/machinery/dna_scannernew/proc/put_in(mob/M)
	occupant = M
	M.forceMove(src)
	M.update_perspective()

	icon_state = "scanner_1"

	// search for ghosts, if the corpse is empty and the scanner is connected to a cloner
	if(locate(/obj/machinery/computer/cloning, get_step(src, NORTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, SOUTH)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, EAST)) \
		|| locate(/obj/machinery/computer/cloning, get_step(src, WEST)))

		if(!M.client && M.mind)
			for(var/mob/observer/dead/ghost in GLOB.player_list)
				if(ghost.mind == M.mind)
					to_chat(ghost, "<b><font color = #330033><font size = 3>Your corpse has been placed into a cloning scanner. Return to your body if you want to be resurrected/cloned!</b> (Verbs -> Ghost -> Re-enter corpse)</font></font>")
					break
	return

/obj/machinery/dna_scannernew/proc/go_out()
	if(!occupant|| locked)
		return
	if(istype(occupant,/mob/living/carbon/brain))
		for(var/obj/O in src)
			if(istype(O,/obj/item/organ/internal/brain))
				O.forceMove(loc)
				occupant.forceMove(O)
				break
	else
		occupant.forceMove(loc)
	occupant.update_perspective()
	occupant = null
	icon_state = "scanner_0"

/obj/machinery/dna_scannernew/proc/occupant_valid(mob/victim)
	if(isnull(victim))
		victim = occupant
	if(isnull(victim))
		return FALSE
	if(iscarbon(victim))
		var/mob/living/carbon/casted_carbon = victim
		return !casted_carbon.isSynthetic()
	return FALSE
