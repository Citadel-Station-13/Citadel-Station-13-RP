//! DNA Procs
/**
 * sets our DNA to something
 * make sure this is a CLONE if another thing is already using this!
 */
/mob/living/carbon/human/proc/set_dna(datum/dna/D)
	#warn impl ; have to updat everything too

	#warn dna should do the application; we do the rendering

/**
 * copies our DNA from something
 */
/mob/living/carbon/human/proc/copy_dna_from(dna_or_human)

/**
 * returns a clone of our dna
 */
/mob/living/carbon/human/proc/clone_dna()
	return dna.clone()

/**
 * initializes our dna
 */
/mob/living/carbon/human/proc/init_dna()

/**
 * updates all visuals/whatnot for dna
 */
/mob/living/carbon/human/proc/update_dna()
