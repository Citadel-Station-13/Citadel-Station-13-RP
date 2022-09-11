/datum/category_item/catalogue/technology/bot/cleanbot
	name = "Bot - Cleanbot"
	desc = "Cleanbots are little more than stabilized mop buckets \
	on wheels, programmed with basic pathfinding abilities and onboard \
	filth sensors. The cleanbot deploys its mop, utilizing a heavily concentrated\
	Space Cleaner solution which will generally last it an entire shift."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/bot/cleanbot
	name = "Cleanbot"
	desc = "A little cleaning robot, it looks so excited!"
	icon_state = "cleanbot0"
	req_one_access = list(access_robotics, access_janitor)
	botcard_access = list(access_janitor)
	catalogue_data = list(/datum/category_item/catalogue/technology/bot/cleanbot)

	locked = FALSE //Starts unlocked so roboticist can set them to patrol.
	wait_if_pulled = TRUE
	min_target_dist = 0

	var/cleaning = FALSE
	var/wet_floors = FALSE
	var/spray_blood = FALSE
	var/blood = TRUE
	var/list/target_types = list()

/mob/living/bot/cleanbot/Initialize(mapload)
	. = ..()
	get_targets()

/mob/living/bot/cleanbot/handleIdle()
	if(!wet_floors && !spray_blood && prob(2))
		custom_emote(2, "makes an excited booping sound!")
		playsound(src.loc, 'sound/machines/synth_yes.ogg', 50, FALSE)

	if(wet_floors && prob(5)) // Make a mess
		if(istype(loc, /turf/simulated))
			var/turf/simulated/T = loc
			T.wet_floor()

	if(spray_blood && prob(5)) // Make a big mess
		visible_message("Something flies out of [src]. It seems to be acting oddly.")
		var/obj/effect/debris/cleanable/blood/gibs/gib = new /obj/effect/debris/cleanable/blood/gibs(loc)
		// TODO - I have a feeling weakrefs will not work in ignore_list, verify this ~Leshana
		var/datum/weakref/g = WEAKREF(gib)
		ignore_list += g
		spawn(600)
			ignore_list -= g

/mob/living/bot/cleanbot/handlePanic()	// Speed modification based on alert level.
	. = 0
	switch(get_security_level())
		if("green")
			. = 0

		if("yellow")
			. = 1

		if("violet")
			. = 1

		if("orange")
			. = 1

		if("blue")
			. = 2

		if("red")
			. = 2

		if("delta")
			. = 2

	return .

/mob/living/bot/cleanbot/lookForTargets()
	for(var/obj/effect/debris/cleanable/D in view(world.view, src)) // There was some odd code to make it start with nearest decals, it's unnecessary, this works
		if(confirmTarget(D))
			target = D
			return

/mob/living/bot/cleanbot/confirmTarget(var/obj/effect/debris/cleanable/D)
	if(!..())
		return FALSE
	for(var/T in target_types)
		if(istype(D, T))
			return TRUE
	return FALSE

/mob/living/bot/cleanbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/cleanbot/UnarmedAttack(var/obj/effect/debris/cleanable/D, var/proximity)
	if(!..())
		return

	if(!istype(D))
		return

	if(D.loc != loc)
		return

	busy = TRUE
	if(prob(20))
		custom_emote(2, "begins to clean up \the [D]")
	update_icons()
	var/cleantime = istype(D, /obj/effect/debris/cleanable/dirt) ? 10 : 50
	if(do_after(src, cleantime))
		if(istype(loc, /turf/simulated))
			var/turf/simulated/f = loc
			f.dirt = FALSE
		if(!D)
			return
		qdel(D)
		if(D == target)
			target = null
	busy = FALSE
	update_icons()

