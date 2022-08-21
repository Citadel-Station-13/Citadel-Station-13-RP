/**
 * news storage
 *
 * ? specs:
 * ? everything: networks, channels, posts, comments, should be stored by UIDs
 * ? usually it's fine to do AUTO_INCREMENT or something similar for this
 * ?
 * ? should be capable of random access
 * ? can, but doesn't have to be capable of search
 */
/datum/news_storage_backend
	/// name
	var/name = "unknown storage backend"

