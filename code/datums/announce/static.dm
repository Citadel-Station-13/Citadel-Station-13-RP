// contains global announcers

GLOBAL_DATUM_INIT(announcer_station_radio, /datum/announcer/radio_broadcast, new(new /datum/announce_location/main_station))
GLOBAL_DATUM_INIT(announcer_station_speaker, /datum/announcer/speaker_network, new(new /datum/announce_location/main_station))
GLOBAL_DATUM_INIT(announcer_station_legacy_minor, /datum/announcer/minor_announce, new(new /datum/announce_location/main_station))
GLOBAL_DATUM_INIT(announcer_station_legacy_centcom, /datum/announcer/major_announce, new(new /datum/announce_location/main_station))
