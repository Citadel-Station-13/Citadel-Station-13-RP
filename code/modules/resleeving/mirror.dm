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
	var/tmp/mob/living/carbon/human/human
	item_flags = ITEM_NOBLUDGEON
//holder to prevent having to find it each time
/mob/living/carbon/human/var/obj/item/implant/mirror/mirror

/obj/item/implant/mirror/digest_act(var/atom/movable/item_storage = null)
    return FALSE

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
	spawn(20)
	if((H.client.prefs.organ_data[O_BRAIN] != null))
		to_chat(usr, "<span class='warning'>WARNING: WRONG MIRROR TYPE DETECTED, PLEASE RECTIFY IMMEDIATELY TO AVOID REAL DEATH.</span>")
		H.mirror = src
		return
	else
		stored_mind = SStranscore.m_backupE(H.mind, one_time = TRUE)
		icon_state = "mirror_implant"
		human = H
		human.mirror = src

/obj/item/implant/mirror/afterattack(var/obj/machinery/computer/transhuman/resleeving/target, mob/user)
	if (!istype(target))
		return
	target.active_mr = stored_mind

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
			if(loc == user)			// we assume they can't click someone else's hand items lmao
				if(!user.attempt_insert_item_for_installation(src, MT))
					return
			else
				forceMove(MT)
			MT.imp = src
			MT.update_icon()
		else
			if(istype(I, /obj/item/dogborg/mirrortool))
				var/obj/item/dogborg/mirrortool/MT = I
				if(MT.imp)
					to_chat(usr, "The mirror tool already contains a mirror.")
					return // It's full.
				// dogborgs can't hold mirrors
				forceMove(MT)
				MT.imp = src

/obj/item/implant/mirror/positronic
	name = "Synthetic Mirror"
	desc = "An altered form of the common mirror designed to work with synthetic brains."

/obj/item/implant/mirror/positronic/post_implant(var/mob/living/carbon/human/H)
	spawn(20)
	if((H.client.prefs.organ_data[O_BRAIN] != null))
		stored_mind = SStranscore.m_backupE(H.mind, one_time = TRUE)
		icon_state = "mirror_implant"
		H.mirror = src
	else
		to_chat(usr, "<span class='warning'>WARNING: WRONG MIRROR TYPE DETECTED, PLEASE RECTIFY IMMEDIATELY TO AVOID REAL DEATH.</span>")
		H.mirror = src

/obj/item/mirrorscanner
	name = "Mirror Scanner"
	desc = "A handheld scanner that will display the name of the currently stored consciousness in a mirror."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "sleevemate"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	item_flags = ITEM_NOBLUDGEON

/obj/item/mirrortool
	name = "Mirror Installation Tool"
	desc = "A tool for the installation and removal of Mirrors. The tool has a set of barbs for removing Mirrors from a body, and a slot for depositing it directly into a resleeving console."
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirrortool"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	item_flags = ITEM_NOBLUDGEON
	var/obj/item/implant/mirror/imp = null

/obj/item/mirrortool/afterattack(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return
	if(user.zone_sel.selecting == BP_TORSO && imp == null)
		if(imp == null && H.mirror)
			H.visible_message("<span class='warning'>[user] is attempting remove [H]'s mirror!</span>")
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(H)
			var/turf/T1 = get_turf(H)
			if (T1 && ((H == user) || do_after(user, 20)))
				if(user && H && (get_turf(H) == T1) && src)
					H.visible_message("<span class='warning'>[user] has removed [H]'s mirror.</span>")
					add_attack_logs(user,H,"Mirror removed by [user]")
					src.imp = H.mirror
					H.mirror = null
					update_icon()
		else
			to_chat(usr, "This person has no mirror installed.")

	else if (user.zone_sel.selecting == BP_TORSO && imp != null)
		if (imp)
			if(!H.client)
				to_chat(usr, "Manual mirror transplant into mindless body not supported, please use the resleeving console.")
				return
			if(H.mirror)
				to_chat(usr, "This person already has a mirror!")
				return
			if(!H.mirror)
				H.visible_message("<span class='warning'>[user] is attempting to implant [H] with a mirror.</span>")
				user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
				user.do_attack_animation(H)
				var/turf/T1 = get_turf(H)
				if (T1 && ((H == user) || do_after(user, 20)))
					if(user && H && (get_turf(H) == T1) && src && src.imp)
						H.visible_message("<span class='warning'>[H] has been implanted by [user].</span>")
						add_attack_logs(user,H,"Implanted with [imp.name] using [name]")
						if(imp.handle_implant(H))
							imp.post_implant(H)
						src.imp = null
						update_icon()
	else
		to_chat(usr, "You must target the torso.")
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/mirrortool/attack_self(var/mob/user)
	if(!imp)
		to_chat(usr, "No mirror is loaded.")
	else
		user.put_in_hands_or_drop(imp)
		imp = null
		update_icon()

/obj/item/mirrortool/attack_hand(mob/user as mob)
	if(user.get_inactive_held_item() == src)
		user.put_in_hands_or_drop(imp)
		imp = null
		update_icon()
	. = ..()

/obj/item/mirrortool/update_icon() //uwu
	..()
	if(imp == null)
		icon_state = "mirrortool"
	else
		icon_state = "mirrortool_loaded"

/obj/item/mirrortool/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/implant/mirror))
		if(imp)
			to_chat(usr, "This mirror tool already contains a mirror.")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		imp = I
		user.visible_message("[user] inserts the [I] into the [src].", "You insert the [I] into the [src].")
	update_icon()
	update_held_icon()
	return
