
#warn below

/obj/machinery/resleeving/body_printer/synth_fab
	name = "SynthFab 3000"
	desc = "A rapid fabricator for synthetic bodies.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	icon = 'icons/obj/machines/synthpod.dmi'
	icon_state = "pod_0"
	circuit = /obj/item/circuitboard/resleeving/synth_printer

/obj/machinery/resleeving/body_printer/synth_fab/update_icon()
	..()
	icon_state = "pod_0"
	if(busy && !(machine_stat & NOPOWER))
		icon_state = "pod_1"
	else if(broken)
		icon_state = "pod_g"
