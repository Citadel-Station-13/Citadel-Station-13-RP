#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/security
	name = T_BOARD("security camera monitor")
	build_path = /obj/machinery/computer/security
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	var/list/network
	var/locked = TRUE
	var/emagged = 0

/obj/item/circuitboard/security/Initialize(mapload)
	. = ..()
	network = GLOB.using_map.station_networks

/obj/item/circuitboard/security/tv
	name = T_BOARD("security camera monitor - television")
	build_path = /obj/machinery/computer/security/wooden_tv

/obj/item/circuitboard/security/engineering
	name = T_BOARD("engineering camera monitor")
	build_path = /obj/machinery/computer/security/engineering
	req_access = list()

/obj/item/circuitboard/security/engineering/Initialize(mapload)
	. = ..()
	network = engineering_networks

/obj/item/circuitboard/security/mining
	name = T_BOARD("mining camera monitor")
	build_path = /obj/machinery/computer/security/mining
	network = list("Mining Outpost")
	req_access = list()

/obj/item/circuitboard/security/telescreen/entertainment
	name = T_BOARD("entertainment camera monitor")
	build_path = /obj/machinery/computer/security/telescreen/entertainment
	board_type = new /datum/frame/frame_types/display
	matter = list(MAT_STEEL = 50, MAT_GLASS = 50)

/obj/item/circuitboard/security/telescreen/entertainment/Initialize(mapload)
	. = ..()
	network = NETWORK_THUNDER

/obj/item/circuitboard/security/after_construct(atom/A)
	. = ..()
	if(!istype(A, /obj/machinery/computer/security))
		return
	var/obj/machinery/computer/security/S = A
	S.set_network(network.Copy())

/obj/item/circuitboard/security/after_deconstruct(atom/A)
	. = ..()
	if(!istype(A, /obj/machinery/computer/security))
		return
	var/obj/machinery/computer/security/S = A
	network = S.network.Copy()

/obj/item/circuitboard/security/emag_act(remaining_charges, mob/user)
	if(emagged)
		to_chat(user, "Circuit lock is already removed.")
		return
	to_chat(user, SPAN_NOTICE("You override the circuit lock and open controls."))
	emagged = 1
	locked = FALSE
	return 1

/obj/item/circuitboard/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/card/id))
		if(emagged)
			to_chat(user, SPAN_WARNING("Circuit lock does not respond."))
			return
		if(check_access(I))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "" : "un"]lock the circuit controls."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	else if(istype(I,/obj/item/multitool))
		if(locked)
			to_chat(user, SPAN_WARNING("Circuit controls are locked."))
			return
		var/existing_networks = jointext(network,",")
		var/input = sanitize(input(usr, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			to_chat(usr, "No input found please hang up and try your call again.")
			return
		var/list/tempnetwork = splittext(input, ",")
		tempnetwork = difflist(tempnetwork,restricted_camera_networks,1)
		if(tempnetwork.len < 1)
			to_chat(usr, "No network found please hang up and try your call again.")
			return
		network = tempnetwork
	return
