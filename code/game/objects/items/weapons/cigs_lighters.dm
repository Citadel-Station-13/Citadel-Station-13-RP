//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CUSTOM CIGS
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//For anything that can light stuff on fire
/obj/item/flame
	waterproof = FALSE
	var/lit = FALSE

/obj/item/flame/proc/extinguish(mob/user, no_message)
	lit = FALSE
	damtype = "brute"
	STOP_PROCESSING(SSobj, src)

/obj/item/flame/water_act(depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)


/obj/item/flame/is_hot()
	return lit

///////////
//MATCHES//
///////////
/obj/item/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = FALSE
	var/smoketime = 5
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/flame/match/process(delta_time)
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(submerged() || smoketime < 1)
		extinguish()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/flame/match/dropped(mob/user)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		spawn(0)
			var/turf/location = src.loc
			if(istype(location))
				location.hotspot_expose(700, 5)
			extinguish()
	return ..()

/obj/item/flame/match/extinguish(mob/user, no_message)
	. = ..()
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt match"
	desc = "A match. This one has seen better days."
	burnt = TRUE

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = NONE
	waterproof = FALSE

	var/lit = FALSE
	var/icon_on
	var/type_butt = null
	var/chem_volume = 0
	var/max_smoketime = 0 //Related to sprites
	var/smoketime = 0
	var/is_pipe = FALSE	// Prevents a runtime with pipes
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/brand
	blood_sprite_state = null //Can't bloody these

/obj/item/clothing/mask/smokable/Initialize(mapload)
	. = ..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15
	if(smoketime && !max_smoketime)
		max_smoketime = smoketime

/obj/item/clothing/mask/smokable/proc/smoke(amount)
	if(smoketime > max_smoketime)
		smoketime = max_smoketime
	smoketime -= amount
	if(reagents && reagents.total_volume) // check if it has any reagents at all
		if(ishuman(loc))
			var/mob/living/carbon/human/C = loc
			if(src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2) // Most of it is not inhaled... balance reasons.
		else // else just remove some of the reagents
			reagents.remove_any(REM)

/obj/item/clothing/mask/smokable/process(delta_time)
	var/turf/location = get_turf(src)
	smoke(1)
	if(submerged() || smoketime < 1)
		extinguish()
		return
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/clothing/mask/smokable/update_icon()
	if(lit)
		icon_state = "[initial(icon_state)]_on"
		item_state = "[initial(item_state)]_on"
	else if(smoketime < max_smoketime)
		if(is_pipe)
			icon_state = initial(icon_state)
			item_state = initial(item_state)
		else
			icon_state = "[initial(icon_state)]_burnt"
			item_state = "[initial(item_state)]_burnt"
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_l_hand(0)
		M.update_inv_r_hand(1)
	..()

/obj/item/clothing/mask/smokable/examine(mob/user)
	. = ..()
	if(is_pipe)
		return
	var/smoke_percent = round((smoketime / max_smoketime) * 100)
	switch(smoke_percent)
		if(90 to INFINITY)
			. += "[src] is still fresh."
		if(60 to 90)
			. += "[src] has a good amount of burn time remaining."
		if(30 to 60)
			. += "[src] is about half finished."
		if(10 to 30)
			. += "[src] is starting to burn low."
		else
			. += "[src] is nearly burnt out!"

/obj/item/clothing/mask/smokable/water_act(var/depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)


