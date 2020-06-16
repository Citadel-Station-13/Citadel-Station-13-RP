/obj/item/clothing/accessory/collar/lifecrystal
	name = "\improper Vey-Med Life-Alert"
	desc = "A small crystal with a single light on its surface. It's supposed to notify an offsite facility if you're dead for too long."
	w_class = ITEMSIZE_SMALL
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'
	icon_state = "khlife"
	item_state = "khlife_overlay"
	overlay_state = "khlife_overlay"
	slot_flags = SLOT_TIE
	var/mob/owner = null
	var/client/owner_c = null //They'll be dead when we message them probably.
	var/state = 0 //0 - New, 1 - Dead, 2 - Signaling, 3 - Recovering (same as iconstates)

/obj/item/clothing/accessory/collar/lifecrystal/Initialize(mapload)
	. = ..()
	update_state(1)

/obj/item/clothing/accessory/collar/lifecrystal/Destroy() //Waitwaitwait
	if(state == 1)
		process() //Nownownow
	STOP_PROCESSING(SSobj, src)
	return ..() //Okfine

/obj/item/clothing/accessory/collar/lifecrystal/process()
	check_owner()
	if((state > 1) || !owner)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/lifecrystal/attack_self(mob/user as mob)
	owner = user	//We're paired to this guy
	owner_c = user.client	//This is his client
	check_owner()
	to_chat(user, "<span class='notice'>The [name] glows pleasantly blue.</span>")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/lifecrystal/proc/check_owner()
	//He's dead, jim
	if(owner && (owner.stat == DEAD))
		update_state(2)
		sleep(60)
		if(owner.stat == DEAD)
			ebroadcast("Alert! [owner.real_name] is in critical condition in [get_area(owner).name]!")
			update_state(3)


/obj/item/clothing/accessory/collar/lifecrystal/proc/ebroadcast(var/message)
	var/list/datum/radio_frequency/secure_radio_connections = new
	var/datum/radio_frequency/connection = secure_radio_connections["Medical"]
	Broadcast_Message(connection, owner,
				0, "*garbled alert*", null,
				message, "[owner.real_name]'s Life Crystal", "Life Alert", "[owner.real_name]'s Life Crystal", "shrill synthetic voice",
				0, 0, list(0), connection.frequency, "alarms", null)

/obj/item/clothing/accessory/collar/lifecrystal/proc/update_state(var/tostate)
	state = tostate
	icon_state = "[initial(icon_state)][tostate]"
	update_icon()
