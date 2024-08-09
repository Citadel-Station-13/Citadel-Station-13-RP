/obj/machinery/door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	var/maxtemperature = heat_resistance //same as a normal steel wall

	if(exposed_temperature > maxtemperature)
		var/burndamage = log(RAND_F(0.9, 1.1) * (exposed_temperature - maxtemperature))
		inflict_atom_damage(burndamage, damage_flag = ARMOR_FIRE, damage_mode = DAMAGE_MODE_GRADUAL)
	return ..()