/obj/item/clothing/mask/smokable/proc/light(flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		if(submerged())
			to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
			return
		src.lit = TRUE
		damtype = "fire"
		if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect_system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		update_icon()
		set_light(2, 0.25, "#E38F46")
		START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/proc/extinguish(mob/user, no_message)
	lit = FALSE
	damtype = "brute"
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	update_icon()

/obj/item/clothing/mask/smokable/extinguish(mob/user, no_message)
	var/turf/T = get_turf(src)
	set_light(0)
	STOP_PROCESSING(SSobj, src)
	if(type_butt)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		if(brand)
			butt.desc += " This one is \a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out."))
			M.remove_from_mob(src) //un-equip it so the overlays can update
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		qdel(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if(ismob(loc))
			var/mob/living/M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
			lit = FALSE
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
			smoketime = 0
			reagents.clear_reagents()
			name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		to_chat(H, SPAN_NOTICE("You take a drag on your [name]."))
		smoke(5)
		return TRUE
	return ..()

/obj/item/clothing/mask/smokable/attackby(obj/item/W, mob/user)
	..()
	if(W.is_hot())
		var/text = matchmes
		if(istype(W, /obj/item/flame/match))
			text = matchmes
		else if(istype(W, /obj/item/flame/lighter/zippo))
			text = zippomes
		else if(istype(W, /obj/item/flame/lighter))
			text = lightermes
		else if(istype(W, /obj/item/weldingtool))
			text = weldermes
		else if(istype(W, /obj/item/assembly/igniter))
			text = ignitermes
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/attack(mob/living/M, mob/living/user, def_zone)
	if(istype(M) && M.on_fire)
		user.do_attack_animation(M)
		light(SPAN_NOTICE("[user] coldly lights the [name] with the burning body of [M]."))
		return TRUE
	else
		return ..()

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cig"
	item_state = "cig"
	throw_speed = 0.5
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	type_butt = /obj/item/cigbutt
	chem_volume = 15
	max_smoketime = 300
	smoketime = 300
	var/nicotine_amt = 2
	matchmes = SPAN_NOTICE("USER lights their NAME with their FLAME.")
	lightermes = SPAN_NOTICE("USER manages to light their NAME with FLAME.")
	zippomes = SPAN_ROSE("With a flick of their wrist, USER lights their NAME with their FLAME.")
	weldermes = SPAN_NOTICE("USER casually lights the NAME with FLAME.")
	ignitermes = SPAN_NOTICE("USER fiddles with FLAME, and manages to light their NAME.")

/obj/item/clothing/mask/smokable/cigarette/Initialize(mapload)
	. = ..()
	if(nicotine_amt)
		reagents.add_reagent("nicotine", nicotine_amt)

/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/I, mob/user)
	..()

	if(istype(I, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = I
		if(S.active)
			light(SPAN_WARNING("[user] swings their [I], barely missing their nose. They light their [name] in the process."))

	return

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user, proximity)
	..()
	if(!proximity)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, SPAN_NOTICE("You dip \the [src] into \the [glass]."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user)
	if(lit == TRUE)
		if(user.a_intent == INTENT_HARM)
			user.visible_message(SPAN_NOTICE("[user] drops and treads on the lit [src], putting it out instantly."))
			extinguish(no_message = TRUE)
		else
			user.visible_message(SPAN_NOTICE("[user] puts out \the [src]."))
			extinguish()
	return ..()

/obj/item/clothing/mask/smokable/cigarette/import
	name = "cigarette"
	desc = "A roll of tobacco and blended herbs."
	icon_state = "cigimp"
	item_state = "cigimp"
	throw_speed = 0.5
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	type_butt = /obj/item/cigbutt/imp
	chem_volume = 15
	max_smoketime = 300
	smoketime = 300
	nicotine_amt = 2

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2"
	type_butt = /obj/item/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigar"
	max_smoketime = 1500
	smoketime = 1500
	chem_volume = 20
	nicotine_amt = 4
	matchmes = SPAN_NOTICE("USER lights their NAME with their FLAME.")
	lightermes = SPAN_NOTICE("USER manages to offend their NAME by lighting it with FLAME.")
	zippomes = SPAN_ROSE("With a flick of their wrist, USER lights their NAME with their FLAME.")
	weldermes = SPAN_NOTICE("USER insults NAME by lighting it with FLAME.")
	ignitermes = SPAN_NOTICE("USER fiddles with FLAME, and manages to light their NAME with the power of science.")

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2"
	nicotine_amt = 7

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2"
	max_smoketime = 7200
	smoketime = 7200
	chem_volume = 30
	nicotine_amt = 10

/obj/item/clothing/mask/smokable/cigarette/cigar/taj
	name = "S'rendarr's Hand"
	desc = "A Tajaran smokable herb similar to tobacco, produced at one of the countless plantations on Adhomai. It is known to have medicinal properties."
	icon_state = "cigar3"

/obj/item/clothing/mask/smokable/cigarette/cigar/taj/Initialize(mapload)
	. = ..()
	if(nicotine_amt)
		reagents.add_reagent("bicaridine", nicotine_amt)

/obj/item/clothing/mask/smokable/cigarette/cigar/taj/premium
	name = "S'rendarr's Own"
	desc = "A premium Tajaran cigar, licensed for export by Confederate Commonwealth of Adhomai representing the best product of all Tajaran nations."
	icon_state = "cigar2"
	nicotine_amt = 7

/obj/item/clothing/mask/smokable/cigarette/cigar/taj/premium/Initialize(mapload)
	. = ..()
	if(nicotine_amt)
		reagents.add_reagent("bicaridine", nicotine_amt)

/obj/item/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 1

/obj/item/cigbutt/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	transform = turn(transform,rand(0,360))

/obj/item/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/I, mob/user)
	..()

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/cigbutt/imp
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon_state = "cigimpbutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Made of fine, stained cherry wood."
	icon_state = "pipe"
	item_state = "pipe"
	smoketime = 0
	chem_volume = 50
	matchmes = SPAN_NOTICE("USER lights their NAME with their FLAME.")
	lightermes = SPAN_NOTICE("USER manages to light their NAME with FLAME.<")
	zippomes = SPAN_ROSE("With much care, USER lights their NAME with their FLAME.")
	weldermes = SPAN_NOTICE("USER recklessly lights NAME with FLAME.")
	ignitermes = SPAN_NOTICE("USER fiddles with FLAME, and manages to light their NAME with the power of science.")
	is_pipe = TRUE

