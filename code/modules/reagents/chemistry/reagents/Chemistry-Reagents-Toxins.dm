/* Toxins, poisons, venoms */

/datum/reagent/toxin/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic, do not eat."
	taste_description = "plastic"
	reagent_state = REAGENT_LIQUID
	color = "#CF3600"
	strength = 5

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	reagent_state = REAGENT_LIQUID
	color = "#792300"
	strength = 10

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	reagent_state = REAGENT_LIQUID
	color = "#003333"
	strength = 10

/datum/reagent/toxin/neurotoxic_protein
	name = "toxic protein"
	id = "neurotoxic_protein"
	description = "A weak neurotoxic chemical commonly found in Sivian fish meat."
	taste_description = "fish"
	reagent_state = REAGENT_LIQUID
	color = "#005555"
	strength = 8
	skin_danger = 0.4

/datum/reagent/toxin/neurotoxic_protein/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(alien != IS_DIONA)
		if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
			step(M, pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		if(prob(20))
			M.adjustBrainLoss(0.1)

//R-UST port
// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/datum/reagent/toxin/hydrophoron
	name = "Hydrophoron"
	id = "hydrophoron"
	description = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 80
	var/fire_mult = 30

/datum/reagent/toxin/hydrophoron/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()
	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(allocated / fire_mult)

/datum/reagent/toxin/hydrophoron/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.take_random_targeted_damage(brute = 0, brute = removed * 0.1) //being splashed directly with hydrophoron causes minor chemical burns
	if(prob(10 * fire_mult))
		M.pl_effects()

/datum/reagent/toxin/hydrophoron/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	if(!istype(target, /turf/simulated))
		return
	var/turf/simulated/T = target
	T.assume_gas(GAS_ID_PHORON, CEILING(allocated / 2, 1), T20C)
	for(var/turf/simulated/floor/target_tile in range(0,T))
		target_tile.assume_gas(GAS_ID_PHORON, allocated / 2, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	. = max(., allocated)

/datum/reagent/toxin/hydrophoron/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(alien == IS_SLIME)
		M.adjust_fire_stacks(removed * 10)
		if(prob(10))
			to_chat(M, "<span class='critical'>You feel something boiling within you!</span>")
			spawn(rand(30, 60))
				M.IgniteMob()

/datum/reagent/toxin/spidertoxin
	name = "Spidertoxin"
	id = "spidertoxin"
	description = "A liquifying toxin produced by giant spiders."
	color = "#2CE893"
	strength = 5

/datum/reagent/toxin/phoron
	name = "Phoron"
	id = "phoron"
	description = "Phoron in its liquid form."
	taste_mult = 1.5
	reagent_state = REAGENT_LIQUID
	color = "#9D14DB"
	strength = 30
	touch_met = 5
	skin_danger = 1

/datum/reagent/toxin/phoron/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()

	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(allocated / 5)

/datum/reagent/toxin/phoron/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	M.adjust_fire_stacks(removed / 5)
	if(alien == IS_VOX || alien == IS_XENOHYBRID)
		return
	M.take_random_targeted_damage(brute = 0, brute = removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(50))
		M.pl_effects()

/datum/reagent/toxin/phoron/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_VOX)
		M.adjustOxyLoss(-100 * removed) //5 oxyloss healed per tick.
		return //You're wasting plasma (a semi-limited chemical) to save someone, so it might as well be somewhat strong.
	if(alien == IS_XENOHYBRID)//They have an organ that uses phoron
		return
	if(alien == IS_SLIME)
		M.adjust_fire_stacks(removed * 3) //Not quite 'converting' it. It's like mixing fuel into a jelly. You get explosive, or at least combustible, jelly.
	..()

/datum/reagent/toxin/phoron/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/turf/simulated/T = target
	if(!istype(T))
		return
	T.assume_gas(GAS_ID_PHORON, allocated, T20C)
	. = max(., allocated)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	taste_description = "almond"
	taste_mult = 0.6
	reagent_state = REAGENT_LIQUID
	color = "#CF3600"
	strength = 20
	metabolism_rate = REM * 2

/datum/reagent/toxin/cyanide/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	M.adjustOxyLoss(20 * removed)
	M.afflict_sleeping(20 * 1)

/datum/reagent/toxin/mold
	name = "Mold"
	id = "mold"
	description = "A mold is a fungus that causes biodegradation of natural materials. This variant contains mycotoxins, and is dangerous to humans."
	taste_description = "mold"
	reagent_state = REAGENT_SOLID
	strength = 5

/datum/reagent/toxin/mold/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	M.adjustToxLoss(strength * removed)
	if(prob(5))
		M.vomit()

/datum/reagent/toxin/mold/miasma
	name = "Miasma"
	id = "miasma"
	description = "A toxic cloud of decay, caused by the rotting of corpses."
	taste_description = "rot and decay"
	reagent_state = REAGENT_GAS
	color = "#006000"
	strength = 10

/datum/reagent/toxin/expired_medicine
	name = "Expired Medicine"
	id = "expired_medicine"
	description = "Some form of liquid medicine that is well beyond its shelf date. Administering it now would cause illness."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	strength = 5
	filtered_organs = list(O_SPLEEN)

/datum/reagent/toxin/expired_medicine/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(prob(5))
		M.vomit()

/datum/reagent/toxin/expired_medicine/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_blood(M, alien, removed * 0.66, metabolism)

/datum/reagent/toxin/stimm	//Homemade Hyperzine
	name = "Stimm"
	id = "stimm"
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a"
	metabolism_rate = REM * 3
	overdose = 10
	strength = 3

/datum/reagent/toxin/stimm/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("twitch", "blink_r", "shiver"))
	if(prob(15))
		M.visible_message("[M] shudders violently.", "You shudder uncontrollably, it hurts.")
		M.take_random_targeted_damage(brute = 6 * removed, brute = 0)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	taste_description = "salt"
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF"
	strength = 0
	overdose = REAGENTS_OVERDOSE
	filtered_organs = list(O_SPLEEN, O_KIDNEYS)

