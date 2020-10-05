/obj/item/clothing/accessory/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	slot = ACCESSORY_SLOT_TORSO //Legacy/balance purposes
	concealed_holster = 1
	var/obj/item/holstered = null
	var/list/can_hold //VOREStation Add
	var/list/cant_hold // cit add
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'

/obj/item/clothing/accessory/holster/proc/holster(var/obj/item/I, var/mob/living/user)
	if(holstered && istype(user))
		to_chat(user, "<span class='warning'>There is already \a [holstered] holstered here!</span>")
		return
	//VOREStation Edit - Machete scabbard support
	if (LAZYLEN(can_hold))
		if(!is_type_in_list(I, can_hold) && !is_type_in_list(I, cant_hold))
			to_chat(user, "<span class='warning'>[I] won't fit in [src]!</span>")
			return

	else if (!(I.slot_flags & SLOT_HOLSTER))
	//VOREStation Edit End
		to_chat(user, "<span class='warning'>[I] won't fit in [src]!</span>")
		return

	if(istype(user))
		user.stop_aiming(no_message=1)
	holstered = I
	user.drop_from_inventory(holstered)
	holstered.forceMove(src)
	holstered.add_fingerprint(user)
	w_class = max(w_class, holstered.w_class)
	user.visible_message("<span class='notice'>[user] holsters [holstered].</span>", "<span class='notice'>You holster \the [holstered].</span>")
	name = "occupied [initial(name)]"
	playsound(user, "[sound_in]", 75, 0)

/obj/item/clothing/accessory/holster/proc/clear_holster()
	holstered = null
	name = initial(name)

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		to_chat(user, "<span class='warning'>You need an empty hand to draw \the [holstered]!</span>")
	else
		if(user.a_intent == INTENT_HARM)
			user.visible_message(
				"<span class='danger'>[user] draws \the [holstered], ready to go!</span>", //VOREStation Edit
				"<span class='warning'>You draw \the [holstered], ready to go!</span>" //VOREStation Edit
				)
		else
			user.visible_message(
				"<span class='notice'>[user] draws \the [holstered], pointing it at the ground.</span>",
				"<span class='notice'>You draw \the [holstered], pointing it at the ground.</span>"
				)
		user.put_in_hands(holstered)
		playsound(user, "[sound_out]", 75, 0)
		holstered.add_fingerprint(user)
		w_class = initial(w_class)
		clear_holster()

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit && (slot & ACCESSORY_SLOT_UTILITY))	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	. = ..()
	if (holstered)
		. += "A [holstered] is holstered here."
	else
		. += "It is empty."

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	if(has_suit)
		has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/accessory/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	//can't we just use src here?
	var/obj/item/clothing/accessory/holster/H = null
	if (istype(src, /obj/item/clothing/accessory/holster))
		H = src
	else if (istype(src, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = src
		if (LAZYLEN(S.accessories))
			H = locate() in S.accessories

	if (!H)
		to_chat(usr, "<span class='warning'>Something is very wrong.</span>")

	if(!H.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, "<span class='warning'>You need your gun equipped to holster it.</span>")
			return
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/accessory/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"

/obj/item/clothing/accessory/holster/waist
	name = "waist holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	overlay_state = "holster_low"
	concealed_holster = 0

/obj/item/clothing/accessory/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_hip"
	concealed_holster = 0

/obj/item/clothing/accessory/holster/leg
	name = "leg holster"
	desc = "A tacticool handgun holster. Worn on the upper leg."
	icon_state = "holster_leg"
	overlay_state = "holster_leg"
	concealed_holster = 0

/obj/item/clothing/accessory/holster/machete
	name = "machete scabbard"
	desc = "A handsome synthetic leather scabbard with matching belt."
	icon_state = "holster_machete"
	slot = ACCESSORY_SLOT_WEAPON
	concealed_holster = 0
	can_hold = list(/obj/item/material/knife/machete)
	cant_hold = list(/obj/item/material/knife/machete/armblade)
	sound_in = 'sound/effects/holster/sheathin.ogg'
	sound_out = 'sound/effects/holster/sheathout.ogg'

/obj/item/clothing/accessory/holster/machete/occupied
	var/holstered_spawn = /obj/item/material/knife/machete

/obj/item/clothing/accessory/holster/machete/occupied/Initialize()
	holstered = new holstered_spawn

/obj/item/clothing/accessory/holster/machete/occupied/deluxe
	holstered_spawn = /obj/item/material/knife/machete/deluxe

/obj/item/clothing/accessory/holster/machete/occupied/durasteel
	holstered_spawn = /obj/item/material/knife/machete/deluxe/durasteel

/obj/item/clothing/accessory/holster/waist/kinetic_accelerator
	name = "KA holster"
	desc = "A specialized holster, made specifically for Kinetic Accelerator."
	can_hold = list(/obj/item/gun/energy/kinetic_accelerator)
