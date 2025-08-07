// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER

/obj/item/stack/material/cyborg/Initialize(mapload, new_amount, merge)
	. = ..()
	name = "[material.display_name] synthesizer"
	desc = "A device that synthesises [material.display_name]."

/obj/item/stack/material/cyborg/update_strings()
	return

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet-plastic"
	stack_type = /obj/item/stack/material/plastic
	material = /datum/prototype/material/plastic

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet-metal"
	stack_type = /obj/item/stack/material/steel
	material = /datum/prototype/material/steel

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-plasteel"
	stack_type = /obj/item/stack/material/plasteel
	material = /datum/prototype/material/plasteel

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	stack_type = /obj/item/stack/material/wood
	material = /datum/prototype/material/wood_plank

/obj/item/stack/material/cyborg/glass
	icon_state = "sheet-glass"
	stack_type = /obj/item/stack/material/glass
	material = /datum/prototype/material/glass

/obj/item/stack/material/cyborg/glass/reinforced
	icon_state = "sheet-rglass"
	stack_type = /obj/item/stack/material/glass/reinforced
	material = /datum/prototype/material/glass/reinforced
	charge_costs = list(500, 1000)
