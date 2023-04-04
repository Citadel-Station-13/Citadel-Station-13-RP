GLOBAL_LIST_EMPTY(leap_pad_lookup)

/obj/machinery/leap_pad
	name = "quantum leap pad"
	desc = "An expensive, and highly efficient quantum pad configured to near-instantaneously transmit its cargo instead of keeping the conduit open."
	#warn sprite
	density = FALSE
	anchored = TRUE

	/// target; either a leap_pad or an /atom
	var/atom/target
	/// lookup for autolink
	var/autolink_key
	/// autolink target
	var/autolink_target

	/// chargeup time
	var/charge_time = 10 SECONDS
	/// recharge time
	var/recharge_time = 10 SECONDS
	/// overlay states for charging? amount if so, will be _1, _2, ...
	var/charge_overlays = 0

	/// teleport timer
	var/teleport_timerid

/obj/machinery/leap_pad/Initialize(mapload)
	. = ..()
	if(autolink_key)
		GLOB.leap_pad_lookup[autolink_key] = src

/obj/machinery/leap_pad/Destroy()
	target = null
	if(autolink_key)
		GLOB.leap_pad_lookup -= autolink_key
	return ..()

/obj/machinery/leap_pad/proc/set_autolink_key(new_key)
	if(autolink_key)
		GLOB.leap_pad_lookup -= autolink_key
	autolink_key = new_key
	if(autolink_key)
		GLOB.leap_pad_lookup[autolink_key] = src

/obj/machinery/leap_pad/process()
	. = ..()
	#warn impl

/obj/machinery/leap_pad/update_overlays()
	. = ..()
	#warn impl

/obj/machinery/leap_pad/vv_edit_var(var_name, new_value, mass_edit, raw_edit)
	if(raw_edit)
		return ..()
	switch(var_name)
		if(NAMEOF(src, autolink_key))
			set_autolink_key(new_value)
			return TRUE
	return ..()

/obj/machinery/leap_pad/proc/autolink()
	if(!autolink_target)
		set_target(null)
		return
	var/atom/A = GLOB.leap_pad_lookup[autolink_target]
	set_target(A)

/obj/machinery/leap_pad/proc/set_target(atom/new_target)
	target = new_target

/obj/machinery/leap_pad/proc/cancel()

/obj/machinery/leap_pad/proc/finalize()

/obj/machinery/leap_pad/proc/initiate()

/obj/machinery/leap_pad/proc/get_targets()

/obj/machinery/leap_pad/proc/transition(list/atom/targets)

#warn impl
