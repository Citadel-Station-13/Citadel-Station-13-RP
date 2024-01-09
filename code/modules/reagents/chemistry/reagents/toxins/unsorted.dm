/* Toxins, poisons, venoms */

/datum/reagent/toxin
	name = "toxin"
	id = "toxin"
	description = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	reagent_state = REAGENT_LIQUID
	color = "#CF3600"
	bloodstream_metabolism_multiplier = 0.25 // 0.05 by default. Hopefully enough to get some help, or die horribly, whatever floats your boat
	filtered_organs = list(O_LIVER, O_KIDNEYS)
	var/strength = 4 // How much damage it deals per unit
	var/skin_danger = 0.2 // The multiplier for how effective the toxin is when making skin contact.

/datum/reagent/toxin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(strength && !entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		if(issmall(entity)) removed *= 2 // Small bodymass, more effect from lower volume.
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			removed *= 0.25 // Results in half the standard tox as normal. Prometheans are 'Small' for flaps.
			if(dose >= 10)
				entity.nutrition += strength * removed //Body has to deal with the massive influx of toxins, rather than try using them to repair.
			else
				entity.heal_organ_damage((10/strength) * removed, (10/strength) * removed) //Doses of toxins below 10 units, and 10 strength, are capable of providing useful compounds for repair.
		entity.adjustToxLoss(strength * removed)

/datum/reagent/toxin/affect_touch(mob/living/carbon/entity, alien, removed)
	affect_blood(M, alien, removed * 0.2)

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

/datum/reagent/toxin/neurotoxic_protein/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(!entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		if(CHECK_MOBILITY(entity, MOBILITY_CAN_MOVE) && istype(entity.loc, /turf/space))
			step(entity, pick(GLOB.cardinal))
		if(prob(5))
			entity.emote(pick("twitch", "drool", "moan"))
		if(prob(20))
			entity.adjustBrainLoss(0.1)

//R-UST port
// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/datum/reagent/toxin/hydrophoron
	name = "Hydrophoron"
	id = "hydrophoron"
	description = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 80
	var/fire_mult = 30

/datum/reagent/toxin/hydrophoron/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / fire_mult)

/datum/reagent/toxin/hydrophoron/affect_touch(mob/living/carbon/M, alien, removed)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with hydrophoron causes minor chemical burns
	if(prob(10 * fire_mult))
		M.pl_effects()

/datum/reagent/toxin/hydrophoron/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	T.assume_gas(GAS_ID_PHORON, CEILING(volume/2, 1), T20C)
	for(var/turf/simulated/floor/target_tile in range(0,T))
		target_tile.assume_gas(GAS_ID_PHORON, volume/2, 400+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	remove_self(volume)

/datum/reagent/toxin/hydrophoron/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.adjust_fire_stacks(removed * 10)
		if(prob(10))
			to_chat(entity, "<span class='critical'>You feel something boiling within you!</span>")
			spawn(rand(30, 60))
				entity.IgniteMob()

/datum/reagent/toxin/spidertoxin
	name = "Spidertoxin"
	id = "spidertoxin"
	description = "A liquifying toxin produced by giant spiders."
	color = "#2CE893"
	strength = 5

/datum/reagent/toxin/phoron
	// todo: reagent traits, this shouldn't be a toxin subtype.
	name = "Phoron"
	id = "phoron"
	description = "Phoron in its liquid form."
	taste_mult = 1.5
	reagent_state = REAGENT_LIQUID
	color = "#9D14DB"
	strength = 30
	touch_met = 5
	skin_danger = 1

/datum/reagent/toxin/phoron/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/toxin/phoron/affect_touch(mob/living/carbon/M, alien, removed)
	..()
	M.adjust_fire_stacks(removed / 5)
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_VOX)] || alien == IS_XENOHYBRID)
		return
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(50))
		M.pl_effects()

/datum/reagent/toxin/phoron/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_VOX)])
		entity.adjustOxyLoss(-100 * removed) //5 oxyloss healed per tick.
		return //You're wasting plasma (a semi-limited chemical) to save someone, so it might as well be somewhat strong.
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_XENOHYBRID)])//They have an organ that uses phoron
		return
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.adjust_fire_stacks(removed * 3) //Not quite 'converting' it. It's like mixing fuel into a jelly. You get explosive, or at least combustible, jelly.
	..()

