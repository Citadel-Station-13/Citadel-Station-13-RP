/* Paint and crayons */

/datum/reagent/crayon_dust
	name = "Crayon dust"
	id = "crayon_dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	taste_description = "powdered wax"
	reagent_state = REAGENT_LIQUID
	color = "#888888"
	overdose = 5

/datum/reagent/crayon_dust/red
	name = "Red crayon dust"
	id = "crayon_dust_red"
	color = "#FE191A"

/datum/reagent/crayon_dust/orange
	name = "Orange crayon dust"
	id = "crayon_dust_orange"
	color = "#FFBE4F"

/datum/reagent/crayon_dust/yellow
	name = "Yellow crayon dust"
	id = "crayon_dust_yellow"
	color = "#FDFE7D"

/datum/reagent/crayon_dust/green
	name = "Green crayon dust"
	id = "crayon_dust_green"
	color = "#18A31A"

/datum/reagent/crayon_dust/blue
	name = "Blue crayon dust"
	id = "crayon_dust_blue"
	color = "#247CFF"

/datum/reagent/crayon_dust/purple
	name = "Purple crayon dust"
	id = "crayon_dust_purple"
	color = "#CC0099"

/datum/reagent/crayon_dust/grey //Mime
	name = "Grey crayon dust"
	id = "crayon_dust_grey"
	color = "#808080"

/datum/reagent/crayon_dust/brown //Rainbow
	name = "Brown crayon dust"
	id = "crayon_dust_brown"
	color = "#846F35"

/datum/reagent/marker_ink
	name = "Marker ink"
	id = "marker_ink"
	description = "Intensely coloured ink used in markers."
	taste_description = "extremely bitter"
	reagent_state = REAGENT_LIQUID
	color = "#888888"
	overdose = 5

/datum/reagent/marker_ink/black
	name = "Black marker ink"
	id = "marker_ink_black"
	color = "#000000"

/datum/reagent/marker_ink/red
	name = "Red marker ink"
	id = "marker_ink_red"
	color = "#FE191A"

/datum/reagent/marker_ink/orange
	name = "Orange marker ink"
	id = "marker_ink_orange"
	color = "#FFBE4F"

/datum/reagent/marker_ink/yellow
	name = "Yellow marker ink"
	id = "marker_ink_yellow"
	color = "#FDFE7D"

/datum/reagent/marker_ink/green
	name = "Green marker ink"
	id = "marker_ink_green"
	color = "#18A31A"

/datum/reagent/marker_ink/blue
	name = "Blue marker ink"
	id = "marker_ink_blue"
	color = "#247CFF"

/datum/reagent/marker_ink/purple
	name = "Purple marker ink"
	id = "marker_ink_purple"
	color = "#CC0099"

/datum/reagent/marker_ink/grey //Mime
	name = "Grey marker ink"
	id = "marker_ink_grey"
	color = "#808080"

/datum/reagent/marker_ink/brown //Rainbow
	name = "Brown marker ink"
	id = "marker_ink_brown"
	color = "#846F35"

/datum/reagent/chalk_dust
	name = "chalk dust"
	id = "chalk_dust"
	description = "Dusty powder obtained by grinding chalk."
	taste_description = "powdered chalk"
	reagent_state = REAGENT_LIQUID
	color = "#FFFFFF"
	overdose = 5

/datum/reagent/chalk_dust/red
	name = "red chalk dust"
	id = "chalk_dust_red"
	color = "#aa0000"

/datum/reagent/chalk_dust/black
	name = "black chalk dust"
	id = "chalk_dust_black"
	color = "#180000"

/datum/reagent/chalk_dust/blue
	name = "blue chalk dust"
	id = "chalk_dust_blue"
	color = "#000370"

/* Things that didn't fit anywhere else */

/datum/reagent/gold
	name = "Gold"
	id = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#F7C430"

/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#D0D0D0"

/datum/reagent/uranium
	name ="Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#B8B8C0"

/datum/reagent/platinum
	name = "Platinum"
	id = "platinum"
	description = "Platinum is a dense, malleable, ductile, highly unreactive, precious, gray-white transition metal.  It is very resistant to corrosion."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#777777"

