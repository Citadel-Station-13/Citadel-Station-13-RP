// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER

/obj/item/stack/material/cyborg/Initialize(mapload, new_amount, merge)
	. = ..()
	name = "[material.display_name] synthesiser"
	desc = "A device that synthesises [material.display_name]."

/obj/item/stack/material/cyborg/update_strings()
	return

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet-plastic"
	material = /datum/material/plastic

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet-metal"
	material = /datum/material/steel

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-plasteel"
	material = /datum/material/plasteel

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	material = /datum/material/wood

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet-glass"
	material = /datum/material/glass

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-rglass"
	material = /datum/material/glass/reinforced
	charge_costs = list(500, 1000)
