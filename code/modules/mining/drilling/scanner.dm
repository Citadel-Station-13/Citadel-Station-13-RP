/obj/item/weapon/mining_scanner
	name = "ore detector"
	desc = "A complex device used to locate ore deep underground in a 3 by 3 area around you."
	icon = 'icons/obj/device.dmi'
	icon_state = "forensic0-old" //GET A BETTER SPRITE.
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)

/obj/item/weapon/mining_scanner/attack_self(mob/user)
	to_chat(user,"You begin sweeping \the [src] about, scanning for metal deposits.")
	playsound(loc, 'sound/items/goggles_charge.ogg', 50, 1, -6)

	if(!do_after(user, 50))
		return

	var/list/metals = list(
		"surface minerals" = 0,
		"precious metals" = 0,
		"nuclear fuel" = 0,
		"exotic matter" = 0
		)

	for(var/turf/simulated/T in range(2, get_turf(user)))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			switch(metal)
				if("silicates", "carbon", "hematite")	ore_type = "surface minerals"
				if("gold", "silver", "diamond")					ore_type = "precious metals"
				if("uranium")									ore_type = "nuclear fuel"
				if("phoron", "osmium", "hydrogen")				ore_type = "exotic matter"

			if(ore_type) metals[ore_type] += T.resources[metal]

	to_chat(user,"\icon[src] <span class='notice'>The scanner beeps and displays a readout.</span>")

	for(var/ore_type in metals)
		var/result = "no sign"

		switch(metals[ore_type])
			if(1 to 25) result = "trace amounts"
			if(26 to 75) result = "significant amounts"
			if(76 to INFINITY) result = "huge quantities"

		to_chat(user,"- [result] of [ore_type].")

/obj/item/weapon/mining_scanner/advanced
	name = "advanced ore detector"
	desc = "A compact, complex device used to quickly locate ore deep underground in a 5 by 5 area around you."
	icon_state = "mining-scanner" //thank you eris spriters
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000)

/obj/item/weapon/mining_scanner/advanced/attack_self(mob/user)
	to_chat(user,"You sweep \the [src] about, quickly pinging for ore deposits.")
	playsound(loc, 'sound/items/goggles_charge.ogg', 50, 1, -6)

	if(!do_after(user, 10))
		return

	var/list/metals = list(
		"hematite" = 0,
		"carbon" = 0,
		"silicates" = 0,
		"silver" = 0,
		"gold" = 0,
		"diamond" = 0,
		"platinum" = 0,
		"phoron" = 0,
		"uranium" = 0,
		"hydrogen" = 0
			)

	for(var/turf/simulated/T in range(5, get_turf(user)))

		if(!T.has_resources)
			continue

		for(var/metal in T.resources)
			var/ore_type

			switch(metal)
				if("hematite")	ore_type = "hematite"
				if("carbon")	ore_type = "carbon"
				if("silicates") ore_type = "silicates"
				if("silver")	ore_type = "silver"
				if("gold")	ore_type = "gold"
				if("diamond")	ore_type = "diamond"
				if("platinum")	ore_type = "platinum"
				if("phoron")	ore_type = "phoron"
				if("uranium")	ore_type = "uranium"
				if("hydrogen")	ore_type = "hydrogen"

			if(ore_type) metals[ore_type] += T.resources[metal]

	to_chat(user,"\icon[src] <span class='notice'>The scanner beeps and displays a readout.</span>")

	for(var/ore_type in metals)
		var/result = "no sign"
		result = metals[ore_type]
		to_chat(user,"- [result] [ore_type].")