
/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = O_LUNGS
	parent_organ = BP_TORSO
	//Baymed addition
	w_class = ITEM_SIZE_NORMAL
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60

	var/active_breathing = 1
	var/has_gills = FALSE
	var/breath_type
	var/exhale_type
	var/list/poison_types

	var/min_breath_pressure
	var/last_int_pressure
	var/last_ext_pressure
	var/max_pressure_diff = 60

	var/oxygen_deprivation = 0
	var/safe_exhaled_max = 6
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/breathing = 0
	var/last_successful_breath
	var/breath_fail_ratio // How badly they failed a breath. Higher is worse.

/obj/item/organ/internal/lungs/process(delta_time)
	..()

	if(!owner)
		return

	if(is_bruised())
		if(prob(4))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(8))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.AdjustLosebreath(15)

	if(owner.internal_organs_by_name[O_BRAIN]) // As the brain starts having Trouble, the lungs start malfunctioning.
		var/obj/item/organ/internal/brain/Brain = owner.internal_organs_by_name[O_BRAIN]
		if(Brain.get_control_efficiency() <= 0.8)
			if(prob(4 / max(0.1,Brain.get_control_efficiency())))
				spawn owner.emote("me", 1, "gasps for air!")
				owner.AdjustLosebreath(round(3 / max(0.1,Brain.get_control_efficiency())))

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50)
	bruise()

/obj/item/organ/internal/lungs/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

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
