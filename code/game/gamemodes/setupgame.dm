/////////////////////////
// (mostly) DNA2 SETUP
/////////////////////////

// Randomize block, assign a reference name, and optionally define difficulty (by making activation zone smaller or bigger)
// The name is used on /vg/ for species with predefined genetic traits,
//  and for the DNA panel in the player panel.
/proc/getAssignedBlock(var/name,var/list/blocksLeft, var/activity_bounds=DNA_DEFAULT_BOUNDS)
	if(blocksLeft.len==0)
		warning("[name]: No more blocks left to assign!")
		return 0
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	assigned_blocks[assigned]=name
	dna_activity_bounds[assigned]=activity_bounds
	//testing("[name] assigned to block #[assigned].")
	return assigned

/proc/setupgenetics()
	var/list/numsToAssign=new()
	for(var/i=1;i<DNA_SE_LENGTH;i++)
		numsToAssign += i

	//testing("Assigning DNA blocks:")

	// Standard muts, imported from older code above.
	DNABLOCK_BLIND        = getAssignedBlock("SDISABILITY_NERVOUS",           numsToAssign)
	DNABLOCK_DEAF         = getAssignedBlock("SDISABILITY_DEAF",            numsToAssign)
	DNABLOCK_HULK         = getAssignedBlock("MUTATION_HULK",   numsToAssign, DNA_HARD_BOUNDS)
	DNABLOCK_TELE         = getAssignedBlock("TELE",            numsToAssign, DNA_HARD_BOUNDS)
	DNABLOCK_FIRE         = getAssignedBlock("FIRE",            numsToAssign, DNA_HARDER_BOUNDS)
	DNABLOCK_XRAY         = getAssignedBlock("MUTATION_XRAY",   numsToAssign, DNA_HARDER_BOUNDS)
	DNABLOCK_CLUMSY       = getAssignedBlock("MUTATION_CLUMSY", numsToAssign)
	DNABLOCK_FAKE         = getAssignedBlock("FAKE",            numsToAssign)

	// UNUSED!
	//DNABLOCK_COUGH      = getAssignedBlock("COUGH",         numsToAssign)
	//DNABLOCK_GLASSES    = getAssignedBlock("GLASSES",       numsToAssign)
	//DNABLOCK_EPILEPSY   = getAssignedBlock("DISABILITY_EPILEPSY",      numsToAssign)
	//DNABLOCK_TWITCH     = getAssignedBlock("TWITCH",        numsToAssign)
	//DNABLOCK_NERVOUS    = getAssignedBlock("DISABILITY_NERVOUS",       numsToAssign)

	// Bay muts (UNUSED)
	// DNABLOCK_HEADACHE      = getAssignedBlock("HEADACHE",      numsToAssign)
	// DNABLOCK_NOBREATH      = getAssignedBlock("NOBREATH",      numsToAssign, DNA_HARD_BOUNDS)
	// DNABLOCK_REMOTEVIEW    = getAssignedBlock("REMOTEVIEW",    numsToAssign, DNA_HARDER_BOUNDS)
	// DNABLOCK_REGENERATE    = getAssignedBlock("REGENERATE",    numsToAssign, DNA_HARDER_BOUNDS)
	// DNABLOCK_INCREASERUN   = getAssignedBlock("INCREASERUN",   numsToAssign, DNA_HARDER_BOUNDS)
	DNABLOCK_REMOTETALK    = getAssignedBlock("REMOTETALK",    numsToAssign, DNA_HARDER_BOUNDS)
	// DNABLOCK_MORPH         = getAssignedBlock("MORPH",         numsToAssign, DNA_HARDER_BOUNDS)
	// COLDBLOCK          = getAssignedBlock("COLD",          numsToAssign)
	// DNABLOCK_HALLUCINATION = getAssignedBlock("HALLUCINATION", numsToAssign)
	// DNABLOCK_NOPRINTS     = getAssignedBlock("NOPRINTS",      numsToAssign, DNA_HARD_BOUNDS)
	// DNABLOCK_NOSHOCK      = getAssignedBlock("SHOCKIMMUNITY", numsToAssign)
	// DNABLOCK_DWARFISM     = getAssignedBlock("SMALLSIZE",     numsToAssign, DNA_HARD_BOUNDS)

	//
	// Static Blocks
	/////////////////////////////////////////////.

	// Monkeyblock is always last.
	DNABLOCK_MONKEY = DNA_SE_LENGTH

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned[DNA_SE_LENGTH]
	for(var/gene_type in typesof(/datum/gene))
		var/datum/gene/G = new gene_type
		if(G.block)
			if(G.block in blocks_assigned)
				warning("DNA2: Gene [G.name] trying to use already-assigned block [G.block] (used by [english_list(blocks_assigned[G.block])])")
			dna_genes.Add(G)
			var/list/assignedToBlock[0]
			if(blocks_assigned[G.block])
				assignedToBlock=blocks_assigned[G.block]
			assignedToBlock.Add(G.name)
			blocks_assigned[G.block]=assignedToBlock
