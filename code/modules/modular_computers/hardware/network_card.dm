/obj/item/computer_hardware/network_card
	name = "network card"
	desc = "A basic wireless network card for usage with standard NTNet frequencies."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	icon_state = "netcard_basic"

	var/hardware_id = null // Identification ID. Technically MAC address of this device. Can't be changed by user.
	var/identification_string = "" // Identification string, technically nickname seen in the network. Can be set by user.
	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores NTNet wireless checks.
	malfunction_probability = 1
	device_type = MC_NET
	var/static/ntnet_card_uid = 1

/obj/item/computer_hardware/network_card/diagnostics(mob/user)
	..()
	to_chat(user, "NIX Unique ID: [hardware_id]")
	to_chat(user, "NIX User Tag: [identification_string]")
	to_chat(user, "Supported protocols:")
	to_chat(user, "511.m SFS (Subspace) - Standard Frequency Spread")
	if(long_range)
		to_chat(user, "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth")
	if(ethernet)
		to_chat(user, "OpenEth (Physical Connection) - Physical network connection port")

/obj/item/computer_hardware/network_card/New(l)
	..()
	hardware_id = ntnet_card_uid++

// Returns a string identifier of this network card
/obj/item/computer_hardware/network_card/proc/get_network_tag()
	return "[identification_string] (NID [hardware_id])"

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/computer_hardware/network_card/proc/get_signal(specific_action = 0)
	if(!holder) // Hardware is not installed in anything. No signal. How did this even get called?
		return 0

	if(!check_functionality())
		return 0

	if(ethernet) // Computer is connected via wired connection.
		return 3

	// if(!SSnetworks.station_network || !SSnetworks.station_network.check_function(specific_action)) // NTNet is down and we are not connected via wired connection. No signal.
	// 	return 0

	if(!ntnet_global || !ntnet_global.check_function(specific_action) || is_banned()) // NTNet is down and we are not connected via wired connection. No signal.
		return 0

	if(holder)
		var/turf/T = get_turf(holder)
		if(!istype(T)) //no reception in nullspace
			return 0
		if(T.z in (LEGACY_MAP_DATUM).station_levels)
			// Computer is on station. Low/High signal depending on what type of network card you have
			if(long_range)
				return 2
			else
				return 1
		if(T.z in (LEGACY_MAP_DATUM).contact_levels) //not on station, but close enough for radio signal to travel
			if(long_range) // Computer is not on station, but it has upgraded network card. Low signal.
				return 1

	if(long_range) // Computer is not on station, but it has upgraded network card. Low signal.
		return 1

	return FALSE // Computer is not on station and does not have upgraded network card. No signal.
/obj/item/computer_hardware/network_card/proc/is_banned()
	return ntnet_global.check_banned(hardware_id)

/obj/item/computer_hardware/network_card/advanced
	name = "advanced NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	w_class = WEIGHT_CLASS_TINY

/obj/item/computer_hardware/network_card/quantum
	name = "quantum NTNet network card"
	desc = "A network card that can connect to NTnet from anywhere, using quantum entanglement."
	long_range = 1
	origin_tech = list(TECH_DATA = 6, TECH_ENGINEERING = 7)
	power_usage = 200 // Infinite range but higher power usage.
	icon_state = "netcard_advanced"
	w_class = WEIGHT_CLASS_TINY

/obj/item/computer_hardware/network_card/quantum/get_signal(specific_action = 0)
	if(!holder)
		return 0
	if(!enabled)
		return 0
	if(!check_functionality() || !ntnet_global || is_banned())
		return 0
	return 2

/obj/item/computer_hardware/network_card/wired
	name = "wired NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. This one also supports wired connection."
	ethernet = 1
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/computer_hardware/network_card/integrated //Borg tablet version, only works while the borg has power and is not locked
	name = "cyborg data link"