/datum/reagent/toxin/potassium_chloride/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed * 2)

/datum/reagent/toxin/potassium_chloride/legacy_affect_overdose(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath - 10)
			H.adjustOxyLoss(2)
			H.afflict_paralyze(20 * 10)

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery. Not safe to eat!"
	taste_description = "salt"
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF"
	strength = 10
	overdose = 20
	filtered_organs = list(O_SPLEEN, O_KIDNEYS)

/datum/reagent/toxin/potassium_chlorophoride/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.afflict_paralyze(20 * 10)
	if(alien == IS_SLIME)
		M.adjustFireLoss(removed * 3)

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "numbness"
	reagent_state = REAGENT_SOLID
	color = "#669900"
	metabolism_rate = REM
	strength = 3
	mrate_static = TRUE

/datum/reagent/toxin/zombiepowder/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(alien == IS_DIONA)
		return
	M.status_flags |= STATUS_FAKEDEATH
	addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living/carbon, __really_shitty_zombie_powder_shim)), 0.5 SECONDS)
	M.adjustOxyLoss(3 * removed)
	M.afflict_paralyze(20 SECONDS)
	M.silent = max(M.silent, 10)
	M.tod = stationtime2text()

/mob/living/carbon/proc/__really_shitty_zombie_powder_shim()
	if(bloodstr.has_reagent(/datum/reagent/toxin/zombiepowder))
		return
	status_flags &= ~STATUS_FAKEDEATH
	update_mobility()

/datum/reagent/toxin/lichpowder
	name = "Lich Powder"
	id = "lichpowder"
	description = "A stablized nerve agent that puts the subject into a strange state of un-death."
	reagent_state = REAGENT_SOLID
	color = "#666666"
	metabolism_rate = REM * 0.75
	strength = 2
	mrate_static = TRUE

/datum/reagent/toxin/lichpowder/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(alien == IS_DIONA)
		return
	M.status_flags |= STATUS_FAKEDEATH
	addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living/carbon, __really_shitty_lich_powder_shim)), 0.5 SECONDS)
	M.adjustOxyLoss(1 * removed)
	M.silent = max(M.silent, 10)
	M.tod = stationtime2text()

	if(prob(1))
		M.visible_message("[M] wheezes.", "You wheeze sharply... it's cold.")
		M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C - 10)

/mob/living/carbon/proc/__really_shitty_lich_powder_shim()
	if(bloodstr.has_reagent(/datum/reagent/toxin/lichpowder))
		return
	status_flags &= ~STATUS_FAKEDEATH
	update_mobility()

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	id = "fertilizer"
	description = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	reagent_state = REAGENT_LIQUID
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"

/datum/reagent/toxin/fertilizer/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE) //cit change: fertilizer is full of natural easily digestible plant fats
		M.nutrition += removed * 5
		return

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	id = "eznutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	id = "robustharvest"

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	reagent_state = REAGENT_LIQUID
	color = "#49002E"
	strength = 4

/datum/reagent/toxin/plantbgone/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	if(istype(target, /turf/simulated/wall))
		var/turf/simulated/wall/W = target
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message("<span class='notice'>The fungi are completely dissolved by the solution!</span>")

