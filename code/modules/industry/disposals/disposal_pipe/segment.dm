// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/Initialize(mapload, dir)
	. = ..()
	if(icon_state == "pipe-s")
		dpdir = src.dir | turn(src.dir, 180)
	else
		dpdir = src.dir | turn(src.dir, -90)
