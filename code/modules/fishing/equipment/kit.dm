/obj/item/storage/toolbox/fishing
	name = "fishing toolbox"
	desc = "Contains everything you need for your fishing trip."
	icon_state = "fishing"
	inhand_icon_state = "artistic_toolbox"
	material_flags = NONE

/obj/item/storage/toolbox/fishing/Initialize(mapload)
	. = ..()
	// Can hold fishing rod despite the size
	var/static/list/exception_cache = typecacheof(/obj/item/fishing_rod)
	atom_storage.exception_hold = exception_cache

/obj/item/storage/toolbox/fishing/PopulateContents()
	new /obj/item/bait_can/worm(src)
	new /obj/item/fishing_rod(src)
	new /obj/item/fishing_hook(src)
	new /obj/item/fishing_line(src)

/obj/item/storage/box/fishing_hooks
	name = "fishing hook set"

/obj/item/storage/box/fishing_hooks/PopulateContents()
	. = ..()
	new /obj/item/fishing_hook/magnet(src)
	new /obj/item/fishing_hook/shiny(src)
	new /obj/item/fishing_hook/weighted(src)

/obj/item/storage/box/fishing_lines
	name = "fishing line set"

/obj/item/storage/box/fishing_lines/PopulateContents()
	. = ..()
	new /obj/item/fishing_line/bouncy(src)
	new /obj/item/fishing_line/reinforced(src)
	new /obj/item/fishing_line/cloaked(src)
