//////////////////////////////////////////////////////////////
////////////////////////Mirror Implants//////////////////////
////////////////////////////////////////////////////////////

/obj/item/implant/mirror
	name = "Mirror"
	desc = "A small implanted disk that stores a copy of ones conciousness, updated at times of rest."
	catalogue_data = /datum/category_item/catalogue/technology/resleeving
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "backup_implant"
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
		stored_mind = SStranscore.m_backupE(H.mind, one_time = TRUE)

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
			var/obj/item/mirrortool/implanter = I
			if(implanter.imp)
				return // It's full.
			user.drop_from_inventory(src)
			forceMove(implanter)
			implanter.imp = src


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

/obj/item/mirrortool/attack(mob/living/carbon/human/M, mob/living/user, target_zone)
	if(target_zone == BP_TORSO)
		for(var/obj/item/organ/I in M.organs)
			for(var/obj/item/implant/mirror/MI in I.contents)
				imp = MI
	else
		to_chat(usr, "You must target the torso.")

/obj/item/mirrortool/attack_self(var/mob/user)
	if(!imp)
		to_chat(usr, "No mirror is loaded.")
	else
		user.put_in_hands(imp)


