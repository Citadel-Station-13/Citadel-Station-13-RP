//!# Pictures

// /datum/picture/var/picture_flags
/// was captured this round
#define PICTURE_IS_CURRENT_ROUND			(1<<0)
/// has been saved by md5 to disk
#define PICTURE_IS_SAVED					(1<<1)
/// is currently loaded in memory
#define PICTURE_IS_LOADED					(1<<2)
