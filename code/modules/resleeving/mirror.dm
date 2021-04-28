//////////////////////////////////////////////////////////////
////////////////////////Mirror Implants//////////////////////
////////////////////////////////////////////////////////////

/obj/item/implant/mirror
	name = "Mirror"
	desc = "A small implanted disk that stores a copy of ones conciousness, updated at times of rest."
	catalogue_data = /datum/category_item/catalogue/technology/resleeving
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirror_implant_f"
	var/stored_mind = null

/obj/item/implant/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Galactic Immortality Initiative Mirror Implant<BR>
<b>Life:</b> Indefinite.<BR>
<b>Important Notes:</b> Implant updates when the user sleeps, or when manually done by an update chamber. Loss of implant complicates resleeving.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> A self-contained disk that can store the conciousness of a living creature.<BR>
<b>Special Features:</b> Allows the user to transfer their mind to another body in the event of death, or the desire to change sleeves.<BR>
<b>Integrity:</b> Extremely sturdy, at risk of damage through sustained high frequency or direct energy attacks."}
	return dat

/obj/item/implant/mirror/post_implant(var/mob/living/carbon/human/H)
	if(istype(H))
		spawn(20)
		stored_mind = SStranscore.m_backupE(H.mind, one_time = TRUE)
		icon_state = "mirror_implant"

/obj/item/implant/mirror/afterattack(var/obj/machinery/computer/transhuman/resleeving/target, mob/user)
	target.active_mr = stored_mind
	. = ..()

/obj/item/implant/mirror/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mirrorscanner))
		if(stored_mind == null)
			to_chat(usr, "No consciousness found.")
		else
			to_chat(usr, "This mirror contains a consciousness.")
	else
		if(istype(I, /obj/item/mirrortool))
			var/obj/item/mirrortool/MT = I
			if(MT.imp)
				to_chat(usr, "The mirror tool already contains a mirror.")
				return // It's full.
			user.drop_from_inventory(src)
			forceMove(MT)
			MT.imp = src


/obj/item/implant/mirror/positronic
	name = "Positronic Mirror"
	desc = "An altered form of the common mirror designed to work with positronic brains."


/obj/item/mirrorscanner
	name = "Mirror Scanner"
	desc = "A handheld scanner that will display the name of the currently stored consciousness in a mirror."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

/obj/item/mirrortool
	name = "Mirror Installation Tool"
	desc = "A tool for the installation and removal of Mirrors"
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/obj/item/implant/mirror/imp = null

/obj/item/mirrortool/attack(mob/living/carbon/human/M as mob, mob/user as mob, target_zone)
	if(target_zone == BP_TORSO && imp == null)
		for(var/obj/item/organ/I in M.organs)
			for(var/obj/item/implant/mirror/MI in I.contents)
				if(imp == null)
					M.visible_message("<span class='warning'>[user] is attempting remove [M]'s mirror!</span>")
					user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
					user.do_attack_animation(M)
					var/turf/T1 = get_turf(M)
					if (T1 && ((M == user) || do_after(user, 20)))
						if(user && M && (get_turf(M) == T1) && src)
							M.visible_message("<span class='warning'>[user] has removed [M]'s mirror.</span>")
							add_attack_logs(user,M,"Mirror removed by [user]")
							src.imp = MI
							qdel(MI)
	else if (target_zone == BP_TORSO && imp != null)
		if (imp)
			M.visible_message("<span class='warning'>[user] is attempting to implant [M] with a mirror.</span>")
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(M)
			var/turf/T1 = get_turf(M)
			if (T1 && ((M == user) || do_after(user, 20)))
				if(user && M && (get_turf(M) == T1) && src && src.imp)
					M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")
					add_attack_logs(user,M,"Implanted with [imp.name] using [name]")
					if(imp.handle_implant(M))
						imp.post_implant(M)
					src.imp = null
	else
		to_chat(usr, "You must target the torso.")

/obj/item/mirrortool/attack_self(var/mob/user)
	if(!imp)
		to_chat(usr, "No mirror is loaded.")
	else
		user.put_in_hands(imp)
		imp = null