/datum/reagent/uranium/legacy_affect_touch(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	legacy_affect_ingest(M, alien, removed, metabolism)

/datum/reagent/uranium/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.apply_effect(5 * removed, IRRADIATE, 0)

/datum/reagent/uranium/touch_turf(turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/debris/cleanable/greenglow/glow = locate(/obj/effect/debris/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/debris/cleanable/greenglow(T)
			return

/datum/reagent/adrenaline
	name = "Adrenaline"
	id = "adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "bitterness"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	mrate_static = TRUE

/datum/reagent/adrenaline/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_DIONA)
		return
	M.set_unconscious(0)
	M.set_paralyzed(0)
	M.adjustToxLoss(rand(3))

/datum/reagent/water/holywater
	name = "Holy Water"
	id = "holywater"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	taste_description = "water"
	color = "#E0E8EF"
	mrate_static = TRUE

	glass_name = "holy water"
	glass_desc = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."

/datum/reagent/water/holywater/legacy_affect_ingest(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	..()
	if(ishuman(M)) // Any location
		if(M.mind && cult.is_antagonist(M.mind) && prob(10))
			cult.remove_antagonist(M.mind)

/datum/reagent/water/holywater/touch_turf(turf/T)
	if(volume >= 5)
		T.holy = 1
	return

/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	taste_description = "mordant"
	taste_mult = 2
	reagent_state = REAGENT_GAS
	color = "#404030"

/datum/reagent/ammonia/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.nutrition += removed * 2 //cit change: fertilizer is waste for plants
		return

/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	taste_description = "iron"
	reagent_state = REAGENT_LIQUID
	color = "#604030"

/datum/reagent/diethylamine/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(alien == IS_ALRAUNE)
		M.nutrition += removed * 5 //cit change: fertilizer is waste for plants
		return

/datum/reagent/fluorosurfactant // Foam precursor
	name = "Fluorosurfactant"
	id = "fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	taste_description = "metal"
	reagent_state = REAGENT_LIQUID
	color = "#9E6B38"

/datum/reagent/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#664B63"

/datum/reagent/lube // TODO: spraying on borgs speeds them up
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	reagent_state = REAGENT_LIQUID
	color = "#009CA8"

/datum/reagent/lube/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	if(volume >= 1)
		T.wet_floor(2)

/datum/reagent/silicate
	name = "Silicate"
	id = "silicate"
	description = "A compound that can be used to reinforce glass."
	taste_description = "plastic"
	reagent_state = REAGENT_LIQUID
	color = "#C7FFFF"

/datum/reagent/silicate/touch_obj(obj/O)
	if(istype(O, /obj/structure/window))
		var/obj/structure/window/W = O
		W.apply_silicate(volume)
		remove_self(volume)
	return

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	taste_description = "sweetness"
	reagent_state = REAGENT_LIQUID
	color = "#808080"

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	taste_description = "oil"
	reagent_state = REAGENT_LIQUID
	color = "#808080"

/datum/reagent/coolant
	name = "Coolant"
	id = "coolant"
	description = "Industrial cooling substance."
	taste_description = "sourness"
	taste_mult = 1.1
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	affects_robots = TRUE

/datum/reagent/coolant/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	if(M.isSynthetic() && ishuman(M))
		var/mob/living/carbon/human/H = M

		var/datum/reagent/blood/coolant = H.get_blood(H.vessel)

		if(coolant)
			H.vessel.add_reagent("blood", removed, coolant.data)

		else
			H.vessel.add_reagent("blood", removed)
			H.fixblood()

	else
		..()

/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	taste_description = "a special education class"
	color = "#FFFFCC"

/datum/reagent/woodpulp
	name = "Wood Pulp"
	id = "woodpulp"
	description = "A mass of wood fibers."
	taste_description = "wood"
	reagent_state = REAGENT_LIQUID
	color = "#B97A57"

/datum/reagent/luminol
	name = "Luminol"
	id = "luminol"
	description = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	reagent_state = REAGENT_LIQUID
	color = "#F2F3F4"

/datum/reagent/luminol/touch_obj(obj/O)
	O.reveal_blood()

/datum/reagent/luminol/touch_mob(mob/living/L)
	L.reveal_blood()

/datum/reagent/nutriment/biomass
	name = "Biomass"
	id = "biomass"
	description = "A slurry of compounds that contains the basic requirements for life."
	taste_description = "salty meat"
	reagent_state = REAGENT_LIQUID
	color = "#DF9FBF"

// The opposite to healing nanites, exists to make unidentified hypos implied to have nanites not be 100% safe.
/datum/reagent/defective_nanites
	name = "Defective Nanites"
	id = "defective_nanites"
	description = "Miniature medical robots that are malfunctioning and cause bodily harm. Fortunately, they cannot self-replicate."
	taste_description = "metal"
	reagent_state = REAGENT_SOLID
	color = "#333333"
	metabolism = REM * 3 // Broken nanomachines go a bit slower.
	scannable = 1

/datum/reagent/defective_nanites/legacy_affect_blood(mob/living/carbon/M, alien, removed, datum/reagent_metabolism/metabolism)
	M.take_random_targeted_damage(brute = 2 * removed, brute = 2 * removed)
	M.adjustOxyLoss(4 * removed)
	M.adjustToxLoss(2 * removed)
	M.adjustCloneLoss(2 * removed)

/datum/reagent/fishbait
	name = "Fish Bait"
	id = "fishbait"
	description = "A natural slurry that particularily appeals to fish."
	taste_description = "earthy"
	reagent_state = REAGENT_LIQUID
	color = "#62764E"

/datum/reagent/crude_oil
	name = "Oil"
	id = "oil"
	description = "Burns in a small smoky fire, mostly used to get Ash."
	reagent_state = REAGENT_LIQUID
	color = "#292929"
	taste_description = "oil"

/datum/reagent/ash_powder
	name = "Ash"
	id = "ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = REAGENT_LIQUID
	color = "#665c56"
	taste_description = "ash"

/datum/reagent/gunpowder
	name = "Gunpowder"
	id = "gunpowder"
	description = "A primitive explosive chemical."
	reagent_state = REAGENT_SOLID
	color = "#464650"
	taste_description = "salt"

/*Liquid Carpets*/

/datum/reagent/carpet
	name = "Liquid Carpet"
	id = "liquidcarpet"
	description = "Liquified carpet fibers, ready for dyeing."
	reagent_state = REAGENT_LIQUID
	color = "#b51d05"
	taste_description = "carpet"

/datum/reagent/carpet/black
	name = "Liquid Black Carpet"
	id = "liquidcarpetb"
	description = "Black Carpet Fibers, ready for reinforcement."
	reagent_state = REAGENT_LIQUID
	color = "#000000"
	taste_description = "rare and ashy carpet"

/datum/reagent/carpet/blue
	name = "Liquid Blue Carpet"
	id = "liquidcarpetblu"
	description = "Blue Carpet Fibers, ready for reinforcement."
	reagent_state = REAGENT_LIQUID
	color = "#3f4aee"
	taste_description = "commanding carpet"

/datum/reagent/carpet/turquoise
	name = "Liquid Turquoise Carpet"
	id = "liquidcarpettur"
	description = "Turquoise Carpet Fibers, ready for reinforcement."
	reagent_state = REAGENT_LIQUID
	color = "#0592b5"
	taste_description = "water-logged carpet"

/datum/reagent/carpet/sblue
	name = "Liquid Silver Blue Carpet"
	id = "liquidcarpetsblu"
	description = "Silver Blue Carpet Fibers, ready for reinforcement."
	reagent_state = REAGENT_LIQUID
	color = "#0011ff"
	taste_description = "sterile and medicinal carpet"

/datum/reagent/carpet/clown
	name = "Liquid Clown Carpet"
	id = "liquidcarpetc"
	description = "Clown Carpet Fibers.... No clowns were harmed in the making of this."
	reagent_state = REAGENT_LIQUID
	color = "#e925be"
	taste_description = "clown shoes and banana peels"

/datum/reagent/carpet/purple
	name = "Liquid Purple Carpet"
	id = "liquidcarpetp"
	description = "Purple Carpet Fibers, ready for reinforcement."
	reagent_state = REAGENT_LIQUID
	color = "#a614d3"
	taste_description = "bleeding edge carpet research"

/datum/reagent/carpet/orange
	name = "Liquid Orange Carpet"
	id = "liquidcarpeto"
	description = "Orange Carpet Fibers, ready for reinforcement."
	reagent_state = REAGENT_LIQUID
	color = "#f16e16"
	taste_description = "extremely overengineered carpet"

//Ashlander Alchemy!
/datum/reagent/alchemybase
	name = "Alchemical Base"
	id = "alchemybase"
	description = "A compound of ash and sulphuric acid, used on Surt as a base for alchemical processes."
	reagent_state = REAGENT_LIQUID
	color = "#5a5e3c"
	taste_description = "sour ash"

/datum/reagent/phlogiston
	name = "Phlogiston"
	id = "phlogiston"
	description = "A solution of gunpowder and alchemical base, reduced into a sticky tar. It is immensely volatile."
	reagent_state = REAGENT_LIQUID
	color = "#522222"
	taste_description = "sulphurous sand"

/datum/reagent/bitterash
	name = "Bitter Ash"
	id = "bitterash"
	description = "A finely granulated mixture of ash and pokalea, rendered into a pungent slurry by alchemical base."
	reagent_state = REAGENT_SOLID
	color = "#302f2f"
	taste_description = "sour wax and sulphur"
