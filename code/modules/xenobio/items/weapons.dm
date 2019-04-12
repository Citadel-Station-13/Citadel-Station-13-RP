/obj/item/weapon/melee/baton/slime
	name = "slimebaton"
	desc = "A modified stun baton designed to stun slimes and other lesser slimy xeno lifeforms for handling."
	icon_state = "slimebaton"
	item_state = "slimebaton"
	slot_flags = SLOT_BELT
	force = 9
	lightcolor = "#33CCFF"
	origin_tech = list(TECH_COMBAT = 2, TECH_BIO = 2)
	agonyforce = 10	//It's not supposed to be great at stunning human beings.
	hitcost = 48	//Less zap for less cost
	description_info = "This baton will stun a slime or other slime-based lifeform for about five seconds, if hit with it while on."

/obj/item/weapon/melee/baton/slime/attack(mob/living/L, mob/user, hit_zone)
	if(istype(L) && status) // Is it on?
		if(L.mob_class & MOB_CLASS_SLIME) // Are they some kind of slime? (Prommies might pass this check someday).
			if(isslime(L))
				var/mob/living/simple_mob/slime/S = L
				S.slimebatoned(user, 5) // Feral and xenobio slimes will react differently to this.
			else
				L.Weaken(5)

		// Now for prommies.
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.species && H.species.name == SPECIES_PROMETHEAN)
				var/agony_to_apply = 60 - agonyforce
				H.apply_damage(agony_to_apply, HALLOSS)

	..()

/obj/item/weapon/melee/baton/slime/loaded/Initialize()
	bcell = new/obj/item/weapon/cell/device(src)
	update_icon()
	return ..()


// Research borg's version
/obj/item/weapon/melee/baton/slime/robot
	hitcost = 200

/obj/item/weapon/melee/baton/slime/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
	return ..()

/obj/item/weapon/melee/baton/slime/robot/attackby(obj/item/weapon/W, mob/user)
	return

