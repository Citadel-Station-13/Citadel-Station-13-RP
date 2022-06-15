//? WARNING: DO NOT FUCK WITH THIS FILE UNNECESSARILY. These values are serialized DIRECTLY, if you screw with them bad stuff happens.

//!# Persist
// /datum/news_persist_serializer/var/news_serializer_flags
/// supports random access aka lazyloading
#define NEWS_SERIALIZER_RANDOM_ACCESS				(1<<0)
/// supports incremental updates
#define NEWS_SERIALIZER_INCREMENTAL					(1<<1)
/// always load completely at server boot
#define NEWS_SERIALIZER_DO_NOT_LAZYLOAD				(1<<2)
/// always save immediately, do not cache
#define NEWS_SERIALIZER_DO_NOT_BUFFER				(1<<3)

//!# News - General

//!# News - Networks

// network flags

//!# News - Channels

// channel flags

//!# News - Posts

// post flags

//!# News - Comments

// comment flags
/// admin made
#define NEWS_COMMENT_FLAG_ADMIN						(1<<0)
/// persistence loaded
#define NEWS_COMMENT_FLAG_PERSISTED					(1<<1)
/// marked for deleted
#define NEWS_COMMENT_FLAG_USER_DELETED				(1<<2)
/// marked for hidden - don't render at all
#define NEWS_COMMENT_FLAG_HIDDEN					(1<<3)

/// news comment max length in characters
#define NEWS_COMMENT_MAX_LENGTH 4096

