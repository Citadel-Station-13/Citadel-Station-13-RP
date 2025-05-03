/obj/item/grenade/simple/spawner
	desc = "It is set to detonate in 5 seconds. It will unleash unleash an unspecified anomaly into the vicinity."
	name = "delivery grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "delivery"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4)
	var/spawner_type = null // must be an object path
	var/deliveryamt = 1 // amount of type to deliver

// Detonate now just handles the two loops that query for people in lockers and people who can see it.
/obj/item/grenade/simple/spawner/on_detonate(turf/location, atom/grenade_location)
	..()

	if(spawner_type && deliveryamt)
		// Make a quick flash
		playsound(location, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(location, null))
			if(M.eyecheck() <= 0)
				M.flash_eyes()

		// Spawn some hostile syndicate critters
		for(var/i=1, i<=deliveryamt, i++)
			var/atom/movable/x = new spawner_type(location)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(NORTH,SOUTH,EAST,WEST))

/obj/item/grenade/simple/spawner/manhacks
	name = "manhack delivery grenade"
	spawner_type = /mob/living/simple_mob/mechanical/viscerator
	deliveryamt = 5
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

/obj/item/grenade/simple/spawner/manhacks/mercenary
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/mercenary

/obj/item/grenade/simple/spawner/manhacks/raider
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/raider

/obj/item/grenade/simple/spawner/manhacks/station
	desc = "It is set to detonate in 5 seconds. It will deploy three weaponized survey drones."
	deliveryamt = 3
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/station
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_ILLEGAL = 1)

/obj/item/grenade/simple/spawner/manhacks/station/locked
	desc = "It is set to detonate in 5 seconds. It will deploy three weaponized survey drones. This one has a safety interlock that prevents release if used while in proximity to the facility."
	req_access = list(ACCESS_SECURITY_ARMORY) //for toggling safety
	var/locked = 1

/obj/item/grenade/simple/spawner/manhacks/station/locked/activate(datum/event_args/actor/actor)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in (LEGACY_MAP_DATUM).map_levels)
			icon_state = initial(icon_state)
			return TRUE
	return ..()

/obj/item/grenade/simple/spawner/manhacks/station/locked/attackby(obj/item/I, mob/user)
	var/obj/item/card/id/id = I.GetID()
	if(istype(id))
		if(check_access(id))
			locked = !locked
			to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		user.visible_message("<span class='notice'>[user] swipes \the [I] against \the [src].</span>")
	else
		return ..()

/obj/item/grenade/simple/spawner/manhacks/station/locked/emag_act(var/remaining_charges,var/mob/user)
	..()
	locked = !locked
	to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src]!</span>")

/obj/item/grenade/simple/spawner/manhacks/apidean
	name = "\improper Apidean drone grenade"
	desc = "Contains hibernating eggs of fast growing, organic kill-drones, used by Apidaen Enforcers to sweep ships and tunnels of deviants and intruders."
	icon_state = "beenade"
	spawner_type = /mob/living/simple_mob/mechanical/viscerator/apidean

/obj/item/grenade/simple/spawner/ward
	name = "sentry delivery grenade"
	desc = "It is set to detonate in 5 seconds. It will deploy a single thermal-optic sentry drone."
	spawner_type = /mob/living/simple_mob/mechanical/ward/monitor/crew
	deliveryamt = 1
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_BLUESPACE = 2)

/obj/item/grenade/simple/spawner/spesscarp
	name = "carp delivery grenade"
	spawner_type = /mob/living/simple_mob/animal/space/carp
	deliveryamt = 5
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

/obj/item/grenade/simple/spawner/spider
	name = "spider delivery grenade"
	spawner_type = /mob/living/simple_mob/animal/giant_spider/hunter
	deliveryamt = 3
	origin_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 4, TECH_ILLEGAL = 4)

//Sometimes you just need a sudden influx of spiders.
/obj/item/grenade/simple/spawner/spider/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	item_state = "briefcase"
	damage_force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	deliveryamt = 6
