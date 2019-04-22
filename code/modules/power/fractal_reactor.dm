// ###############################################################################
// # ITEM: FRACTAL ENERGY REACTOR                                                #
// # FUNCTION: Generate infinite electricity. Used for map testing.              #
// ###############################################################################

/obj/machinery/power/fractal_reactor
	name = "Fractal Energy Reactor"
	desc = "This thing drains power from fractal-subspace." // (DEBUG ITEM: INFINITE POWERSOURCE FOR MAP TESTING. CONTACT DEVELOPERS IF FOUND.)"
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker" //ICON stolen from solar tracker. There is no need to make new texture for debug item
	anchored = TRUE
	density = TRUE
	var/power_generation_rate = 1000000 //Defaults to 1MW of power.
	var/powernet_connection_failed = 0
	var/mapped_in = FALSE					//Do not announce creation when it's mapped in.

	// This should be only used on Dev for testing purposes.
/obj/machinery/power/fractal_reactor/Initialize()
	. = ..()
	if(!mapped_in)
		message_admins("<b><font color='red'>WARNING:</font><font color='black'> Map testing power source activated at: X:[src.loc.x] Y:[src.loc.y] Z:[src.loc.z]</font></b>")

/obj/machinery/power/fractal_reactor/adminspawn
	mapped_in = TRUE

/obj/machinery/power/fractal_reactor/process()
	if(!powernet && (world.time - powernet_connection_failed > 150))		//try every 15 seconds.
		if(!connect_to_network())
			powernet_connection_failed = world.time
	add_avail(power_generation_rate)