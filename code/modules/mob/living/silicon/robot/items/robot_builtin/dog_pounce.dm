// todo: this is fucking stupid, rework everything.

/obj/item/robot_builtin/dog_pounce
	name = "pounce"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "pounce"
	desc = "Leap at your target to momentarily stun them."
	damage_force = 0
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	throw_force = 0

/obj/item/robot_builtin/dog_pounce/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/mob/living/silicon/robot/R = user
	R.leap()

/mob/living/silicon/robot/proc/leap()
	if(last_special > world.time)
		to_chat(src, "Your leap actuators are still recharging.")
		return

	if(cell.charge < 1000)
		to_chat(src, "Cell charge too low to continue.")
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(3,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 3) return

	if(last_special > world.time)
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 10
	status_flags |= STATUS_LEAPING
	pixel_y = pixel_y + 10

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at_old(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/mecha/mechstep2.ogg', 50, 1)
	pixel_y = base_pixel_y
	cell.charge -= 750

	sleep(5)

	if(status_flags & STATUS_LEAPING) status_flags &= ~STATUS_LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.species.lightweight == 1)
			H.afflict_paralyze(20 * 3)
			return
	var/armor_block = run_armor_check(T, "melee")
	var/armor_soak = get_armor_soak(T, "melee")
	T.apply_damage(20, DAMAGE_TYPE_HALLOSS,, armor_block, armor_soak)
	if(prob(33))
		T.apply_effect(3, WEAKEN, armor_block)
