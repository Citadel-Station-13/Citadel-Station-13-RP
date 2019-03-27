<<<<<<< HEAD
/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

//for convenience
#define ENABLE_BITFIELD(variable, flag) (variable |= (flag))
#define DISABLE_BITFIELD(variable, flag) (variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag) (variable & flag)

//check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) ((flagvar & (flags)) == flags)

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))
=======
#define ALL (~0)
#define NONE 0

// datum_flags
#define DF_VAR_EDITED	(1<<0)
#define DF_ISPROCESSING (1<<1)
>>>>>>> 4839b4b... Merge pull request #4577 from VOREStation/upstream-merge-5677
