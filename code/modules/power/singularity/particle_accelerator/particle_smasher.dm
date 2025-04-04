/*
 * Contains the particle smasher and its recipes.
 */

/obj/machinery/particle_smasher
	name = "Particle Focus"
	desc = "A strange device used to create exotic matter."
	icon = 'icons/obj/machines/particle_smasher.dmi'
	icon_state = "smasher"
	anchored = 0
	density = 1
	use_power = USE_POWER_OFF
	armor = /datum/armor/object/heavy

	var/image/material_layer	// Holds the image used for the filled overlay.
	var/image/material_glow		// Holds the image used for the glow overlay.
	var/image/reagent_layer		// Holds the image used for showing a contained beaker.
	var/energy = 0				// How many 'energy' units does this have? Acquired by a Particle Accelerator like a Singularity.
	var/max_energy = 600
	var/obj/item/stack/material/target	// The material being bombarded.
	var/obj/item/reagent_containers/reagent_container		// Holds the beaker. The process will consume ALL reagents inside it.
	var/beaker_type = /obj/item/reagent_containers/glass/beaker
	var/list/storage		// Holds references to items allowed to be used in the fabrication phase.
	var/max_storage = 3	// How many items can be jammed into it?
	var/list/recipes	// The list containing the Particle Smasher's recipes.

/obj/machinery/particle_smasher/Initialize(mapload)
	. = ..()
	storage = list()
	update_icon()
	prepare_recipes()

/obj/machinery/particle_smasher/Destroy()
	for(var/datum/particle_smasher_recipe/D in recipes)
		qdel(D)
	recipes.Cut()
	for(var/atom/movable/AM in contents)
		AM.forceMove(drop_location())
	return ..()

/obj/machinery/particle_smasher/examine(mob/user, dist)
	. = ..()
	. += "<span class='notice'>\The [src] contains:</span>"
	for(var/obj/item/I in contents)
		. += "<span class='notice'>\the [I]</span>"

/obj/machinery/particle_smasher/attackby(obj/item/W as obj, mob/user as mob)
	if(W.type == /obj/item/atmos_analyzer)
		to_chat(user, "<span class='notice'>\The [src] reads an energy level of [energy].</span>")
	else if(istype(W, /obj/item/stack/material) && !target)
		var/obj/item/stack/material/M = W
		if(M.uses_charge)
			to_chat(user, "<span class='notice'>You cannot fill \the [src] with a synthesizer!</span>")
			return
		if(!user.attempt_insert_item_for_installation(M, src))
			return
		target = M
		user.visible_message("[user] slots \the [target] into [src].")
		update_icon()
	else if(istype(W, beaker_type))
		if(reagent_container)
			to_chat(user, "<span class='notice'>\The [src] already has a container attached.</span>")
			return
		if(!user.transfer_item_to_loc(W, src))
			return
		reagent_container = W
		to_chat(user, "<span class='notice'>You add \the [reagent_container] to \the [src].</span>")
		update_icon()
		return
	else if(W.is_wrench())
		anchored = !anchored
		playsound(src, W.tool_sound, 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet.")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet.")
		update_icon()
		return
	else if(istype(W, /obj/item/card/id))
		to_chat(user, "<span class='notice'>Swiping \the [W] on \the [src] doesn't seem to do anything...</span>")
		return ..()
	else if(storage.len < max_storage)
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		storage += W
	else
		return ..()

/obj/machinery/particle_smasher/update_icon()
	cut_overlays()
	if(!material_layer)
		material_layer = image(icon, "[initial(icon_state)]-material")
	if(!material_glow)
		material_glow = image(icon, "[initial(icon_state)]-material-glow")
		material_glow.plane = ABOVE_LIGHTING_PLANE
	if(!reagent_layer)
		reagent_layer = image(icon, "[initial(icon_state)]-reagent")
	if(anchored)
		icon_state = "[initial(icon_state)]-o"
		if(target)
			material_layer.color = target.material.icon_colour
			add_overlay(material_layer)
//			if(successful_craft)
//				material_glow.color = target.material.icon_colour
//				add_overlay(material_glow)
		if(reagent_container)
			add_overlay(reagent_layer)
	else
		icon_state = initial(icon_state)

	if(target && energy)
		var/power_percent = round((energy / max_energy) * 100)
		light_color = target.material.icon_colour
		switch(power_percent)
			if(0 to 25)
				light_range = 1
			if(26 to 50)
				light_range = 2
			if(51 to 75)
				light_range = 3
			if(76 to INFINITY)
				light_range = 4
		set_light(light_range, 2, light_color)
	else
		set_light(0, 0, "#FFFFFF")

