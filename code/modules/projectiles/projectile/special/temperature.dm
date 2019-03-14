/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	fire_sound = 'sound/weapons/pulse3.ogg'
	damage = 0
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	nodamage = 1
	check_armour = "energy" // It actually checks heat/cold protection.
	var/target_temperature = 50
	light_range = 2
	light_power = 0.5
	light_color = "#55AAFF"

	combustion = FALSE

/obj/item/projectile/temp/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target

		var/protection = null
		var/potential_temperature_delta = null
		var/new_temperature = L.bodytemperature

		if(target_temperature >= T20C) // Make it cold.
			protection = L.get_cold_protection(target_temperature)
			potential_temperature_delta = 75
			new_temperature = max(new_temperature - potential_temperature_delta, target_temperature)
		else // Make it hot.
			protection = L.get_heat_protection(target_temperature)
			potential_temperature_delta = 200 // Because spacemen temperature needs stupid numbers to actually hurt people.
			new_temperature = min(new_temperature + potential_temperature_delta, target_temperature)

		var/temp_factor = abs(protection - 1)

		new_temperature = round(new_temperature * temp_factor)
		L.bodytemperature = new_temperature

/obj/item/projectile/temp/cold

/obj/item/projectile/temp/hot
	name = "heat beam"
	target_temperature = 1000

	combustion = TRUE
