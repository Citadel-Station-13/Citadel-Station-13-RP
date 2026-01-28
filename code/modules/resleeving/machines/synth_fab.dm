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

#warn synthfab-power
#warn synthfab-panel

/obj/machinery/resleeving/body_printer/synth_fab/loaded/Initialize(mapload)
	. = ..()
	#warn impl