/datum/reagent/toxin/plantbgone/on_touch_obj(obj/target, remaining, allocated, data)
	. = ..()
	var/obj/O = target
	if(istype(O, /obj/effect/plant))
		qdel(O)
	else if(istype(O, /obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.damage_integrity(15, 35)

/datum/reagent/toxin/plantbgone/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/plantbgone/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/pestbgone
	name = "Pest-B-Gone"
	id = "pestbgone"
	description = "A harmful toxic mixture designed to kill insects and pests. Do not ingest!"
	taste_mult = 1
	reagent_state = REAGENT_LIQUID
	color = "#8FB97C"
	strength = 4

/datum/reagent/toxin/pestbgone/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()
	if(istype(target, /mob/living))
		var/mob/living/living_target = target
		if(istype(target, /mob/living/simple_mob/animal/roach))
			living_target.adjustToxLoss(10 * allocated)
			. = max(., allocated)
		else if(istype(target, /mob/living/simple_mob/animal/giant_spider))
			living_target.adjustToxLoss(5 * allocated)
			. = max(., allocated)

/datum/reagent/toxin/pestbgone/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_APIDAEN)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/pestbgone/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_APIDAEN)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/sifslurry
	name = "Sivian Sap"
	id = "sifsap"
	description = "A natural slurry comprised of fluorescent bacteria native to Sif, in the Vir system."
	taste_description = "sour"
	reagent_state = REAGENT_LIQUID
	color = "#C6E2FF"
	strength = 2
	overdose = 20

/datum/reagent/toxin/sifslurry/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA) // Symbiotic bacteria.
		M.nutrition += strength * removed
		return
	else
		M.add_modifier(/datum/modifier/slow_pulse, 30 SECONDS)
	..()

/datum/reagent/toxin/sifslurry/legacy_affect_overdose(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		overdose_mod *= H.species.chemOD_mod
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_SIFSLURRY_OD(removed))
	M.apply_effect(5 * removed, DROWSY, 0, 0)

/datum/reagent/toxin/sifslurry/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_blood(M, alien, removed * 0.7, metabolism)

/datum/reagent/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	reagent_state = REAGENT_LIQUID
	color = "#8E18A9"
	power = 10
	meltdose = 4

/datum/reagent/acid/digestive
	name = "Digestive acid"
	id = "stomacid"
	description = "Some form of digestive slurry."
	taste_description = "vomit"
	reagent_state = REAGENT_LIQUID
	color = "#664330"
	power = 2
	meltdose = 30

/datum/reagent/toxin/chlorine_gas
	name = "Chlorine gas"
	id = "chlorinegas"
	description = "A pungent yellow-green acidic gas."
	taste_description = "bleach"
	reagent_state = REAGENT_GAS
	color = "#c5f72d"

/datum/reagent/thermite/venom
	name = "Pyrotoxin"
	id = "thermite_v"
	description = "A biologically produced compound capable of melting steel or other metals, similarly to thermite."
	taste_description = "sweet chalk"
	reagent_state = REAGENT_SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/venom/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustFireLoss(3 * removed)
	if(M.fire_stacks <= 1.5)
		M.adjust_fire_stacks(0.15)
	if(alien == IS_DIONA)
		return
	if(prob(10))
		to_chat(M,"<span class='warning'>Your veins feel like they're on fire!</span>")
		M.adjust_fire_stacks(0.1)
	else if(prob(5))
		M.IgniteMob()
		to_chat(M,"<span class='critical'>Some of your veins rupture, the exposed blood igniting!</span>")

/datum/reagent/condensedcapsaicin/venom
	name = "Irritant toxin"
	id = "condensedcapsaicin_v"
	description = "A biological agent that acts similarly to pepperspray. This compound seems to be particularly cruel, however, capable of permeating the barriers of blood vessels."
	taste_description = "fire"
	color = "#B31008"
	filtered_organs = list(O_SPLEEN)

/datum/reagent/condensedcapsaicin/venom/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(prob(50))
		M.adjustToxLoss(0.5 * removed)
	if(prob(50))
		M.apply_effect(4, AGONY, 0)
		if(prob(20))
			to_chat(M,"<span class='danger'>You feel like your insides are burning!</span>")
		else if(prob(20))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!","rubs at their eyes!")]</span>")
	else
		M.eye_blurry = max(M.eye_blurry, 10)

/datum/reagent/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	taste_description = "acid"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lexorin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(alien == IS_SLIME)
		M.apply_effect(5, AGONY, 0)
		M.adjustToxLoss(3 * removed)
		if(prob(10))
			to_chat(M, "<span class='warning'>Your cellular mass hardens for a moment.</span>")
			M.afflict_stun(20 * 6)
		return
	if(alien == IS_SKRELL)
		M.take_random_targeted_damage(brute = 2.4 * removed, brute = 0)
		if(M.losebreath < 10)
			M.AdjustLosebreath(1)
	else
		M.take_random_targeted_damage(brute = 3 * removed, brute = 0)
		if(M.losebreath < 15)
			M.AdjustLosebreath(1)

