/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = ITEMSIZE_SMALL
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT
	var/rating = 1

/obj/item/stock_parts/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

/obj/item/stock_parts/get_rating()
	return rating
