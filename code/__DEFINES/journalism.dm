//? WARNING: DO NOT FUCK WITH THIS FILE UNNECESSARILY. These values are serialized DIRECTLY, if you screw with them bad stuff happens.

//!# News - General


//!# News - Storage

// storage backend flags
/// capable of search
#define NEWS_STORAGE_BACKEND_SEARCH_CAPABLE					(1<<0)


//!# News - Networks

// network flags

//!# News - Channels

// channel flags

/// news channel name max length in characters
#define NEWS_CHANNEL_NAME_MAX_LENGTH		64
/// news channel desc max length in characters
#define NEWS_CHANNEL_DESC_MAX_LENGTH		2048

//!# News - Posts

// post flags

/// news post max length in characters
#define NEWS_POST_MAX_LENGTH 4096

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
#define NEWS_COMMENT_MAX_LENGTH 512

