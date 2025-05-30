//a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"
	var/obj/linked 	// the linked obj/machinery/disposal or obj/disposaloutlet

/obj/structure/disposalpipe/trunk/Initialize(mapload)
	. = ..()
	dpdir = dir
	return INITIALIZE_HINT_LATELOAD

/obj/structure/disposalpipe/trunk/LateInitialize()
	getlinked()

/obj/structure/disposalpipe/trunk/proc/getlinked()
	linked = null
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D)
		linked = D
		if (!D.trunk)
			D.trunk = src

	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O)
		linked = O
	return

	// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(obj/item/I, mob/user)

	//Disposal bins or chutes
	/*
	These shouldn't be required
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D && D.anchored)
		return

	//Disposal outlet
	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O && O.anchored)
		return
	*/

	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in src.loc
	if(C && C.anchored)
		return

	var/turf/T = src.loc
	if(!T.is_plating())
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user, 0, I)
	if(istype(I, /obj/item/weldingtool))
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0,user))
			playsound(src, W.tool_sound, 100, 1)
			// check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			to_chat(user, "Slicing the disposal pipe.")
			sleep(30)
			if(!W.isOn()) return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			to_chat(user, "You need more welding fuel to cut the pipe.")
			return

	// would transfer to next pipe segment, but we are in a trunk
	// if not entering from disposal bin,
	// transfer to linked object (outlet or bin)

/obj/structure/disposalpipe/trunk/transfer(var/obj/structure/disposalholder/H)

	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc
	// otherwise, go to the linked object
	if(linked)
		var/obj/structure/disposaloutlet/O = linked
		if(istype(O) && (H))
			O.expel(H)	// expel at outlet
		else
			var/obj/machinery/disposal/D = linked
			if(H)
				D.expel(H)	// expel at disposal
	else
		if(H)
			src.expel(H, src.loc, 0)	// expel at turf
	return null

	// nextdir

/obj/structure/disposalpipe/trunk/nextdir(var/fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0
