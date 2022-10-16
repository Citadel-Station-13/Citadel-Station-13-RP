//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_hats.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEMSIZE_SMALL
	blood_sprite_state = "helmetblood"

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0
	var/image/helmet_light

	drop_sound = 'sound/items/drop/hat.ogg'
// todo: this is an awful way to do it but it works
	unequip_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(istype(user, /mob/living/silicon/robot/drone))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1
	else if(istype(user, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		to_chat(user, "<span class='warning'>You are already wearing a hat.</span>")
	else if(success == 1)
		to_chat(user, "<span class='notice'>You crawl under \the [src].</span>")
	return 1

/obj/item/clothing/head/update_icon(var/mob/user)
	var/mob/living/carbon/human/H
	if(ishuman(user))
		H = user

	if(on)
		// Generate object icon.
		if(!GLOB.light_overlay_cache["[light_overlay]_icon"])
			GLOB.light_overlay_cache["[light_overlay]_icon"] = image(icon = 'icons/obj/light_overlays.dmi', icon_state = "[light_overlay]")
		helmet_light = GLOB.light_overlay_cache["[light_overlay]_icon"]
		add_overlay(helmet_light)

		// Generate and cache the on-mob icon, which is used in update_inv_head().
		var/body_type = (H && H.species.get_bodytype_legacy(H))
		var/cache_key = "[light_overlay][body_type && sprite_sheets[body_type] ? "_[body_type]" : ""]"
		if(!GLOB.light_overlay_cache[cache_key])
			var/use_icon = LAZYACCESS(sprite_sheets,body_type) || 'icons/mob/light_overlays.dmi'
			GLOB.light_overlay_cache[cache_key] = image(icon = use_icon, icon_state = "[light_overlay]")

	else if(helmet_light)
		cut_overlay(helmet_light)
		helmet_light = null

	user.update_inv_head() //Will redraw the helmet with the light on the mob