/obj/item/clothing/mask/smokable/pipe/Initialize(mapload)
	. = ..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user)
	if(lit == 1)
		if(user.a_intent == INTENT_HARM)
			user.visible_message(SPAN_NOTICE("[user] empties the lit [src] on the floor!."))
			extinguish(no_message = TRUE)
		else
			user.visible_message(SPAN_NOTICE("[user] puts out \the [src]."))
			extinguish()

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/melee/energy/sword))
		return

	..()

	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = I
		if(!G.dry)
			to_chat(user, SPAN_NOTICE("[G] must be dried before you stuff it into [src]."))
			return
		if(smoketime)
			to_chat(user, SPAN_NOTICE("[src] is already packed."))
			return
		max_smoketime = 1000
		smoketime = 1000
		if(G.reagents)
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		name = "[G.name]-packed [initial(name)]"
		qdel(G)

	else if(istype(I, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = I
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to light their [name] with [I]."))

	else if(istype(I, /obj/item/flame/match))
		var/obj/item/flame/match/M = I
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [I]."))

	else if(istype(I, /obj/item/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [I], and manages to light their [name] with the power of science."))

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipe"
	item_state = "cobpipe"
	chem_volume = 35

///////////////
//CUSTOM CIGS//
///////////////
//and by custom cigs i mean craftable joints. smoke weed every day

/obj/item/clothing/mask/smokable/cigarette/joint
	name = "joint"
	desc = "This probably shouldn't ever show up."
	icon_state = "joint"
	max_smoketime = 500
	smoketime = 500
	nicotine_amt = 0

/obj/item/clothing/mask/smokable/cigarette/blunt
	name = "blunt"
	desc = "This probably shouldn't ever show up."
	icon_state = "blunt"
	max_smoketime = 750
	smoketime = 750
	nicotine_amt = 0

/obj/item/rollingpaper
	name = "rolling paper"
	desc = "A small, thin piece of easily flammable paper, commonly used for rolling and smoking various dried plants."
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	icon_state = "cig paper"

/obj/item/rollingpaper/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = I
		if(!G.dry)
			to_chat(user, SPAN_NOTICE("[G] must be dried before you roll it into [src]."))
			return
		var/obj/item/clothing/mask/smokable/cigarette/joint/J = new /obj/item/clothing/mask/smokable/cigarette/joint(user.loc)
		to_chat(usr, SPAN_NOTICE("You roll the [G.name] into a joint!"))
		J.add_fingerprint(user)
		if(G.reagents)
			G.reagents.trans_to_obj(J, G.reagents.total_volume)
		J.name = "[G.name] joint"
		J.desc = "A joint lovingly rolled and filled with [G.name]. Blaze it."
		qdel(G)
		qdel(src)

/obj/item/rollingblunt
	name = "blunt paper"
	desc = "A small, thin piece of tobacco-based paper, commonly used for rolling and smoking various dried plants."
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	icon_state = "blunt paper"

/obj/item/rollingblunt/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = W
		if (!G.dry)
			to_chat(user, "<span class='notice'>[G] must be dried before you roll it into [src].</span>")
			return
		var/obj/item/clothing/mask/smokable/cigarette/blunt/B = new /obj/item/clothing/mask/smokable/cigarette/blunt(user.loc)
		to_chat(usr,"<span class='notice'>You roll the [G.name] into a blunt!</span>")
		B.add_fingerprint(user)
		if(G.reagents)
			G.reagents.trans_to_obj(B, G.reagents.total_volume)
		B.name = "[G.name] blunt"
		B.desc = "A blunt lovingly rolled and filled with [G.name]. Blaze it."
		qdel(G)
		qdel(src)


/////////
//ZIPPO//
/////////
/obj/item/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = ITEMSIZE_TINY
	throwforce = 4
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/base_state

/obj/item/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon = 'icons/obj/zippo.dmi'
	icon_state = "zippo"
	item_state = "zippo"

/obj/item/flame/lighter/random/Initialize(mapload)
	. = ..()
	icon_state = "lighter-[pick("r","c","y","g")]"
	item_state = icon_state
	base_state = icon_state

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(submerged())
		to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
		return
	if(!base_state)
		base_state = icon_state
	if(!lit)
		lit = TRUE
		icon_state = "[base_state]on"
		item_state = "[base_state]on"
		if(istype(src, /obj/item/flame/lighter/zippo) )
			user.visible_message(SPAN_ROSE("Without even breaking stride, [user] flips open and lights [src] in one smooth movement."))
			playsound(loc, "sound/items/zippo_open.ogg", 75, TRUE, -1)
		else
			if(prob(95))
				user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light \the [src]."))
			else
				to_chat(user, SPAN_WARNING("You burn yourself while lighting the lighter."))
				if(user.get_left_hand() == src)
					user.apply_damage(2, BURN, "l_hand")
				else
					user.apply_damage(2, BURN, "r_hand")
				user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light the [src], they however burn their finger in the process."))

		set_light(2)
		START_PROCESSING(SSobj, src)
	else
		lit = FALSE
		icon_state = "[base_state]"
		item_state = "[base_state]"
		if(istype(src, /obj/item/flame/lighter/zippo) )
			user.visible_message(SPAN_ROSE("You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing."))
			playsound(loc, "sound/items/zippo_close.ogg", 75, TRUE, -1)
		else
			user.visible_message(SPAN_NOTICE("[user] quietly shuts off the [src]."))

		set_light(0)
		STOP_PROCESSING(SSobj, src)
	return


/obj/item/flame/lighter/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M, /mob))
		return

	if(lit == 1)
		M.IgniteMob()
		add_attack_logs(user,M,"Lit on fire with [src]")

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == O_MOUTH && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/flame/lighter/zippo))
				cig.light(SPAN_ROSE("[user] whips the [name] out and holds it for [M]."))
			else
				cig.light(SPAN_NOTICE("[user] holds the [name] out for [M], and lights the [cig.name]."))
	else
		..()

