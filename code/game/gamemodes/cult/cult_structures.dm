/obj/structure/cult
	density = 1
	anchored = 1
	icon = 'icons/obj/cult.dmi'

/obj/structure/cult/cultify()
	return

/obj/structure/cult/talisman
	name = "Altar"
	desc = "A bloodstained altar dedicated to Nar-Sie."
	icon_state = "talismanaltar"


/obj/structure/cult/forge
	name = "Daemon forge"
	desc = "A forge used in crafting the unholy weapons used by the armies of Nar-Sie."
	icon_state = "forge"

/obj/structure/cult/pylon
	name = "Pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	icon_state = "pylon"
	var/isbroken = 0
	light_range = 5
	light_color = "#3e0000"
	var/obj/item/wepon = null

	var/shatter_message = "The pylon shatters!"
	var/impact_sound = 'sound/effects/Glasshit.ogg'
	var/shatter_sound = 'sound/effects/Glassbr3.ogg'

	var/activation_cooldown = 30 SECONDS
	var/last_activation = 0

/obj/structure/cult/pylon/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/cult/pylon/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	attackpylon(user, 5)

/obj/structure/cult/pylon/attack_generic(var/mob/user, var/damage)
	attackpylon(user, damage)

/obj/structure/cult/pylon/attackby(obj/item/W as obj, mob/user as mob)
	attackpylon(user, W.damage_force)

/obj/structure/cult/pylon/inflict_atom_damage(damage, damage_type, damage_tier, damage_flag, damage_mode, hit_zone, attack_type, datum/attack_source)
	pylonhit(damage)
	return damage

/obj/structure/cult/pylon/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	pylonhit(proj.get_structure_damage())

/obj/structure/cult/pylon/proc/pylonhit(var/damage)
	if(!isbroken)
		if(prob(1+ damage * 5))
			visible_message("<span class='danger'>[shatter_message]</span>")
			STOP_PROCESSING(SSobj, src)
			playsound(get_turf(src),shatter_sound, 75, 1)
			isbroken = 1
			density = 0
			icon_state = "[initial(icon_state)]-broken"
			set_light(0)

/obj/structure/cult/pylon/proc/attackpylon(mob/user as mob, var/damage)
	if(!isbroken)
		if(prob(1+ damage * 5))
			user.visible_message(
				"<span class='danger'>[user] smashed \the [src]!</span>",
				"<span class='warning'>You hit \the [src], and its crystal breaks apart!</span>",
				"You hear a tinkle of crystal shards."
				)
			STOP_PROCESSING(SSobj, src)
			user.do_attack_animation(src)
			playsound(get_turf(src),shatter_sound, 75, 1)
			isbroken = 1
			density = 0
			icon_state = "[initial(icon_state)]-broken"
			set_light(0)
		else
			to_chat(user, "You hit \the [src]!")
			playsound(get_turf(src),impact_sound, 75, 1)
	else
		if(prob(damage * 2))
			to_chat(user, "You pulverize what was left of \the [src]!")
			qdel(src)
		else
			to_chat(user, "You hit \the [src]!")
		playsound(get_turf(src),impact_sound, 75, 1)

/obj/structure/cult/pylon/proc/repair(mob/user as mob)
	if(isbroken)
		START_PROCESSING(SSobj, src)
		to_chat(user, "You repair \the [src].")
		isbroken = 0
		density = 1
		icon_state = initial(icon_state)
		set_light(5)

// Returns 1 if the pylon does something special.
/obj/structure/cult/pylon/proc/pylon_unique()
	last_activation = world.time
	return 0

/obj/structure/cult/pylon/process(delta_time)
	if(!isbroken && (last_activation < world.time + activation_cooldown) && pylon_unique())
		flick("[initial(icon_state)]-surge",src)

/obj/structure/cult/tome
	name = "Desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl."
	icon_state = "tomealtar"

//sprites for this no longer exist	-Pete
//(they were stolen from another game anyway)
/*
/obj/structure/cult/pillar
	name = "Pillar"
	desc = "This should not exist"
	icon_state = "pillar"
	icon = 'magic_pillar.dmi'
*/

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back."
	icon = 'icons/obj/cult.dmi'
	icon_state = "hole"
	density = TRUE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE | INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF
	anchored = TRUE
	var/spawnable = null

/obj/effect/gateway/active
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_mob/animal/space/bats,
		/mob/living/simple_mob/creature,
		/mob/living/simple_mob/faithless
	)

/obj/effect/gateway/active/cult
	light_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_mob/animal/space/bats/cult,
		/mob/living/simple_mob/creature/cult,
		/mob/living/simple_mob/faithless/cult
	)

/obj/effect/gateway/active/cult/cultify()
	return

/obj/effect/gateway/active/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(spawn_things)), rand(30, 60) SECONDS)

/obj/effect/gateway/active/proc/spawn_things()
	var/t = pick(spawnable)
	new t(drop_location())
	qdel(src)