/obj/machinery/particle_smasher/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	if(istype(proj, /obj/projectile/beam))
		if(proj.damage_force >= 50)
			TryCraft()
		return PROJECTILE_IMPACT_DELETE
	return ..()

/obj/machinery/particle_smasher/process(delta_time)
	if(!src.anchored)	// Rapidly loses focus.
		if(energy)
			radiation_pulse(src, RAD_INTENSITY_PARTICLE_SMASHER_ENERGY_LOSS(30))
			energy = max(0, energy - 30)
			update_icon()

	if(energy)
		radiation_pulse(src, RAD_INTENSITY_PARTICLE_SMASHER_ENERGY_LOSS(5))
		energy = clamp(energy - 5, 0, max_energy)

/obj/machinery/particle_smasher/proc/prepare_recipes()
	if(!recipes)
		recipes = list()
		for(var/D in subtypesof(/datum/particle_smasher_recipe))
			recipes += new D
	else
		for(var/datum/particle_smasher_recipe/D in recipes)
			qdel(D)
		recipes.Cut()
		for(var/D in subtypesof(/datum/particle_smasher_recipe))
			recipes += new D

/obj/machinery/particle_smasher/proc/TryCraft()

	if(!recipes || !recipes.len)
		recipes = typesof(/datum/particle_smasher_recipe)

	if(!target)	// You are just blasting an empty machine.
		visible_message("<span class='notice'>\The [src] shudders.</span>")
		update_icon()
		return

	var/list/possible_recipes = list()
	var/max_prob = 0
	for(var/datum/particle_smasher_recipe/R in recipes)	// Only things for the smasher. Don't get things like the chef's cake recipes.
		if(R.probability)	// It's actually a recipe you're supposed to be able to make.
			if(istype(target, R.required_material))
				if(energy >= R.required_energy_min && energy <= R.required_energy_max)	// The machine has enough Vaguely Defined 'Energy'.
					var/turf/T = get_turf(src)
					var/datum/gas_mixture/environment = T.return_air()
					if(environment.temperature >= R.required_atmos_temp_min && environment.temperature <= R.required_atmos_temp_max)	// Too hot, or too cold.
						if(R.reagents && R.reagents.len)
							if(!reagent_container || R.check_reagents(reagent_container.reagents) == -1)	// It doesn't have a reagent storage when it needs it, or it's lacking what is needed.
								continue
						if(R.items && R.items.len)
							if(!(storage && storage.len) || R.check_items(src) == -1)	// It's empty, or it doesn't contain what is needed.
								continue
						possible_recipes += R
						max_prob += R.probability

	if(possible_recipes.len)
		var/local_prob = rand(0, max_prob - 1)%max_prob
		var/cumulative = 0
		for(var/datum/particle_smasher_recipe/R in possible_recipes)
			cumulative += R.probability
			if(local_prob < cumulative)
				DoCraft(R)
				break
	update_icon()

/obj/machinery/particle_smasher/proc/DoCraft(var/datum/particle_smasher_recipe/recipe)
	if(!recipe)
		return

	target.use(1)

	if(reagent_container)
		for(var/i in recipe.reagents)
			reagent_container.reagents.remove_reagent(i, recipe.reagents[i])

	if(recipe.items && recipe.items.len)
		for(var/type in recipe.items)
			var/obj/item/thing = locate(type) in src
			if(thing)
				qdel(thing)

	new recipe.result(drop_location())
	update_icon()

/obj/machinery/particle_smasher/Exited(atom/movable/AM)
	if(AM == target)
		target = null
	if(AM == reagent_container)
		reagent_container = null
	if(islist(storage) && (AM in storage))
		storage -= AM
	return ..()

/obj/machinery/particle_smasher/verb/eject_contents()
	set src in view(1)
	set category = VERB_CATEGORY_OBJECT
	set name = "Eject Particle Focus Contents"

	if(usr.incapacitated())
		return

	DumpContents()

/obj/machinery/particle_smasher/proc/DumpContents()
	var/atom/A = drop_location()
	for(var/obj/item/I in contents)
		I.forceMove(A)
	update_icon()

/*
 * The special recipe datums used for the particle smasher.
 */

