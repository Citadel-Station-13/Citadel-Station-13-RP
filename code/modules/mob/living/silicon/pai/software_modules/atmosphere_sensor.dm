/datum/pai_software/atmosphere_sensor
	name = "Atmosphere Sensor"
	ram_cost = 5
	id = "atmos_sense"
	toggle = 0

/datum/pai_software/atmosphere_sensor/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	var/data[0]

	var/turf/T = get_turf_or_move(user.loc)
	if(!T)
		data["reading"] = 0
		data["pressure"] = 0
		data["temperature"] = 0
		data["temperatureC"] = 0
		data["gas"] = list()
	else
		var/datum/gas_mixture/env = T.return_air()
		data["reading"] = 1
		var/pres = env.return_pressure() * 10
		data["pressure"] = "[round(pres/10)].[pres%10]"
		data["temperature"] = round(env.temperature)
		data["temperatureC"] = round(env.temperature-T0C)

		var/t_moles = env.total_moles
		var/gases[0]
		for(var/g in env.gas)
			var/gas[0]
			gas["name"] = GLOB.meta_gas_names[g]
			gas["percent"] = round((env.gas[g] / t_moles) * 100)
			gases[++gases.len] = gas
		data["gas"] = gases

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "pai_atmosphere.tmpl", "Atmosphere Sensor", 350, 300)
		ui.set_initial_data(data)
		ui.open()
