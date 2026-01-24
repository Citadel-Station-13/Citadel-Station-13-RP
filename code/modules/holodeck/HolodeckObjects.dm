// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/turf/simulated/floor/holofloor
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/get_lumcount(minlum = 0, maxlum = 1)
	return 0.8

/turf/simulated/floor/holofloor/attackby(obj/item/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/simulated/floor/holofloor/set_flooring()
	return

/turf/simulated/floor/holofloor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /datum/prototype/flooring/carpet

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_CARPET)
	canSmoothWith = (SMOOTH_GROUP_CARPET)

/turf/simulated/floor/holofloor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /datum/prototype/flooring/tiling

/turf/simulated/floor/holofloor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /datum/prototype/flooring/tiling/dark

/turf/simulated/floor/holofloor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /datum/prototype/flooring/linoleum

/turf/simulated/floor/holofloor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /datum/prototype/flooring/wood

/turf/simulated/floor/holofloor/grass
	name = "lush grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /datum/prototype/flooring/grass

/turf/simulated/floor/holofloor/snow
	name = "snow"
	base_name = "snow"
	icon = 'icons/turf/floors.dmi'
	base_icon = 'icons/turf/floors.dmi'
	icon_state = "snow"
	base_icon_state = "snow"

/turf/simulated/floor/holofloor/space
	icon = 'icons/turf/space.dmi'
	plane = SPACE_PLANE
	name = "\proper space"
	icon_state = "white"

/turf/simulated/floor/holofloor/reinforced
	icon = 'icons/turf/flooring/tiles.dmi'
	initial_flooring = /datum/prototype/flooring/reinforced
	name = "reinforced holofloor"
	icon_state = "reinforced"

/turf/simulated/floor/holofloor/beach
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon = 'icons/misc/beach.dmi'
	base_icon = 'icons/misc/beach.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/beach/sand
	name = "sand"
	icon_state = "desert"
	base_icon_state = "desert"

/turf/simulated/floor/holofloor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	base_icon_state = "sandwater"

/turf/simulated/floor/holofloor/beach/water
	name = "water"
	icon_state = "seashallow"
	base_icon_state = "seashallow"

/turf/simulated/floor/holofloor/desert
	name = "desert sand"
	base_name = "desert sand"
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon_state = "asteroid"
	base_icon_state = "asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/desert/Initialize(mapload)
	. = ..()
	if(prob(10))
		add_overlay("asteroid[rand(0,9)]")

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_padded_preview"
	anchored = 1.0
	pressure_resistance = 15

/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_gloves.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_gloves.dmi',
			)
	item_state = "boxing"
	special_attack_type = /datum/melee_attack/unarmed/holopugilism

/datum/melee_attack/unarmed/holopugilism
	sparring_variant_type = /datum/melee_attack/unarmed/holopugilism
	damage_type = DAMAGE_TYPE_HALLOSS

/obj/structure/window/reinforced/holowindow
	allow_deconstruct = FALSE

/obj/structure/window/reinforced/holowindow/drop_products(method, atom/where)
	return
/obj/structure/window/reinforced/holowindow/shatter_feedback()
	playsound(src, "shatter", 70, 1)
	visible_message("[src] fades away as it shatters!")

/obj/machinery/door/window/holowindoor/attackby(obj/item/I as obj, mob/user as mob)
	if(user.a_intent == INTENT_HARM)
		return ..()

	if (src.operating == 1)
		return

	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick("[base_state]deny", src)

	return

/obj/machinery/door/window/holowindoor/shatter(var/display_message = 1)
	src.density = 0
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)

/obj/structure/bed/chair/holochair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		to_chat(user, "<span class='notice'>It's a holochair, you can't dismantle it!</span>")
	return

/obj/structure/bed/holobed/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		to_chat(user, "<span class='notice'>It's a holochair, you can't dismantle it!</span>")
	return

/obj/item/holo
	damage_type = DAMAGE_TYPE_HALLOSS

/obj/item/holo/esword
	desc = "May the force be within you. Sorta."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "esword"
	var/lcolor
	var/rainbow = FALSE
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)
	damage_force = 3.0
	throw_speed = 1
	throw_range = 5
	throw_force = 0
	w_class = WEIGHT_CLASS_SMALL
	atom_flags = NOBLOODY
	var/active = 0

