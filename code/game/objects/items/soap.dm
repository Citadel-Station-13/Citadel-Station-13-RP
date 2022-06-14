/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	flags = NOCONDUCT
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HOLSTER
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/soap/nanotrasen
	desc = "A NanoTrasen-brand bar of soap. Smells of phoron."
	icon_state = "soapnt"

/obj/item/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/soap/deluxe/Initialize(mapload)
	. = ..()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"
