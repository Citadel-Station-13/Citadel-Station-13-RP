// Defines for the ai_intelligence var.
// Controls if the mob will do 'advanced tactics' like running from grenades.
/// Be dumber than usual.
#define AI_DUMB			1
/// Default level.
#define AI_NORMAL		2
/// Will do more processing to be a little smarter, like not walking while confused if it could risk stepping randomly onto a bad tile.
#define AI_SMART		3
#define ai_log(M,V)	if(debug_ai) ai_log_output(M,V)

// Logging level defines.
/// Don't show anything.
#define AI_LOG_OFF		0
/// Show logs of things likely causing the mob to not be functioning correctly.
#define AI_LOG_ERROR	1
/// Show less serious but still helpful to know issues that might be causing things to work incorrectly.
#define AI_LOG_WARNING	2
/// Important regular events, like selecting a target or switching stances.
#define AI_LOG_INFO		3
/// More detailed information about the flow of execution.
#define AI_LOG_DEBUG	4
/// Even more detailed than the last. Will absolutely flood your chatlog.
#define AI_LOG_TRACE	5
// Results of pre-movement checks.
// Todo: Move outside AI code?
/// Recently moved and needs to try again soon.
#define MOVEMENT_ON_COOLDOWN	-1
/// Move() returned false for whatever reason and the mob didn't move.
#define MOVEMENT_FAILED			0
/// Move() returned true and the mob hopefully moved.
#define MOVEMENT_SUCCESSFUL		1
// Reasons for targets to not be valid. Based on why, the AI responds differently.
/// We can fight them.
#define AI_TARGET_VALID			0
/// They were in field of view but became invisible. Switch to STANCE_BLINDFIGHT if no other viable targets exist.
#define AI_TARGET_INVIS			1
/// No longer in field of view. Go STANCE_REPOSITION to their last known location if no other targets are seen.
#define AI_TARGET_NOSIGHT		2
/// They are an ally. Find a new target.
#define AI_TARGET_ALLY			3
/// They're dead. Find a new target.
#define AI_TARGET_DEAD			4
/// Target is currently unable to receive damage for whatever reason. Find a new target or wait.
#define AI_TARGET_INVINCIBLE	5
