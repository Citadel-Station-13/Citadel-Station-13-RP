//* news_network_flags

DEFINE_BITFIELD(news_network_flags, list(

))

//* news_channel_flags

DEFINE_BITFIELD(news_channel_flags, list(

))

//* news_post_flags

DEFINE_BITFIELD(news_post_flags, list(

))

//* news_comment_flags

DEFINE_BITFIELD(news_comment_flags, list(

))

//*                   news_cursor interface: user permissions flags                                *//
//* this is for permissions to perform actions on a network; users need to be authenticated first. *//

/// write + comment on your own posts/channels, and non-locked others' posts/channels.
#define JOURNALISM_USERMODE_WRITE (1<<0)
/// bypass locking on posts/channels
#define JOURNALISM_USERMODE_BYPASS (1<<1)
/// hit stuff with D-notices, and see stuff hit with D-notices
#define JOURNALISM_USERMODE_CENSOR (1<<2)
/// delete stuff completely
#define JOURNALISM_USERMODE_DELETE (1<<3)
/// see deleted content
#define JOURNALISM_USERMODE_AUDIT (1<<4)

//*                      news_cursor interface: global permissions flags                                    *//
//* this is for permissions to control an uplink datum, which is a context of access to the actual networks *//

/// un/block entire networks with D-notices / command suspensions within the context of an uplink stream
/// un/mark entire networks as read-only when accessed from the context of that uplink stream
/// this is non-persistent
#define JOURNALISM_GLOBALMODE_CENSOR (1<<0)
/// see network trace logs of an uplink stream
/// network trace logs are persistent
#define JOURNALISM_GLOBALMODE_TRACE (1<<1)
/// block individual users from an uplink stream
/// this is non-persistent
#define JOURNALISM_GLOBALMODE_RESTRICT (1<<2)

//* limits / throttling
/// max channels per person, per network
#define JOURNALISM_CHANNEL_INDIVIDUAL_LIMIT (10)
/// cooldown before making channels
#define JOURNALISM_CHANNEL_INDIVIDUAL_COOLDOWN (30 MINUTES)
/// cooldown before making posts
#define JOURNALISM_POST_INDIVIDUAL_COOLDOWN (0.5 MINUTES)
/// cooldown before making comments
#define JOURNALISM_COMMENT_INDIVIDUAL_COOLDOWN (10 SECONDS)
