/obj/item/storage/hypokit
	name = "hypospray kit"
	desc = "A standard issue storage case and assorted vials for a prototype subdermal hypospray."
	icon = 'icons/items/storage/firstaid_small.dmi'
	inhand_icon = 'icons/items/storage/firstaid.dmi'
	icon_state = "normal"
	slot_flags = SLOT_BELT
	max_storage_space = INVENTORY_BOX_SPACE
	can_hold = list(
		/obj/item/reagent_containers/glass/hypovial,
		/obj/item/hypospray,
	)

	var/hypospray_path = /obj/item/hypospray
	var/vial_path = /obj/item/reagent_containers/glass/hypovial
	var/vial_amount = 6

/obj/item/storage/hypokit/PopulateContents()
	. = ..()
	new hypospray_path(src)
	spawn_hypovials()

/obj/item/storage/hypokit/proc/spawn_hypovials()
	for(var/i in 1 to vial_amount)
		new vial_path(src)

/obj/item/storage/hypokit/combat
	name = "combat hypospray kit"
	icon_state = "tactical"
	hypospray_path = /obj/item/hypospray/combat/loaded
	vial_path = /obj/item/reagent_containers/glass/hypovial/large
	max_storage_space = INVENTORY_BOX_SPACE * 2
	storage_cost = ITEMSIZE_COST_NORMAL * 1.5

/obj/item/storage/hypokit/combat/loaded/spawn_hypovials()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/bicaridine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dylovene(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/kelotane(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dexalin_plus(src)
	new /obj/item/reagent_containers/glass/hypovial/large/inaprovaline(src)
	new /obj/item/reagent_containers/glass/hypovial/large/peridaxon(src)
	new /obj/item/reagent_containers/glass/hypovial/large/tramadol(src)
	new /obj/item/reagent_containers/glass/hypovial/large/arithrazine(src)
	new /obj/item/reagent_containers/glass/hypovial/large/spaceacillin(src)

/obj/item/storage/hypokit/advanced
	name = "advanced hypospray kit"
	icon = 'icons/items/storage/firstaid.dmi'
	icon_state = "briefcase"
	inhand_state = "normal"
	hypospray_path = /obj/item/hypospray/advanced/loaded
	vial_path = /obj/item/reagent_containers/glass/hypovial/large
	max_storage_space = INVENTORY_BOX_SPACE * 2
	storage_cost = ITEMSIZE_COST_NORMAL * 1.5

/obj/item/storage/hypokit/advanced/loaded/spawn_hypovials()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/bicaridine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dylovene(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/kelotane(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dexalin_plus(src)
	new /obj/item/reagent_containers/glass/hypovial/large/inaprovaline(src)
	new /obj/item/reagent_containers/glass/hypovial/large/peridaxon(src)
	new /obj/item/reagent_containers/glass/hypovial/large/tramadol(src)
	new /obj/item/reagent_containers/glass/hypovial/large/arithrazine(src)
	new /obj/item/reagent_containers/glass/hypovial/large/spaceacillin(src)

/obj/item/storage/hypokit/advanced/cmo
	hypospray_path = /obj/item/hypospray/advanced/cmo/loaded

/obj/item/storage/hypokit/advanced/cmo/loaded/spawn_hypovials()
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/bicaridine(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/dylovene(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/glass/hypovial/large/kelotane(src)
	new /obj/item/reagent_containers/glass/hypovial/large/dexalin_plus(src)
	new /obj/item/reagent_containers/glass/hypovial/large/inaprovaline(src)
	new /obj/item/reagent_containers/glass/hypovial/large/peridaxon(src)
	new /obj/item/reagent_containers/glass/hypovial/large/tramadol(src)
	new /obj/item/reagent_containers/glass/hypovial/large/arithrazine(src)
	new /obj/item/reagent_containers/glass/hypovial/large/spaceacillin(src)

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
