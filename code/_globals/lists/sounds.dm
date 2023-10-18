/**
 * Holds a lookup of soundbyte type to .ogg
 * Obviously returns raw .ogg, not the soundbyte
 *
 * "but silicons, aren't real globals banned?"
 * - GLOB. has access overhead. It really doesn't matter most of the time, but,
 *   if I'm doing something as crucial as sound I might as well cut as much overhead
 *   as I can.
 */
GLOBAL_REAL_LIST(__sfx_lookup)
