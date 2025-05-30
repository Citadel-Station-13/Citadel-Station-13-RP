/obj/item/storage/hypokit
	name = "hypospray kit"
	desc = "A standard issue storage case and assorted vials for a prototype subdermal hypospray."
	icon = 'icons/items/storage/firstaid_small.dmi'
	inhand_icon = 'icons/items/storage/firstaid.dmi'
	icon_state = "normal"
	slot_flags = SLOT_BELT
	max_combined_volume = STORAGE_VOLUME_BOX
	insertion_whitelist = list(
		/obj/item/reagent_containers/glass/hypovial,
		/obj/item/hypospray,
	)

	var/hypospray_path = null
	var/vial_path = /obj/item/reagent_containers/glass/hypovial
	var/vial_amount = 0

/obj/item/storage/hypokit/legacy_spawn_contents()
	. = ..()
	if(hypospray_path)
		new hypospray_path(src)
	spawn_hypovials()

/obj/item/storage/hypokit/proc/spawn_hypovials()
	if(!vial_path)
		return
	for(var/i in 1 to vial_amount)
		new vial_path(src)

/obj/item/storage/hypokit/full
	hypospray_path = /obj/item/hypospray
	vial_amount = 13

/obj/item/storage/hypokit/full/loaded
	hypospray_path = /obj/item/hypospray/loaded

/obj/item/storage/hypokit/full/loaded/spawn_hypovials()
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

/obj/item/storage/hypokit/combat
	name = "combat hypospray kit"
	icon_state = "tactical"
	vial_path = /obj/item/reagent_containers/glass/hypovial/large
	max_combined_volume = STORAGE_VOLUME_BOX * 2
	weight_volume = WEIGHT_VOLUME_NORMAL * 1.5

/obj/item/storage/hypokit/combat/full
	hypospray_path = /obj/item/hypospray/combat
	vial_amount = 13

/obj/item/storage/hypokit/combat/full/loaded
	hypospray_path = /obj/item/hypospray/combat/loaded

/obj/item/storage/hypokit/combat/full/loaded/spawn_hypovials()
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
	vial_path = /obj/item/reagent_containers/glass/hypovial/large
	max_combined_volume = STORAGE_VOLUME_BOX * 2
	weight_volume = WEIGHT_VOLUME_NORMAL * 1.5

/obj/item/storage/hypokit/advanced/full
	hypospray_path = /obj/item/hypospray/advanced
	vial_amount = 13

/obj/item/storage/hypokit/advanced/full/loaded
	hypospray_path = /obj/item/hypospray/advanced/loaded

/obj/item/storage/hypokit/advanced/full/loaded/spawn_hypovials()
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
	hypospray_path = null
	vial_amount = 0

/obj/item/storage/hypokit/advanced/cmo/full
	hypospray_path = /obj/item/hypospray/advanced/cmo
	vial_amount = 13

/obj/item/storage/hypokit/advanced/cmo/full/loaded
	hypospray_path = /obj/item/hypospray/advanced/cmo/loaded

/obj/item/storage/hypokit/advanced/cmo/full/loaded/spawn_hypovials()
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
