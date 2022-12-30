/obj/item/clothing/gloves/boxing
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "red", SLOT_ID_LEFT_HAND = "red")

/*
/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(W.is_wirecutter() || istype(W, /obj/item/surgical/scalpel))
		to_chat(user, "<span class='notice'>That won't work.</span>")	//Nope
		return
	..()
*/

/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "green", SLOT_ID_LEFT_HAND = "green")

/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blue", SLOT_ID_LEFT_HAND = "blue")

/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "yellow", SLOT_ID_LEFT_HAND = "yellow")

/obj/item/clothing/gloves/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "latex"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "white", SLOT_ID_LEFT_HAND = "white")
