#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/supplycomp
	name = T_BOARD("supply ordering console")
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = list(TECH_DATA = 2)
	var/contraband_enabled = FALSE

/obj/item/circuitboard/supplycomp/control
	name = T_BOARD("supply ordering console")
	build_path = /obj/machinery/computer/supplycomp/control
	origin_tech = list(TECH_DATA = 3)

/obj/item/circuitboard/supplycomp/after_construct(atom/A)
	. = ..()
	if(!istype(A, /obj/machinery/computer/supplycomp))
		return
	var/obj/machinery/computer/supplycomp/S = A
	S.can_order_contraband = contraband_enabled

/obj/item/circuitboard/supplycomp/after_deconstruct(atom/A)
	. = ..()
	if(!istype(A, /obj/machinery/computer/supplycomp))
		return
	var/obj/machinery/computer/supplycomp/S = A
	contraband_enabled = S.can_order_contraband

/obj/item/circuitboard/supplycomp/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/multitool))
		var/catastasis = contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		if(tgui_alert(user, "Current receiver spectrum is set to: [catastasis]", "Multitool-Circuitboard Interface", list("Switch to [opposite_catastasis]", "Cancel")) != "Cancel")
			contraband_enabled = !contraband_enabled
		return
