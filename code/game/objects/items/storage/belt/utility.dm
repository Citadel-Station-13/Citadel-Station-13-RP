
/obj/item/storage/belt/utility
	name = "tool-belt" //Carn: utility belt is nicer, but it bamboozles the text parsing.
	desc = "Can hold various tools."
	icon_state = "utility"
	item_state = "utility"
	#warn this
	insertion_whitelist = list(
		/obj/item/cell/device,
		/obj/item/material/knife/machete/hatchet,
	)

/obj/item/storage/belt/utility/full
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
		/obj/item/stack/cable_coil/random_belt
	)

/obj/item/storage/belt/utility/atmostech
	starts_with = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/weldingtool,
		/obj/item/tool/crowbar,
		/obj/item/tool/wirecutters,
	)

/obj/item/storage/belt/utility/chief
	name = "chief engineer's toolbelt"
	desc = "Holds tools, looks snazzy."
	icon_state = "utilitybelt_ce"
	item_state = "utility_ce"

/obj/item/storage/belt/utility/chief/full
	starts_with = list(
		/obj/item/tool/screwdriver/power,
		/obj/item/tool/crowbar/power,
		/obj/item/weldingtool/experimental,
		/obj/item/multitool,
		/obj/item/stack/cable_coil/random_belt,
		/obj/item/extinguisher/mini,
		/obj/item/atmos_analyzer/longrange
	)

/obj/item/storage/belt/utility/alien
	name = "alien belt"
	desc = "A belt(?) that can hold things."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "belt"
	item_state = "security"

/obj/item/storage/belt/utility/alien/full
	starts_with = list(
		/obj/item/tool/screwdriver/alien,
		/obj/item/tool/wrench/alien,
		/obj/item/weldingtool/alien,
		/obj/item/tool/crowbar/alien,
		/obj/item/tool/wirecutters/alien,
		/obj/item/multitool/alien,
		/obj/item/stack/cable_coil/alien
	)

/obj/item/storage/belt/utility/crystal
	name = "crystalline tool harness"
	desc = "A segmented belt of strange crystalline material."
	icon_state = "utilitybelt_crystal"
	item_state = "utilitybelt_crystal"

/obj/item/storage/belt/utility/crystal/Initialize()
	new /obj/item/multitool/crystal(src)
	new /obj/item/tool/wrench/crystal(src)
	new /obj/item/tool/crowbar/crystal(src)
	new /obj/item/tool/screwdriver/crystal(src)
	new /obj/item/tool/wirecutters/crystal(src)
	new /obj/item/weldingtool/electric/crystal(src)
	update_icon()
	. = ..()
