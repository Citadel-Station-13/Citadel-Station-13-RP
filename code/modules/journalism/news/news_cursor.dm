/**
 * news cursor datum encapsulates access
 *
 * reason: news now needs unironic reference counting to know what can/can't be loaded in memory, as opposed
 * to being in sql.
 *
 * doing sql queries every ui update is somewhat unfeasible
 *
 * if we end up doing that anyways, well, L i guess.
 */
/datum/news_cursor


