/**
 * controller
 *
 * things coordinate via this
 *
 * machinery, controllers, and remotes should be bound to this
 */
/obj/machinery/bluespace_controller
	name = "teleporter mainframe"
	desc = "A powerful mainframe controlling teleporters. This thing performs the necessary numbers-crunching to shunt things through bluespace tunnels, as well as coordinate all the machinery required to do so."
	#warn sprite

	/// linked pad
	/// only one pad allowed
	var/obj/machinery/bluespace_pad/pad
	/// linked capacitors
	/// capacitor linking is optional
	var/list/obj/machinery/bluespace_capacitor/capacitors
	/// linked projectors
	var/list/obj/machinery/bluespace_projector/projectors
	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

