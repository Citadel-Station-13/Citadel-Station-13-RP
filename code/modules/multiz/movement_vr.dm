/mob/CheckFall(var/atom/movable/falling_atom)
	return falling_atom.fall_impact(src)

/* //Leaving this here to show my previous iterations which failed.
/mob/living/fall_impact(var/atom/hit_atom) //This is called even when a humanoid falls. Dunno why, it just does.
	if(isliving(hit_atom)) //THIS WEAKENS THE PERSON FALLING & NOMS THE PERSON FALLEN ONTO. SRC is person fallen onto.  hit_atom is the person falling. Confusing.
		var/mob/living/pred = hit_atom
		pred.visible_message("<span class='danger'>\The [pred] falls onto \the [src]! FALL IMPACT MOB</span>")
		pred.Weaken(8) //Stun the person you're dropping onto! You /are/ suffering massive damage for a single stun.
		if(isliving(hit_atom) && isliving(src))
			var/mob/living/prey = src
			if(pred.can_be_drop_pred && prey.can_be_drop_prey) //Is person falling pred & person being fallen onto prey?
				pred.feed_grabbed_to_self_falling_nom(pred,prey)
			else if(prey.can_be_drop_pred && pred.can_be_drop_prey) //Is person being fallen onto pred & person falling prey
				pred.feed_grabbed_to_self_falling_nom(prey,pred) //oh, how the tables have turned.
*/
/mob/zshadow/fall_impact(var/atom/hit_atom, var/damage_min = 0, var/damage_max = 10, var/silent = FALSE, var/planetary = FALSE) //You actually "fall" onto their shadow, first.
	/*
	var/floor_below = src.loc.below //holy fuck
	for(var/mob/M in floor_below.contents)
		if(M && M != src) //THIS WEAKENS THE MOBS YOU'RE FALLING ONTO
			M.visible_message("<span class='danger'>\The [src] drops onto \the [M]! FALL IMPACT SHADOW WEAKEN 8</span>")
			M.Weaken(8)
	*/
/*	if(isliving(hit_atom)) //THIS WEAKENS THE PERSON FALLING & NOMS THE PERSON FALLEN ONTO. SRC is person fallen onto.  hit_atom is the person falling. Confusing.
		var/mob/living/pred = hit_atom
		pred.visible_message("<span class='danger'>\The [hit_atom] falls onto \the [src.owner]!</span>")
		pred.Weaken(8) //Stun the person you're dropping onto! You /are/ suffering massive damage for a single stun.
		var/mob/living/prey = src.owner //The shadow's owner
		if(isliving(prey))
			if(pred.can_be_drop_pred && prey.can_be_drop_prey) //Is person falling pred & person being fallen onto prey?
				pred.feed_grabbed_to_self_falling_nom(pred,prey)
			else if(prey.can_be_drop_pred && pred.can_be_drop_prey) //Is person being fallen onto pred & person falling prey
				pred.feed_grabbed_to_self_falling_nom(prey,pred) //oh, how the tables have turned.
			else
				playsound(loc, "punch", 25, 1, -1)
				prey.Weaken(8) //Just fall onto them if neither of the above apply.
				var/tdamage
				for(var/i = 1 to 10)
					tdamage = rand(0, 10)/2
					pred.adjustBruteLoss(tdamage)
					prey.adjustBruteLoss(tdamage)
				pred.updatehealth()
				prey.updatehealth()
*/
/mob/living/proc/dropped_onto(var/atom/hit_atom)
	if(!isliving(hit_atom))
		return 0

	var/mob/living/pred = hit_atom
	pred.visible_message("<span class='danger'>\The [hit_atom] falls onto \the [src]!</span>")
	pred.Weaken(8)
	var/mob/living/prey = src
	var/fallloc = prey.loc
	if(pred.can_be_drop_pred && prey.can_be_drop_prey)
		pred.feed_grabbed_to_self_falling_nom(pred,prey)
		pred.loc = fallloc
	else if(prey.can_be_drop_pred && pred.can_be_drop_prey)
		prey.feed_grabbed_to_self_falling_nom(prey,pred)
	else
		prey.Weaken(8)
		pred.loc = prey.loc
		playsound(loc, "punch", 25, 1, -1)
		var/tdamage
		for(var/i = 1 to 10)
			tdamage = rand(0, 10)/2
			pred.adjustBruteLoss(tdamage)
			prey.adjustBruteLoss(tdamage)
		pred.updatehealth()
		prey.updatehealth()
	return 1
