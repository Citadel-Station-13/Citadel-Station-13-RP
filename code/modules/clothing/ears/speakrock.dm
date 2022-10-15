/obj/item/radio/headset/speak_n_rock
	name = "\improper 'NT'-brand headphones"
	desc = "A set of open-backed headphones emblazened with a corporate logo. Connects to radio networks. Warranty void if used underwater."
	slot_flags = SLOT_EARS
	ear_protection = 0 // set to 0 for now, can change later

	var/headphones_on = FALSE

	worn_render_flags = NONE
	worn_bodytypes = BODYTYPE_TESHARI

	icon = 'icons/modules/clothing/ears/headphones.dmi'
	icon_state   = "headphones-off"
	inhand_state = "headphones-off"


// This is a clone of /obj/item/clothing/ears/earmuffs/headphones/verb/togglemusic()'s functionality.
/obj/item/radio/headset/speak_n_rock/verb/togglemusic()
	set name = "Toggle Headphone Music"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living) || usr.stat)
		return

	var/base_icon = copytext(icon_state,1,(length(icon_state) - 3 + headphones_on))

	headphones_on = !headphones_on
	icon_state = "[base_icon]-[headphones_on ? "on" : "off"]"
	to_chat(usr, SPAN_NOTICE("You turn the music [headphones_on ? "on" : "off"]."))

	if (ismob(loc))
		var/mob/M = loc
		M.update_inv_ears()

/obj/item/radio/headset/speak_n_rock/AltClick(mob/user)
	if(!Adjacent(user))
		return
	else if(!headphones_on)
		togglemusic()
	else
		togglemusic()

//donator item
/obj/item/radio/headset/speak_n_rock/aura
	name = "\improper KNIGHT-brand Melodic headset"
	icon_state = "auraphones_off"
	desc = "A hand-made series of headphones. Featuring a unique, bowman-inspired design, each is made with the individual in mind."
	adhoc_fallback = TRUE
