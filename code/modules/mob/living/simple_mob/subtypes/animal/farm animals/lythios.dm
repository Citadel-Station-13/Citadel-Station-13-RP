///Lythios "Experimental Fauna" since we technically need to be doing something on this planet.


/datum/category_item/catalogue/fauna/livestock/icegoat
	name = "Experimental Livestock - Glacicorn"
	desc = "A genetically engineered lifeform distantly related to the domesitcated goat.\
	It is currently being developed by NT as part of an independent initiative to slowly\
	ween itself off reliance on Centauri Provisions for its food. It is capable of surviving\
	in the harshest colds, and survives off of chemical processes only possible in extreme cold.\
	As a result it dies rather quickly in what most races would consider 'comfortable' heat.\
	Theirs ice spikes though dangerous are seen as a necessary defense for theoretical predators.\
	Its milk is notably chilled by frost oil created as a by product of surviving on icy planets."
	value = CATALOGUER_REWARD_TRIVIAL


/mob/living/simple_mob/animal/icegoat
	name = "glacicorn"
	desc = "A genetically engineered goat designed to thrive on massively cold worlds. It seems no amount of genetic tampering can change a goat's unpleasant disposition."
	tt_desc = "E Capri absonulla"
	icon_state = "icegoat"
	icon_living = "icegoat"
	icon_dead = "icegoat_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/livestock/icegoat)

	faction = "goat"

	minbodytemp = 100
	maxbodytemp = 250

	health = 40
	maxHealth = 40

	randomized = TRUE

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = list("kicked","impales","gores")

	say_list_type = /datum/say_list/goat
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	meat_amount = 4
	bone_amount = 2
	hide_amount = 3
	exotic_amount = 2

	var/datum/reagents/udder = null

/mob/living/simple_mob/animal/icegoat/Initialize(mapload)
	. = ..()
	udder = new(50)
	udder.my_atom = src

/mob/living/simple_mob/animal/icegoat/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(4,8))
			udder.add_reagent("frostoil", rand(1, 2))

		if(locate(/obj/effect/plant) in loc)
			var/obj/effect/plant/SV = locate() in loc
			SV.die_off(1)

		if(locate(/obj/machinery/portable_atmospherics/hydroponics/soil/invisible) in loc)
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/SP = locate() in loc
			qdel(SP)

		if(!pulledby)
			var/obj/effect/plant/food
			food = locate(/obj/effect/plant) in oview(5,loc)
			if(food)
				var/step = get_step_to(src, food, 0)
				Move(step)

/mob/living/simple_mob/animal/icegoat/Move()
	..()
	if(!stat)
		for(var/obj/effect/plant/SV in loc)
			SV.die_off(1)

/mob/living/simple_mob/animal/icegoat/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_id_to(G, "milk", rand(4,8))
		transfered = udder.trans_id_to(G, "frostoil", rand(1,2))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<font color='red'>The [O] is full.</font>")
		if(!transfered)
			to_chat(user, "<font color='red'>The udder is dry. Wait a bit longer...</font>")
	else
		..()

/datum/category_item/catalogue/fauna/livestock/woolie
	name = "Experimental Livestock - Woolie"
	desc = "A large ball of dense wool hiding an unusual octopedal creature.\
	It has been genetically engineered almost from scratch to create an animal\
	capable of producing a natural clothing fiber on even the coldest worlds.\
	Cloth can be sheared from the outer most layers of its woolen coat which\
	regrows quickly. Lower layers of the coat tend to be too dense to shear.\
	These peaceful animals have temperment similar to sheep and are very peaceful."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/woolie
	name = "woolie"
	desc = "A ball of wool that hides a peculiar peaceful creature. Its thick coat protectsit from even the harshest weather."
	tt_desc = "E Lanovis absonulla"
	icon_state = "woolie"
	icon_living = "woolie"
	icon_dead = "woolie_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/livestock/woolie)

	faction = "goat"

	minbodytemp = 100
	maxbodytemp = 300

	health = 40
	maxHealth = 40

	randomized = TRUE

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = list("angrily nudges")

	meat_amount = 4
	bone_amount = 2
	hide_amount = 3
	exotic_amount = 2

	var/coat_amount = 0
	var/coat_mat = /obj/item/stack/material/cloth