/datum/reagent/toxin/phoron/touch_turf(turf/simulated/T, amount)
	if(!istype(T))
		return
	T.assume_gas(GAS_ID_VOLATILE_FUEL, amount, T20C)
	remove_self(amount)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	taste_description = "almond"
	taste_mult = 0.6
	reagent_state = REAGENT_LIQUID
	color = "#CF3600"
	strength = 20
	bloodstream_metabolism_multiplier = 2

/datum/reagent/toxin/cyanide/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	entity.adjustOxyLoss(20 * removed)
	entity.afflict_sleeping(20 * 1)

/datum/reagent/toxin/mold
	name = "Mold"
	id = "mold"
	description = "A mold is a fungus that causes biodegradation of natural materials. This variant contains mycotoxins, and is dangerous to humans."
	taste_description = "mold"
	reagent_state = REAGENT_SOLID
	strength = 5

/datum/reagent/toxin/mold/affect_ingest(mob/living/carbon/M, alien, removed)
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

/datum/reagent/toxin/expired_medicine/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(prob(5))
		entity.vomit()

/datum/reagent/toxin/expired_medicine/affect_ingest(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.66)


/datum/reagent/toxin/stimm	//Homemade Hyperzine
	name = "Stimm"
	id = "stimm"
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a"
	bloodstream_metabolism_multiplier = 3
	overdose_threshold = 10
	strength = 3

/datum/reagent/toxin/stimm/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_TAJARAN)])
		removed *= 1.25
	..()
	if(prob(15))
		entity.emote(pick("twitch", "blink_r", "shiver"))
	if(prob(15))
		entity.visible_message("[entity] shudders violently.", "You shudder uncontrollably, it hurts.")
		entity.take_organ_damage(6 * removed, 0)
	entity.add_chemical_effect(CHEMICAL_EFFECT_SPEEDBOOST, 1)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	taste_description = "salt"
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF"
	strength = 0
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	filtered_organs = list(O_SPLEEN, O_KIDNEYS)

/datum/reagent/toxin/potassium_chloride/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		M.adjustFireLoss(removed * 2)

/datum/reagent/toxin/potassium_chloride/overdose(mob/living/carbon/M, alien)
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
	overdose_threshold = 20
	filtered_organs = list(O_SPLEEN, O_KIDNEYS)

/datum/reagent/toxin/potassium_chlorophoride/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, entity.losebreath-10)
			H.adjustOxyLoss(2)
			H.afflict_paralyze(20 * 10)
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.adjustFireLoss(removed * 3)

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "numbness"
	reagent_state = REAGENT_SOLID
	color = "#669900"
	metabolism = REM
	strength = 3
	mrate_static = TRUE

/datum/reagent/toxin/zombiepowder/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.status_flags |= STATUS_FAKEDEATH
	entity.adjustOxyLoss(3 * removed)
	entity.afflict_paralyze(20 * 10)
	entity.silent = max(entity.silent, 10)
	entity.tod = stationtime2text()

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~STATUS_FAKEDEATH
	return ..()

/datum/reagent/toxin/lichpowder
	name = "Lich Powder"
	id = "lichpowder"
	description = "A stablized nerve agent that puts the subject into a strange state of un-death."
	reagent_state = REAGENT_SOLID
	color = "#666666"
	bloodstream_metabolism_multiplier = 0.75
	strength = 2
	mrate_static = TRUE

/datum/reagent/toxin/lichpowder/affect_touch(mob/living/carbon/M, alien, removed)
	..()
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	M.status_flags |= STATUS_FAKEDEATH
	M.adjustOxyLoss(1 * removed)
	M.silent = max(M.silent, 10)
	M.tod = stationtime2text()

	if(prob(1))
		M.visible_message("[M] wheezes.", "You wheeze sharply... it's cold.")
		M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C - 10)

/datum/reagent/toxin/lichpowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~STATUS_FAKEDEATH
	return ..()

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	id = "fertilizer"
	description = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	reagent_state = REAGENT_LIQUID
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"

/datum/reagent/toxin/fertilizer/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)]) //cit change: fertilizer is full of natural easily digestible plant fats
		entity.nutrition += removed * 5
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

/datum/reagent/toxin/plantbgone/touch_turf(turf/T)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message("<span class='notice'>The fungi are completely dissolved by the solution!</span>")

/datum/reagent/toxin/plantbgone/touch_obj(obj/O, volume)
	if(istype(O, /obj/effect/plant))
		qdel(O)
	else if(istype(O, /obj/structure/alien/weeds/))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.damage_integrity(15, 35)

/datum/reagent/toxin/plantbgone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)])
		entity.adjustToxLoss(50 * removed)

