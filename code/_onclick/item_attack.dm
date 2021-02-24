/// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	// if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return TRUE
	interact(user)

/**
 * Called on the item before it hits something
 *
 * Arguments:
 * * atom/A - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/obj/item/proc/pre_attack(atom/A, mob/living/user, params) //do stuff before attackby!
	// if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return TRUE
	return FALSE //return TRUE to avoid calling attackby after this proc does stuff

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, params, attack_modifier = 1)
	pre_attack(A, user)
	add_fingerprint(user)
	return A.attackby(src, user, params, attack_modifier)

/**
 * Called on an object being hit by an item
 *
 * Arguments:
 * * obj/item/W - The item hitting this atom
 * * mob/user - The wielder of this item
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */
/atom/proc/attackby(obj/item/W, mob/user, params)
	// if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, params) & COMPONENT_NO_AFTERATTACK)
	// 	return TRUE
	return FALSE

// /atom/movable/attackby(obj/item/W, mob/user, params, attack_modifier)
// 	if(!(W.flags & NOBLUDGEON))
// 		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/obj/attackby(obj/item/I, mob/living/user, params)
	return ..() || (I.attack_obj(src, user)) // (obj_flags & CAN_BE_HIT) &&

/mob/living/attackby(obj/item/I, mob/living/user, params)
	if(..())
		return TRUE
	user.setClickCooldown(get_attack_speed())
	if(can_operate(src) && I.do_surgery(src,user))
		if(I.can_do_surgery(src,user))
			return TRUE
		return FALSE
	if(attempt_vr(src,"vore_attackby",args))
		return FALSE //VOREStation Add - The vore, of course.
	return I.attack(src, user, params)

// Used to get how fast a mob should attack, and influences click delay.
// This is just for inheritence.
/mob/proc/get_attack_speed()
	return DEFAULT_ATTACK_COOLDOWN

// Same as above but actually does useful things.
// W is the item being used in the attack, if any. modifier is if the attack should be longer or shorter than usual, for whatever reason.
/mob/living/get_attack_speed(var/obj/item/W)
	var/speed = base_attack_cooldown
	if(W && istype(W))
		speed = W.attackspeed
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.attack_speed_percent))
			speed *= M.attack_speed_percent
	return speed


/**
 * Called from [/mob/living/proc/attackby]
 *
 * Arguments:
 * * mob/living/M - The mob being hit by this item
 * * mob/living/user - The mob hitting with this item
 * * params - Click params of this attack
 */
/obj/item/proc/attack(mob/living/M, mob/living/user, params)
	// var/signal_return = SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user, params)
	// if(signal_return & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return TRUE
	// if(signal_return & COMPONENT_SKIP_ATTACK)
	// 	return

	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user, params)

	if(item_flags & NOBLUDGEON)
		return

	// if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
	// 	to_chat(user, "<span class='warning'>You don't want to harm other living beings!</span>")
	// 	return

	// if(item_flags & EYE_STAB && user.zone_selected == BODY_ZONE_PRECISE_EYES)
	// 	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
	// 		M = user
	// 	if(eyestab(M,user))
	// 		return
	if(!force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), TRUE, -1)
	else if(hitsound)
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = -1, falloff = 0)

	M.lastattacker = user.real_name
	// M.lastattackerckey = user.ckey
	user.lastattacked = M

	user.do_attack_animation(M)
	M.attacked_by(src, user)

	if(!no_attack_log)
		add_attack_logs(user,M,"attacked with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])")
	add_fingerprint(user)

	var/hit_zone = M.resolve_item_attack(src, user, user.zone_sel.selecting)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone)

/// The equivalent of the standard version of [/obj/item/proc/attack] but for object targets.
/obj/item/proc/attack_obj(obj/O, mob/living/user)
	// if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_OBJ, O, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return
	if(item_flags & NOBLUDGEON)
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(O)
	O.attacked_by(src, user)

/// Called from [/obj/item/proc/attack_obj] and [/obj/item/proc/attack] if the attack succeeds
/atom/movable/proc/attacked_by()
	return

