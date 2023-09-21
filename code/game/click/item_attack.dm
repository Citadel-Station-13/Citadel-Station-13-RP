//! the below call sequence is no longer accurate
//! converted code goes into items.dm
//! this is a legacy file because i don't want to rewrite the entire click system in one go
/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.

Mobs:

mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, params, attack_modifier = 1, clickchain_flags)
	if(!(atom_flags & NOPRINT))
		add_fingerprint(user)
	return A.attackby(src, user, params, clickchain_flags, attack_modifier)

// No comment
/atom/proc/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	return I.standard_melee_attack(src, user, clickchain_flags, params, damage_multiplier, user.zone_sel?.selecting, user.a_intent)

/mob/living/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(can_operate(src) && user.a_intent != INTENT_HARM && I.do_surgery(src,user))
		return NONE
	if(attempt_vr(src,"vore_attackby",args))
		return
	return I.standard_melee_attack(src, user, clickchain_flags, params, damage_multiplier, user.zone_sel?.selecting, user.a_intent)

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
