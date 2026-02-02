/obj/machinery/resleeving/body_printer/synth_fab
	name = "synth fabricator"
	desc = "A rapid fabricator for synthetic bodies."
	icon_state = "synthfab-map"
	base_icon_state = "synthfab"
	circuit = /obj/item/circuitboard/resleeving/synth_printer
	materials_limit = 50 * SHEET_MATERIAL_AMOUNT
	c_eject_at_health_ratio = 1
	c_synthetic_glass_cost = 12.5 * SHEET_MATERIAL_AMOUNT
	c_synthetic_metal_cost = 25 * SHEET_MATERIAL_AMOUNT

/obj/machinery/resleeving/body_printer/synth_fab/loaded/Initialize(mapload)
	. = ..()
	icon_state = base_icon_state

/obj/machinery/resleeving/body_printer/synth_fab/power_change()
	. = ..()
	if(.)
		update_icon()

/obj/machinery/resleeving/body_printer/synth_fab/update_icon(updates)
	. = ..()
	if(!(machine_stat & NOPOWER))
		add_overlay("[base_icon_state]-power")
	if(panel_open)
		add_overlay("[base_icon_state]-power")

/obj/machinery/resleeving/body_printer/synth_fab/loaded

/obj/machinery/resleeving/body_printer/synth_fab/loaded/Initialize(mapload)
	. = ..()
	materials.add(list(
		/datum/prototype/material/glass::id = materials_limit,
		/datum/prototype/material/steel::id = materials_limit,
	))

