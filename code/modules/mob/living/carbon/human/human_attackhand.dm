/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/living/carbon/human/target, var/hit_zone)

	if(nif && nif.flag_check(NIF_C_HARDCLAWS,NIF_FLAGS_COMBAT))
		return unarmed_hardclaws
	if(src.default_attack && src.default_attack.is_usable(src, target, hit_zone))
		if(pulling_punches)
			var/datum/melee_attack/unarmed/soft_type = src.default_attack.get_sparring_variant()
			if(soft_type)
				return soft_type
		return src.default_attack

	if(src.gloves)
		var/obj/item/clothing/gloves/G = src.gloves
		if(istype(G) && G.special_attack && G.special_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/melee_attack/unarmed/soft_type = G.special_attack.get_sparring_variant()
				if(soft_type)
					return soft_type
			return G.special_attack
	for(var/datum/melee_attack/unarmed/u_attack in species.unarmed_attacks)
		if(u_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/melee_attack/unarmed/soft_variant = u_attack.get_sparring_variant()
				if(soft_variant)
					return soft_variant
			return u_attack
	return null

//can move this to a different .dm if needed
/mob/living/carbon/human/AltClick(mob/user)
	. = ..()
	if(!Adjacent(user) || !user.canClick() || user.incapacitated() || user.stat)
		return
	var/mob/living/carbon/human/H = user
	if (istype(H) && attempt_to_scoop(H))
		return
	//if someone else ever decides altclicking people should do other things, bare in mind it currently continues if the person fails to be scooped

/mob/living/carbon/human/attack_generic(var/mob/user, var/damage, var/attack_message, var/armor_type = "melee", var/armor_pen = 0, var/a_sharp = 0, var/a_edge = 0)

	if(!damage)
		return

	add_attack_logs(user,src,"Melee attacked with fists (miss/block)",admin_notify = FALSE) //No admin notice since this is usually fighting simple animals
	src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)

	var/dam_zone = pick(organs_by_name)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, armor_type, armor_pen)
	var/armor_soak = get_armor_soak(affecting, armor_type, armor_pen)
	apply_damage(damage, DAMAGE_TYPE_BRUTE, affecting, armor_block, armor_soak, sharp = a_sharp, edge = a_edge)
	update_health()
	return TRUE

//Used to attack a joint through grabbing
/mob/living/carbon/human/proc/grab_joint(var/mob/living/user, var/def_zone)
	if(user.check_grab(src) < GRAB_NECK)
		return

	if(!def_zone) def_zone = user.zone_sel.selecting
	var/target_zone = check_zone(def_zone)
	if(!target_zone)
		return FALSE
	var/obj/item/organ/external/organ = get_organ(check_zone(target_zone))
	if(!organ || organ.dislocated > 0 || organ.dislocated == -1) //don't use is_dislocated() here, that checks parent
		return FALSE

	user.visible_message("<span class='warning'>[user] begins to dislocate [src]'s [organ.joint]!</span>")
	if(do_after(user, 100))
		organ.dislocate(1)
		src.visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		return TRUE
	return FALSE

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = FALSE
	if(pulling)
		visible_message("<span class='danger'>[user] has broken [src]'s grip on [pulling]!</span>")
		success = TRUE
		stop_pulling()

	for(var/obj/item/grab/grab as anything in get_held_items_of_type(/obj/item/grab))
		if(grab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [grab.affecting]!</span>")
			success = TRUE
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), grab)
	return success

/*
	We want to ensure that a mob may only apply pressure to one organ of one mob at any given time. Currently this is done mostly implicitly through
	the behaviour of do_after() and the fact that applying pressure to someone else requires a grab:
	If you are applying pressure to yourself and attempt to grab someone else, you'll change what you are holding in your active hand which will stop do_mob()
	If you are applying pressure to another and attempt to apply pressure to yourself, you'll have to switch to an empty hand which will also stop do_mob()
	Changing targeted zones should also stop do_mob(), preventing you from applying pressure to more than one body part at once.
*/
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || (organ.robotic >= ORGAN_ROBOT))
		return FALSE

	if(organ.applied_pressure)
		to_chat(user, "<span class='warning'>Someone is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].</span>")
		return FALSE

	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]

	if(user == src)
		user.visible_message("\The [user] starts applying pressure to [TU.his] [organ.name]!", "You start applying pressure to your [organ.name]!")
	else
		user.visible_message("\The [user] starts applying pressure to [src]'s [organ.name]!", "You start applying pressure to [src]'s [organ.name]!")
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_mob(user, src, INFINITY, target_zone, progress = 0)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message("\The [user] stops applying pressure to [TU.his] [organ.name]!", "You stop applying pressure to your [organ]!")
		else
			user.visible_message("\The [user] stops applying pressure to [src]'s [organ.name]!", "You stop applying pressure to [src]'s [organ.name]!")

	return TRUE

/mob/living/carbon/human
	var/datum/melee_attack/unarmed/default_attack

/mob/living/carbon/human/verb/check_attacks()
	set name = "Check Attacks"
	set category = VERB_CATEGORY_IC
	set src = usr

	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	for(var/datum/melee_attack/unarmed/u_attack in species.unarmed_attacks)
		dat += "<b>Primarily [u_attack.attack_name] </b><br/><br/><br/>"

	src << browse(HTML_SKELETON(dat), "window=checkattack")
	return

/mob/living/carbon/human/check_attacks()
	var/dat = "<b><font size = 5>Known Attacks</font></b><br/><br/>"

	if(default_attack)
		dat += "Current default attack: [default_attack.attack_name] - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/>"

	for(var/datum/melee_attack/unarmed/u_attack in species.unarmed_attacks)
		if(u_attack == default_attack)
			dat += "<b>Primarily [u_attack.attack_name]</b> - default - <a href='byond://?src=\ref[src];default_attk=reset_attk'>reset</a><br/><br/><br/>"
		else
			dat += "<b>Primarily [u_attack.attack_name]</b> - <a href='byond://?src=\ref[src];default_attk=\ref[u_attack]'>set default</a><br/><br/><br/>"

	src << browse(HTML_SKELETON(dat), "window=checkattack")

/mob/living/carbon/human/Topic(href, href_list)
	if(href_list["default_attk"])
		if(href_list["default_attk"] == "reset_attk")
			set_default_attack(null)
		else
			var/datum/melee_attack/unarmed/u_attack = locate(href_list["default_attk"])
			if(u_attack && (u_attack in species.unarmed_attacks))
				set_default_attack(u_attack)
		check_attacks()
		return 1
	else
		return ..()

/mob/living/carbon/human/proc/set_default_attack(var/datum/melee_attack/unarmed/u_attack)
	default_attack = u_attack
