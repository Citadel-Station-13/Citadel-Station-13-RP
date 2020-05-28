// /datum/gas/gas_flags flags
/// Is this gas a viable combustion fuel? Ported from XGM variable oxidizer-oxidant combustion system.
#define GAS_FLAG_FUEL				(1<<0)
/// Is this gas a viable combustion oxidizer? Ported from XGM variable oxidizer-oxidant combustion system.
#define GAS_FLAG_OXIDIZER			(1<<1)
/// Is this gas able to contaminate things like clothing? ZAS phoron contaminent memes.
#define GAS_FLAGS_CONTAMINANT		(1<<2)
/// Is this gas a valid R-UST fusion fuel? Has NOTHING to do with tg fusion!
#define GAS_FLAG_FUSION_FUEL		(1<<3)
