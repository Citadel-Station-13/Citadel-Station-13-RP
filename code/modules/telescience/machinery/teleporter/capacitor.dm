
/obj/machinery/bluespace_capacitor
	name = "bluespace projection capacitor"
	desc = "A powerful capacitor used to power a bluespace field projector."
	#warn sprite

	/// kilojoules of energy stored
	var/stored = 0
	/// kilojoules of energy we can store
	var/capacity = 50
	/// charge rate in kw
	var/draw_rate = 0
	/// max charge rate in kw
	var/draw_max = 1000

	/// linked projector
	var/obj/machinery/bluespace_projector/projector
	/// linked consoles
	var/list/obj/machinery/computer/teleporter/consoles
	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

	#warn powernet connection datums?

/obj/machinery/bluespace_capacitor/proc/charge(kj)

/obj/machinery/bluespace_capacitor/proc/use(kj)

#warn impl all
