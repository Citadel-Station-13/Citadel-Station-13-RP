/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	closet_appearance = /singleton/closet_appearance/secure_closet
	req_access = list(ACCESS_COMMAND_LOCKERS)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/PopulateContents()
	new /obj/item/radio/headset(src)
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel/norm(src)
	new /obj/item/instrument/piano_synth(src)

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/medigown(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/white(src)


/obj/structure/closet/secure_closet/personal/cabinet
	closet_appearance = /singleton/closet_appearance/cabinet/secure

	starts_with = list(
		/obj/item/storage/backpack/satchel/withwallet,
		/obj/item/radio/headset
		)

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W as obj, mob/user as mob)
	if (opened)
		if (istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			MouseDroppedOn(G.affecting, user)      //act like they were dragged onto the closet
		user.transfer_item_to_loc(W, loc)
	else if(W.GetID())
		var/obj/item/card/id/I = W.GetID()

		if(broken)
			to_chat(user, "<span class='warning'>It appears to be broken.</span>")
			return
		if(!I || !I.registered_name)	return
		if(allowed(user) || !registered_name || (istype(I) && (registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			locked = !locked

			if(!registered_name)
				registered_name = I.registered_name
				desc = "Owned by [I.registered_name]."
			update_icon()
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
	else if(istype(W, /obj/item/melee/energy/blade))
		if(emag_act(INFINITY, user, "The locker has been sliced open by [user] with \an [W]!", "You hear metal being sliced and sparks flying."))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, loc)
			spark_system.start()
			playsound(loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(loc, "sparks", 50, 1)
	else
		to_chat(user, "<span class='warning'>Access Denied</span>")
	return

/obj/structure/closet/secure_closet/personal/emag_act(var/remaining_charges, var/mob/user, var/visual_feedback, var/audible_feedback)
	if(!broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		if(visual_feedback)
			visible_message("<span class='warning'>[visual_feedback]</span>", "<span class='warning'>[audible_feedback]</span>")
		update_icon()
		return 1

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE)) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		add_fingerprint(usr)
		if (locked || !registered_name)
			to_chat(usr, "<span class='warning'>You need to unlock it first.</span>")
		else if (broken)
			to_chat(usr, "<span class='warning'>It appears to be broken.</span>")
		else
			if (opened)
				if(!close())
					return
			locked = 1
			registered_name = null
			desc = "It's a secure locker for personnel. The first card swiped gains control."
			update_icon()
	return