/datum/reagent/toxin/plantbgone/affect_touch(mob/living/carbon/M, alien, removed)
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_ALRAUNE)])
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/pestbgone
	name = "Pest-B-Gone"
	id = "pestbgone"
	description = "A harmful toxic mixture designed to kill insects and pests. Do not ingest!"
	taste_mult = 1
	reagent_state = REAGENT_LIQUID
	color = "#8FB97C"
	strength = 4

/datum/reagent/toxin/pestbgone/touch_obj(mob/living/simple_mob/animal/A, removed)
	if(istype(A, /mob/living/simple_mob/animal/roach))
		A.adjustToxLoss(10 * removed)
	else if(istype(A, /mob/living/simple_mob/animal/giant_spider))
		A.adjustToxLoss(5 * removed)

/datum/reagent/toxin/pestbgone/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_APIDAEN)])
		entity.adjustToxLoss(50 * removed)

/datum/reagent/toxin/pestbgone/affect_touch(mob/living/carbon/M, alien, removed)
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_APIDAEN)])
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/sifslurry
	name = "Sivian Sap"
	id = "sifsap"
	description = "A natural slurry comprised of fluorescent bacteria native to Sif, in the Vir system."
	taste_description = "sour"
	reagent_state = REAGENT_LIQUID
	color = "#C6E2FF"
	strength = 2
	overdose_threshold = 20

/datum/reagent/toxin/sifslurry/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)]) // Symbiotic bacteria.
		entity.nutrition += strength * removed
		return
	else
		entity.add_modifier(/datum/modifier/slow_pulse, 30 SECONDS)
	..()

/datum/reagent/toxin/sifslurry/overdose(mob/living/carbon/M, alien, removed) // Overdose effect.
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		overdose_mod *= H.species.chemOD_mod
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_SIFSLURRY_OD(removed))
	M.apply_effect(5 * removed, DROWSY, 0, 0)

/datum/reagent/toxin/sifslurry/affect_ingest(mob/living/carbon/M, alien, removed)
	affect_blood(M, alien, removed * 0.7)

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

//Solid Chlorine is alkaline, but gaseous Chlorine is acidic.
/datum/reagent/acid/chlorine_gas
	name = "Chlorine gas"
	id = "chlorinegas"
	description = "A pungent yellow-green acidic gas."
	taste_description = "bleach"
	reagent_state = REAGENT_GAS
	color = "#c5f72d"
	power = 5
	meltdose = 10

/datum/reagent/thermite/venom
	name = "Pyrotoxin"
	id = "thermite_v"
	description = "A biologically produced compound capable of melting steel or other metals, similarly to thermite."
	taste_description = "sweet chalk"
	reagent_state = REAGENT_SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/thermite/venom/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	entity.adjustFireLoss(3 * removed)
	if(entity.fire_stacks <= 1.5)
		entity.adjust_fire_stacks(0.15)
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(prob(10))
		to_chat(entity,"<span class='warning'>Your veins feel like they're on fire!</span>")
		entity.adjust_fire_stacks(0.1)
	else if(prob(5))
		entity.IgniteMob()
		to_chat(entity,"<span class='critical'>Some of your veins rupture, the exposed blood igniting!</span>")

/datum/reagent/condensedcapsaicin/venom
	name = "Irritant toxin"
	id = "condensedcapsaicin_v"
	description = "A biological agent that acts similarly to pepperspray. This compound seems to be particularly cruel, however, capable of permeating the barriers of blood vessels."
	taste_description = "fire"
	color = "#B31008"
	filtered_organs = list(O_SPLEEN)

/datum/reagent/condensedcapsaicin/venom/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(prob(50))
		entity.adjustToxLoss(0.5 * removed)
	if(prob(50))
		entity.apply_effect(4, AGONY, 0)
		if(prob(20))
			to_chat(entity,"<span class='danger'>You feel like your insides are burning!</span>")
		else if(prob(20))
			entity.visible_message("<span class='warning'>[entity] [pick("dry heaves!","coughs!","splutters!","rubs at their eyes!")]</span>")
	else
		entity.eye_blurry = max(entity.eye_blurry, 10)

/datum/reagent/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	taste_description = "acid"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/lexorin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		entity.apply_effect(5, AGONY, 0)
		entity.adjustToxLoss(3 * removed)
		if(prob(10))
			to_chat(entity, "<span class='warning'>Your cellular mass hardens for a moment.</span>")
			entity.afflict_stun(20 * 6)
		return
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		entity.take_organ_damage(2.4 * removed, 0)
		if(entity.losebreath < 10)
			entity.AdjustLosebreath(1)
	else
		entity.take_organ_damage(3 * removed, 0)
		if(entity.losebreath < 15)
			entity.AdjustLosebreath(1)

