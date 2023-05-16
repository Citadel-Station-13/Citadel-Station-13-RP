/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/stacks.dmi'
	icon_state = "nanopaste"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	amount = 10
	tool_speed = 0.75 //Used in surgery, shouldn't be the same speed as a normal screwdriver on mechanical organ repair.
	w_class = ITEMSIZE_SMALL
	no_variants = FALSE
	var/restoration_external = 5
	var/restoration_internal = 20


/obj/item/stack/nanopaste/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(!isliving(target))
		return ..()
	var/mob/living/L = target
	if (istype(L,/mob/living/silicon/robot))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = L
		if (R.getBruteLoss() || R.getFireLoss())
			if(!can_use(1))
				to_chat(user, SPAN_WARNING("There isn't enough left."))
				return CLICKCHAIN_DO_NOT_PROPAGATE
			if(do_after(user,7 * tool_speed))
				R.adjustBruteLoss(-15)
				R.adjustFireLoss(-15)
				R.update_health()
				use(1)
				user.visible_message("<span class='notice'>\The [user] applied some [src] on [R]'s damaged areas.</span>",\
				"<span class='notice'>You apply some [src] at [R]'s damaged areas.</span>")
		else
			to_chat(user, "<span class='notice'>All [R]'s systems are nominal.</span>")

	if (istype(L,/mob/living/carbon/human))		//Repairing robolimbs
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/external/S = H.get_organ(user.zone_sel.selecting)
		if (S && (S.robotic >= ORGAN_ROBOT))
			if(!S.get_damage())
				to_chat(user, "<span class='notice'>Nothing to fix here.</span>")
			else if(can_use(1))
				user.setClickCooldown(user.get_attack_speed(src))
				if(S.open >= 2)
					if(do_after(user,5 * tool_speed))
						S.heal_damage(restoration_internal, restoration_internal, robo_repair = 1)
				else if(do_after(user,5 * tool_speed))
					S.heal_damage(restoration_external,restoration_external, robo_repair =1)
				H.update_health()
				use(1)
				user.visible_message("<span class='notice'>\The [user] applies some nanite paste on [user != L ? "[L]'s [S.name]" : "[S]"] with [src].</span>",\
				"<span class='notice'>You apply some nanite paste on [user == L ? "your" : "[L]'s"] [S.name].</span>")

/obj/item/stack/nanopaste/advanced
	name = "advanced nanopaste"
	singular_name = "advanced nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery. This swarm is capable of repairing more effectively."
	icon_state = "adv_nanopaste"
	restoration_external = 10
