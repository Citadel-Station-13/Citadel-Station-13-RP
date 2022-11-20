/**
 * DNA
 *
 * holds genetic information on an organism
 * anything semantically genetic that is non-temporary-state
 * not held by organs should probably be held here
 * basically: anything cosmetic, or anything full-body-gene-power-y
 */
/datum/dna
	//! cosmetics - PLEASE use setters, as we aggressively cache these on clone to avoid meomry overhead!
	/// skin color, or a string corrosponding to skin tone lookup
	var/skin_color = rgb(238, 206, 179)
	/// eye color
	var/eye_color = rgb(50, 50, 50)
	/// hair
	VAR_PRIVATE/datum/sprite_accessory_data/hair
	/// facial hair
	VAR_PRIVATE/datum/sprite_accessory_data/facial_hair
	/// ears
	VAR_PRIVATE/datum/sprite_accessory_data/ears_1
	/// ears
	VAR_PRIVATE/datum/sprite_accessory_data/ears_2
	/// tail
	VAR_PRIVATE/datum/sprite_accessory_data/tail
	/// wings
	VAR_PRIVATE/datum/sprite_accessory_data/wings
	/// body markings
	VAR_PRIVATE/list/datum/sprite_accessory_data/markings
	/// gender
	var/gender = MALE


//! READ-ONLY, GETS OVERWRITTEN
//! DO NOT FUCK WITH THESE OR BYOND WILL EAT YOUR FACE

	/// Encoded SE.
	var/struc_enzymes  = ""
	/// MD5 of player name.
	var/unique_enzymes = ""

	// Internal dirtiness checks.
	var/dirtyUI = 0
	var/dirtySE = 0

//! Okay to read, but you're an idiot if you do.
//! BLOCK = VALUE
	var/list/SE[DNA_SE_LENGTH]

//? From old dna.
	/// Should probably change to an integer => string map but I'm lazy.
	var/b_type = "A+"
	/// Stores the real name of the person who originally got this dna datum. Used primarily for changelings,
	var/real_name

	var/custom_species
	var/base_species = SPECIES_HUMAN
	var/list/species_traits = list()
	var/blood_color = "#A10808"
	var/custom_say
	var/custom_ask
	var/custom_whisper
	var/custom_exclaim

//? New stuff.
	var/species = SPECIES_HUMAN
	var/list/body_descriptors = null
	///? Modifiers with the MODIFIER_GENETIC flag are saved.  Note that only the type is saved, not an instance.
	var/list/genetic_modifiers = list()

	var/s_base = ""

#warn vv edit var to allow editing things via id for sprite accessories!

/**
 * Make a copy of this strand.
 * USE THIS WHEN COPYING STUFF OR YOU'LL GET CORRUPTION!
 */
/datum/dna/proc/clone()
	var/datum/dna/cloned = new
	//! reference accessories, not full clone
	hair.is_shared_datum = TRUE
	cloned.hair = hair
	facial_hair.is_shared_datum = TRUE
	cloned.facial_hair = facial_hair
	ears_1.is_shared_datum = TRUE
	cloned.ears_1 = ears_1
	ears_2.is_shared_datum = TRUE
	cloned.ears_2 = ears_2
	tail.is_shared_datum = TRUE
	cloned.tail = tail
	wings.is_shared_datum = TRUE
	cloned.wings = wings
	cloned.markings = list()
	for(var/datum/sprite_accessory_data/D in markings)
		D.is_shared_datum = TRUE
		cloned.markings += D

	cloned.unique_enzymes=unique_enzymes
	cloned.b_type=b_type
	cloned.real_name=real_name
	cloned.species=species
	cloned.base_species=base_species
	cloned.custom_species=custom_species
	cloned.species_traits=species_traits.Copy()
	cloned.blood_color=blood_color
	cloned.custom_say=custom_say
	cloned.custom_ask=custom_ask
	cloned.custom_whisper=custom_whisper
	cloned.custom_exclaim=custom_exclaim
	cloned.s_base=s_base
	for(var/b=1;b<=DNA_SE_LENGTH;b++)
		cloned.SE[b]=SE[b]
	cloned.UpdateUI()
	cloned.UpdateSE()
	return cloned


