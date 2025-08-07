// a broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	dpdir = 0		// broken pipes have dpdir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

// called when welded
// for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
//	var/obj/item/scrap/S = new(src.loc)
//	S.set_components(200,0,0)
	qdel(src)
