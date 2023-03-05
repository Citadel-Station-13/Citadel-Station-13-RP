/obj/item/reagent_synth
	name = "reagent synthesis module"
	desc = "Some kind of complex device used for synthesizing reagents."
	#warn sprite

	/// type enum - can't have more than one of this in a dispenser, if not null.
	var/unique_type
	/// reagents by typepath or id that we allow syntehsis of
	var/list/reagents_provided
	/// power in kilojoules per unit synthesized
	var/reagents_drain = 4 // ~5k units on 10k cell

/obj/item/reagent_synth/Initialize(mapload)
	reagents_provided = typelist(NAMEOF(src, reagents_provided), reagents_provided)
	return ..()

#warn rnd designs

/obj/item/reagent_synth/chemistry
	name = "reagent synthesis module (Chemistry)"
	reagents_provided = list(
		/datum/reagent/hydrogen,
		/datum/reagent/lithium,
		/datum/reagent/carbon,
		/datum/reagent/nitrogen,
		/datum/reagent/oxygen,
		/datum/reagent/fluorine,
		/datum/reagent/sodium,
		/datum/reagent/aluminum,
		/datum/reagent/silicon,
		/datum/reagent/phosphorus,
		/datum/reagent/iron,
		/datum/reagent/copper,
		/datum/reagent/mercury,
		/datum/reagent/radium,
		/datum/reagent/water,
		/datum/reagent/ethanol,
		/datum/reagent/sugar,
		/datum/reagent/acid,
		/datum/reagent/tungsten,
		/datum/reagent/calcium,
	)

/obj/item/reagent_synth/bar
	name = "reagent synthesis module (Bar)"
	reagents_provided = list(
	)

/obj/item/reagent_synth/cafe
	name = "reagent synthesis module (Cafe)"
	reagents_provided = list(
	)

/obj/item/reagent_synth/drink
	name = "reagent synthesis module (Soda)"
	reagents_provided = list(
	)

/obj/item/reagent_synth/medicine
	name = "reagent synthesis module (Medicine)"
	reagents_provided = list(
		/datum/reagent/inaprovaline,
		/datum/reagent/ryetalyn,
		/datum/reagent/paracetamol,
		/datum/reagent/tramadol,
		/datum/reagent/oxycodone,
		/datum/reagent/sterilizine,
		/datum/reagent/leporazine,
		/datum/reagent/kelotane,
		/datum/reagent/dermaline,
		/datum/reagent/dexalin,
		/datum/reagent/dexalinp,
		/datum/reagent/tricordrazine,
		/datum/reagent/dylovene,
		/datum/reagent/synaptizine,
		/datum/reagent/hyronalin,
		/datum/reagent/arithrazine,
		/datum/reagent/alkysine,
		/datum/reagent/imidazoline,
		/datum/reagent/peridaxon,
		/datum/reagent/bicaridine,
		/datum/reagent/hyperzine,
		/datum/reagent/rezadone,
		/datum/reagent/spaceacillin,
		/datum/reagent/ethylredoxrazine,
		/datum/reagent/soporific,
		/datum/reagent/chloralhydrate,
		/datum/reagent/cryoxadone,
		/datum/reagent/clonexadone,
	)


