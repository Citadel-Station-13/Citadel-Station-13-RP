/obj/item/robot_builtin/dog_swordtail
	name = "sword tail"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "swordtail"
	desc = "A glowing pink dagger normally attached to the end of a cyborg's tail. It appears to be extremely sharp."
	damage_force = 20 //Takes 5 hits to 100-0
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	throw_force = 0 //This shouldn't be thrown in the first place.
	attack_sound = 'sound/weapons/blade1.ogg'
	attack_verb = list("slashed", "stabbed", "jabbed", "mauled", "sliced")
	w_class = WEIGHT_CLASS_NORMAL
