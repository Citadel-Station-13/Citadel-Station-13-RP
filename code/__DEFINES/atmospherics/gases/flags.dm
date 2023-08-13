//! flags
// /datum/gas/gas_flags flags
/// Is this gas a viable combustion fuel? Ported from XGM variable oxidizer-oxidant combustion system.
#define GAS_FLAG_FUEL				(1<<0)
/// Is this gas a viable combustion oxidizer? Ported from XGM variable oxidizer-oxidant combustion system.
#define GAS_FLAG_OXIDIZER			(1<<1)
/// Is this gas able to contaminate things like clothing? ZAS phoron contaminent memes.
#define GAS_FLAG_CONTAMINANT		(1<<2)
/// Is this gas a valid R-UST fusion fuel? Has NOTHING to do with tg fusion!
#define GAS_FLAG_FUSION_FUEL		(1<<3)
/// gas is unknown/alien
#define GAS_FLAG_UNKNOWN			(1<<4)
/// gas is core gas, always render & on main filter options. implies [GAS_FLAG_FILTERABLE].
#define GAS_FLAG_CORE				(1<<5)
/// gas is common enough to be filtered by machinery without spectrometry/grouping
#define GAS_FLAG_FILTERABLE				(1<<6)
/// gas is highly dangerous, mostly used to know when to *loudly* log as opposed to just log
#define GAS_FLAG_DANGEROUS			(1<<7)

DEFINE_BITFIELD(gas_flags, list(
	BITFIELD(GAS_FLAG_FUEL),
	BITFIELD(GAS_FLAG_OXIDIZER),
	BITFIELD(GAS_FLAG_CONTAMINANT),
	BITFIELD(GAS_FLAG_FUSION_FUEL),
	BITFIELD(GAS_FLAG_UNKNOWN),
	BITFIELD(GAS_FLAG_CORE),
	BITFIELD(GAS_FLAG_FILTERABLE),
	BITFIELD(GAS_FLAG_DANGEROUS),
))
