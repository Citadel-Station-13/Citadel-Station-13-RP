/obj/machinery/light/proc/flicker(amount = rand(10, 20))
	var/on_s = on // s stands for safety
	if(flickering)
		return
	flickering = TRUE
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i in 1 to amount)
				if(status != LIGHT_OK)
					break
				if(on_s != on)
					return
				on_s = !on_s
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = FALSE
