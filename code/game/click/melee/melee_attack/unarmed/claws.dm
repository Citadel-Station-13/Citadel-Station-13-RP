/datum/melee_attack/unarmed/claws
	attack_name = "claws"
	verb_past_participle = list("scratched", "clawed", "slashed")
	attack_verb_legacy = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE

/datum/melee_attack/unarmed/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]
	if(!skill)	skill = 1
	attack_damage = clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [T.himself] in the [affecting.name]!</span>")
		return 0

	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user] scratched [target] across [TT.his] cheek!</span>")
				if(3 to 4)
					user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [target]'s [pick("head", "neck")]!</span>") //'with spread claws' sounds a little bit odd, just enough that conciseness is better here I think
				if(5)
					user.visible_message(pick(
						"<span class='danger'>[user] rakes [T.his] [pick(attack_noun)] across [target]'s face!</span>",
						"<span class='danger'>[user] tears [T.his] [pick(attack_noun)] into [target]'s face!</span>",
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] scratched [target]'s [affecting.name]!</span>")
				if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
				if(5)		user.visible_message("<span class='danger'>[user] tears [T.his] [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!</span>")

/datum/melee_attack/unarmed/claws/strong
	attack_name = "strong claws"
	attack_verb_legacy = list("slashed")
	damage = 10
	damage_tier = 3
	damage_mode = DAMAGE_MODE_SHRED | DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE

/datum/melee_attack/unarmed/claws/strong/xeno
	verb_past_participle = list("slashed", "gouged", "stabbed")
	attack_verb_legacy = list("slashed", "gouged", "stabbed")
	damage_tier = 4
	damage = 20

/datum/melee_attack/unarmed/claws/strong/xeno/queen
	verb_past_participle = list("slashed", "gouged", "stabbed", "gored")
	attack_verb_legacy = list("slashed", "gouged", "stabbed", "gored")
	damage = 25

/datum/melee_attack/unarmed/claws/good
	damage = 10

/datum/melee_attack/unarmed/claws/good/venom

/datum/melee_attack/unarmed/claws/good/venom/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	if(target.can_inject(null,FALSE,zone,FALSE))
		target.bloodstr.add_reagent("toxin",2)

/datum/melee_attack/unarmed/claws/shadekin
	var/energy_gain = 3

/datum/melee_attack/unarmed/claws/shadekin/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	user.shadekin_adjust_energy(energy_gain)