/datum/reagent/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	taste_description = "slime"
	taste_mult = 0.9
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E"

/datum/reagent/mutagen/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(prob(33))
		legacy_affect_blood(M, alien, removed, metabolism)

/datum/reagent/mutagen/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(prob(67))
		legacy_affect_blood(M, alien, removed, metabolism)

/datum/reagent/mutagen/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)

	if(M.isSynthetic())
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(alien == IS_SLIME && prob(25))
			var/color_shift = rand(-100, 100)
			spawn(1)
				if(prob(33))
					if(H.r_skin)
						H.r_skin = max(0, min(255, H.r_skin + color_shift))
					if(H.r_hair)
						H.r_hair = max(0, min(255, H.r_hair + color_shift))
					if(H.r_facial)
						H.r_facial = max(0, min(255, H.r_facial + color_shift))
				if(prob(33))
					if(H.g_skin)
						H.g_skin = max(0, min(255, H.g_skin + color_shift))
					if(H.g_hair)
						H.g_hair = max(0, min(255, H.g_hair + color_shift))
					if(H.g_facial)
						H.g_facial = max(0, min(255, H.g_facial + color_shift))
				if(prob(33))
					if(H.b_skin)
						H.b_skin = max(0, min(255, H.b_skin + color_shift))
					if(H.b_hair)
						H.b_hair = max(0, min(255, H.b_hair + color_shift))
					if(H.b_facial)
						H.b_facial = max(0, min(255, H.b_facial + color_shift))
						return
		if(alien == IS_CHIMERA && prob(33))
			var/color_shift = rand(-100, 100)
			spawn(1)
				if(prob(45))
					if(H.r_skin)
						H.r_skin = max(0, min(255, H.r_skin + color_shift))
					if(H.r_hair)
						H.r_hair = max(0, min(255, H.r_hair + color_shift))
					if(H.r_facial)
						H.r_facial = max(0, min(255, H.r_facial + color_shift))
				if(prob(45))
					if(H.g_skin)
						H.g_skin = max(0, min(255, H.g_skin + color_shift))
					if(H.g_hair)
						H.g_hair = max(0, min(255, H.g_hair + color_shift))
					if(H.g_facial)
						H.g_facial = max(0, min(255, H.g_facial + color_shift))
				if(prob(45))
					if(H.b_skin)
						H.b_skin = max(0, min(255, H.b_skin + color_shift))
					if(H.b_hair)
						H.b_hair = max(0, min(255, H.b_hair + color_shift))
					if(H.b_facial)
						H.b_facial = max(0, min(255, H.b_facial + color_shift))
		if(H.species.species_flags & NO_SCAN)
			return

//The original coder comment here wanted it to be "Approx. one mutation per 10 injected/20 ingested/30 touching units"
//The issue was, it was removed (.2) multiplied by .1, which resulted in a .02% chance per tick to have a mutation occur. Or more accurately, 5000 injected for a single mutation.
//To honor their original idea, let's keep it as 10/20/30 as they wanted... For the most part.

	if(M.dna)
		if(prob(removed * 10)) // Removed is .2 per tick. Multiplying it by 10 makes it a 2% chance per tick. 10 units has 50 ticks, so 10 units injected should give a single good/bad mutation.
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40)) //Additionally, let's make it so there's an 8% chance per tick for a random cosmetic/not guranteed good/bad mutation.
			randmuti(M)//This should equate to 4 random cosmetic mutations per 10 injected/20 ingested/30 touching units
			to_chat(M, "<span class='warning'>You feel odd!</span>")
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_MUTAGEN(removed))

/datum/reagent/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	taste_description = "slime"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	color = "#801E28"

/datum/reagent/slimejelly/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(alien == IS_SLIME) //Partially made of the stuff. Why would it hurt them?
		if(prob(75))
			M.heal_overall_damage(25 * removed, 25 * removed)
			M.adjustToxLoss(rand(-30, -10) * removed)
			M.druggy = max(M.druggy, 10)
			M.ceiling_chemical_effect(CE_PAINKILLER, 60)
	else
		if(prob(10))
			to_chat(M, "<span class='danger'>Your insides are burning!</span>")
			M.adjustToxLoss(rand(100, 300) * removed)
		else if(prob(40))
			M.heal_organ_damage(25 * removed, 0)

/datum/reagent/advmutationtoxin
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin"
	description = "A corruptive toxin produced by slimes. Turns the subject of the chemical into a Promethean."
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E"

