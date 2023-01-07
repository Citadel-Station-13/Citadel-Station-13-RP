////////////////////////////////
//// Resleeving implant
//// for both organic and synthetic crew
////////////////////////////////

//The backup implant itself
/obj/item/implant/backup
	name = "backup implant"
	desc = "A mindstate backup implant that occasionally stores a copy of one's mind on a central server for backup purposes."
	catalogue_data = list(///datum/category_item/catalogue/information/organization/vey_med,
						/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "backup_implant"

/obj/item/implant/backup/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [GLOB.using_map.company_name] Employee Backup Implant<BR>
<b>Life:</b> ~8 hours.<BR>
<b>Important Notes:</b> Implant is life-limited. Dissolves into harmless biomaterial after around ~8 hours, the typical work shift.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a microchip that scans the brain to create identical backups.<BR>
<b>Special Features:</b> Allows the restoration of employees within an eight hour period.<BR>
<b>Integrity:</b> Sturdy, weak against acidic compounds."}
	return dat

/obj/item/implant/backup/Destroy()
	SStranscore.implants -= src
	return ..()

/obj/item/implant/backup/post_implant(var/mob/living/carbon/human/H)
	if(istype(H))
		SStranscore.implants |= src
		return 1

//New, modern implanter instead of old style implanter.
/obj/item/backup_implanter
	name = "backup implanter"
	desc = "After discovering that Nanotrasen was just re-using the same implanters over and over again on organics, leading to cross-contamination, Vey-Med designed this self-cleaning model. Holds four backup implants at a time."
	catalogue_data = list(///datum/category_item/catalogue/information/organization/vey_med,
						/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "bimplant"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	var/list/obj/item/implant/backup/imps = list()
	var/max_implants = 4 //Iconstates need to exist due to the update proc!

/obj/item/backup_implanter/Initialize(mapload)
	. = ..()
	for(var/i = 1 to max_implants)
		var/obj/item/implant/backup/imp = new(src)
		imps |= imp
		imp.germ_level = 0
	update()

/obj/item/backup_implanter/proc/update()
	icon_state = "[initial(icon_state)][imps.len]"
	germ_level = 0

/obj/item/backup_implanter/attack_self(mob/user as mob)
	if(!istype(user))
		return

	if(imps.len)
		to_chat(user, "<span class='notice'>You eject a backup implant.</span>")
		var/obj/item/implant/backup/imp = imps[imps.len]
		imp.forceMove(get_turf(user))
		imps -= imp
		user.put_in_hands(imp)
		update()
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")

	return

/obj/item/backup_implanter/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/implant/backup))
		if(imps.len < max_implants)
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			imps |= W
			W.germ_level = 0
			update()
			to_chat(user, "<span class='notice'>You load \the [W] into \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] is already full!</span>")

/obj/item/backup_implanter/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if (!istype(target, /mob/living/carbon))
		return
	if (user && imps.len)
		target.visible_message("<span class='notice'>[user] is injecting a backup implant into [target].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(target)

		var/turf/T1 = get_turf(target)
		if (T1 && ((target == user) || do_after(user, 5 SECONDS, target)))
			if(user && target && (get_turf(target) == T1) && src && src.imps.len)
				target.visible_message("<span class='notice'>[target] has been backup implanted by [user].</span>")

				var/obj/item/implant/backup/imp = imps[imps.len]
				if(imp.handle_implant(target,user.zone_sel.selecting))
					imp.post_implant(target)
					imps -= imp
					add_attack_logs(user,target,"Implanted backup implant")

				update()

//The glass case for the implant
/obj/item/implantcase/backup
	name = "glass case - 'backup'"
	desc = "A case containing a backup implant."
	icon_state = "implantcase-b"

/obj/item/implantcase/backup/Initialize(mapload)
	src.imp = new /obj/item/implant/backup(src)
	return ..()

//The box of backup implants
/obj/item/storage/box/backup_kit
	name = "backup implant kit"
	desc = "Box of stuff used to implant backup implants."
	icon_state = "implant"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syringe_kit", SLOT_ID_LEFT_HAND = "syringe_kit")

/obj/item/storage/box/backup_kit/PopulateContents()
	for(var/i = 1 to 7)
		new /obj/item/implantcase/backup(src)
	new /obj/item/implanter(src)

/* CITADEL CHANGE - Removes this useless shit
//Purely for fluff
/obj/item/implant/backup/full
	name = "vey-med backup implant"
	desc = "A normal Vey-Med wireless cortical stack with neutrino and QE transmission for constant-stream consciousness upload."
END OF CITADEL CHANGE */
