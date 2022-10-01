
/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = O_LUNGS
	parent_organ = BP_TORSO

/obj/item/organ/internal/lungs/tick_life(dt)
	. = ..()

	var/stabilization = HAS_TRAIT(owner, TRAIT_MECHANICAL_VENTILATION)? 1 : 0

	if(is_bruised())
		if(prob(4))
			spawn()
				owner?.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(8))
			spawn()
				owner?.emote("me", 1, "gasps for air!")
			// cpr helps a tiny bit with lung damage but frankly, L for you!
			owner.AdjustLosebreath(15 - (stabilization * 5))

	// cpr nullifies brainstem requirement
	if(owner.internal_organs_by_name[O_BRAIN] && !stabilization) // As the brain starts having Trouble, the lungs start malfunctioning.
		var/obj/item/organ/internal/brain/Brain = owner.internal_organs_by_name[O_BRAIN]
		if(Brain.get_control_efficiency() <= 0.8)
			if(prob(4 / max(0.1,Brain.get_control_efficiency())))
				spawn()
					owner?.emote("me", 1, "gasps for air!")
				owner.AdjustLosebreath(round(3 / max(0.1,Brain.get_control_efficiency())))

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50)
	bruise()

/obj/item/organ/internal/lungs/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.)
		return

	//Bacterial pneumonia
	if (. >= 1)
		if(prob(5))
			owner.emote("cough")
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("You suddenly feel short of breath and take a sharp, painful breath!",1)
			owner.adjustOxyLoss(30) //Look it's hard to simulate low O2 perfusion okay

/obj/item/organ/internal/lungs/grey
	icon_state = "lungs_grey"

/obj/item/organ/internal/lungs/grey/colormatch/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, .proc/sync_color), 15)

/obj/item/organ/internal/lungs/grey/colormatch/proc/sync_color()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.species.blood_color)
			add_atom_colour(H.species.blood_color, FIXED_COLOUR_PRIORITY)