//! ## UNIQUE IDENTITY ## !//

/**
 * Create random UI.
 */
/datum/dna/proc/ResetUI(defer=0)
	// todo: actual randomization based on species when
	if(!defer)
		UpdateUI()


/// Set a DNA UI block's raw value.
/datum/dna/proc/SetUIValue(block, value, defer=0)
	if (block<=0)
		return
	ASSERT(value>0)
	ASSERT(value<=4095)
	UI[block]=value
	dirtyUI=1
	if(!defer)
		UpdateUI()


/// Get a DNA UI block's raw value.
/datum/dna/proc/GetUIValue(block)
	if (block<=0)
		return 0
	return UI[block]


/**
 * Set a DNA UI block's value, given a value and a max possible value.
 * Used in hair and facial styles (value being the index and maxvalue being the len of the hairstyle list)
 */
/datum/dna/proc/SetUIValueRange(block, value, maxvalue, defer=0)
	if (block<=0)
		return
	if (value==0)
		value = 1 // FIXME: hair/beard/eye RGB values if they are 0 are not set, this is a work around we'll encode it in the DNA to be 1 instead.
	ASSERT(maxvalue<=4095)
	var/range = (4095 / maxvalue)
	if(value)
		SetUIValue(block,round(value * range),defer)


/**
 * Gets a DNA UI block's value, given a block and a max possible value.
 * Used in hair and facial styles (value being the index and maxvalue being the len of the hairstyle list)
 */
/datum/dna/proc/GetUIValueRange(block, maxvalue)
	if (block<=0)
		return 0
	var/value = GetUIValue(block)
	return round(0.5 + (value / 4096) * maxvalue)


/**
 * Is the UI gene "on" or "off"?
 * For UI, this is simply a check of if the value is > 2050.
 */
/datum/dna/proc/GetUIState(block)
	if (block<=0)
		return
	return UI[block] > 2050


/**
 * Set UI gene "on" (1) or "off" (0)
 */
/datum/dna/proc/SetUIState(block, on, defer=0)
	if (block<=0)
		return
	var/val
	if(on)
		val=rand(2050,4095)
	else
		val=rand(1,2049)
	SetUIValue(block,val,defer)


/**
 * Get a hex-encoded UI block.
 */
/datum/dna/proc/GetUIBlock(block)
	return EncodeDNABlock(GetUIValue(block))


/**
 * Do not use this unless you absolutely have to.
 * Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
 * Used in DNA modifiers.
 */
/datum/dna/proc/SetUIBlock(block, value, defer=0)
	if (block<=0)
		return
	return SetUIValue(block,hex2num(value),defer)


/**
 * Get a sub-block from a block.
 */
/datum/dna/proc/GetUISubBlock(block, subBlock)
	return copytext(GetUIBlock(block),subBlock,subBlock+1)

/**
 * Do not use this unless you absolutely have to.
 * Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
 * Used in DNA modifiers.
 */
/datum/dna/proc/SetUISubBlock(block, subBlock, newSubBlock, defer=0)
	if (block<=0)
		return
	var/oldBlock=GetUIBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	SetUIBlock(block,newBlock,defer)



//! ## STRUCTURAL ENZYMES ## !//

/**
 * "Zeroes out" all of the blocks.
 */
/datum/dna/proc/ResetSE()
	for(var/i = 1, i <= DNA_SE_LENGTH, i++)
		SetSEValue(i,rand(1,1024),1)
	UpdateSE()


/**
 * Set a DNA SE block's raw value.
 */
/datum/dna/proc/SetSEValue(block, value, defer=0)
	if (block<=0)
		return
	ASSERT(value>=0)
	ASSERT(value<=4095)
	SE[block]=value
	dirtySE=1
	if(!defer)
		UpdateSE()


/**
 * Get a DNA SE block's raw value.
 */
/datum/dna/proc/GetSEValue(block)
	if (block<=0)
		return 0
	return SE[block]


/**
 * Set a DNA SE block's value, given a value and a max possible value.
 * Might be used for species?
 */
/datum/dna/proc/SetSEValueRange(block, value, maxvalue)
	if (block<=0)
		return
	ASSERT(maxvalue<=4095)
	var/range = round(4095 / maxvalue)
	if(value)
		SetSEValue(block, value * range - rand(1,range-1))


/**
 * Getter version of above.
 */
/datum/dna/proc/GetSEValueRange(block, maxvalue)
	if (block<=0)
		return 0
	var/value = GetSEValue(block)
	return round(1 +(value / 4096)*maxvalue)


/**
 * Is the block "on" (1) or "off" (0)? (Un-assigned genes are always off.)
 */
/datum/dna/proc/GetSEState(block)
	if (block<=0)
		return 0
	var/list/BOUNDS=GetDNABounds(block)
	var/value=GetSEValue(block)
	return (value > BOUNDS[DNA_ON_LOWERBOUND])


/**
 * Set a block "on" or "off".
 */
/datum/dna/proc/SetSEState(block, on, defer=0)
	if (block<=0)
		return
	var/list/BOUNDS=GetDNABounds(block)
	var/val
	if(on)
		val=rand(BOUNDS[DNA_ON_LOWERBOUND],BOUNDS[DNA_ON_UPPERBOUND])
	else
		val=rand(1,BOUNDS[DNA_OFF_UPPERBOUND])
	SetSEValue(block,val,defer)


/**
 * Get hex-encoded SE block.
 */
/datum/dna/proc/GetSEBlock(block)
	return EncodeDNABlock(GetSEValue(block))


/**
 * Do not use this unless you absolutely have to.
 * Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
 * Used in DNA modifiers.
 */
/datum/dna/proc/SetSEBlock(block, value, defer=0)
	if (block<=0)
		return
	var/nval=hex2num(value)
	//testing("SetSEBlock([block],[value],[defer]): [value] -> [nval]")
	return SetSEValue(block,nval,defer)


/datum/dna/proc/GetSESubBlock(block, subBlock)
	return copytext(GetSEBlock(block),subBlock,subBlock+1)


/**
 * Do not use this unless you absolutely have to.
 * Set a sub-block from a hex character.  This is inefficient.  If you can, use SetUIValue().
 * Used in DNA modifiers.
 */
/datum/dna/proc/SetSESubBlock(block, subBlock, newSubBlock, defer=0)
	if (block<=0)
		return
	var/oldBlock=GetSEBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	//testing("SetSESubBlock([block],[subBlock],[newSubBlock],[defer]): [oldBlock] -> [newBlock]")
	SetSEBlock(block,newBlock,defer)


/proc/EncodeDNABlock(value)
	return num2hex(value, 3)


/datum/dna/proc/UpdateUI()
	src.uni_identity=""
	for(var/block in UI)
		uni_identity += EncodeDNABlock(block)
	//testing("New UI: [uni_identity]")
	dirtyUI=0


/datum/dna/proc/UpdateSE()
	//var/oldse=struc_enzymes
	struc_enzymes=""
	for(var/block in SE)
		struc_enzymes += EncodeDNABlock(block)
	//testing("Old SE: [oldse]")
	//testing("New SE: [struc_enzymes]")
	dirtySE=0


/**
 *!BACK-COMPAT!
 * Just checks our character has all the crap it needs.
 */
/datum/dna/proc/check_integrity(mob/living/carbon/human/character)
	if(character)
		if(UI.len != DNA_UI_LENGTH)
			ResetUIFrom(character)

		if(length(struc_enzymes)!= 3*DNA_SE_LENGTH)
			ResetSE()

		if(length(unique_enzymes) != 32)
			unique_enzymes = md5(character.real_name)
	else
		if(length(uni_identity) != 3*DNA_UI_LENGTH)
			uni_identity = "00600200A00E0110148FC01300B0095BD7FD3F4"
		if(length(struc_enzymes)!= 3*DNA_SE_LENGTH)
			struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"


/**
 * !BACK-COMPAT!
 * Initial DNA setup.  I'm kind of wondering why the hell this doesn't just call the above.
 */
/datum/dna/proc/ready_dna(mob/living/carbon/human/character)
	ResetUIFrom(character)

	ResetSE()

	unique_enzymes = md5(character.real_name)
	reg_dna[unique_enzymes] = character.real_name
