//* Saycode Types *//

/// works as long as can see
#define SAYCODE_TYPE_VISIBLE (1<<0)
/// works as long as can hear
#define SAYCODE_TYPE_AUDIBLE (1<<1)
/// works as long as conscious
#define SAYCODE_TYPE_CONSCIOUS (1<<2)
/// works as long as alive
#define SAYCODE_TYPE_LIVING (1<<3)
/// it just works
#define SAYCODE_TYPE_ALWAYS (1<<4)

//* Saycode Origins *//

/// from say()
#define SAYCODE_ORIGIN_SAY (1<<0)
/// from whisper()
#define SAYCODE_ORIGIN_WHISPER (1<<1)
/// from me()
#define SAYCODE_ORIGIN_EMOTE (1<<2)
/// from subtle()
#define SAYCODE_ORIGIN_SUBTLE (1<<3)
/// from subtler()
#define SAYCODE_ORIGIN_SUBTLER (1<<4)
