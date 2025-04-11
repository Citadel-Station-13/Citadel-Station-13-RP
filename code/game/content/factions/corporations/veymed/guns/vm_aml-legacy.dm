/obj/item/storage/secure/briefcase/ml3m_pack_med
	name = "\improper AML \'Medigun\' kit"
	desc = "A storage case for a multi-purpose healing gun. Variety hour!"
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/secure/briefcase/ml3m_pack_med/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/microbattery/vm_aml(src)
	new /obj/item/ammo_magazine/microbattery/vm_aml(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/brute(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/burn(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/stabilize(src)

/obj/item/storage/secure/briefcase/ml3m_pack_cmo
	name = "\improper Advanced AML \'Medigun\' kit"
	desc = "A storage case for a multi-purpose healing gun. Variety hour!"
	w_class = WEIGHT_CLASS_NORMAL
	max_single_weight_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/secure/briefcase/ml3m_pack_cmo/legacy_spawn_contents()
	new /obj/item/gun/projectile/ballistic/microbattery/vm_aml/sidearm/advanced(src)
	new /obj/item/ammo_magazine/microbattery/vm_aml/sidearm/advanced(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/brute(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/burn(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/stabilize(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/toxin(src)
	new /obj/item/ammo_casing/microbattery/vm_aml/omni(src)

// todo: all this will need to use /datum/medigun_cell's

/obj/item/ammo_casing/microbattery/vm_aml
	name = "\'AML\' nanite cell - UNKNOWN"
	desc = "A miniature nanite fabricator for a medigun."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)
	icon_state = "ml3m_batt"
	origin_tech = list(TECH_BIO = 2, TECH_MATERIAL = 1, TECH_MAGNETS = 2)

/obj/projectile/beam/medical_cell
	name = "\improper healing beam"
	icon_state = "medbeam"
	nodamage = 1
	damage_force = 0
	damage_flag = ARMOR_LASER
	light_color = "#80F5FF"

	combustion = FALSE

	legacy_muzzle_type = /obj/effect/projectile/muzzle/medigun
	legacy_tracer_type = /obj/effect/projectile/tracer/medigun
	legacy_impact_type = /obj/effect/projectile/impact/medigun

/obj/projectile/beam/medical_cell/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(ishuman(target))
		on_hit_legacy(target)

/obj/projectile/beam/medical_cell/proc/on_hit_legacy(var/mob/living/carbon/human/target) //what does it do when it hits someone?
	return

/obj/item/ammo_casing/microbattery/vm_aml/brute
	name = "\'AML\' nanite cell - BRUTE"
	microbattery_group_key = "brute"
	microbattery_mode_color = "#BF0000"
	microbattery_mode_name = "<span style='color:#BF0000;font-weight:bold;'>BRUTE</span>"
	projectile_type = /obj/projectile/beam/medical_cell/brute

/obj/projectile/beam/medical_cell/brute/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-10)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/burn
	name = "\'AML\' nanite cell - BURN"
	microbattery_group_key = "burn"
	microbattery_mode_color = "#FF8000"
	microbattery_mode_name = "<span style='color:#FF8000;font-weight:bold;'>BURN</span>"
	projectile_type = /obj/projectile/beam/medical_cell/burn

/obj/projectile/beam/medical_cell/burn/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustFireLoss(-10)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/stabilize
	name = "\'AML\' nanite cell - STABILIZE" //Disinfects all open wounds, cures oxy damage
	microbattery_group_key = "stabilize"
	microbattery_mode_color = "#0080FF"
	microbattery_mode_name = "<span style='color:#0080FF;font-weight:bold;'>STABILIZE</span>"
	projectile_type = /obj/projectile/beam/medical_cell/stabilize

/obj/projectile/beam/medical_cell/stabilize/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustOxyLoss(-30)
		for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
			var/obj/item/organ/external/O = target.organs_by_name[name]
			for (var/datum/wound/W as anything in O.wounds)
				if (W.internal)
					continue
				W.disinfect()
		target.add_modifier(/datum/modifier/stabilize, 20 SECONDS)
	else
		return 1

/datum/modifier/stabilize
	name = "stabilize"
	desc = "Your injuries are stabilized and your pain abates!"
	mob_overlay_state = "cyan_sparkles"
	stacks = MODIFIER_STACK_EXTEND
	pain_immunity = TRUE
	bleeding_rate_percent = 0.1 //only a little
	incoming_oxy_damage_percent = 0

/obj/item/ammo_casing/microbattery/vm_aml/toxin
	name = "\'AML\' nanite cell - TOXIN"
	microbattery_group_key = "tox"
	microbattery_mode_color = "#00A000"
	microbattery_mode_name = "<span style='color:#00A000;font-weight:bold;'>TOXIN</span>"
	projectile_type = /obj/projectile/beam/medical_cell/toxin

/obj/projectile/beam/medical_cell/toxin/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-10)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/omni
	name = "\'AML\' nanite cell - OMNI"
	microbattery_group_key = "omni"
	microbattery_mode_color = "#8040FF"
	microbattery_mode_name = "<span style='color:#8040FF;font-weight:bold;'>OMNI</span>"
	projectile_type = /obj/projectile/beam/medical_cell/omni

/obj/projectile/beam/medical_cell/omni/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-2.5)
		target.adjustFireLoss(-2.5)
		target.adjustToxLoss(-2.5)
		target.adjustOxyLoss(-20)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/antirad
	name = "\'AML\' nanite cell - ANTIRAD"
	microbattery_group_key = "antirad"
	microbattery_mode_color = "#008000"
	microbattery_mode_name = "<span style='color:#008000;font-weight:bold;'>ANTIRAD</span>"
	projectile_type = /obj/projectile/beam/medical_cell/antirad

/obj/projectile/beam/medical_cell/antirad/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-2.5)
		target.cure_radiation(RAD_MOB_CURE_STRENGTH_MEDIGUN)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/brute2
	name = "\'AML\' nanite cell - BRUTE-II"
	microbattery_group_key = "brute-2"
	microbattery_mode_color = "#BF0000"
	microbattery_mode_name = "<span style='color:#BF0000;font-weight:bold;'>BRUTE-II</span>"
	projectile_type = /obj/projectile/beam/medical_cell/brute2

/obj/projectile/beam/medical_cell/brute2/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-20)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/burn2
	name = "\'AML\' nanite cell - BURN-II"
	microbattery_group_key = "burn-2"
	microbattery_mode_color = "#FF8000"
	microbattery_mode_name = "<span style='color:#FF8000;font-weight:bold;'>BURN-II</span>"
	projectile_type = /obj/projectile/beam/medical_cell/burn2

/obj/projectile/beam/medical_cell/burn2/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustFireLoss(-20)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/stabilize2
	name = "\'AML\' nanite cell - STABILIZE-II" //Disinfects and bandages all open wounds, cures all oxy damage
	microbattery_group_key = "stabilize-2"
	microbattery_mode_color = "#0080FF"
	microbattery_mode_name = "<span style='color:#0080FF;font-weight:bold;'>STABILIZE-II</span>"
	projectile_type = /obj/projectile/beam/medical_cell/stabilize2

/obj/projectile/beam/medical_cell/stabilize2/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustOxyLoss(-200)
		for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
			var/obj/item/organ/external/O = target.organs_by_name[name]
			for (var/datum/wound/W as anything in O.wounds)
				if(W.internal)
					continue
				if(O.is_bandaged() == FALSE)
					W.bandage()
				if(O.is_salved() == FALSE)
					W.salve()
				W.disinfect()
		target.add_modifier(/datum/modifier/stabilize, 20 SECONDS)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/omni2
	name = "\'AML\' nanite cell - OMNI-II"
	microbattery_group_key = "omni-2"
	microbattery_mode_color = "#8040FF"
	microbattery_mode_name = "<span style='color:#8040FF;font-weight:bold;'>OMNI-II</span>"
	projectile_type = /obj/projectile/beam/medical_cell/omni2

/obj/projectile/beam/medical_cell/omni2/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-5)
		target.adjustFireLoss(-5)
		target.adjustToxLoss(-5)
		target.adjustOxyLoss(-30)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/toxin2
	name = "\'AML\' nanite cell - TOXIN-II"
	microbattery_group_key = "tox-2"
	microbattery_mode_color = "#00A000"
	microbattery_mode_name = "<span style='color:#00A000;font-weight:bold;'>TOXIN-II</span>"
	projectile_type = /obj/projectile/beam/medical_cell/toxin2

