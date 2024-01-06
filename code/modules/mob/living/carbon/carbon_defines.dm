/mob/living/carbon
	gender = MALE
	throw_force = 10

	//? Composition
	/// species - datumized handling of racial intrinsics like health, environmental, breathing, etc. set using set_species() **only**
	var/datum/species/species

	var/list/stomach_contents = list()
	///var/list/datum/disease2/disease/virus2 = list()
	var/list/antibodies = list()
	var/last_eating = 0 	//Not sure what this does... I found it hidden in food.dm

	var/life_tick = 0      // The amount of life ticks that have processed on this mob.

	// total amount of wounds on mob, used to spread out healing and the like over all wounds
	var/wound_tally = 0

	// inventory
	var/obj/item/handcuffed = null //Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.

	//Surgery info
	var/datum/surgery_status/op_stage = new/datum/surgery_status
	//Active emote/pose
	var/pose = null
	
	#warn uhh
	var/datum/reagent_holder/metabolism/bloodstream/bloodstr = null
	var/datum/reagent_holder/metabolism/ingested/ingested = null

	var/pulse = PULSE_NORM	//current pulse level

	var/does_not_breathe = 0 //Used for specific mobs that can't take advantage of the species flags (changelings)

	//these two help govern taste. The first is the last time a taste message was shown to the plaer.
	//the second is the message in question.
	var/last_taste_time = 0
	var/last_taste_text = ""

	//* Reagent Metabolism

	/// reagent biologies we count as
	var/list/reagent_biologies = list()
	/// this tick's overall CHEMICAL_EFFECT defines
	/// this is mostly a legacy system we still keep around,
	/// as sometimes snowflake flags are useful
	var/list/reagent_cycle_effects
	/// our bloodstream metabolism holder
	var/datum/reagent_holder/metabolism/bloodstream/reagents_bloodstream
	/// for now, this is on /carbon, later, it should be an organ
	/// oh and funny shit should happen if you eat stuff without a stomach :^)
	var/datum/reagent_holder/metabolism/ingested/reagents_ingested
