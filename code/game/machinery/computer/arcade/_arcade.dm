GLOBAL_LIST_INIT(arcade_prize_pool, list(
		/obj/item/storage/box/snappops					= 2,
		/obj/item/toy/blink								= 2,
		/obj/item/clothing/under/syndicate/tacticool	= 2,
		/obj/item/toy/sword								= 2,
		/obj/item/gun/projectile/revolver/capgun		= 2,
		/obj/item/toy/crossbow							= 2,
		/obj/item/clothing/suit/syndicatefake			= 2,
		/obj/item/storage/fancy/crayons					= 2,
		/obj/item/toy/spinningtoy						= 2,
		/obj/item/toy/prize/ripley						= 1,
		/obj/item/toy/prize/fireripley					= 1,
		/obj/item/toy/prize/deathripley					= 1,
		/obj/item/toy/prize/gygax						= 1,
		/obj/item/toy/prize/durand						= 1,
		/obj/item/toy/prize/honk						= 1,
		/obj/item/toy/prize/marauder					= 1,
		/obj/item/toy/prize/seraph						= 1,
		/obj/item/toy/prize/mauler						= 1,
		/obj/item/toy/prize/odysseus					= 1,
		/obj/item/toy/prize/phazon						= 1,
		/obj/item/toy/waterflower						= 1,
		/obj/random/action_figure						= 1,
		/obj/random/plushie								= 1,
		/obj/item/toy/cultsword							= 1,
		/obj/item/toy/bouquet/fake						= 1,
		/obj/item/clothing/accessory/badge/sheriff		= 2,
		/obj/item/clothing/head/cowboy_hat/small		= 2,
		/obj/item/toy/stickhorse						= 2
		))

/obj/machinery/computer/arcade
	name = "random arcade"
	desc = "random arcade machine"
	icon_state = "arcade1"
	icon_keyboard = "no_keyboard"
	icon_screen = null
	light_color = LIGHT_COLOR_GREEN
	var/list/prize_override

/obj/machinery/computer/arcade/proc/Reset()
	return

/obj/machinery/computer/arcade/Initialize(mapload)
	. = ..()
	Reset()

/obj/machinery/computer/arcade/proc/prizevend(mob/user, prizes = 1)
	SEND_SIGNAL(user, COMSIG_ARCADE_PRIZEVEND, user, prizes)
/*
	if(user.mind?.get_skill_level(/datum/skill/gaming) >= SKILL_LEVEL_LEGENDARY && HAS_TRAIT(user, TRAIT_GAMERGOD))
		visible_message("<span class='notice'>[user] inputs an intense cheat code!",\
		"<span class='notice'>You hear a flurry of buttons being pressed.</span>")
		say("CODE ACTIVATED: EXTRA PRIZES.")
		prizes *= 2
*/
	for(var/i = 0, i < prizes, i++)
		//SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "arcade", /datum/mood_event/arcade)
		// if(prob(0.0001)) //1 in a million
		// 	new /obj/item/gun/energy/pulse/prize(src)
		// 	visible_message(
		// 		SPAN_NOTICE("[src] dispenses.. woah, a gun! Way past cool."),
		// 		SPAN_NOTICE("You hear a chime and a shot."))
		// 	//user.client.give_award(/datum/award/achievement/misc/pulse, user)
		// 	return

		var/prizeselect
		if(prize_override)
			prizeselect = pickweight(prize_override)
		else
			prizeselect = pickweight(GLOB.arcade_prize_pool)
		var/atom/movable/the_prize = new prizeselect(get_turf(src))
		playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)
		visible_message(
			SPAN_NOTICE("[src] dispenses [the_prize]!"), \
			SPAN_NOTICE("You hear a chime and a clunk."))

/obj/machinery/computer/arcade/emp_act(severity)
	. = ..()
	var/override = FALSE
	if(prize_override)
		override = TRUE

	if(machine_stat & (NOPOWER|BROKEN)/* || . & EMP_PROTECT_SELF*/)
		return

	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(0,2)
	for(var/i = num_of_prizes; i > 0; i--)
		if(override)
			empprize = pickweight(prize_override)
		else
			empprize = pickweight(GLOB.arcade_prize_pool)
		new empprize(loc)
	explosion(loc, -1, 0, 1+num_of_prizes/*, flame_range = 1+num_of_prizes*/)

/obj/machinery/computer/arcade/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/stack/arcadeticket))
		var/obj/item/stack/arcadeticket/T = O
		var/amount = T.get_amount()
		if(amount <2)
			to_chat(user, SPAN_WARNING("You need 2 tickets to claim a prize!"))
			return
		prizevend(user)
		T.pay_tickets()
		T.update_appearance()
		O = T
		to_chat(user, SPAN_NOTICE("You turn in 2 tickets to \the [src] and claim a prize!"))
		return