/obj/projectile/beam/medical_cell/toxin2/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-20)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/haste
	name = "\'AML\' nanite cell - HASTE"
	microbattery_group_key = "haste"
	microbattery_mode_color = "#FF3300"
	microbattery_mode_name = "<span style='color:#FF3300;font-weight:bold;'>HASTE</span>"
	projectile_type = /obj/projectile/beam/medical_cell/haste

/obj/projectile/beam/medical_cell/haste/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.add_modifier(/datum/modifier/medigunhaste, 20 SECONDS)
	else
		return 1

/datum/modifier/medigunhaste
	name = "haste"
	desc = "You can move much faster!"
	mob_overlay_state = "haste"
	stacks = MODIFIER_STACK_EXTEND
	slowdown = -0.5 //a little faster!
	evasion = 1.15 //and a little harder to hit!

/obj/item/ammo_casing/microbattery/vm_aml/resist
	name = "\'AML\' nanite cell - RESIST"
	microbattery_group_key = "resist"
	microbattery_mode_color = "#555555"
	microbattery_mode_name = "<span style='color:#555555;font-weight:bold;'>RESIST</span>"
	projectile_type = /obj/projectile/beam/medical_cell/resist

/obj/projectile/beam/medical_cell/resist/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.add_modifier(/datum/modifier/resistance, 20 SECONDS)
	else
		return 1