/datum/reagent/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	taste_description = "slime"
	taste_mult = 0.9
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E"

/datum/reagent/mutagen/affect_touch(mob/living/carbon/M, alien, removed)
	if(prob(33))
		affect_blood(M, alien, removed)

/datum/reagent/mutagen/affect_ingest(mob/living/carbon/M, alien, removed)
	if(prob(67))
		affect_blood(M, alien, removed)

/datum/reagent/mutagen/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()

	if(entity.isSynthetic())
		return

	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)] && prob(25))
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
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_CHIMERA)] && prob(33))
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

	if(entity.dna)
		if(prob(removed * 10)) // Removed is .2 per tick. Multiplying it by 10 makes it a 2% chance per tick. 10 units has 50 ticks, so 10 units injected should give a single good/bad mutation.
			randmuti(entity)
			if(prob(98))
				randmutb(entity)
			else
				randmutg(entity)
			domutcheck(entity, null)
			entity.UpdateAppearance()
		if(prob(removed * 40)) //Additionally, let's make it so there's an 8% chance per tick for a random cosmetic/not guranteed good/bad mutation.
			randmuti(entity)//This should equate to 4 random cosmetic mutations per 10 injected/20 ingested/30 touching units
			to_chat(entity, "<span class='warning'>You feel odd!</span>")
	entity.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_MUTAGEN(removed))

/datum/reagent/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	taste_description = "slime"
	taste_mult = 1.3
	reagent_state = REAGENT_LIQUID
	color = "#801E28"

/datum/reagent/slimejelly/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)]) //Partially made of the stuff. Why would it hurt them?
		if(prob(75))
			entity.heal_overall_damage(25 * removed, 25 * removed)
			entity.adjustToxLoss(rand(-30, -10) * removed)
			entity.druggy = max(entity.druggy, 10)
			entity.ceiling_chemical_effect(CHEMICAL_EFFECT_PAINKILLER, 60)
	else
		if(prob(10))
			to_chat(entity, "<span class='danger'>Your insides are burning!</span>")
			entity.adjustToxLoss(rand(100, 300) * removed)
		else if(prob(40))
			entity.heal_organ_damage(25 * removed, 0)

/datum/reagent/advmutationtoxin
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin"
	description = "A corruptive toxin produced by slimes. Turns the subject of the chemical into a Promethean."
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E"

/datum/reagent/advmutationtoxin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(ishuman(entity))
		var/mob/living/carbon/human/H = entity
		if(H.species.get_species_id() != SPECIES_ID_PROMETHEAN)
			to_chat(entity, "<span class='danger'>Your flesh rapidly mutates!</span>")

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
	bloodstream_metabolism_multiplier = 0.5
	ingest_met = REM * 1.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/soporific/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/threshold = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		threshold = 1.2

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		threshold = 6	//Evens to 3 due to the fact they are considered 'small' for flaps.

	var/effective_dose = dose
	if(issmall(entity))
		effective_dose *= 2

	if(effective_dose < 1 * threshold)
		if(effective_dose == metabolism * 2 || prob(5))
			entity.emote("yawn")
	else if(effective_dose < 1.5 * threshold)
		entity.eye_blurry = max(entity.eye_blurry, 10)
	else if(effective_dose < 5 * threshold)
		if(prob(50))
			entity.afflict_paralyze(20 * 2)
		entity.drowsyness = max(entity.drowsyness, 20)
	else
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)]) //They don't have eyes, and they don't really 'sleep'. Fumble their general senses.
			entity.eye_blurry = max(entity.eye_blurry, 30)

			if(prob(20))
				entity.ear_deaf = max(entity.ear_deaf, 4)
				entity.Confuse(2)
			else
				entity.afflict_paralyze(20 * 2)
		else
			entity.afflict_sleeping(20 * 20)
		entity.drowsyness = max(entity.drowsyness, 60)

/datum/reagent/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	taste_description = "bitterness"
	reagent_state = REAGENT_SOLID
	color = "#000067"
	bloodstream_metabolism_multiplier = 0.5
	ingest_met = REM * 1.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE * 0.5
	overdose_mod = 5	//For that good, lethal feeling

