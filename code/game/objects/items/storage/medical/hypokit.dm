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
	spawn_hypovials()

/obj/item/storage/hypokit/proc/spawn_hypovials()
	for(var/i in 1 to 12)
		new /obj/item/reagent_containers/glass/hypovial(src)

/obj/item/storage/hypokit/combat
	name = "combat hypospray kit"
	icon_state = "tactical"
	hypospray_path = /obj/item/hypospray/combat

/obj/item/storage/hypokit/combat/loaded/spawn_hypovials()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/bicaridine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dylovene(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/kelotane(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dexalin(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/inaprovaline(src)
	new /obj/item/reagent_containers/glass/hypovial/large/peridaxon(src)
	new /obj/item/reagent_containers/glass/hypovial/large/tramadol(src)

/obj/item/storage/hypokit/advanced
	name = "advanced hypospray kit"
	icon_state = "briefcase"
	inhand_state = "normal"
	hypospray_path = /obj/item/hypospray/advanced

/obj/item/storage/hypokit/advanced/loaded/spawn_hypovials()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/bicaridine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dylovene(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/kelotane(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dexalin(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/tricordrazine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/inaprovaline(src)

/obj/item/storage/hypokit/loaded

/obj/item/storage/hypokit/loaded/spawn_hypovials()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/bicaridine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/dylovene(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/kelotane(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/dexalin(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/tricordrazine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/inaprovaline(src)