/datum/reagent/advmutationtoxin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.get_species_id() != SPECIES_ID_PROMETHEAN)
			to_chat(M, "<span class='danger'>Your flesh rapidly mutates!</span>")

			var/list/backup_implants = list()
			for(var/obj/item/organ/I in H.organs)
				for(var/obj/item/implant/backup/BI in I.contents)
					backup_implants += BI
			if(backup_implants.len)
				for(var/obj/item/implant/backup/BI in backup_implants)
					BI.forceMove(src)

			H.set_species(/datum/species/shapeshifter/promethean)
			H.shapeshifter_set_colour("#05FF9B") //They can still change their color.

			if(backup_implants.len)
				var/obj/item/organ/external/torso = H.get_organ(BP_TORSO)
				for(var/obj/item/implant/backup/BI in backup_implants)
					BI.forceMove(torso)
					torso.implants += BI


/datum/reagent/soporific
	name = "Soporific"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#009CA8"
	metabolism_rate = REM * 0.5
	ingest_met = REM * 1.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/soporific/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return

	var/threshold = 1
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 6	//Evens to 3 due to the fact they are considered 'small' for flaps.

	var/effective_dose = metabolism.total_processed_dose

	if(effective_dose < 1 * threshold)
		if(effective_dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(effective_dose < 1.5 * threshold)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(effective_dose < 5 * threshold)
		if(prob(50))
			M.afflict_paralyze(20 * 2)
		M.drowsyness = max(M.drowsyness, 20)
	else
		if(alien == IS_SLIME) //They don't have eyes, and they don't really 'sleep'. Fumble their general senses.
			M.eye_blurry = max(M.eye_blurry, 30)

			if(prob(20))
				M.ear_deaf = max(M.ear_deaf, 4)
				M.Confuse(2)
			else
				M.afflict_paralyze(20 * 2)
		else
			M.afflict_sleeping(20 * 20)
		M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#000067"
	metabolism_rate = REM * 0.5
	ingest_met = REM * 1.5
	overdose = REAGENTS_OVERDOSE * 0.5
	overdose_mod = 5	//For that good, lethal feeling

/datum/reagent/chloralhydrate/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return

	var/threshold = 1
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 6	//Evens to 3 due to the fact they are considered 'small' for flaps.

	var/effective_dose = metabolism.total_processed_dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose == metabolism)
		M.Confuse(2)
		M.drowsyness += 2
	else if(effective_dose < 2 * threshold)
		M.afflict_paralyze(20 * 30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		if(alien == IS_SLIME)
			if(prob(30))
				M.ear_deaf = max(M.ear_deaf, 4)
			M.eye_blurry = max(M.eye_blurry, 60)
			M.afflict_paralyze(20 * 30)
			M.Confuse(40)
		else
			M.afflict_sleeping(20 * 30)

	if(effective_dose > 1 * threshold)
		M.adjustToxLoss(removed)

/datum/reagent/chloralhydrate/legacy_affect_overdose(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	M.SetLosebreath(10)
	M.adjustOxyLoss(removed * overdose_mod)

/datum/reagent/chloralhydrate/beer2 //disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	taste_description = "beer"
	reagent_state = REAGENT_LIQUID
	color = "#FFD300"

	glass_name = "beer"
	glass_desc = "A freezing pint of beer"

/* Drugs */

/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	taste_description = "bitterness"
	taste_mult = 0.4
	reagent_state = REAGENT_LIQUID
	color = "#60A584"
	metabolism_rate = REM * 0.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/space_drugs/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 15
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8

	if(alien == IS_SLIME)
		drug_strength = drug_strength * 1.2

	M.druggy = max(M.druggy, drug_strength)
	if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && CHECK_MOBILITY(M, MOBILITY_CAN_MOVE))
		step(M, pick(GLOB.cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))

/datum/reagent/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#202040"
	metabolism_rate = REM * 0.25
	overdose = REAGENTS_OVERDOSE

/datum/reagent/serotrotium/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "gasp"))
	return

/datum/reagent/serotrotium/venom
	name = "Serotropic venom"
	id = "serotrotium_v"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans. This appears to be a biologically produced form, resulting in a specifically toxic nature."
	taste_description = "chalky bitterness"
	filtered_organs = list(O_SPLEEN)

/datum/reagent/serotrotium/venom/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(prob(30))
		if(prob(25))
			M.emote(pick("shiver", "blink_r"))
		M.adjustBrainLoss(0.2 * removed)
	return ..()

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#000055"
	metabolism_rate = REM * 0.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/cryptobiolin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	var/drug_strength = 4

	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8

	if(alien == IS_SLIME)
		drug_strength = drug_strength * 1.2

	M.make_dizzy(drug_strength)
	M.Confuse(drug_strength * 5)

/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	filtered_organs = list(O_SPLEEN)