/datum/modifier/resistance
	name = "resistance"
	desc = "You resist 15% of all incoming damage and stuns!"
	mob_overlay_state = "repel_missiles"
	stacks = MODIFIER_STACK_EXTEND
	disable_duration_percent = 0.85
	incoming_damage_percent = 0.85

/obj/item/ammo_casing/microbattery/vm_aml/corpse_mend
	name = "\'AML\' nanite cell - CORPSE MEND"
	microbattery_group_key = "corpsemend"
	microbattery_mode_color = "#669900"
	microbattery_mode_name = "<span style='color:#669900;font-weight:bold;'>CORPSE MEND</span>"
	projectile_type = /obj/projectile/beam/medical_cell/corpse_mend

/obj/projectile/beam/medical_cell/corpse_mend/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		if(target.stat == DEAD)
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
			target.adjustToxLoss(-50)
			target.adjustOxyLoss(-200)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/brute3
	name = "\'AML\' nanite cell - BRUTE-III"
	microbattery_group_key = "brute-3"
	microbattery_mode_color = "#BF0000"
	microbattery_mode_name = "<span style='color:#BF0000;font-weight:bold;'>BRUTE-III</span>"
	projectile_type = /obj/projectile/beam/medical_cell/brute3

/obj/projectile/beam/medical_cell/brute3/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-40)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/burn3
	name = "\'AML\' nanite cell - BURN-III"
	microbattery_group_key = "burn-3"
	microbattery_mode_color = "#FF8000"
	microbattery_mode_name = "<span style='color:#FF8000;font-weight:bold;'>BURN-III</span>"
	projectile_type = /obj/projectile/beam/medical_cell/burn3

/obj/projectile/beam/medical_cell/burn3/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustFireLoss(-40)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/toxin3
	name = "\'AML\' nanite cell - TOXIN-III"
	microbattery_group_key = "tox-3"
	microbattery_mode_color = "#00A000"
	microbattery_mode_name = "<span style='color:#00A000;font-weight:bold;'>TOXIN-III</span>"
	projectile_type = /obj/projectile/beam/medical_cell/toxin3

/obj/projectile/beam/medical_cell/toxin3/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustToxLoss(-40)
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/omni3
	name = "\'AML\' nanite cell - OMNI-III"
	microbattery_group_key = "omni-3"
	microbattery_mode_color = "#8040FF"
	microbattery_mode_name = "<span style='color:#8040FF;font-weight:bold;'>OMNI-III</span>"
	projectile_type = /obj/projectile/beam/medical_cell/omni3

/obj/projectile/beam/medical_cell/omni3/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.adjustBruteLoss(-10)
		target.adjustFireLoss(-10)
		target.adjustToxLoss(-10)
		target.adjustOxyLoss(-60)
	else
		return 1

// Illegal cells!
/obj/item/ammo_casing/microbattery/vm_aml/shrink
	name = "\'AML\' nanite cell - SHRINK"
	microbattery_group_key = "size-shrink"
	microbattery_mode_color = "#910ffc"
	microbattery_mode_name = "<span style='color:#910ffc;font-weight:bold;'>SHRINK</span>"
	projectile_type = /obj/projectile/beam/medical_cell/shrink

/obj/projectile/beam/medical_cell/shrink/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.resize(0.5)
		target.show_message("<font color=#4F49AF>The beam fires into your body, changing your size!</font>")
		target.updateicon()
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/grow
	name = "\'AML\' nanite cell - GROW"
	microbattery_group_key = "size-grow"
	microbattery_mode_color = "#fc0fdc"
	microbattery_mode_name = "<span style='color:#fc0fdc;font-weight:bold;'>GROW</span>"
	projectile_type = /obj/projectile/beam/medical_cell/grow

/obj/projectile/beam/medical_cell/grow/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.resize(2.0)
		target.show_message("<font color=#4F49AF>The beam fires into your body, changing your size!</font>")
		target.updateicon()
	else
		return 1

/obj/item/ammo_casing/microbattery/vm_aml/normalsize
	name = "\'AML\' nanite cell - NORMALSIZE"
	microbattery_group_key = "size-normal"
	microbattery_mode_color = "#C70FEC"
	microbattery_mode_name = "<span style='color:#C70FEC;font-weight:bold;'>NORMALSIZE</span>"
	projectile_type = /obj/projectile/beam/medical_cell/normalsize

/obj/projectile/beam/medical_cell/normalsize/on_hit_legacy(var/mob/living/carbon/human/target)
	if(istype(target, /mob/living/carbon/human))
		target.resize(1)
		target.show_message("<font color=#4F49AF>The beam fires into your body, changing your size!</font>")
		target.updateicon()
	else
		return 1