/datum/particle_smasher_recipe
	var/list/reagents	// example: = list("pacid" = 5)
	var/list/items		// example: = list(/obj/item/tool/crowbar, /obj/item/welder) Place /foo/bar before /foo. Do not include fruit. Maximum of 3 items.

	var/result = /obj/item/stack/material/iron		// The sheet this will produce.
	var/required_material = /obj/item/stack/material/iron	// The required material sheet.
	var/required_energy_min = 0			// The minimum energy this recipe can process at.
	var/required_energy_max = 600		// The maximum energy this recipe can process at.
	var/required_atmos_temp_min = 0		// The minimum ambient atmospheric temperature required, in kelvin.
	var/required_atmos_temp_max = 600	// The maximum ambient atmospheric temperature required, in kelvin.
	var/probability = 0					// The probability for the recipe to be produced. 0 will make it impossible.

/datum/particle_smasher_recipe/proc/check_items(var/obj/container as obj)
	. = 1
	if (items && items.len)
		var/list/checklist = list()
		checklist = items.Copy() // You should really trust Copy
		if(istype(container, /obj/machinery/particle_smasher))
			var/obj/machinery/particle_smasher/machine = container
			for(var/obj/O in machine.storage)
				if(istype(O,/obj/item/reagent_containers/food/snacks/grown))
					continue // Fruit is handled in check_fruit().
				var/found = 0
				for(var/i = 1; i < checklist.len+1; i++)
					var/item_type = checklist[i]
					if (istype(O,item_type))
						checklist.Cut(i, i+1)
						found = 1
						break
				if (!found)
					. = 0
		if (checklist.len)
			. = -1
	return .

/datum/particle_smasher_recipe/proc/check_reagents(var/datum/reagent_holder/avail_reagents)
	. = 1
	for (var/r_r in reagents)
		var/aval_r_amnt = avail_reagents.get_reagent_amount(r_r)
		if (!(abs(aval_r_amnt - reagents[r_r])<0.5)) //if NOT equals
			if (aval_r_amnt>reagents[r_r])
				. = 0
			else
				return -1
	if ((reagents?(reagents.len):(0)) < length(avail_reagents.reagent_volumes))
		return 0
	return .

/datum/particle_smasher_recipe/deuterium_tritium
	reagents = list("hydrogen" = 15)

	result = /obj/item/stack/material/tritium
	required_material = /obj/item/stack/material/deuterium

	required_energy_min = 200
	required_energy_max = 400

	required_atmos_temp_max = 200
	probability = 30

/datum/particle_smasher_recipe/verdantium_morphium
	result = /obj/item/stack/material/morphium
	required_material = /obj/item/stack/material/verdantium

	required_energy_min = 400
	required_energy_max = 500
	probability = 20

/datum/particle_smasher_recipe/plasteel_morphium
	items = list(/obj/item/prop/alien/junk)

	result = /obj/item/stack/material/morphium
	required_material = /obj/item/stack/material/plasteel

	required_energy_min = 100
	required_energy_max = 300
	probability = 10

/datum/particle_smasher_recipe/osmium_lead
	reagents = list("tungsten" = 10)

	result = /obj/item/stack/material/lead
	required_material = /obj/item/stack/material/osmium

	required_energy_min = 200
	required_energy_max = 400

	required_atmos_temp_min = 1000
	required_atmos_temp_max = 8000
	probability = 50

/datum/particle_smasher_recipe/steel_plasteel
	reagents = list(MAT_PHORON = 60) //three sheet of phoron and one sheet of steel

	result = /obj/item/stack/material/plasteel
	required_material = /obj/item/stack/material/steel

	required_energy_min = 100
	required_energy_max = 250

	probability = 50

/datum/particle_smasher_recipe/plasteel_durasteel
	reagents = list(MAT_PHORON = 40, "pacid" = 20)

	result = /obj/item/stack/material/durasteel
	required_material = /obj/item/stack/material/plasteel

	required_energy_min = 590
	required_energy_max = 650

	required_atmos_temp_min = 888
	required_atmos_temp_max = 896 //more temperature CBT either setup a cooler and heater array to hold or coordinate with your fellow scientists
	probability = 50

