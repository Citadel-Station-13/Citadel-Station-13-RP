/obj/random/lore_book
	name = "random lore book"
	desc = "This is a random book"
	icon = 'icons/obj/library.dmi'
	icon_state = "book"

/obj/random/lore_book/item_to_spawn()
	return pick(/obj/item/book/lore/xenomorph_castes)
