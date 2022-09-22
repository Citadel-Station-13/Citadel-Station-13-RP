//! Tool usage flags
/// do not make message
#define TOOL_OP_NO_MESSAGE				(1<<0)
/// do not make audio
#define TOOL_OP_NO_AUDIO				(1<<1)
/// do not make standard message
#define TOOL_OP_NO_STANDARD_MESSAGE		(1<<2)
/// do not make standard audio
#define TOOL_OP_NO_STANDARD_AUDIO		(1<<3)
/// bypass delay
#define TOOL_OP_INSTANT					(1<<4)
/// initiated through dynamic tool system
#define TOOL_OP_DYNAMIC					(1<<5)
/// initiated through auto-use-tool system
#define TOOL_OP_AUTOPILOT				(1<<6)
/// actually doing it as opposed to a check; feel free to do user feedback
#define TOOL_OP_REAL					(1<<7)
/// silent - do not give audible or visual feedbcak
#define TOOL_OP_SILENT					(TOOL_OP_NO_AUDIO | TOOL_OP_NO_MESSAGE)
/// do not do standard feedback
#define TOOL_OP_NO_STANDARD_FEEDBACK	(TOOL_OP_NO_STANDARD_MESSAGE | TOOL_OP_NO_STANDARD_AUDIO)

//! Misc
// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20
