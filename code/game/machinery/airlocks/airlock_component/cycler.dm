//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_component/cycler
	name = "airlock cycler"
	desc = "A set of machinery used for manipulating the atmosphere inside of an airlock. Doubles as a gas sensor."
	#warn sprite

	/// max pumping power in kw
	var/pumping_power = 50

/obj/machinery/airlock_component/cycler/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.cycler)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.cycler = src

/obj/machinery/airlock_component/cycler/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.cycler == src)
		network.cycler = null
		network.queue_recheck()

/obj/machinery/airlock_component/cycler/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