/datum/reagent/impedrezene/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	M.jitteriness = max(M.jitteriness - 5, 0)
	if(prob(80))
		M.adjustBrainLoss(0.1 * removed)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")

/datum/reagent/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#B31008"
	metabolism_rate = REM * 0.25
	overdose = REAGENTS_OVERDOSE

/datum/reagent/mindbreaker/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 100

	if(alien == IS_SKRELL)
		drug_strength *= 0.8

	if(alien == IS_SLIME)
		drug_strength *= 1.2

	M.setHallucination(max(M.hallucination, drug_strength))

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#E700E7"
	overdose = REAGENTS_OVERDOSE
	metabolism_rate = REM * 0.5

/datum/reagent/psilocybin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return

	var/threshold = 1
	if(alien == IS_SKRELL)
		threshold = 1.2

	if(alien == IS_SLIME)
		threshold = 0.8

	M.druggy = max(M.druggy, 30)

	var/effective_dose = metabolism.total_processed_dose

	if(effective_dose < 1 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(effective_dose < 2 * threshold)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))

/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#181818"

/datum/reagent/talum_quem
	name = "Talum-quem"
	id = "talum_quem"
	description = " A very carefully tailored hallucinogen, for use of the Talum-Katish."
	taste_description = "bubblegum"
	taste_mult = 1.6
	reagent_state = REAGENT_LIQUID
	color = "#db2ed8"
	metabolism_rate = REM * 0.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/talum_quem/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return

	var/drug_strength = 29
	if(alien == IS_SKRELL)
		drug_strength = drug_strength * 0.8
	else
		M.adjustToxLoss(10 * removed) //Given incorporations of other toxins with similiar damage, this seems right.

	M.druggy = max(M.druggy, drug_strength)
	if(prob(10) && isturf(M.loc) && !istype(M.loc, /turf/space) && CHECK_MOBILITY(M, MOBILITY_CAN_MOVE))
		step(M, pick(GLOB.cardinal))
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))

/* Transformations */

/datum/reagent/slimetoxin
	name = "Mutation Toxin"
	id = "mutationtoxin"
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E"

/datum/reagent/slimetoxin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.species_flags & NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 10))
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(M)
			to_chat(M, "<span class='warning'>You feel odd!</span>")
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_SLIMETOXIN(removed))

/datum/reagent/aslimetoxin
	name = "Docility Toxin"
	id = "docilitytoxin"
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = REAGENT_LIQUID
	color = "#FF69B4"

/datum/reagent/aslimetoxin/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism) // TODO: check if there's similar code anywhere else
	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.species_flags & NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 10))
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(M)
			to_chat(M, "<span class='warning'>You feel odd!</span>")
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_ASLIMETOXIN(removed))

/*
 * Hostile nanomachines.
 * Now scannable! Removed with shockchems!
 */

/datum/reagent/nanite/shredding
	name = "Shredding Nanites"
	id = "shredding_nanites"
	description = "Nanites meant to stitch wounds togeher repurpose to tear the body apart from the inside out!"
	taste_description = "metal"
	taste_mult = 0.1
	reagent_state = REAGENT_SOLID
	color = "#555555"
	mrate_static = TRUE
	metabolism_rate = 0.01 //Fast no more they stick in you for a long time
	reagent_filter_flags = REAGENT_FILTER_NO_COMMON_BIOANALYSIS
	affects_robots = TRUE

/datum/reagent/nanite/shredding/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustBruteLoss(40 * removed) //Bicaridine can outheal it (unless Metabolism is less then 75%).
	M.adjustOxyLoss(40 * removed)

/datum/reagent/nanite/shredding/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism) //Now they can be used in chemsmoke (Nanite Kill Clouds)
	M.adjustBruteLoss(40 * removed)
	M.adjustOxyLoss(40 * removed)

/datum/reagent/nanite/irradiated
	name = "Irradiated Nanites"
	id = "irradiated_nanites"
	description = "These miniature robots seem to be give off life threatening gamma radiation endangering both the host and those around them."
	taste_description = "metal"
	taste_mult = 0.1
	reagent_state = REAGENT_SOLID
	mrate_static = TRUE
	color = "#555555"
	metabolism_rate = 0.01 //No gimmick you just glow for longer now!
	reagent_filter_flags = REAGENT_FILTER_NO_COMMON_BIOANALYSIS
	affects_robots = TRUE

/datum/reagent/nanite/irradiated/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	// todo: this should be more brutal on people around the person without being too brutal on the person
	// new radiation just kind of scales pretty badly
	/// rads to everyone around you
	radiation_pulse(M, RAD_INTENSITY_CHEM_IRRADIATED_NANITES)
	/// radiate the person a bit just in case they're armored
	M.rad_act(RAD_INTENSITY_CHEM_IRRADIATED_NANITES_SELF)

