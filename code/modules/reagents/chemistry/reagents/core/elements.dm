/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	taste_description = "metal"
	taste_mult = 1.1
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8"

/datum/reagent/calcium
	name = "Calcium"
	id = "calcium"
	description = "A chemical element, the building block of bones."
	taste_description = "metallic chalk" // Apparently, calcium tastes like calcium.
	taste_mult = 1.3
	reagent_state = REAGENT_SOLID
	color = "#e9e6e4"

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = REAGENT_SOLID
	color = "#1C1300"
	ingest_met = REM * 5

/datum/reagent/carbon/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	if(length(M.ingested.reagent_volumes) > 1)
		var/effect = 1 / (length(M.ingested.reagent_volumes) - 1)
		for(var/datum/reagent/R in M.ingested.get_reagent_datums())
			if(R == src)
				continue
			M.ingested.remove_reagent(R.id, removed * effect)

/datum/reagent/carbon/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/turf/T = target
	if(!istype(T, /turf/space))
		var/obj/effect/debris/cleanable/dirt/dirtoverlay = locate(/obj/effect/debris/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/debris/cleanable/dirt(T)
			dirtoverlay.alpha = allocated * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + allocated * 30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	taste_description = "pool water"
	reagent_state = REAGENT_GAS
	color = "#d1db77"

/datum/reagent/chlorine/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.take_random_targeted_damage(brute = 1*REM, brute = 0)

/datum/reagent/chlorine/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.take_random_targeted_damage(brute = 1*REM, brute = 0)

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	taste_description = "pennies"
	color = "#6E3B08"

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	taste_description = "acid"
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/fluorine/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustToxLoss(removed)

/datum/reagent/fluorine/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.adjustToxLoss(removed)

/datum/reagent/gold
	name = "Gold"
	id = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#F7C430"

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	taste_mult = 0 //no taste
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#353535"

/datum/reagent/iron/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#808080"

/datum/reagent/lithium/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien != IS_DIONA)
		if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
			step(M, pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = REAGENT_LIQUID
	color = "#484848"

/datum/reagent/mercury/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien != IS_DIONA)
		if(CHECK_MOBILITY(M, MOBILITY_CAN_MOVE) && istype(M.loc, /turf/space))
			step(M, pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		M.adjustBrainLoss(0.1)

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	taste_mult = 0 //no taste
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	taste_mult = 0
	reagent_state = REAGENT_GAS
	color = "#808080"

/datum/reagent/oxygen/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * 3)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = REAGENT_SOLID
	color = "#832828"

/datum/reagent/phosphorus/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.nutrition += removed * 2 //cit change - phosphorus is good for plants

/datum/reagent/platinum
	name = "Platinum"
	id = "platinum"
	description = "Platinum is a dense, malleable, ductile, highly unreactive, precious, gray-white transition metal.  It is very resistant to corrosion."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#777777"

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = REAGENT_SOLID
	color = "#A0A0A0"

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_mult = 0	//Apparently radium is tasteless
	reagent_state = REAGENT_SOLID
	color = "#C7C7C7"

/datum/reagent/radium/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(issmall(M))
		removed *= 2
	M.afflict_radiation(RAD_MOB_AFFLICT_STRENGTH_RADIUM(removed))
	if(M.virus2.len)
		for(var/ID in M.virus2)
			var/datum/disease2/disease/V = M.virus2[ID]
			if(prob(5))
				M.antibodies |= V.antigen

/datum/reagent/radium/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/turf/T = target
	if(allocated >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/debris/cleanable/greenglow/glow = locate(/obj/effect/debris/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/debris/cleanable/greenglow(T)

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	taste_mult = 0
	reagent_state = REAGENT_SOLID
	color = "#A8A8A8"

/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#D0D0D0"

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = REAGENT_SOLID
	color = "#808080"

/datum/reagent/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_description = "metal"
	taste_mult = 0 //no taste
	reagent_state = REAGENT_SOLID
	color = "#DCDCDC"

/datum/reagent/uranium
	name ="Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#B8B8C0"

/datum/reagent/uranium/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_ingest(M, alien, removed, metabolism)

/datum/reagent/uranium/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.apply_effect(5 * removed, IRRADIATE, 0)

/datum/reagent/uranium/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()
	if(allocated >= 3)
		if(!istype(target, /turf/space))
			var/obj/effect/debris/cleanable/greenglow/glow = locate(/obj/effect/debris/cleanable/greenglow, target)
			if(!glow)
				new /obj/effect/debris/cleanable/greenglow(target)
