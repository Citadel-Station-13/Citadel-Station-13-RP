/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	w_class = ITEMSIZE_TINY
	thrown_force_divisor = 1
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = 1
	edge = 1
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	var/loaded      //Descriptive string for currently loaded food object.
	var/scoop_food = 1

/obj/item/material/kitchen/utensil/Initialize(mapload)
	. = ..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)

/obj/item/material/kitchen/utensil/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(!istype(target))
		return ..()

	if(user.a_intent != INTENT_HELP)
		if(user.zone_sel.selecting == BP_HEAD || user.zone_sel.selecting == O_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				target = user
			return eyestab(target,user)
		else
			return ..()

	if (reagents.total_volume > 0)
		reagents.trans_to_mob(target, reagents.total_volume, CHEM_INGEST)
		if(target == user)
			if(!target.can_eat(loaded))
				return
			target.visible_message("<span class='notice'>\The [user] eats some [loaded] from \the [src].</span>")
		else
			user.visible_message("<span class='warning'>\The [user] begins to feed \the [target]!</span>")
			if(!(target.can_force_feed(user, loaded) && do_mob(user, target, 5 SECONDS)))
				return
			target.visible_message("<span class='notice'>\The [user] feeds some [loaded] to \the [target] with \the [src].</span>")
		playsound(target,'sound/items/eatfood.ogg', rand(10,40), 1)
		cut_overlays()
		return
	else
		to_chat(user, "<span class='warning'>You don't have anything on \the [src].</span>")	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"
	sharp = 1
	edge = 0

/obj/item/material/kitchen/utensil/fork/plastic
	material_parts = /datum/material/plastic

/obj/item/material/kitchen/utensil/fork/plasteel
	material_parts = /datum/material/plasteel

/obj/item/material/kitchen/utensil/fork/durasteel
	material_parts = /datum/material/durasteel

/obj/item/material/kitchen/utensil/spoon/plasteel
	material_parts = /datum/material/plasteel

/obj/item/material/kitchen/utensil/spoon/durasteel
	material_parts = /datum/material/durasteel

/obj/item/material/knife/plasteel
	material_parts = /datum/material/plasteel

/obj/item/material/knife/durasteel
	material_parts = /datum/material/durasteel

/obj/item/material/kitchen/rollingpin/plasteel
	material_parts = /datum/material/plasteel

/obj/item/material/kitchen/rollingpin/durasteel
	material_parts = /datum/material/durasteel

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	edge = 0
	sharp = 0
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	material_parts = /datum/material/plastic

/*
 * Knives
 */

/* From the time of Clowns. Commented out for posterity, and sanity.
/obj/item/material/knife/attack(target as mob, mob/living/user as mob)
	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>You accidentally cut yourself with \the [src].</span>")
		user.take_organ_damage(20)
		return
	return ..()
*/
/obj/item/material/knife/plastic
	material_parts = /datum/material/plastic

/*
 * Rolling Pins
 */

/obj/item/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	material_parts = /datum/material/wood
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	dulled_divisor = 0.75	// Still a club
	thrown_force_divisor = 1 // as above
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/material/kitchen/rollingpin/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/L = user
	if(!istype(L))
		return ..()
	if ((MUTATION_CLUMSY in L.mutations) && prob(50))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand and hits your head.</span>")
		L.take_organ_damage(10)
		L.afflict_unconscious(20 * 2)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()
