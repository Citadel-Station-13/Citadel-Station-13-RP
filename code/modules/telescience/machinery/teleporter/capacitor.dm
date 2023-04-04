
/obj/machinery/bluespace_capacitor
	name = "bluespace projection capacitor"
	desc = "A powerful capacitor used to power a bluespace field projector."
	#warn sprite

	/// linked projector
	var/obj/machinery/bluespace_projector/projector
	/// linked consoles
	var/list/obj/machinery/computer/teleporter/consoles
	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

#warn impl