/datum/reagent/nanite/irradiated/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	radiation_pulse(M, RAD_INTENSITY_CHEM_IRRADIATED_NANITES)
	M.rad_act(RAD_INTENSITY_CHEM_IRRADIATED_NANITES_SELF)

/datum/reagent/nanite/neurophage
	name = "Neurophage Nanites"
	id = "neurophage_nanites"
	description = "Dangerous microscoptic robots that attack the both the brain and the alkysine sent to repair it."
	taste_description = "metal"
	taste_mult = 0.1
	reagent_state = REAGENT_SOLID
	mrate_static = TRUE
	color = "#555555"
	metabolism_rate = 0.01
	reagent_filter_flags = REAGENT_FILTER_NO_COMMON_BIOANALYSIS
	filtered_organs = list(O_SPLEEN)
	affects_robots = TRUE

/datum/reagent/nanite/neurophage/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustBrainLoss(20 * removed)	// Alkysine can outheal it, however since mrate is so slow you need 5 times the Alky to fully heal through it
	M.adjustBruteLoss(20 * removed)
	M.ingested?.remove_reagent(/datum/reagent/alkysine, removed * 10)
	M.bloodstr?.remove_reagent(/datum/reagent/alkysine, removed * 10)

/datum/reagent/nanite/neurophage/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustBrainLoss(20 * removed)
	M.adjustBruteLoss(20 * removed)
	M.ingested?.remove_reagent(/datum/reagent/alkysine, removed * 10)
	M.bloodstr?.remove_reagent(/datum/reagent/alkysine, removed * 10)

/datum/reagent/nanite/heartkill
	name = "Heartkill Nanites"
	id = "heartkill_nanites"
	description = "A simple weaponized nanomachine which enters the bloodstream then begins to clot flow to the heart. ."
	taste_description = "metal"
	taste_mult = 0.1 //Sssshhh you don't want them to know they have been poisoned
	reagent_state = REAGENT_SOLID
	mrate_static = TRUE
	color = "#555555"
	metabolism_rate = 0.01

/datum/reagent/nanite/heartkill/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism) //Damage handled using the heart_attack() proc in heart.dm
	var/mob/living/carbon/human/H = M
	if(istype(H))
		if(prob(5))
			H.heart_attack()

/datum/reagent/nanite/heartkill/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)//Damage handled using the heart_attack() proc in heart.dm
	var/mob/living/carbon/human/H = M
	if(istype(H))
		if(prob(5))
			H.heart_attack()

//Special toxins for solargrubs
//Moved from Chemistry-Reagents-Vore_vr.dm
/datum/reagent/grubshock
	name = "200 V" //in other words a painful shock
	id = "shockchem"
	description = "A liquid that quickly dissapates to deliver a painful shock. It can also disable nanomachines in the body."
	reagent_state = REAGENT_LIQUID
	color = "#E4EC2F"
	metabolism_rate = 2.50
	affects_robots = TRUE

/datum/reagent/grubshock/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.electrocute(0, 10 * removed, 0, ELECTROCUTE_ACT_FLAG_INTERNAL, null)
	for(var/datum/reagent/nanite/path_check in M.ingested.get_reagent_datums())
		M.ingested.remove_reagent(path_check.id, removed * 30)
	for(var/datum/reagent/nanite/path_check in M.bloodstr.get_reagent_datums())
		M.bloodstr.remove_reagent(path_check.id, removed * 30)

/datum/reagent/grubshock/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.electrocute(0, 10 * removed, 0, ELECTROCUTE_ACT_FLAG_INTERNAL, null)
	for(var/datum/reagent/nanite/path_check in M.ingested.get_reagent_datums())
		M.ingested.remove_reagent(path_check.id, removed * 30)
	for(var/datum/reagent/nanite/path_check in M.bloodstr.get_reagent_datums())
		M.bloodstr.remove_reagent(path_check.id, removed * 30)

/datum/reagent/grubshock/on_touch_mob(mob/target, remaining, allocated, data, zone)
	..()
	target.electrocute(0, 10 * allocated, 0, ELECTROCUTE_ACT_FLAG_INTERNAL, null)
	return allocated

//This chem is for removing nanites without grubmeat
/datum/reagent/lessershock
	name = "2 V" //in other words a less painful shock
	id = "lessershock"
	description = "A liquidified Lithium-Iron-Phosphate battery. Can be used to deliver shocks to the body in order to counter hostile nanomachines."
	reagent_state = REAGENT_SOLID
	color = "#E4EC2F"
	metabolism_rate = 2.50

	affects_robots = TRUE

