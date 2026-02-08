/obj/machinery/resleeving/body_printer/grower_pod
	name = "grower pod"
	desc = "A state-of-the-art pod capable of growing a humanoid body from biomass suitable for \
	the reimplantation of a mirrored mind. \
	This is not existentially dreadful at all, or anything."
	circuit = /obj/item/circuitboard/resleeving/grower_pod
	bottles_limit = 3
	c_biological_biomass_cost = 30

/obj/machinery/resleeving/body_printer/grower_pod/loaded/Initialize(mapload)
	. = ..()
	LAZYINITLIST(bottles)
	for(var/i in 1 to bottles_limit)
		bottles += new /obj/item/reagent_containers/glass/bottle/biomass(src)
