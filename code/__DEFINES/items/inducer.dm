// /inducer_act returns
/// continue without using charge
#define INDUCER_ACT_CONTINUE "continue"
/// immediately stop
#define INDUCER_ACT_STOP "stop"

// /inducer_scan returns
/// normal - use list
#define INDUCER_SCAN_NORMAL			0
/// ignore scan result, silent fail
#define INDUCER_SCAN_BLOCK			1
/// say something is interfering, loud fail
#define INDUCER_SCAN_INTERFERE		2
/// say something is full
#define INDUCER_SCAN_FULL			3

// /inducer/var/inducer_flags
/// no using on guns
#define INDUCER_NO_GUNS				(1<<0)
