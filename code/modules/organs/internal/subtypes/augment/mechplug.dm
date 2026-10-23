/obj/item/organ/internal/augment/mechplug
    name = "mechplug"
	icon_state = ""
	#warn fix icon_state being empty
    desc = "A cybernetic implant that allows a mech pilot to interface with their mech directly, providing enhanced control and feedback."
    organ_tag = O_AUG_MECHPLUG
    parent_organ = BP_HEAD

	var/datum/shieldcall/shieldcall

/obj/item/organ/internal/augment/mechplug/Initialize(mapload)
	shieldcall = new /datum/shieldcall/mechplug
	. = ..() // set ., default return value, to parent call

/obj/item/organ/internal/augment/mechplug/Destroy()
	QDEL_NULL(shieldcall) // destroy and unreference the shieldcall / clear the variable
	return ..() // do parent call

/obj/item/organ/internal/augment/mechplug/handle_organ_mod_special(removed)
	if(removed)
		// being removed
		owner.unregister_shieldcall(shieldcall)
	else
		// being added
		owner.register_shieldcall(shieldcall)
	..()

/datum/shieldcall/mechplug
	low_level_intercept = TRUE

/datum/shieldcall/mechplug/handle_shieldcall(atom/defending, list/shieldcall_args, fake_attack)
	if(fake_attack)
		return
	if(shieldcall_args[SHIELDCALL_ARG_HIT_ZONE] != BP_HEAD)
		return
	var/incoming_damage_type = shieldcall_args[SHIELDCALL_ARG_DAMAGE_TYPE]
	if((incoming_damage_type != DAMAGE_TYPE_BRUTE)&&(incoming_damage_type != DAMAGE_TYPE_BURN))
		return
	if(shieldcall_args[SHIELDCALL_ARG_DAMAGE] < 5)
		return
	shieldcall_args[SHIELDCALL_ARG_DAMAGE] *= 1.05




//code for elevated EMP effects
// if damage type taken location: any = EMP, check folowing
// damage valuse < 5, blurry vision (5 seconds)
// if damage value > 5 and < 30, blurry vision (20 seconds) & confusion (10 seconds)
// if damage value > 30, knock out