/mob/living/bot/cleanbot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/reagent_containers/glass/bucket(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/cleanbot/update_icons()
	if(busy)
		icon_state = "cleanbot-c"
	else
		icon_state = "cleanbot[on]"

/mob/living/bot/cleanbot/attack_hand(var/mob/user)
	ui_interact(user)

/mob/living/bot/cleanbot/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cleanbot", name)
		ui.open()

/mob/living/bot/cleanbot/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()
	data["on"] = on
	data["open"] = open
	data["locked"] = locked

	data["blood"] = blood
	data["patrol"] = will_patrol

	data["wet_floors"] = wet_floors
	data["spray_blood"] = spray_blood
	data["version"] = "v2.0"
	return data

/mob/living/bot/cleanbot/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	usr.set_machine(src)

	switch(action)
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
			. = TRUE

		if("blood")
			blood = !blood
			get_targets()
			. = TRUE

		if("patrol")
			will_patrol = !will_patrol
			patrol_path = null
			. = TRUE

		if("wet_floors")
			wet_floors = !wet_floors
			to_chat(usr, SPAN_NOTICE("You twiddle the screw."))
			. = TRUE

		if("spray_blood")
			spray_blood = !spray_blood
			to_chat(usr, SPAN_NOTICE("You press the weird button."))
			. = TRUE

/mob/living/bot/cleanbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!wet_floors || !spray_blood)
		if(user)
			to_chat(user, SPAN_NOTICE("The [src] buzzes and beeps."))
			playsound(src.loc, 'sound/machines/buzzbeep.ogg', 50, FALSE)
		spray_blood = TRUE
		wet_floors = TRUE
		return TRUE

/mob/living/bot/cleanbot/proc/get_targets()
	target_types = list()

	target_types += /obj/effect/debris/cleanable/blood/oil
	target_types += /obj/effect/debris/cleanable/vomit
	target_types += /obj/effect/debris/cleanable/crayon
	target_types += /obj/effect/debris/cleanable/liquid_fuel
	target_types += /obj/effect/debris/cleanable/mucus
	target_types += /obj/effect/debris/cleanable/dirt

	if(blood)
		target_types += /obj/effect/debris/cleanable/blood

/* Assembly */

/obj/item/bucket_sensor
	desc = "It's a bucket. With a sensor attached."
	name = "proxy bucket"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "bucket_proxy"
	force = 3.0
	throw_force = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/created_name = "Cleanbot"

/obj/item/bucket_sensor/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm) || (istype(W, /obj/item/organ/external/arm) && ((W.name == "robotic left arm") || (W.name == "robotic right arm"))))
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		var/turf/T = get_turf(loc)
		var/mob/living/bot/cleanbot/A = new /mob/living/bot/cleanbot(T)
		A.name = created_name
		to_chat(user, "<span class='notice'>You add the robot arm to the bucket and sensor assembly. Beep boop!</span>")
		qdel(src)

	else if(istype(W, /obj/item/stack/material/steel))
		var/obj/item/stack/material/steel/M = W
		if(M.amount >= 5)
			M.use(5)
			var/turf/T = get_turf(loc)
			var/mob/living/bot/cleanbot/roomba/A = new /mob/living/bot/cleanbot/roomba(T)
			A.name = created_name
			to_chat(user, "<span class='notice'>You add the metal sheets onto and around the bucket and sensor assembly. Beep boop!</span>")
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need five sheets of metal to encase the sensor.</span>")

	else if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t

//Port of Roombas and the Roomba Maid from /vg/station.

/mob/living/bot/cleanbot/roomba
	desc = "A small, plate-like cleaning robot. It looks quite concerned."
	icon_state = "roombot0"
	var/created_name = "Roombot"
	var/armed = 0
	var/coolingdown = 0
	var/attackcooldown = 0

