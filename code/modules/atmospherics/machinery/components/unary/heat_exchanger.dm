/obj/machinery/atmospherics/component/unary/heat_exchanger
	name = "Heat Exchanger"
	desc = "Exchanges heat between two input gases. Setup for fast heat transfer"
	icon = 'icons/obj/atmospherics/heat_exchanger.dmi'
	icon_state = "intact"
	pipe_state = "heunary"

	// todo: we should cache partner.
	//      for now, we just assume pipe system only allows one per
	//      normalized cardinal dir per tile.
	// var/obj/machinery/atmospherics/component/unary/heat_exchanger/paired

	/// thermal conduction power
	///
	/// * multiplied with the partner's to get % of energy to equalize.
	/// * values above 1 currently do nothing
	var/thermal_conduction_power = 1

/obj/machinery/atmospherics/component/unary/heat_exchanger/update_icon_state()
	if(node)
		icon_state = "intact"
	else
		icon_state = "exposed"
	return ..()

/obj/machinery/atmospherics/component/unary/heat_exchanger/process()
	..()

	// detect partner
	// a heat exchanger's exchanging surface is the opposite direction of its pipe direction.
	var/obj/machinery/atmospherics/component/unary/heat_exchanger/paired
	var/opp_dir = turn(dir, 180)
	for(var/obj/machinery/atmospherics/component/unary/heat_exchanger/potential_pair in get_step(src, opp_dir))
		if(potential_pair.dir == opp_dir)
			paired = potential_pair
			break

	if(!paired)
		return

	var/exchange_efficiency = clamp(thermal_conduction_power, 0, 1) * clamp(paired.thermal_conduction_power, 0, 1)
	if(!exchange_efficiency)
		return

	if(air_contents.share_heat_with_mixture(paired.air_contents, exchange_efficiency))
		network?.update = TRUE
		paired.network?.update = TRUE

// todo: standard handling on component level.
/obj/machinery/atmospherics/component/unary/heat_exchanger/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (!W.is_wrench())
		return ..()
	if(is_hidden_underfloor())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	if(unsafe_pressure())
		to_chat(user, "<span class='warning'>You feel a gust of air blowing in your face as you try to unwrench [src]. Maybe you should reconsider..</span>")
	add_fingerprint(user)
	playsound(src, W.tool_sound, 50, 1)
	to_chat(user, "<span class='notice'>You begin to unfasten \the [src]...</span>")
	if (do_after(user, 40 * W.tool_speed))
		user.visible_message( \
			"<span class='notice'>\The [user] unfastens \the [src].</span>", \
			"<span class='notice'>You have unfastened \the [src].</span>", \
			"You hear a ratchet.")
		deconstruct()
