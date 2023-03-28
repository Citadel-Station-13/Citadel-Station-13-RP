///////////////////////////////////
// POWERS
///////////////////////////////////

/datum/gene/basic/nobreath
	name = "No Breathing"
	activation_messages = list("You feel no need to breathe.")
	mutation = MUTATION_NOBREATH

/datum/gene/basic/nobreath/New()
	block = DNABLOCK_NOBREATH

/datum/gene/basic/remoteview
	name = "Remote Viewing"
	activation_messages = list("Your mind expands.")
	mutation = MUTATION_REMOTE_VIEW

/datum/gene/basic/remoteview/New()
	block = DNABLOCK_REMOTEVIEW

/datum/gene/basic/remoteview/activate(mob/M, connected, flags)
	..(M,connected,flags)
	add_verb(M, /mob/living/carbon/human/proc/remoteobserve)

/datum/gene/basic/regenerate
	name = "Regenerate"
	activation_messages = list("You feel better.")
	mutation = MUTATION_REGENERATE

/datum/gene/basic/regenerate/New()
	block = DNABLOCK_REGENERATE

/datum/gene/basic/increaserun
	name = "Super Speed"
	activation_messages = list("Your leg muscles pulsate.")
	mutation = MUTATION_INCREASE_RUN

/datum/gene/basic/increaserun/New()
	block = DNABLOCK_INCREASERUN

/datum/gene/basic/remotetalk
	name = "Telepathy"
	activation_messages = list("You expand your mind outwards.")
	mutation = MUTATION_REMOTE_TALK

/datum/gene/basic/remotetalk/New()
	block = DNABLOCK_REMOTETALK

/datum/gene/basic/remotetalk/activate(mob/M, connected, flags)
	..(M,connected,flags)
	add_verb(M, /mob/living/carbon/human/proc/remotesay)

/datum/gene/basic/morph
	name = "Morph"
	activation_messages = list("Your skin feels strange.")
	mutation = MUTATION_MORPH

/datum/gene/basic/morph/New()
	block = DNABLOCK_MORPH

/datum/gene/basic/morph/activate(mob/M)
	..(M)
	add_verb(M, /mob/living/carbon/human/proc/morph)

/* Not used on bay
/datum/gene/basic/heat_resist
	name = "Heat Resistance"
	activation_messages = list("Your skin is icy to the touch.")
	mutation = mHeatres

/datum/gene/basic/heat_resist/New()
	block = COLDBLOCK

/datum/gene/basic/heat_resist/can_activate(mob/M, flags)
	if(flags & MUTCHK_FORCED)
		return !(/datum/gene/basic/cold_resist in M.active_genes)
	// Probability check
	var/_prob = 15
	if(MUTATION_COLD_RESIST in M.mutations)
		_prob=5
	if(probinj(_prob,(flags&MUTCHK_FORCED)))
		return 1

/datum/gene/basic/heat_resist/OnDrawUnderlays(mob/M, g, fat)
	return "cold[fat]_~s"
*/

/datum/gene/basic/cold_resist
	name = "Cold Resistance"
	activation_messages = list("Your body is filled with warmth.")
	mutation = MUTATION_COLD_RESIST

/datum/gene/basic/cold_resist/New()
	block = DNABLOCK_FIRE

/datum/gene/basic/cold_resist/can_activate(mob/M, flags)
	if(flags & MUTCHK_FORCED)
		return 1
	//	return !(/datum/gene/basic/heat_resist in M.active_genes)
	// Probability check
	var/_prob=30
	//if(mHeatres in M.mutations)
	//	_prob=5
	if(probinj(_prob,(flags & MUTCHK_FORCED)))
		return 1

/datum/gene/basic/cold_resist/OnDrawUnderlays(mob/M, g, fat)
	return "fire[fat]_s"

/datum/gene/basic/noprints
	name = "No Prints"
	activation_messages = list("Your fingers feel numb.")
	mutation = MUTATION_NOPRINTS

/datum/gene/basic/noprints/New()
	block = DNABLOCK_NOPRINTS

/datum/gene/basic/noshock
	name = "Shock Immunity"
	activation_messages = list("Your skin feels strange.")
	mutation = MUTATION_NOSHOCK

/datum/gene/basic/noshock/New()
	block = DNABLOCK_NOSHOCK

/datum/gene/basic/dwarfism
	name = "Dwarfism"
	activation_messages = list("Your skin feels rubbery.")
	mutation = MUTATION_DWARFISM

/datum/gene/basic/dwarfism/New()
	block = DNABLOCK_DWARFISM

/datum/gene/basic/dwarfism/can_activate(mob/M, flags)
	// Can't be big and small.
	if(MUTATION_HULK in M.mutations)
		return 0
	return ..(M,flags)

/datum/gene/basic/dwarfism/activate(mob/M, connected, flags)
	..(M,connected,flags)
	M.pass_flags |= 1

/datum/gene/basic/dwarfism/deactivate(mob/M, connected, flags)
	..(M,connected,flags)
	M.pass_flags &= ~1 //This may cause issues down the track, but offhand I can't think of any other way for humans to get ATOM_PASS_TABLE short of varediting so it should be fine. ~Z

/datum/gene/basic/hulk
	name = "Hulk"
	activation_messages = list("Your muscles hurt.")
	mutation = MUTATION_HULK

/datum/gene/basic/hulk/New()
	block = DNABLOCK_HULK

/datum/gene/basic/hulk/can_activate(mob/M, flags)
	// Can't be big and small.
	if(MUTATION_DWARFISM in M.mutations)
		return 0
	return ..(M,flags)

/datum/gene/basic/hulk/OnDrawUnderlays(mob/M, g, fat)
	if(fat)
		return "hulk_[fat]_s"
	else
		return "hulk_[g]_s"

/datum/gene/basic/hulk/OnMobLife(mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M.health <= 25)
		M.mutations.Remove(MUTATION_HULK)
		M.update_mutations() //update our mutation overlays
		to_chat(M, SPAN_WARNING("You suddenly feel very weak."))
		M.Weaken(3)
		M.emote("collapse")

/datum/gene/basic/xray
	name = "X-Ray Vision"
	activation_messages = list("The walls suddenly disappear.")
	mutation = MUTATION_XRAY

/datum/gene/basic/xray/New()
	block = DNABLOCK_XRAY

/datum/gene/basic/tk
	name = "Telekenesis"
	activation_messages = list("You feel smarter.")
	mutation = MUTATION_TELEKINESIS
	activation_prob=15

/datum/gene/basic/tk/New()
		block = DNABLOCK_TELE

/datum/gene/basic/tk/OnDrawUnderlays(mob/M, g, fat)
	return "telekinesishead[fat]_s"