/datum/particle_smasher_recipe/plastic_diamond
	reagents = list(MAT_CARBON = 100, "ethanol" = 50) //read a paper sometime ago that some guys grew industrial diamonds from various alcoholic drinks

	result = /obj/item/stack/material/diamond
	required_material = /obj/item/stack/material/plastic //eh close enough to graphite

	required_energy_min = 550
	required_energy_max = 600 //As we have no way to set ambient pressure we use the emitter to provide pressure for industrial diamonds think of compressing a Hohlraum to start fusion

	required_atmos_temp_min = 7800 //extreme temperature assuming the focus can be set to inert conditions and ambient atmosphere cannot react with what is basically hot carbon
	required_atmos_temp_max = 7830
	probability = 10

/datum/particle_smasher_recipe/copper_silver
	reagents = list("chlorine" = 25, "fluorine" = 25)

	result = /obj/item/stack/material/silver
	required_material = /obj/item/stack/material/copper

	required_energy_min = 100
	required_energy_max = 150

	required_atmos_temp_min = 130
	required_atmos_temp_max = 140
	probability = 20

/datum/particle_smasher_recipe/deuterium_mhydrogen
	reagents = list("potassium" = 10, "chlorine" = 10, "sacid" = 10 )

	result = /obj/item/stack/material/mhydrogen
	required_material = /obj/item/stack/material/deuterium

	required_energy_min = 500
	required_energy_max = 600

	required_atmos_temp_min = 20
	required_atmos_temp_max = 25
	probability = 90

/datum/particle_smasher_recipe/steel_uranium
	reagents = list("uranium" = 10, "fluorine")

	result = /obj/item/stack/material/uranium
	required_material = /obj/item/stack/material/steel

	required_energy_min = 400
	required_energy_max = 500

	required_atmos_temp_min = 369
	required_atmos_temp_max = 388
	probability = 50

/datum/particle_smasher_recipe/plasteel_titanium
	reagents = list("potassium" = 5, "chlorine" = 5, "sacid" = 5) // :')

	result = /obj/item/stack/material/titanium
	required_material = /obj/item/stack/material/plasteel

	required_energy_min = 300
	required_energy_max = 325

	required_atmos_temp_min = 555
	required_atmos_temp_max = 566
	probability = 50

/datum/particle_smasher_recipe/platinum_osmium
	reagents = list("hydrogen" = 25)

	result = /obj/item/stack/material/osmium
	required_material = /obj/item/stack/material/platinum

	required_energy_min = 500
	required_energy_max = 600

	required_atmos_temp_min = 500
	required_atmos_temp_max = 1000
	probability = 20

/datum/particle_smasher_recipe/osmium_platinum
	reagents = list("hydrogen" = 25, MAT_PHORON = 5)

	result = /obj/item/stack/material/platinum
	required_material = /obj/item/stack/material/osmium

	required_energy_min = 200
	required_energy_max = 300

	required_atmos_temp_min = 30
	required_atmos_temp_max = 60
	probability = 20

/datum/particle_smasher_recipe/steel_gold
	reagents = list(MAT_PHORON = 5)

	result = /obj/item/stack/material/gold
	required_material = /obj/item/stack/material/steel

	required_energy_min = 550
	required_energy_max = 600

	required_atmos_temp_min = 5200
	required_atmos_temp_max = 5250
	probability = 5

/datum/particle_smasher_recipe/gold_platinum
	reagents = list("hydrogen" = 20)

	result = /obj/item/stack/material/platinum
	required_material = /obj/item/stack/material/gold

	required_energy_min = 570
	required_energy_max = 600

	required_atmos_temp_min = 555
	required_atmos_temp_max = 777
	probability = 10

/datum/particle_smasher_recipe/gold_copper
	reagents = list("hydrogen" = 50)

	result = /obj/item/stack/material/copper
	required_material = /obj/item/stack/material/gold

	required_energy_min = 300
	required_energy_max = 400

	required_atmos_temp_min = 293
	required_atmos_temp_max = 298
	probability = 15

/datum/particle_smasher_recipe/phoron_valhollide
	reagents = list(MAT_PHORON = 10, "pacid" = 10)

	result = /obj/item/stack/material/valhollide
	required_material = /obj/item/stack/material/phoron

	required_energy_min = 300
	required_energy_max = 500

	required_atmos_temp_min = 1
	required_atmos_temp_max = 100
	probability = 10

/datum/particle_smasher_recipe/valhollide_supermatter
	reagents = list(MAT_PHORON = 300)

	result = /obj/item/stack/material/supermatter
	required_material = /obj/item/stack/material/valhollide

	required_energy_min = 575
	required_energy_max = 600

	required_atmos_temp_min = 3000
	required_atmos_temp_max = 10000
	probability = 1