/obj/attacked_by(obj/item/I, mob/living/user)
	if(I.force)
		user.visible_message("<span class='danger'>[user] hits [src] with [I]!</span>", \
					"<span class='danger'>You hit [src] with [I]!</span>", null, 3)
		//only witnesses close by and the victim see a hit message.
		// log_combat(user, src, "attacked", I)
		add_attack_logs(user, src, "attacked with [I]")
	take_damage(I.force, I.damtype, "melee", 1)

/mob/living/attacked_by(obj/item/I, mob/living/user)
	send_item_attack_message(I, user)
	if(I.force)
		apply_damage(I.force, I.damtype)
		if(I.damtype == "brute")
			// if(prob(33))
			// 	I.add_mob_blood(src)
			// 	var/turf/location = get_turf(src)
			// 	add_splatter_floor(location)
			// 	if(get_dist(user, src) <= 1) //people with TK won't get smeared with blood
			// 		user.add_mob_blood(src)
		return TRUE //successful attack

// /mob/living/simple_animal/attacked_by(obj/item/I, mob/living/user)
// 	if(!attack_threshold_check(I.force, I.damtype, MELEE, FALSE))
// 		playsound(loc, 'sound/weapons/tap.ogg', I.get_clamped_volume(), TRUE, -1)
// 	else
// 		return ..()

/**
 * Last proc in the [/obj/item/proc/melee_attack_chain]
 *
 * Arguments:
 * * atom/target - The thing that was hit
 * * mob/user - The mob doing the hitting
 * * proximity_flag - is 1 if this afterattack was called on something adjacent, in your square, or on your person.
 * * click_parameters - is the params string from byond [/atom/proc/Click] code, see that documentation.
 */
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, proximity_flag, click_parameters)

/// Called if the target gets deleted by our attack
/obj/item/proc/attack_qdeleted(atom/target, mob/user, proximity_flag, click_parameters)
	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_QDELETED, target, user, proximity_flag, click_parameters)
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_QDELETED, target, user, proximity_flag, click_parameters)

/obj/item/proc/get_clamped_volume()
	if(w_class)
		if(force)
			return clamp((force + w_class) * 4, 30, 100)// Add the item's force to its weight class and multiply by 4, then clamp the value between 30 and 100
		else
			return clamp(w_class * 6, 10, 100) // Multiply the item's weight class by 6, then clamp the value between 10 and 100

/mob/living/proc/send_item_attack_message(obj/item/I, mob/living/user, hit_area)
	// if(!I.force && !length(I.attack_verb_simple) && !length(I.attack_verb_continuous))
	// 	return
	// var/message_verb_continuous = length(I.attack_verb_continuous) ? "[pick(I.attack_verb_continuous)]" : "attacks"
	// var/message_verb_simple = length(I.attack_verb_simple) ? "[pick(I.attack_verb_simple)]" : "attack"
	// var/message_hit_area = ""
	// if(hit_area)
	// 	message_hit_area = " in the [hit_area]"
	// var/attack_message_spectator = "[src] [message_verb_continuous][message_hit_area] with [I]!"
	// var/attack_message_victim = "You're [message_verb_continuous][message_hit_area] with [I]!"
	// var/attack_message_attacker = "You [message_verb_simple] [src][message_hit_area] with [I]!"
	// if(user in viewers(src, null))
	// 	attack_message_spectator = "[user] [message_verb_continuous] [src][message_hit_area] with [I]!"
	// 	attack_message_victim = "[user] [message_verb_continuous] you[message_hit_area] with [I]!"
	// if(user == src)
	// 	attack_message_victim = "You [message_verb_simple] yourself[message_hit_area] with [I]"
	// visible_message("<span class='danger'>[attack_message_spectator]</span>",
	// 	"<span class='userdanger'>[attack_message_victim]</span>", null, 3, user)
	// to_chat(user, "<span class='danger'>[attack_message_attacker]</span>")
	return 1

//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	user.break_cloak()
	if(hitsound)
		playsound(loc, hitsound, 50, 1, -1)

	var/power = force
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			power *= M.outgoing_melee_damage_percent

	if(HULK in user.mutations)
		power *= 2

	return target.hit_with_weapon(src, user, power, hit_zone)
