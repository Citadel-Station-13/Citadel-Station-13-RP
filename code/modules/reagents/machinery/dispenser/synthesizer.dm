/obj/item/reagent_synth
	name = "reagent synthesis module"
	desc = "Some kind of complex device used for synthesizing reagents."
	worn_render_flags = WORN_RENDER_INHAND_NO_RENDER | WORN_RENDER_SLOT_NO_RENDER
	icon = 'icons/items/parts/reagent_synth.dmi'
	icon_state = "synth_prefab"

	/// type enum
	var/reagents_group
	/// reagents by typepath or id that we allow syntehsis of
	var/list/reagents_provided

/obj/item/reagent_synth/Initialize(mapload)
	if(has_typelist(NAMEOF(src, reagents_provided)))
		reagents_provided = get_typelist(NAMEOF(src, reagents_provided))
	else
		reagents_provided = typelist(NAMEOF(src, reagents_provided), resolve_reagents_provided())
	return ..()

/obj/item/reagent_synth/proc/resolve_reagents_provided()

	RETURN_TYPE(/list)
	. = list()
	for(var/thing in reagents_provided)
		if(istext(thing))
			. += thing
		else if(ispath(thing))
			var/datum/reagent/accessing = thing
			. += initial(accessing.id)

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
		/datum/reagent/potassium,
	)

/obj/item/reagent_synth/bar
	name = "reagent synthesis module (Bar)"
	reagents_provided = list(
		/datum/reagent/drink/soda/lemon_lime,
		/datum/reagent/sugar,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/drink/juice/lime,
		/datum/reagent/drink/soda/sodawater,
		/datum/reagent/drink/soda/tonic,
		/datum/reagent/ethanol/beer,
		/datum/reagent/ethanol/coffee/kahlua,
		/datum/reagent/ethanol/whiskey,
		/datum/reagent/ethanol/wine,
		/datum/reagent/ethanol/whitewine,
		/datum/reagent/ethanol/vodka,
		/datum/reagent/ethanol/gin,
		/datum/reagent/ethanol/rum,
		/datum/reagent/ethanol/tequila,
		/datum/reagent/ethanol/vermouth,
		/datum/reagent/ethanol/cognac,
		/datum/reagent/ethanol/cider,
		/datum/reagent/ethanol/ale,
		/datum/reagent/ethanol/mead,
		/datum/reagent/ethanol/alcsassafras
	)

/obj/item/reagent_synth/cafe
	name = "reagent synthesis module (Cafe)"
	reagents_provided = list(
		/datum/reagent/drink/coffee,
		/datum/reagent/drink/coffee/cafe_latte,
		/datum/reagent/drink/coffee/soy_latte,
		/datum/reagent/drink/hot_coco,
		/datum/reagent/drink/milk,
		/datum/reagent/drink/milk/cream,
		/datum/reagent/drink/tea,
		/datum/reagent/drink/ice,
		/datum/reagent/nutriment/mint,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/drink/juice/lemon,
		/datum/reagent/drink/juice/lime,
		/datum/reagent/drink/juice/berry,
	)

/obj/item/reagent_synth/drink
	name = "reagent synthesis module (Soda)"
	reagents_provided = list(
		/datum/reagent/water,
		/datum/reagent/drink/ice,
		/datum/reagent/drink/coffee,
		/datum/reagent/drink/milk/cream,
		/datum/reagent/drink/tea,
		/datum/reagent/drink/tea/icetea,
		/datum/reagent/drink/soda,
		/datum/reagent/drink/soda/spacemountainwind,
		/datum/reagent/drink/soda/sodawater,
		/datum/reagent/drink/soda/dr_gibb,
		/datum/reagent/drink/soda/space_up,
		/datum/reagent/drink/soda/tonic,
		/datum/reagent/sugar,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/drink/juice/watermelon,
		/datum/reagent/drink/juice/lemon,
		/datum/reagent/drink/soda/sassafras,
		/datum/reagent/drink/soda/sarsaparilla,
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

/obj/item/reagent_synth/medicine_addon
	reagents_provided = list(
		/datum/reagent/carthatoline,
		/datum/reagent/corophizine,
		/datum/reagent/myelamine,
		/datum/reagent/osteodaxon,
		/datum/reagent/nutriment/biomass,
		/datum/reagent/iron,
		/datum/reagent/nutriment,
		/datum/reagent/nutriment/protein
	)

/obj/item/reagent_synth/bioproduct
	reagents_provided = list(
		/datum/reagent/nutriment,
		/datum/reagent/nutriment/protein,
		/datum/reagent/drink/milk,
	)

/obj/item/reagent_synth/botanical
	reagents_provided = list(
		/datum/reagent/water,
		/datum/reagent/sugar,
		/datum/reagent/ethanol,
		/datum/reagent/radium,
		/datum/reagent/mutagen,
		/datum/reagent/ammonia,
		/datum/reagent/diethylamine,
		/datum/reagent/toxin/plantbgone,
		/datum/reagent/calcium,
	)
