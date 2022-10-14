//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_shoes.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_shoes.dmi',
		)
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	blood_sprite_state = "shoeblood"

	var/can_hold_knife = 0
	var/obj/item/holding

	var/shoes_under_pants = 0

	var/water_speed = 0		//Speed boost/decrease in water, lower/negative values mean more speed
	var/snow_speed = 0		//Speed boost/decrease on snow, lower/negative values mean more speed
	var/rock_climbing = FALSE // If true, allows climbing cliffs with clickdrag.

	var/step_volume_mod = 1	//How quiet or loud footsteps in this shoe are

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	force = 2
	var/overshoes = 0
	species_restricted = list("exclude",SPECIES_TESHARI, SPECIES_VOX)
	drop_sound = 'sound/items/drop/shoes.ogg'
// todo: this is an awful way to do it but it works
	unequip_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'

	//there's a snake in my boot
	var/list/inside_emotes = list()
	var/recent_squish = 0

/obj/item/clothing/shoes/Initialize(mapload)
	. = ..()
	inside_emotes = list(
		"<font color='red'>You feel weightless for a moment as \the [name] moves upwards.</font>",
		"<font color='red'>\The [name] are a ride you've got no choice but to participate in as the wearer moves.</font>",
		"<font color='red'>The wearer of \the [name] moves, pressing down on you.</font>",
		"<font color='red'>More motion while \the [name] move, feet pressing down against you.</font>"
	)

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "IC"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	if(usr.put_in_hands(holding))
		usr.visible_message("<span class='danger'>\The [usr] pulls a knife out of their boot!</span>")
		holding = null
		overlays -= image(icon, "[icon_state]_knife")
	else
		to_chat(usr, "<span class='warning'>Your need an empty, unbroken hand to do that.</span>")
	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	update_icon()

/obj/item/clothing/shoes/attack_hand(var/mob/living/M)
	if(can_hold_knife == 1 && holding && src.loc == M)
		draw_knife()
		return
	..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if((can_hold_knife == 1) && (istype(I, /obj/item/material/shard) || \
	 istype(I, /obj/item/material/butterfly) || \
	 istype(I, /obj/item/material/kitchen/utensil) || \
	 istype(I, /obj/item/storage/box/survival_knife) ||\
	 istype(I, /obj/item/material/knife/stiletto) ||\
	 istype(I, /obj/item/material/knife/tacknife)))
		if(holding)
			to_chat(user, "<span class='warning'>\The [src] is already holding \a [holding].</span>")
			return
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		holding = I
		user.visible_message("<span class='notice'>\The [user] shoves \the [I] into \the [src].</span>")
		verbs |= /obj/item/clothing/shoes/proc/draw_knife
		update_icon()
	else if(istype(I,/obj/item/holder/micro)) //MICROS IN MY SHOES
		var/full = 0
		for(var/mob/M in src)
			full++
		if(full >= 2)
			to_chat(user,"<span class='warning'>You can't fit anyone else into \the [src]!</span>")
		else
			var/obj/item/holder/micro/holder = I
			if(holder.held_mob && (holder.held_mob in holder))
				to_chat(holder.held_mob,"<span class='warning'>[user] stuffs you into \the [src]!</span>")
				holder.held_mob.forceMove(src)
				to_chat(user,"<span class='notice'>You stuff \the [holder.held_mob] into \the [src]!</span>")
	else
		return ..()

/obj/item/clothing/shoes/attack_self(var/mob/user) //gtfo my shoe
	for(var/mob/M in src)
		M.forceMove(get_turf(user))
		to_chat(M,"<span class='warning'>[user] shakes you out of \the [src]!</span>")
		to_chat(user,"<span class='notice'>You shake [M] out of \the [src]!</span>")

	..()

/obj/item/clothing/shoes/verb/toggle_layer()
	set name = "Switch Shoe Layer"
	set category = "Object"

	if(shoes_under_pants == -1)
		to_chat(usr, SPAN_NOTICE("\The [src] cannot be worn under your pants"))
		return
	shoes_under_pants = !shoes_under_pants
	update_icon()

/obj/item/clothing/shoes/update_icon()
	overlays.Cut() //This removes all the overlays on the sprite and then goes down a checklist adding them as required.
	if(blood_DNA)
		add_blood()
	if(holding)
		overlays += image(icon, "[icon_state]_knife")
	if(contaminated)
		overlays += contamination_overlay
	if(gurgled)
		decontaminate()
		gurgle_contaminate()
	if(ismob(usr))
		var/mob/M = usr
		M.update_inv_shoes()
	return ..()

/obj/item/clothing/shoes/clean_blood()
	update_icon()
	return ..()

/obj/item/clothing/shoes/proc/handle_movement(turf/walking, running)
	if(prob(1) && !recent_squish)
		recent_squish = 1
		spawn(100)
			recent_squish = 0
		for(var/mob/living/M in contents)
			var/emote = pick(inside_emotes)
			to_chat(M, emote)
