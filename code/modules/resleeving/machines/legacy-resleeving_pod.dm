#warn ...
/obj/machinery/resleeving/resleeving_pod/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	user.set_machine(src)
	var/health_text = ""
	var/mind_text = ""
	if(src.occupant)
		if(src.occupant.stat >= DEAD)
			health_text = "<FONT color=red>DEAD</FONT>"
		else if(src.occupant.health < 0)
			health_text = "<FONT color=red>[round(src.occupant.health,0.1)]</FONT>"
		else
			health_text = "[round(src.occupant.health,0.1)]"

		if(src.occupant.mind)
			mind_text = "Mind present: [occupant.mind.name]"
		else
			mind_text = "Mind absent."

	var/dat ="<B>Resleever Status</B><BR>"
	dat +="<B>Current occupant:</B> [src.occupant ? "<BR>Name: [src.occupant]<BR>Health: [health_text]<BR>" : "<FONT color=red>None</FONT>"]<BR>"
	dat +="<B>Mind status:</B> [mind_text]<BR>"
	user.set_machine(src)
	user << browse(HTML_SKELETON(dat), "window=resleever")
	onclose(user, "resleever")

/obj/machinery/resleeving/resleeving_pod/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(!ismob(G.affecting))
			return
		var/mob/M = G.affecting
		if(put_mob(M))
			qdel(G)
			src.updateUsrDialog()
			return //Don't call up else we'll get attack messsages

/obj/machinery/resleeving/resleeving_pod/MouseDroppedOnLegacy(mob/living/carbon/O, mob/user)
	if(!istype(O))
		return FALSE //not a mob
	if(user.incapacitated())
		return FALSE //user shouldn't be doing things
	if(O.anchored)
		return FALSE //mob is anchored???
	if(get_dist(user, src) > 1 || get_dist(user, O) > 1)
		return FALSE //doesn't use adjacent() to allow for non-GLOB.cardinal (fuck my life)
	if(!ishuman(user) && !isrobot(user))
		return FALSE //not a borg or human
	if(panel_open)
		to_chat(user, SPAN_NOTICE("Close the maintenance panel first."))
		return FALSE //panel open

	if(O.buckled)
		return FALSE
	if(O.has_buckled_mobs())
		to_chat(user, SPAN_WARNING( "\The [O] has other entities attached to it. Remove them first."))
		return

	if(put_mob(O))
		if(O == user)
			src.updateUsrDialog()
			visible_message("[user] climbs into \the [src].")
		else
			src.updateUsrDialog()
			visible_message("[user] puts [O] into \the [src].")

	add_fingerprint(user)

/obj/machinery/resleeving/resleeving_pod/MouseDroppedOnLegacy(mob/target, mob/user) //Allows borgs to put people into resleeving without external assistance
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	put_mob(target)

/obj/machinery/resleeving/resleeving_pod/proc/putmind(datum/transhuman/mind_record/MR, mode = 1, mob/living/carbon/human/override = null)
	if((!occupant || !istype(occupant) || occupant.stat >= DEAD) && mode == 1)
		return 0

	//If we're sleeving a subtarget, briefly swap them to not need to duplicate tons of code.
	var/mob/living/carbon/human/original_occupant
	if(override)
		original_occupant = occupant
		occupant = override

	//In case they already had a mind!
	if(occupant && occupant.mind)
		to_chat(occupant, SPAN_WARNING("You feel your mind being overwritten..."))
		log_and_message_admins("was resleeve-wiped from their body.",occupant.mind)
		occupant.ghostize()

	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer(occupant) //Does mind+ckey+client.
	occupant.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.
	if(MR.one_time)
		var/how_long = round((world.time - MR.last_update)/10/60)
		to_chat(occupant,SPAN_DANGER("Your mind backup was a 'one-time' backup. \
		You will not be able to remember anything since the backup, [how_long] minutes ago."))

	// If it was a custom sleeve (not owned by anyone), update namification sequences
	if(!occupant.original_player)
		occupant.real_name = occupant.mind.name
		occupant.name = occupant.real_name
		occupant.dna.real_name = occupant.real_name

	//Inform them and make them a little dizzy.
	if(confuse_amount + blur_amount <= 16)
		to_chat(occupant, SPAN_NOTICE("You feel a small pain in your back as you're given a new \
		mirror implant. Oh, and a new body. \
		Your brain will struggle for some time to relearn its neurological pathways, \
		and you may feel disorientation, moments of confusion, and random pain or spasms. \
		You also feel a constant disconnect, and your body feels foreign. \
		You can't shake the final thoughts and feelings of your past life, and they linger at the \
		forefront of your memory. "))

	occupant.confused   = max(occupant.confused, confuse_amount)
	occupant.eye_blurry = max(occupant.eye_blurry, blur_amount)

	if(occupant.mind && occupant.original_player && occupant.mind.ckey != occupant.original_player)
		log_and_message_admins("is now a cross-sleeved character. Body originally belonged to [occupant.real_name]. Mind is now [occupant.mind.name].",occupant)

	if(original_occupant)
		occupant = original_occupant

	playsound(src, 'sound/machines/medbayscanner1.ogg', 100, TRUE) // Play our sound at the end of the mind injection!
	return 1

/obj/machinery/resleeving/resleeving_pod/proc/go_out(mob/M)
	if(!occupant)
		return
	occupant.forceMove(loc)
	occupant.update_perspective()
	occupant = null
	icon_state = "implantchair"
	return

/obj/machinery/resleeving/resleeving_pod/proc/put_mob(mob/living/carbon/human/M as mob)
	if(!ishuman(M))
		to_chat(usr, SPAN_WARNING("\The [src] cannot hold this!"))
		return
	if(occupant)
		to_chat(usr, SPAN_WARNING("\The [src] is already occupied!"))
		return
	M.stop_pulling()
	M.forceMove(src)
	M.update_perspective()
	occupant = M
	add_fingerprint(usr)
	icon_state = "implantchair_on"
	return TRUE

/obj/machinery/resleeving/resleeving_pod/verb/get_out()
	set name = "EJECT Occupant"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)
	if(usr.stat != CONSCIOUS)
		return
	src.go_out(usr)
	add_fingerprint(usr)
	return

/obj/machinery/resleeving/resleeving_pod/verb/move_inside()
	set name = "Move INSIDE"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)
	if(usr.stat != CONSCIOUS || machine_stat & (NOPOWER|BROKEN))
		return
	put_mob(usr)
	return
