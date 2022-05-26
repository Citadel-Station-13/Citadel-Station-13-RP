// Max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023
#define CHANNEL_VOX 1022
#define CHANNEL_JUKEBOX 1021
/// Sound channel for heartbeats
#define CHANNEL_HEARTBEAT 1020
#define CHANNEL_AMBIENCE_FORCED 1019
#define CHANNEL_AMBIENCE 1018
#define CHANNEL_BUZZ 1017
#define CHANNEL_BICYCLE 1016
/// Fancy Sound Loop channel
#define CHANNEL_PREYLOOP 1015

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

#define CHANNEL_HIGHEST_AVAILABLE 1014 // Fancy Sound Loop channel from 1015

#define MAX_INSTRUMENT_CHANNELS (128 * 6)