/mob/living/simple_mob/animal/passive/woolie/Initialize(mapload)
	. = ..()
	coat_amount = 2

/mob/living/simple_mob/animal/passive/woolie/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		if(prob(5))
			if (coat_amount > 5)
				return
			else
				coat_amount += 1

/mob/living/simple_mob/animal/passive/woolie/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/tool/wirecutters/C = O
	if(istype(C))
		if(coat_amount == 0)
			to_chat(user, "<font color='red'>There is not enough wool to shear from the [src].</font>")
		else
			user.visible_message("<span class='notice'>[user] shears [src] using \the [O].</span>")
			new coat_mat(get_turf(loc), coat_amount)
			coat_amount = 0
	else
		..()

/datum/category_item/catalogue/fauna/livestock/furnacegrub
	name = "Experimental Livestock - Furnace Grub"
	desc = "After years of study by NT xenobiologists, the genes that allowed solar moths\
	to produce heat was extracted and engineered into a docile and mostly safe living furnace.\
	The Furnace Grub as it has been dubbed could provide passive heating even without power systems,\
	which NT hopes can be sold to prospective colonists seeking to colonize the most icy planets."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/furnacegrub
	name = "furnace grub"
	desc = "This grub glows with a powerful heat. "
	icon_state = "furnacegrub"
	icon_living = "furnacegrub"
	icon_dead = "furnacegrub_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/livestock/furnacegrub)

	minbodytemp = 100
	maxbodytemp = 350

	faction = "grubs"
	maxHealth = 50
	health = 50

	melee_damage_lower = 1
	melee_damage_upper = 3

	movement_cooldown = 8

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/grubmeat

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	var/mycolour = COLOR_ORANGE //Variable Lighting colours
	var/original_temp = null //Value to remember temp
	var/set_temperature = T0C + 20 //Sets the target point of 20 Celsius or station Temperature.
	var/heating_power = 30000


/mob/living/simple_mob/animal/passive/furnacegrub/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(icon_state != icon_dead) //I mean on death() Life() should disable but i guess doesnt hurt to make sure -shark
		var/datum/gas_mixture/env = loc.return_air() //Gets all the information on the local air.
		var/transfer_moles = 0.25 * env.total_moles //The bigger the room, the harder it is to heat the room.
		var/datum/gas_mixture/removed = env.remove(transfer_moles)
		var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
		if(heat_transfer > 0 && env.temperature < T0C)	//This should start heating the room at a moderate pace up to 0 celsius.
			heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater
			removed.add_thermal_energy(heat_transfer)

		else if(heat_transfer > 0 && env.temperature < set_temperature) //Set temperature is 450 degrees celsius. Heating rate should increase between 200 and 450 C.
			heating_power = original_temp*100
			heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater. Except it's hot, so yeah.
			removed.add_thermal_energy(heat_transfer)

		else
			return

		env.merge(removed)

	//Since I'm changing hyper mode to be variable we need to store old power
	original_temp = heating_power //We remember our old goal, for use in non perpetual heating level increase

/mob/living/simple_mob/animal/passive/furnacegrub/death()
	src.anchored = 0
	set_light(3, 3, "#FFCC00")

/mob/living/simple_mob/animal/passive/furnacegrub/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_ORANGE)
		return 1


///Lythios Livesotck Crates
/obj/structure/largecrate/animal/icegoat
	name = "glacicorn crate carrier"
	desc = "Contains a pair of glacicorns, ill tempered ice goats. Warning glaicorns will die in enviroment with temperatures exceeding zero degress celcius."
	starts_with = list(/mob/living/simple_mob/animal/icegoat = 2)

/obj/structure/largecrate/animal/woolie
	name = "woolie Crate"
	desc = "Contains a pair of woolies, a sheep like animal designed to live in extreme cold."
	starts_with = list(/mob/living/simple_mob/animal/passive/woolie = 2)

/obj/structure/largecrate/animal/furnacegrub
	name = "furnace grub carrier"
	desc = "Contains one experimental furnace grub. Release into sealed cold enviroments to slowly heat them."
	starts_with = list(/mob/living/simple_mob/animal/passive/furnacegrub)
