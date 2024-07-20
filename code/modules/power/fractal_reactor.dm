// ###############################################################################
// # ITEM: FRACTAL ENERGY REACTOR                                                #
// # FUNCTION: Generate infinite electricity. Used for map testing.              #
// ###############################################################################

/obj/machinery/power/fractal_reactor
	name = "Fractal Energy Reactor"
	desc = "This thing drains power from fractal-subspace." // (DEBUG ITEM: INFINITE POWERSOURCE FOR MAP TESTING. CONTACT DEVELOPERS IF FOUND.)"
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker" //ICON stolen from solar tracker. There is no need to make new texture for debug item
	anchored = 1
	density = 1
	/// in kw
	var/power_generation_rate = 1000 //Defaults to 1MW of power.
	var/powernet_connection_failed = 0
	var/mapped_in = 0					//Do not announce creation when it's mapped in.

	// This should be only used on Dev for testing purposes.
/obj/machinery/power/fractal_reactor/Initialize(mapload, newdir)
	. = ..()
	if(!mapped_in)
		var/turf/T = get_turf(src)
		message_admins(SPAN_BOLDANNOUNCE("Map testing power source activated at: [COORD(T)]"))

/obj/machinery/power/fractal_reactor/process(delta_time)
	supply(power_generation_rate)
