// deepmaint template types we probably won't need more than 24
// always include some form of USE_X.
/// generic
#define DEEPMAINT_TYPE_GENERIC				(1<<0)
/// ice-like
#define DEEPMAINT_TYPE_FROZEN				(1<<1)
/// cave/mountain
#define DEEPMAINT_TYPE_CAVERN				(1<<2)
/// lava-like
#define DEEPMAINT_TYPE_MOLTEN				(1<<3)
/// plains - whether above or underground
#define DEEPMAINT_TYPE_PLAINS				(1<<4)
/// special - marks if this should be usblae aboveground
#define DEEPMAINT_TYPE_USE_ABOVEGROUND		(1<<5)
/// special - marks if this should be usable underground
#define DEEPMAINT_TYPE_USE_UNDERGRONUD		(1<<6)
/// special - marks if this should be usable in space
#define DEEPMAINT_TYPE_USE_SPACE			(1<<7)
/// asteroid
#define DEEPMAINT_TYPE_ASTEROID				(1<<8)
/// spacestation
#define DEEPMAINT_TYPE_STATION				(1<<9)
