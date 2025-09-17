/obj/spawner/gateway
	name = "Gateway map helper"
	var/obj/machinery/gateway/centeraway/gw

/obj/spawner/gateway/Spawn()
	..()
	gw = new(src.loc)
	for(var/direction in GLOB.alldirs)
		var/obj/machinery/gateway/new_gateway_part = new(get_step(src, direction))
		new_gateway_part.dir = direction
	gw.detect()
	qdel(src)
