///MARK ALL FLAG CHANGES IN _globalvars/bitfields.dm!
///All flags should go in here if possible.
/// For convenience.
#define ALL (~0)
#define NONE 0

/// copy flags from B to A
#define COPY_SPECIFIC_BITFIELDS(a, b, flags) (a = ((a & ~(flags)) | (b & flags)))
// Check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags)	((flagvar & (flags)) == flags)

// Macros to test for bits in a bitfield. Note, that this is for use with indexes, not bit-masks!
#define BITTEST(bitfield,index)  ((bitfield)  &   (1 << (index)))
#define BITSET(bitfield,index)   (bitfield)  |=  (1 << (index))
#define BITRESET(bitfield,index) (bitfield)  &= ~(1 << (index))
#define BITFLIP(bitfield,index)  (bitfield)  ^=  (1 << (index))

GLOBAL_LIST_INIT(bitflags, list(
	1<<0,  1<<1,  1<<2,  1<<3,  1<<4,  1<<5,  1<<6,  1<<7,
	1<<8,  1<<9,  1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
	1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23
))
