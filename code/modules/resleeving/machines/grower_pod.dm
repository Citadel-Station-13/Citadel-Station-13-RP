
/obj/machinery/resleeving/body_printer/grower_pod
	name = "grower pod"
	circuit = /obj/item/circuitboard/transhuman_clonepod

/obj/machinery/resleeving/body_printer/grower_pod/loaded/Initialize(mapload)
	. = ..()
	for(var/i in 1 to bottles_limit)
		bottles += new /obj/item/reagent_containers/glass/bottle/biomass(src)

#warn impl all