/mob/living/bot/cleanbot/roomba/attackby(var/obj/item/W, mob/user)
	if(istype(W, /obj/item/material/kitchen/utensil/fork) && !armed && user.a_intent != INTENT_HARM)
		qdel(W)
		to_chat(user, "<span class='notice'>You attach \the [W] to \the [src]. It looks increasingly concerned about its current situation.</span>")
		armed++
		icon_state = "roombot_battle[on]"
		update_icon_state(src)

	else if(istype(W, /obj/item/flame/lighter) && !armed && user.a_intent != INTENT_HARM)
		qdel(W)
		to_chat(user, "<span class='notice'>You attach \the [W] to \the [src]. It appears to roll its sensor in disappointment before carrying on with its work.</span>")
		armed++
		icon_state = "roombot_battle[on]"
		update_icon_state(src)

	else if (istype(W, /obj/item/clothing/head/headband/maid))
		qdel(W)
		var/mob/living/bot/cleanbot/roomba/meido/M = new(get_turf(src))
		qdel(src)

		if(name != initial(name))
			M.name = name
		else
			name = "maidbot"
	else
		. = ..()

/mob/living/bot/cleanbot/roomba/Crossed(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		annoy(L)
	..()

/mob/living/bot/cleanbot/roomba/proc/attack_cooldown()
	coolingdown = TRUE
	spawn(attackcooldown)
		coolingdown = FALSE

/mob/living/bot/cleanbot/roomba/proc/annoy(var/mob/living/L)
	if(coolingdown == FALSE)
		switch(armed)
			if(1)
				L.visible_message("<span class = 'warning'>\The [src] [pick("prongs","pokes","pricks")] \the [L]", "<span class = 'warning'>The little shit, \the [src], stabs you with its attached fork!</span>")
				var/damage = rand(1,5)
				L.adjustBruteLoss(damage)
			if(2)
				L.visible_message("<span class = 'warning'>\The [src] prongs and singes \the [L]</span>", "<span class = 'warning'>The little shit, \the [src], singes and stabs you with its attached fork and lighter!</span>")
				var/damage = rand(3,12)
				L.adjustBruteLoss(damage)
				L.adjustFireLoss(damage/2)
		attack_cooldown()

/mob/living/bot/cleanbot/roomba/update_icons()
	if(busy)
		icon_state = "roombot-c"
	else
		icon_state = "roombot[on]"

/mob/living/bot/cleanbot/roomba/meido
	name = "maidbot"
	desc = "A small, plate-like cleaning robot. It looks quite concerned. This one has a frilly headband attached to the top."
	icon_state = "maidbot0"
	armed = 0

/mob/living/bot/cleanbot/roomba/meido/attackby(var/obj/item/W, mob/user)
	if(istype(W, /obj/item/material/kitchen/utensil/fork) || istype(W, /obj/item/flame/lighter))
		to_chat(user, "<span class='notice'>\The [src] buzzes and recoils at \the [W]. Perhaps it would prefer something more refined?</span>")
		return
	else if (istype(W, /obj/item/clothing/head/headband/maid))
		to_chat(user, "<span class='notice'>\The [src] is already wearing one of those!</span>")
		return
	else if(W.type == /obj/item/material/knife && !armed && user.a_intent != INTENT_HARM)
		qdel(W)
		to_chat(user, "<span class='notice'>\the [src] extends a tiny arm from a hidden compartment and grasps \the [W]. Its light blinks excitedly for a moment before returning to normal.</span>")
		armed++
		icon_state = "maidbot_battle[on]"
		update_icon_state(src)
	else
		. = ..()

/mob/living/bot/cleanbot/roomba/meido/update_icons()
	if(busy)
		icon_state = "maidbot-c"
	else
		icon_state = "maidbot[on]"

/mob/living/bot/cleanbot/roomba/meido/annoy(var/mob/living/L)
	if(!coolingdown && armed)
		L.visible_message("<span class = 'warning'>\The [src] [pick("jabs","stabs","pokes")] \the [L]", "<span class = 'warning'>The little shit, \the [src], stabs you with its knife!</span>")
		L.adjustBruteLoss(rand(4,8))
	attack_cooldown()