/datum/reagent/lessershock/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.electrocute(0, 5 * removed, 0, ELECTROCUTE_ACT_FLAG_INTERNAL, null)
	for(var/datum/reagent/nanite/path_check in M.ingested.get_reagent_datums())
		M.ingested.remove_reagent(path_check.id, removed)
	for(var/datum/reagent/nanite/path_check in M.bloodstr.get_reagent_datums())
		M.bloodstr.remove_reagent(path_check.id, removed)

/datum/reagent/lessershock/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.electrocute(0, 5 * removed, 0, ELECTROCUTE_ACT_FLAG_INTERNAL, null)
	for(var/datum/reagent/nanite/path_check in M.ingested.get_reagent_datums())
		M.ingested.remove_reagent(path_check.id, removed)
	for(var/datum/reagent/nanite/path_check in M.bloodstr.get_reagent_datums())
		M.bloodstr.remove_reagent(path_check.id, removed)

/datum/reagent/lessershock/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.electrocute(0, 5 * removed, 0, ELECTROCUTE_ACT_FLAG_INTERNAL, null)

/datum/reagent/asbestos //asbestos removal handled in under datum/reagent/respirodaxon
	name = "Asbestos"
	id = "asbestos"
	description = "A silicate made of packed fibrils. Renowned for its insulative properties and for getting permanently stuck in the lungs when inhaled as a powder."
	taste_description = "sharp dust"
	reagent_state = REAGENT_SOLID
	color = "#d8d6d6"
	metabolism_rate = 0.01 // Does not leave your system easily
	mrate_static = TRUE
	reagent_filter_flags = REAGENT_FILTER_NO_COMMON_BIOANALYSIS
	overdose = 10

/datum/reagent/asbestos/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.ingested.add_reagent(/datum/reagent/asbestos, 0.02) //No idea what to do with injected asbestos I will simply say it goes to your lungs faster.

/datum/reagent/asbestos/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	var/mob/living/carbon/human/H = M
	if(prob(2))
		M.emote("cough")
		M.adjustOxyLoss(5)
	if(istype(H))
		if(prob(1))
			H.asbestos_lung()

/datum/reagent/asbestos/legacy_affect_overdose(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	. = ..()
	var/mob/living/carbon/human/H = M
	if(prob(4))
		M.emote("cough")
		M.adjustOxyLoss(10)
	if(istype(H))
		if(prob(1))
			H.asbestos_lung()

/datum/reagent/asbestos/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	var/turf/T = target
	if(allocated >= 20)
		var/location = T
		var/datum/effect_system/smoke_spread/chem/S = new /datum/effect_system/smoke_spread/chem
		S.attach(location)
		var/datum/reagent_holder/copy_holder = new
		copy_holder.add_reagent(id, allocated)
		S.set_up(copy_holder, allocated * 0.05, 0, location) //This ghetto smoke solution is 1/8th as effecient as chemsmoke
		playsound(location, 'sound/effects/smoke.ogg', 50, 1, -3)
		spawn(0)
			S.start()

/datum/reagent/polonium
	name = "Polonium-210"
	id = "polonium"
	description = "An extremely deadly radioactive isotope. Even a microgram is lethal. A nicotine-arithrazine mixture is known to help remove it from the blood and stomach."
	taste_mult = 0	//It would be a rather bad if you could taste this poison
	reagent_state = REAGENT_SOLID
	color = "#A6FAFF"
	metabolism_rate = 0.01 //This is around 100 radiation a tick for a total of 5k radiaion a unit. Use stasis!!!
	mrate_static = TRUE
	reagent_filter_flags = REAGENT_FILTER_NO_COMMON_BIOANALYSIS

/datum/reagent/polonium/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_POL210(removed))

/datum/reagent/polonium/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_POL210(removed))

/datum/reagent/polonium/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	if(allocated >= 3)
		if(!istype(target, /turf/space))
			var/obj/effect/debris/cleanable/greenglow/glow = locate(/obj/effect/debris/cleanable/greenglow, target)
			if(!glow)
				new /obj/effect/debris/cleanable/greenglow(target)

/datum/reagent/superhol
	name = "Superhol"
	id = "superhol"
	description = "A synthetic alcohol that attaches to filtration organs and rapidly induces lethal alcohol poisoning. Treated with hepanephrodaxon and ethylredoxrazine."
	taste_description = "burning alcohol"
	color = "#404030"
	taste_mult = 0.1
	metabolism_rate = 0.01
	mrate_static = TRUE
	reagent_filter_flags = REAGENT_FILTER_NO_COMMON_BIOANALYSIS

/datum/reagent/superhol/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.bloodstr.add_reagent(/datum/reagent/ethanol, removed * 200) //Two Ethanol a tick enough so the drunkeness hits slow enough to be semi plausible
	M.add_chemical_effect(CE_ALCOHOL_TOXIC, 5)
