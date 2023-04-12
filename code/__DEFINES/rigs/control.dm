//? rig control flags

/// can use hands
#define RIG_CONTROL_HANDS (1<<0)
/// can move, can emote
#define RIG_CONTROL_MOVEMENT (1<<1)
/// can turn the rig on/off, including userless activation
#define RIG_CONTROL_ACTIVATION (1<<2)
/// can extend/retract/seal/unseal pieces
#define RIG_CONTROL_DEPLOYMENT (1<<3)
/// can control all modules, including changing hotbinds
#define RIG_CONTROL_MODULES (1<<4)
/// can use hotbinds only
#define RIG_CONTROL_HOTBINDS (1<<5)
/// can speak as the rig using its voicebox
#define RIG_CONTROL_SPEECH (1<<6)
/// can access superuser console
#define RIG_CONTROL_CONSOLE (1<<7)
/// can change others' control flags
#define RIG_CONTROL_PERMISSIONS (1<<8)
