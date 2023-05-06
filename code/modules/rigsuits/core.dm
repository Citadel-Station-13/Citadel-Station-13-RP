/**
 * RIG cores serve as a capacitor unit.
 *
 * This balances high power draw modules by making them not only depend on cell capacities and nothing else.
 */
/obj/item/rig_core
	name = "rig core"
	desc = "An expensive, high-throughput energy transfer unit at the core of most modern RIGs."

	/// high power buffer in kj
	var/high_buffer = 2000
	/// low power buffer in kj
	var/low_buffer = 250
	/// high power buffer - stored
	var/high_stored = 0
	/// low power buffer - stored
	var/low_stored = 0
