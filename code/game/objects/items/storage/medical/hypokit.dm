/obj/item/storage/hypokit
	name = "hypospray kit"
	desc = "A standard issue storage case and assorted vials for a prototype subdermal hypospray."
	icon = 'icons/items/storage/firstaid_small.dmi'
	inhand_icon = 'icons/items/storage/firstaid.dmi'
	icon_state = "normal"

	var/hypospray_path = /obj/item/hypospray

/obj/item/storage/hypokit/PopulateContents()
	. = ..()
	new hypospray_path(src)
	for(var/i in 1 to 12)
		new /obj/item/reagent_containers/glass/hypovial(src)

/obj/item/storage/hypokit/combat
	name = "combat hypospray kit"
	icon_state = "tactical"
	hypospray_path = /obj/item/hypospray/combat

/obj/item/storage/hypokit/advanced
	name = "advanced hypospray kit"
	icon_state = "briefcase"
	inhand_state = "normal"
	hypospray_path = /obj/item/hypospray/advanced