/obj/item/holo/esword/green
	lcolor = "#008000"

/obj/item/holo/esword/red
	lcolor = "#FF0000"

// todo: the parry system was removed from this because that sucks maybe readd it later lol

/obj/item/holo/esword/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	active = !active
	if (active)
		damage_force = 30
		item_state = "[icon_state]_blade"
		set_weight_class(WEIGHT_CLASS_BULKY)
		playsound(src, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] is now active.</span>")
	else
		damage_force = 3
		item_state = "[icon_state]"
		set_weight_class(WEIGHT_CLASS_SMALL)
		playsound(src, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")

	update_icon()
	add_fingerprint(user)
	return

/obj/item/holo/esword/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool) && !active)
		if(!rainbow)
			rainbow = TRUE
		else
			rainbow = FALSE
		to_chat(user, "<span class='notice'>You manipulate the color controller in [src].</span>")
		update_icon()
	return ..()

/obj/item/holo/esword/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	blade_overlay.color = lcolor
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
	update_worn_icon()

//BASKETBALL OBJECTS

/obj/item/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = WEIGHT_CLASS_BULKY //Stops people from hiding it in their bags/pockets
	drop_sound = 'sound/items/drop/basketball.ogg'
	pickup_sound = 'sound/items/pickup/basketball.ogg'

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = TRUE
	density = TRUE
	pass_flags_self = ATOM_PASS_THROWN | ATOM_PASS_OVERHEAD_THROW

/obj/structure/holohoop/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(G.state<2)
			to_chat(user, "<span class='warning'>You need a better grip to do that!</span>")
			return
		G.affecting.loc = src.loc
		G.affecting.afflict_paralyze(20 * 5)
		visible_message("<span class='warning'>[G.assailant] dunks [G.affecting] into the [src]!</span>", 3)
		qdel(W)
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		if(!user.attempt_insert_item_for_installation(W, loc))
			to_chat(user, SPAN_WARNING("[W] is stuck to your hand!"))
			return
		visible_message("<span class='notice'>[user] dunks [W] into the [src]!</span>", 3)
		return

/obj/structure/holohoop/CanAllowThrough(atom/movable/mover, turf/target)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/projectile))
			return TRUE
		if(prob(50))
			I.forceMove(loc)
			visible_message(SPAN_NOTICE("Swish! \the [I] lands in \the [src]."), 3)
		else
			visible_message(SPAN_WARNING( "\The [I] bounces off of \the [src]'s rim!"), 3)
		return FALSE
	return ..()


/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/attackby(obj/item/W as obj, mob/user as mob)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/machinery/readybutton/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)

	if(user.stat || machine_stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return

	if(!user.IsAdvancedToolUser())
		return 0

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(usr, "The event has already begun!")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")

// A window that disappears when the ready button is pressed
/obj/structure/window/reinforced/holowindow/disappearing
	name = "Event Window"

//Holocarp

/mob/living/simple_mob/animal/space/carp/holodeck
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_living = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

/mob/living/simple_mob/animal/space/carp/holodeck/Initialize(mapload)
	. = ..()
	set_light(2) //hologram lighting

/mob/living/simple_mob/animal/space/carp/holodeck/proc/set_safety(var/safe)
	if (safe)
		set_iff_factions(MOB_IFF_FACTION_NEUTRAL)
		legacy_melee_damage_lower = 0
		legacy_melee_damage_upper = 0
	else
		set_iff_factions(MOB_IFF_FACTION_CARP)
		legacy_melee_damage_lower = initial(legacy_melee_damage_lower)
		legacy_melee_damage_upper = initial(legacy_melee_damage_upper)

/mob/living/simple_mob/animal/space/carp/holodeck/gib()
	derez() //holograms can't gib

/mob/living/simple_mob/animal/space/carp/holodeck/death()
	..()
	derez()

/mob/living/simple_mob/animal/space/carp/holodeck/proc/derez()
	visible_message("<span class='notice'>\The [src] fades away!</span>")
	qdel(src)

/obj/item/paper/fluff/holodeck/trek_diploma
	name = "paper - Starfleet Academy Diploma"
	info = {"<h2>Starfleet Academy</h2></br><p>Official Diploma</p></br>"}