/datum/reagent/chloralhydrate/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/threshold = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		threshold = 1.2

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		threshold = 6	//Evens to 3 due to the fact they are considered 'small' for flaps.

	var/effective_dose = dose
	if(issmall(entity))
		effective_dose *= 2

	if(effective_dose == metabolism)
		entity.Confuse(2)
		entity.drowsyness += 2
	else if(effective_dose < 2 * threshold)
		entity.afflict_paralyze(20 * 30)
		entity.eye_blurry = max(entity.eye_blurry, 10)
	else
		if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
			if(prob(30))
				entity.ear_deaf = max(entity.ear_deaf, 4)
			entity.eye_blurry = max(entity.eye_blurry, 60)
			entity.afflict_paralyze(20 * 30)
			entity.Confuse(40)
		else
			entity.afflict_sleeping(20 * 30)

	if(effective_dose > 1 * threshold)
		entity.adjustToxLoss(removed)

/datum/reagent/chloralhydrate/overdose(mob/living/carbon/M, alien, removed)
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
	bloodstream_metabolism_multiplier = 0.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/space_drugs/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/drug_strength = 15
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		drug_strength = drug_strength * 0.8

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		drug_strength = drug_strength * 1.2

	entity.druggy = max(entity.druggy, drug_strength)
	if(prob(10) && isturf(entity.loc) && !istype(entity.loc, /turf/space) && CHECK_MOBILITY(entity, MOBILITY_CAN_MOVE))
		step(entity, pick(GLOB.cardinal))
	if(prob(7))
		entity.emote(pick("twitch", "drool", "moan", "giggle"))

/datum/reagent/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#202040"
	bloodstream_metabolism_multiplier = 0.25
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/serotrotium/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(prob(7))
		entity.emote(pick("twitch", "drool", "moan", "gasp"))
	return

/datum/reagent/serotrotium/venom
	name = "Serotropic venom"
	id = "serotrotium_v"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans. This appears to be a biologically produced form, resulting in a specifically toxic nature."
	taste_description = "chalky bitterness"
	filtered_organs = list(O_SPLEEN)

/datum/reagent/serotrotium/venom/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	if(prob(30))
		if(prob(25))
			entity.emote(pick("shiver", "blink_r"))
		M.adjustBrainLoss(0.2 * removed)
	return ..()

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#000055"
	bloodstream_metabolism_multiplier = 0.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/cryptobiolin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	var/drug_strength = 4

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		drug_strength = drug_strength * 0.8

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		drug_strength = drug_strength * 1.2

	entity.make_dizzy(drug_strength)
	entity.Confuse(drug_strength * 5)

/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	filtered_organs = list(O_SPLEEN)

/datum/reagent/impedrezene/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return
	entity.jitteriness = max(entity.jitteriness - 5, 0)
	if(prob(80))
		entity.adjustBrainLoss(0.1 * removed)
	if(prob(50))
		entity.drowsyness = max(entity.drowsyness, 3)
	if(prob(10))
		entity.emote("drool")

/datum/reagent/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	taste_description = "sourness"
	reagent_state = REAGENT_LIQUID
	color = "#B31008"
	bloodstream_metabolism_multiplier = 0.25
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/mindbreaker/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/drug_strength = 100

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		drug_strength *= 0.8

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		drug_strength *= 1.2

	entity.hallucination = max(entity.hallucination, drug_strength)

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#E700E7"
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE
	bloodstream_metabolism_multiplier = 0.5

/datum/reagent/psilocybin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/threshold = 1
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		threshold = 1.2

	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_PROMETHEAN)])
		threshold = 0.8

	entity.druggy = max(entity.druggy, 30)

	var/effective_dose = dose
	if(issmall(entity)) effective_dose *= 2
	if(effective_dose < 1 * threshold)
		entity.apply_effect(3, STUTTER)
		entity.make_dizzy(5)
		if(prob(5))
			entity.emote(pick("twitch", "giggle"))
	else if(effective_dose < 2 * threshold)
		entity.apply_effect(3, STUTTER)
		entity.make_jittery(5)
		entity.make_dizzy(5)
		entity.druggy = max(entity.druggy, 35)
		if(prob(10))
			entity.emote(pick("twitch", "giggle"))
	else
		entity.apply_effect(3, STUTTER)
		entity.make_jittery(10)
		entity.make_dizzy(10)
		entity.druggy = max(entity.druggy, 40)
		if(prob(15))
			entity.emote(pick("twitch", "giggle"))

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
	bloodstream_metabolism_multiplier = 0.5
	overdose_threshold = REAGENTS_OVERDOSE_MEDICINE

