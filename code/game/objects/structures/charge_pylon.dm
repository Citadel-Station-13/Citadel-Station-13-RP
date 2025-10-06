/obj/structure/adherent_pylon
	name = "electron reservoir"
	desc = "A tall, crystalline pylon that pulses with electricity."
	icon = 'icons/obj/machines/adherent.dmi'
	icon_state = "pedestal"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/next_use

/obj/structure/adherent_pylon/examine(mob/user, dist)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.species.get_species_id() != SPECIES_ID_ADHERENT)
		. += "It seems to be throbbing with energy, touching it might be a bad idea."

/obj/structure/adherent_pylon/attack_ai(var/mob/living/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/adherent_pylon/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	charge_user(user)

/obj/structure/adherent_pylon/proc/charge_user(var/mob/living/user)
	if(next_use > world.time) return
	next_use = world.time + 10
	var/mob/living/carbon/human/H = user

	user.setClickCooldownLegacy(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='warning'>There is a loud crack and the smell of ozone as \the [user] touches \the [src].</span>")

	playsound(loc, 'sound/effects/snap.ogg', 50, 1)

	if(istype(H) && H.species.get_species_id() == SPECIES_ID_ADHERENT && H.nutrition < H.species.max_nutrition)
		H.nutrition = 400
		return
	log_and_message_admins("has touched the adherent pylon", user)
	if(isrobot(user))
		user.apply_damage(80, DAMAGE_TYPE_BURN, def_zone = BP_TORSO)
		visible_message("<span class='danger'>Electricity arcs off [user] as it touches \the [src]!</span>")
		to_chat(user, "<span class='danger'><b>You detect damage to your components!</b></span>")
	else if(istype(H) && H.species.get_species_id() != SPECIES_ID_ADHERENT)
		user.electrocute(0, 85, hit_zone = BP_TORSO, source = src)
		visible_message("<span class='danger'>\The [user] has been shocked by \the [src]!</span>")
	user.throw_at_old(get_step(user,get_dir(src,user)), 5, 10)

/obj/structure/adherent_pylon/Bumped(atom/AM)
	. = ..()
	if(ishuman(AM))
		charge_user(AM)

/turf/simulated/floor/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_state = ""
	initial_flooring = /datum/prototype/flooring/crystal
