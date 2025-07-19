/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulphuric acid).
*/

/obj/machinery/lathe/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon = 'icons/obj/machines/fabricators/imprinter.dmi'
	icon_state = "imprinter"
	base_icon_state = "imprinter"
	atom_flags = OPENCONTAINER
	circuit = /obj/item/circuitboard/circuit_imprinter
	has_interface = TRUE
	lathe_type = LATHE_TYPE_CIRCUIT


/obj/machinery/lathe/r_n_d/circuit_imprinter/update_icon_state()
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else
		icon_state = base_icon_state

/obj/machinery/lathe/r_n_d/circuit_imprinter/update_overlays()
	. = ..()
	cut_overlays()
	if(panel_open)
		add_overlay("[base_icon_state]-panel")
