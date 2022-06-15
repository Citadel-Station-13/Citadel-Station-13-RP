/**
 * serializer datums for news
 */
/datum/news_persist_serializer
	/// name
	var/name = "generic serializer"
	/// hints on what kind of serializer we are - see __DEFINES/journalism.dm
	var/news_serializer_flags = NONE

#warn incremental support? lazyload support? impl.
