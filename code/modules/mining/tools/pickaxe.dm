/**
 * mining pickaxe
 *
 * hit rock, mine amount instantly, but has attack delay
 */
/obj/item/pickaxe
	name = "pickaxe"
	desc = "A pickaxe. Hit rocks with it to break them."
	#warn icon stuff
	#warn sound
	#warn w_clsas, force, throw force, etc
	var/mine_sound
	var/clang_sound
	var/tap_sound

	/// currently being used to mine
	var/drilling = FALSE

	/// excavation depth per hit
	var/excavation_depth = EXCAVATION_DEPTH_BASELINE
	/// our pickaxe hardness
	var/excavation_hardness = EXCAVATION_HARDNESS_BASELINE
	/// excavation op flags to use
	var/excavation_flags = EXCAVATION_OP_COURSE | EXCAVATION_OP_PULVERIZING

/obj/item/pickaxe/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Click with help intent to lightly tap the pickaxe on something, and any other intent to strike an object with the pickaxe.")
	if(excavation_flags & EXCAVATION_OP_ABSOLUTE)
		. += SPAN_NOTICE("This pickaxe is unaffected by hardness, but will take longer to mine rocks above its strength.")

// todo: when object damage comes, harm should still damage non rock objects

/obj/item/pickaxe/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	. = ..()
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(user.a_intent == INTENT_HELP)
		if(isitem(target))
			return
		user.visible_message(
			SPAN_NOTICE("[user] lightly taps [src] against [target]."),
			SPAN_NOTICE("You lightly tap [src] against [target].")
		)
		return
	return strike(target, user)? CLICKCHAIN_DO_NOT_PROPAGATE : NONE

/obj/item/pickaxe/proc/strike(atom/target, mob/user)
	set waitfor = FALSE
	if(drilling)
		return FALSE
	if(ismob(target))
		return FALSE
	if(!(target.mine_functionality() & MINE_CAN_EXCAVATE))
		if(isitem(target))
			return FALSE
		user.visible_message(
			SPAN_WARNING("[user] clangs [src] against [target]!"),
			SPAN_WARNING("You loudly clang [src] against [target]!")
		)
		return TRUE
	. = TRUE
	user.setClickCooldown(user.get_attack_speed())
	drilling = TRUE
	mine(target, user, excavation_depth)
	drilling = FALSE

/obj/item/pickaxe/proc/mine(atom/target, mob/user, depth = excavation_depth)
	mine_feedback(target, user)
	target.mine_excavate(depth, excavation_hardness, excavation_flags)

/obj/item/pickaxe/proc/mine_feedback(atom/target, mob/user)
	user.visible_message(
		SPAN_WARNING("[user] chips away at [target] with \the [src]!"),
		SPAN_WARNING("You hit [target] with \the [src], chipping away at it.")
	)

/**
 * archeology pickaxes
 * don't get affected by hardness with depth, but can take longer/shorter due to it.
 */
/obj/item/pickaxe/archeological
	name = "excavation pickaxe"
	desc = "A small, but sharp pickaxe used for precise excavation in archeology."
	excavation_flags = EXCAVATION_OP_ABSOLUTE

/obj/item/pickaxe/archeological/mine(atom/target, mob/user)
	#warn do after
	return ..()

/obj/item/pickaxe/archeological/drill
	name = "excavation drill"
	desc = "A small, but powerful drill used for precise excavation in archeology."

	/// max excavation amount
	var/excavation_depth_max = EXCAVATION_DEPTH_ARCHEOLOGICAL_DRILL

/obj/item/pickaxe/archeological/drill/

#warn hook mousewheel

/obj/item/pickaxe/archeological/drill/mine_feedback(atom/target, mob/user)
	user.visible_message(
		SPAN_WARNING("[user] drills away at [target] with precision."),
		SPAN_WARNING("You drill away at [target] with precision.")
	)
