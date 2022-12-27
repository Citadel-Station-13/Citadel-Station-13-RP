/obj/item/kinetic_crusher
	name = "proto-kinetic lance"
	desc = "An experimental lance utilizing kinetic blasts."
	icon = 'icons/modules/mining/tools/crusher.dmi'
	icon_state = "crusher"
	#warn icon fuckery, onmob, UGH


/obj/item/kinetic_crusher/proc/recharge()

/obj/item/kinetic_crusher/proc/can_mark(atom/A)

/obj/item/kinetic_crusher/proc/mark(atom/A)

/obj/item/kinetic_crusher/proc/detonate_mark(atom/A)

/obj/item/kinetic_crusher/proc/bolt(atom/target, turf/source = get_turf(src), angle = get_physics_angle(source, target), mob/shooter = worn_mob())

#warn icons, stats

/obj/item/kinetic_crusher/dagger
	name = "proto-kinetic dagger"
	desc = "A newer prototype provided to mining and salvage divisions, the NT-PKL series trades the classic design of 'barrel towards target' for more close range capabilitiy. \
	This diverse weapon has been the subject of much controversy - with many users stating that it is 'the dagger of choice for those with no self preservation.' \
	Due to most models being too small to fit standard issue cells, PKL-series weaponry charge from the kinetic energy of a user's motion."

/obj/item/kinetic_crusher/axe
	name = "proto-kinetic crusher"
	desc = "An older prototype in the NT-PKL series, as bulky as it is powerful compared to the newer pocket-tools oft provided to miners. \
	Packs quite a harder punch, but is practically unusable without taking up both of a person's hands."

/obj/item/kineitc_crusher/glaive
	name = "proto-kinetic glaive"
	desc = "<i>Now</i> they've gone too far. This thing obviously transcends the line of 'plausibly a tool' flatly over to 'quite obviously a weapon of kinetic destruction'."

/**
 * base type of kinetic crusher modules
 *
 * crusher modules can never be duplicated on the same crusher
 */
/obj/item/crusher_upgrade
	name = "kinetic lance upgrade"
	desc = "An upgrade for the NT-PKL series of mining 'tools'."
	#warn icon
	icon = 'icons/modules/mining/tools/crusher.dmi'
	icon_state = "upgrade"
	/// the crusher we're installed on
	var/obj/item/kinetic_crusher/crusher
	/// conflicts with other upgrades of this type
	var/conflict_type

/**
 * shows as "[our name] - [description()]"
 */
/obj/item/crusher_upgrade/proc/description()

/obj/item/crusher_upgrade/proc/conflicts(obj/item/crusher_upgrade/other, obj/item/kinetic_crusher/crusher, mob/user)

/obj/item/crusher_upgrade/proc/can_attach(obj/item/kinetic_crusher/crusher)
	return TRUE

/obj/item/crusher_upgrade/proc/on_attach(obj/item/kinetic_crusher/crusher, mob/user)

/obj/item/crusher_upgrade/proc/on_detach(obj/item/kinetic_crusher/crusher, mob/user)

/obj/item/crusher_upgrade/proc/on_mark_detonation(atom/A, mob/user)

/obj/item/crusher_upgrade/proc/on_mark(atom/A, mob/user)

/obj/item/crusher_upgrade/proc/on_mark_loss(atom/A)

/obj/item/crusher_upgrade/proc/on_mark_refresh(atom/A, mob/user, old_time, new_time)

/obj/item/crusher_upgrade/proc/on_mark_check(atom/A, mob/user)

/obj/item/crusher_upgrade/proc/on_bolt_impact(atom/A, mob/user)

/obj/item/crusher_upgrade/proc/on_bolt_fire(atom/target, obj/item/projectile/destabilizer/bolt, mob/user)

/obj/item/crusher_upgrade/proc/on_attack(atom/target, mob/user)

#warn upgrade limitation system? we don't want cost, but...

#warn upgrade: trade concussive to direct damage
#warn upgrade: resonator chain?
#warn upgrade: slightly weaker but faster bolt?
#warn upgrade: faster charge but weaker bolt?
#warn upgrade: slower charge but stronger bolt?
#warn upgrade: trade damage for more disruption + mining?
#warn upgrade: stacking marks?
#warn upgrade: hierophant blast :drooling:
