//! !!! WHAT TO DO IF THE CODEBASE RUNS OUT OF BODYTYPE FLAGS (24 IS MAXIMUM) !!!
//? For now, bodytypes are flags.
//? Hopefully we can get a system where stuff like helmets get mutated to
//? specific types like "snout", "vaguely a cat", "vaguely a fox", "how about all of these"
//? If not, we're going to run out of bodytypes.
//? Hopefully not, because lists are expensive and we don't like them.
//? --------------------------------------------------------------------------------------
//? If the day comes when we run out of bodytypes and I'm not around to do the above,
//? and no one else wants to do something smarter,
//? you can still convert our bodytypes system back to string. You just have to be smart.
//?
//? 1. Don't do anything until you read everything. Regex can destroy semantic information,
//?    and the way I designed this makes it easy to turn into string lists, but if you
//?    mess it up, you just sunk the possibility of doing this at all.
//? 2. BODYTYPE_STRING_whatever's can stay; all overrides, defaults, etc, use them as string IDs.
//?    Don't fucking touch them at all.
//?    For bodytype flags, you will need a regex that converts the worn_bodytypes var
//?    to a list. You might even want to macro it if there's a chance of doing the better system
//?    later.
//?    For worn_bodytypes_converted, well, not many people should use it; all bodytypes should
//?    generally convert if no state is available for species defaults. You don't have to worry about
//?    that.
//? 3. Once you convert the bodytypes to lists, you're not done yet.
//?    While it technically works if you just change the procs in modules/mob/inventory/rendering.dm,
//?    you're just putting numbers in a list, which is pointless if they're not fields.
//?    Rename all BODYTYPE_STRING_X defines to BODYTYPE_KEY_X, and use them for your icon state keys.
//?    No one should ever be touching them anyways, as that involves .dmi edits.
//?    Then.. DON'T rename BODYTYPE_X defines. Just make them strings instead. Again,
//?    rendering procs need to take it into accout, but since they were used as enums and not list
//?    keys already, it should just magically work.
//? 4. We're back to what it was before bodytypes as a concept were made, but somewhat better because
//?    at the very least, we're not doing species names anymore.

//! bodytypes - they are flags for var storage, but should only be passed one at a time to rendering!
/// normal human bodytype (or generally everyone else)
#define BODYTYPE_DEFAULT			(1<<0)
/// teshari bodytype (or generally tiny birds)
#define BODYTYPE_TESHARI			(1<<2)
/// adherent bodytype (or generally giant serpent creatures)
#define BODYTYPE_ADHERENT			(1<<3)
/// unathi bodytype (or generally lizard)
#define BODYTYPE_UNATHI				(1<<4)
/// tajaran bodytype (or generally cat)
#define BODYTYPE_TAJARAN			(1<<5)
/// vulp bodytype (or generally foxes)
#define BODYTYPE_VULPKANIN			(1<<6)
/// skrell bodytype (or generally weird fleshy fishpeople)
#define BODYTYPE_SKRELL				(1<<7)
/// sergal bodytype (or generally cheese)
#define BODYTYPE_SERGAL				(1<<8)
/// akula bodytype (or generally shark)
#define BODYTYPE_AKULA				(1<<9)
/// vox bodytype
#define BODYTYPE_VOX				(1<<10)
/// neverean bodytype
#define BODYTYPE_NEVREAN			(1<<11)
/// promethean bodytype
#define BODYTYPE_PROMETHEAN			(1<<12)
/// highlander zorren
#define BODYTYPE_ZORREN_HIGH		(1<<13)
/// flatlander zorren
#define BODYTYPE_ZORREN_FLAT		(1<<14)
/// zaddat
#define BODYTYPE_ZADDAT				(1<<15)
/// phoronoid
#define BODYTYPE_PHORONOID			(1<<16)
/// werebeast
#define BODYTYPE_WEREBEAST			(1<<17)
/// xenomorph hybrid
#define BODYTYPE_XENOHYBRID			(1<<18)

// todo: what are we going to do with these?
//? we should probably standardize bodytypes as entirely different sprites, and also
//? have a set of "mutators" for items that apply to the default humanoid form
//? like having snout, eats, horns, lithe tail, big long tail, the 2-3 types of fox tails,
//? digitigrade legs, so on, so forth
//! How we'll do that is another problem to be oslved later.
/*
/// has snout - usually relevant for masks and headgear
#define BODYTYPE_SNOUT				(1<<20)
/// snake taur bodytype - usually relevant for hardsuits and similar
#define BODYTYPE_TAUR_SNAKE			(1<<21)
/// horse taur bodytype - ditto
#define BODYTYPE_TAUR_HORSE			(1<<22)
/// digitigrade feet - usually relevant for leg covering gear
#define BODYTYPE_DIGITIGRADE		(1<<23)
*/

//! bodytypes as strings
#define BODYTYPE_STRING_DEFAULT "default"
#define BODYTYPE_STRING_TESHARI "teshari"
#define BODYTYPE_STRING_ADHERENT "adherent"
#define BODYTYPE_STRING_UNATHI "unathi"
#define BODYTYPE_STRING_TAJARAN "tajaran"
#define BODYTYPE_STRING_VULPKANIN "vulpkanin"
#define BODYTYPE_STRING_SKRELL "skrell"
#define BODYTYPE_STRING_SERGAL "sergal"
#define BODYTYPE_STRING_AKULA "akula"
#define BODYTYPE_STRING_VOX "vox"
#define BODYTYPE_STRING_NEVREAN "nevrean"
#define BODYTYPE_STRING_PROMETHEAN "promethean"
#define BODYTYPE_STRING_ZORREN_HIGH "zorren_highlander"
#define BODYTYPE_STRING_ZORREN_FLAT "zorren_flatlander"
#define BODYTYPE_STRING_ZADDAT "zaddat"
#define BODYTYPE_STRING_PHORONOID "phoronoid"
#define BODYTYPE_STRING_WEREBEAST "werebeast"
#define BODYTYPE_STRING_XENOHYBRID "xenohybrid"

/proc/bodytype_to_string(bodytype)
	switch(bodytype)
		if(BODYTYPE_DEFAULT)
			return BODYTYPE_STRING_DEFAULT
		if(BODYTYPE_TESHARI)
			return BODYTYPE_STRING_TESHARI
		if(BODYTYPE_ADHERENT)
			return BODYTYPE_STRING_ADHERENT
		if(BODYTYPE_UNATHI)
			return BODYTYPE_STRING_UNATHI
		if(BODYTYPE_TAJARAN)
			return BODYTYPE_STRING_TAJARAN
		if(BODYTYPE_VULPKANIN)
			return BODYTYPE_STRING_VULPKANIN
		if(BODYTYPE_SKRELL)
			return BODYTYPE_STRING_SKRELL
		if(BODYTYPE_SERGAL)
			return BODYTYPE_STRING_SERGAL
		if(BODYTYPE_AKULA)
			return BODYTYPE_STRING_AKULA
		if(BODYTYPE_VOX)
			return BODYTYPE_STRING_VOX
		if(BODYTYPE_NEVREAN)
			return BODYTYPE_STRING_NEVREAN
		if(BODYTYPE_PROMETHEAN)
			return BODYTYPE_STRING_PROMETHEAN
		if(BODYTYPE_ZORREN_HIGH)
			return BODYTYPE_STRING_ZORREN_HIGH
		if(BODYTYPE_ZORREN_FLAT)
			return BODYTYPE_STRING_ZORREN_FLAT
		if(BODYTYPE_ZADDAT)
			return BODYTYPE_STRING_ZADDAT
		if(BODYTYPE_PHORONOID)
			return BODYTYPE_STRING_PHORONOID
		if(BODYTYPE_WEREBEAST)
			return BODYTYPE_STRING_WEREBEAST
		if(BODYTYPE_XENOHYBRID)
			return BODYTYPE_STRING_XENOHYBRID
		else
			CRASH("unknown bodytype: [bodytype]")