/datum/reagent/talum_quem/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_DIONA)])
		return

	var/drug_strength = 29
	if(entity.reagent_biologies[REAGENT_BIOLOGY_SPECIES(SPECIES_ID_SKRELL)])
		drug_strength = drug_strength * 0.8
	else
		entity.adjustToxLoss(10 * removed) //Given incorporations of other toxins with similiar damage, this seems right.

	entity.druggy = max(entity.druggy, drug_strength)
	if(prob(10) && isturf(entity.loc) && !istype(entity.loc, /turf/space) && CHECK_MOBILITY(entity, MOBILITY_CAN_MOVE))
		step(entity, pick(GLOB.cardinal))
	if(prob(7))
		entity.emote(pick("twitch", "drool", "moan", "giggle"))

/* Transformations */

/datum/reagent/slimetoxin
	name = "Mutation Toxin"
	id = "mutationtoxin"
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E"

/datum/reagent/slimetoxin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.isSynthetic())
		return

	var/mob/living/carbon/human/H = entity
	if(istype(H) && (H.species.species_flags & NO_SCAN))
		return

	if(entity.dna)
		if(prob(removed * 10))
			randmuti(entity)
			if(prob(98))
				randmutb(entity)
			else
				randmutg(entity)
			domutcheck(entity, null)
			entity.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(entity)
			to_chat(entity, "<span class='warning'>You feel odd!</span>")
	entity.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_SLIMETOXIN(removed))

/datum/reagent/aslimetoxin
	name = "Docility Toxin"
	id = "docilitytoxin"
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = REAGENT_LIQUID
	color = "#FF69B4"

/datum/reagent/aslimetoxin/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	if(entity.isSynthetic())
		return

	var/mob/living/carbon/human/H = entity
	if(istype(H) && (H.species.species_flags & NO_SCAN))
		return

	if(entity.dna)
		if(prob(removed * 10))
			randmuti(entity)
			if(prob(98))
				randmutb(entity)
			else
				randmutg(entity)
			domutcheck(entity, null)
			entity.UpdateAppearance()
		if(prob(removed * 40))
			randmuti(entity)
			to_chat(entity, "<span class='warning'>You feel odd!</span>")
	entity.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_ASLIMETOXIN(removed))

/*
 * Hostile nanomachines.
 * Unscannable, and commonly all look the same.
 */

/datum/reagent/shredding_nanites
	name = "Restorative Nanites"
	id = "shredding_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage. These ones seem to be malfunctioning."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#555555"
	bloodstream_metabolism_multiplier = 4
	affects_robots = TRUE

/datum/reagent/shredding_nanites/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	entity.adjustBruteLoss(4 * removed)
	entity.adjustOxyLoss(4 * removed)

/datum/reagent/irradiated_nanites
	name = "Restorative Nanites"
	id = "irradiated_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage. These ones seem to be malfunctioning."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#555555"
	bloodstream_metabolism_multiplier = 4
	affects_robots = TRUE

/datum/reagent/irradiated_nanites/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	// todo: this should be more brutal on people around the person without being too brutal on the person
	// new radiation just kind of scales pretty badly
	/// rads to everyone around you
	radiation_pulse(entity, RAD_INTENSITY_CHEM_IRRADIATED_NANITES)
	/// radiate the person a bit just in case they're armored
	entity.rad_act(RAD_INTENSITY_CHEM_IRRADIATED_NANITES_SELF)

/datum/reagent/neurophage_nanites
	name = "Restorative Nanites"
	id = "neurophage_nanites"
	description = "Miniature medical robots that swiftly restore bodily damage. These ones seem to be completely hostile."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#555555"
	bloodstream_metabolism_multiplier = 4
	filtered_organs = list(O_SPLEEN)
	affects_robots = TRUE

/datum/reagent/neurophage_nanites/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	
	entity.take_overall_damage(2 * removed)

//Special toxins for solargrubs
//Moved from Chemistry-Reagents-Vore_vr.dm
/datum/reagent/grubshock
	name = "200 V" //in other words a painful shock
	id = "shockchem"
	description = "A liquid that quickly dissapates to deliver a painful shock."
	reagent_state = REAGENT_LIQUID
	color = "#E4EC2F"
	bloodstream_metabolism_multiplier = 10
	affects_robots = TRUE

	var/power = 9

/datum/reagent/grubshock/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	entity.take_organ_damage(burn = removed * power * 0.2)
