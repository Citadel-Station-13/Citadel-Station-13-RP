/obj/effect/pai_hologram
	name = "blank hologram"
	desc = "You shouldn't be seeing this!"

	hit_sound_brute = 'sound/weapons/egloves.ogg'
	hit_sound_burn = 'sound/weapons/egloves.ogg'

	var/mob/living/silicon/pai/owner

/obj/effect/pai_hologram/attackby(obj/item/W, mob/user)
	hologram_destroy(user)

/obj/effect/pai_hologram/attack_hand(mob/user, list/params)
	hologram_destroy(user)

/obj/effect/pai_hologram/proc/hologram_destroy(mob/user)
	user.visible_message(SPAN_WARNING("[user] dissipates the holographic [src.name]"))
	QDEL_NULL(src)

/obj/effect/pai_hologram/Destroy()
	owner.handle_hologram_destroy(src)
	. = ..()