/obj/item/flame/lighter/process(delta_time)
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

//Here we add Zippo skins.

/obj/item/flame/lighter/zippo/black
	name = "\improper holy Zippo lighter"
	desc = "Only in regards to Christianity, that is."
	icon_state = "blackzippo"

/obj/item/flame/lighter/zippo/blue
	name = "\improper blue Zippo lighter"
	icon_state = "bluezippo"

/obj/item/flame/lighter/zippo/engraved
	name = "\improper engraved Zippo lighter"
	icon_state = "engravedzippo"
	item_state = "zippo"

/obj/item/flame/lighter/zippo/gold
	name = "\improper golden Zippo lighter"
	icon_state = "goldzippo"

/obj/item/flame/lighter/zippo/moff
	name = "\improper moth Zippo lighter"
	desc = "Too cute to be a Tymisian."
	icon_state = "moffzippo"

/obj/item/flame/lighter/zippo/red
	name = "\improper red Zippo lighter"
	icon_state = "redzippo"

/obj/item/flame/lighter/zippo/ironic
	name = "\improper ironic Zippo lighter"
	desc = "What a quiant idea."
	icon_state = "ironiczippo"

/obj/item/flame/lighter/zippo/capitalist
	name = "\improper capitalist Zippo lighter"
	desc = "Made of gold and obsidian, this is truly not worth however much you spent on it."
	icon_state = "cappiezippo"

/obj/item/flame/lighter/zippo/communist
	name = "\improper communist Zippo lighter"
	desc = "All you need to spark a revolution."
	icon_state = "commiezippo"

/obj/item/flame/lighter/zippo/royal
	name = "\improper royal Zippo lighter"
	desc = "An incredibly fancy lighter, gilded and covered in the color of royalty."
	icon_state = "royalzippo"

/obj/item/flame/lighter/zippo/gonzo
	name = "\improper Gonzo Zippo lighter"
	desc = "A lighter with the iconic Gonzo fist painted on it."
	icon_state = "gonzozippo"

/obj/item/flame/lighter/zippo/rainbow
	name = "\improper rainbow Zippo lighter"
	icon_state = "rainbowzippo"

/obj/item/flame/lighter/zippo/cowgirl
	name = "\improper Cyan Cowgirl Zippo lighter"
	icon_state = "cowzippo"

/obj/item/flame/lighter/zippo/bullet
	name = "\improper bullet lighter"
	desc = "A lighter fashioned out of an old bullet casing."
	icon_state = "bulletlighter"

/obj/item/flame/lighter/zippo/taj
	name = "\improper Adhomai lighter"
	desc = "A brass mechanical lighter made on Adhomai. Its robust design made it a staple tool for Tajara on all sides of the civil war."
	icon_state = "tajzippo"
