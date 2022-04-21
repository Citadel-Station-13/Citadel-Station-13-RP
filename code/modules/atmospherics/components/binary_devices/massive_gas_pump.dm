/**
 *  Massive gas pumps are wired, clunky machines that can use a dynamic amount of power to
 *  do the job of normal gas pumps
 */

/obj/machinery/atmospherics/binary/pump/massive
    //we steal a lot from the normal gas pump in terms of variables
    var/obj/machinery/power/power_machine


/obj/machinery/atmospherics/binary/pump/massive/Initialize(mapload)
    . = ..()
    power_machine = new
    //air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 10//give it a much larger volume
	//air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 10

/obj/machinery/atmospherics/binary/pump/massive/process(delta_time)
    power_rating = power_machine.avail()//Massive addition

    last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how much gas to transfer to meet the target pressure.
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)? network2.volume : 0)
		power_draw = pump_gas(src, air1, air2, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		power_machine.draw_power(power_draw)//Edit for massive else this whole thing stays a normal pump

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1
